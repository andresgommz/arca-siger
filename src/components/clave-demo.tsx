"use client";

import { createContext, useCallback, useContext, useRef, useState } from "react";
import { KeyRound } from "lucide-react";
import type { RespuestaPost, RespuestaPostError } from "@/lib/tipos-api";
import { useConexion } from "./conexion";
import { Boton, Dialogo, estiloEntrada } from "./ui";

const CLAVE_SESION = "arca-demo-clave";

function leerClave(): string | null {
  try {
    return sessionStorage.getItem(CLAVE_SESION);
  } catch {
    return null;
  }
}

function guardarClave(clave: string | null) {
  try {
    if (clave) sessionStorage.setItem(CLAVE_SESION, clave);
    else sessionStorage.removeItem(CLAVE_SESION);
  } catch {
    // sessionStorage no disponible: la clave se pedirá de nuevo.
  }
}

type PedirClave = (incorrecta: boolean) => Promise<string | null>;
const Contexto = createContext<PedirClave | null>(null);

/** Diálogo que pide la clave de demostración y la guarda en sessionStorage. */
export function ClaveDemoProvider({ children }: { children: React.ReactNode }) {
  const [abierto, setAbierto] = useState(false);
  const [incorrecta, setIncorrecta] = useState(false);
  const [valor, setValor] = useState("");
  const resolver = useRef<((clave: string | null) => void) | null>(null);

  const pedir = useCallback<PedirClave>((esIncorrecta) => {
    setIncorrecta(esIncorrecta);
    setValor("");
    setAbierto(true);
    return new Promise((resolve) => {
      resolver.current = resolve;
    });
  }, []);

  const terminar = (clave: string | null) => {
    setAbierto(false);
    resolver.current?.(clave);
    resolver.current = null;
  };

  return (
    <Contexto.Provider value={pedir}>
      {children}
      <Dialogo abierto={abierto} titulo="Clave de demostración" onCerrar={() => terminar(null)}>
        <form
          onSubmit={(e) => {
            e.preventDefault();
            if (valor.trim()) terminar(valor.trim());
          }}
          className="space-y-4"
        >
          <p className="text-gray-700">
            Las operaciones que modifican la base de datos piden una clave en la versión publicada. Se guarda solo
            mientras esta pestaña esté abierta.
          </p>
          {incorrecta && (
            <p role="alert" className="rounded-lg border border-rechazo-borde bg-rechazo-fondo p-3 text-rechazo">
              La clave no es válida. El servidor respondió 401.
            </p>
          )}
          <input
            type="password"
            autoFocus
            autoComplete="off"
            value={valor}
            onChange={(e) => setValor(e.target.value)}
            className={estiloEntrada}
            aria-label="Clave de demostración"
            placeholder="Clave"
          />
          <div className="flex justify-end gap-3">
            <Boton type="button" variante="secundario" onClick={() => terminar(null)}>
              Cancelar
            </Boton>
            <Boton type="submit" disabled={!valor.trim()}>
              <KeyRound className="size-4" aria-hidden /> Continuar
            </Boton>
          </div>
        </form>
      </Dialogo>
    </Contexto.Provider>
  );
}

const SIN_CLAVE: RespuestaPostError = { ok: false, tipo: "clave", mensaje: "La operación necesita la clave de demostración." };

/** Envía un POST a /api/<ruta>, pidiendo la clave de demostración si hace falta. */
export function useEnviar() {
  const pedirClave = useContext(Contexto);
  const { estado } = useConexion();
  if (!pedirClave) throw new Error("useEnviar debe usarse dentro de ClaveDemoProvider");

  return useCallback(
    async (ruta: string, cuerpo: Record<string, unknown>): Promise<RespuestaPost> => {
      let clave = leerClave();
      if (estado?.clave_requerida && !clave) {
        clave = await pedirClave(false);
        if (!clave) return SIN_CLAVE;
        guardarClave(clave);
      }

      for (let intento = 0; intento < 2; intento++) {
        let r: Response;
        try {
          r = await fetch(`/api/${ruta}`, {
            method: "POST",
            headers: { "Content-Type": "application/json", ...(clave ? { "x-demo-clave": clave } : {}) },
            body: JSON.stringify(cuerpo),
          });
        } catch {
          return { ok: false, tipo: "conexion", mensaje: "No se pudo conectar con el servidor de la aplicación." };
        }
        let json: RespuestaPost;
        try {
          json = (await r.json()) as RespuestaPost;
        } catch {
          json = { ok: false, tipo: "servidor", mensaje: `El servidor respondió HTTP ${r.status}.` };
        }
        if (r.status === 401 && !json.ok && json.tipo === "clave" && intento === 0) {
          guardarClave(null);
          clave = await pedirClave(Boolean(clave));
          if (!clave) return json;
          guardarClave(clave);
          continue;
        }
        return json;
      }
      return SIN_CLAVE;
    },
    [estado?.clave_requerida, pedirClave],
  );
}
