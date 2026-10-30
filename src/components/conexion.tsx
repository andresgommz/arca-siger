"use client";

import { createContext, useCallback, useContext, useMemo, useState } from "react";
import useSWR from "swr";
import { CircleCheck, CloudOff, Loader2 } from "lucide-react";
import type { EstadoConexion } from "@/lib/tipos-api";
import { formatearFechaHora } from "@/lib/formatos";

interface ValorConexion {
  estado: EstadoConexion | undefined;
  /** true si se sabe que hay conexión con Oracle. */
  conectado: boolean;
  comprobando: boolean;
  /** Fecha (ISO) de los datos guardados que se están mostrando, o null si vienen en vivo. */
  fechaCache: string | null;
  registrarOrigen: (desdeCache: boolean, fecha: string | null) => void;
}

const Contexto = createContext<ValorConexion | null>(null);

async function cargarEstado(url: string): Promise<EstadoConexion> {
  const r = await fetch(url, { cache: "no-store" });
  return (await r.json()) as EstadoConexion;
}

export function ConexionProvider({ children }: { children: React.ReactNode }) {
  const { data, isLoading } = useSWR("/api/estado", cargarEstado, {
    refreshInterval: 15000,
    revalidateOnFocus: true,
  });
  const [fechaCache, setFechaCache] = useState<string | null>(null);

  const registrarOrigen = useCallback((desdeCache: boolean, fecha: string | null) => {
    setFechaCache((actual) => {
      if (desdeCache) return fecha && (!actual || fecha < actual) ? fecha : actual ?? fecha;
      return null;
    });
  }, []);

  const valor = useMemo<ValorConexion>(
    () => ({
      estado: data,
      conectado: Boolean(data?.conectado),
      comprobando: isLoading && !data,
      fechaCache: data?.conectado ? null : fechaCache,
      registrarOrigen,
    }),
    [data, isLoading, fechaCache, registrarOrigen],
  );

  return <Contexto.Provider value={valor}>{children}</Contexto.Provider>;
}

export function useConexion(): ValorConexion {
  const valor = useContext(Contexto);
  if (!valor) throw new Error("useConexion debe usarse dentro de ConexionProvider");
  return valor;
}

/** Indicador de estado: verde conectado; ámbar sin conexión con datos guardados (solo local). */
export function IndicadorConexion({ grande = false }: { grande?: boolean }) {
  const { estado, comprobando } = useConexion();
  const tam = grande ? "text-base px-4 py-2" : "text-sm px-3 py-1.5";

  if (comprobando || !estado) {
    return (
      <span className={`inline-flex items-center gap-2 rounded-full border border-gray-300 bg-gray-50 text-gray-700 ${tam}`}>
        <Loader2 className="size-4 animate-spin" aria-hidden /> Comprobando conexión con Oracle
      </span>
    );
  }
  if (estado.conectado) {
    return (
      <span className={`inline-flex items-center gap-2 rounded-full border border-exito-borde bg-exito-fondo font-medium text-exito ${tam}`}>
        <CircleCheck className="size-4" aria-hidden /> Conectado con Oracle
      </span>
    );
  }
  return (
    <span
      className={`inline-flex items-center gap-2 rounded-full border border-advertencia-borde bg-advertencia-fondo font-medium text-advertencia ${tam}`}
      title={estado.mensaje}
    >
      <CloudOff className="size-4" aria-hidden />
      {estado.cache_local ? "Sin conexión: se muestran datos guardados" : "Sin conexión con Oracle"}
    </span>
  );
}

/** Aviso fijo cuando lo que se ve en pantalla viene de la caché local. */
export function AvisoCache() {
  const { fechaCache } = useConexion();
  if (!fechaCache) return null;
  return (
    <div role="status" className="border-b border-advertencia-borde bg-advertencia-fondo px-6 py-2 text-center font-medium text-advertencia">
      <CloudOff className="mr-2 inline size-4 align-[-2px]" aria-hidden />
      Sin conexión: datos guardados del {formatearFechaHora(fechaCache)}
      <span className="font-normal"> (las operaciones y el restablecer están deshabilitados hasta que vuelva la conexión)</span>
    </div>
  );
}
