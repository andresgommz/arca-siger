"use client";

import { useCallback, useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { ArrowLeft, Loader2 } from "lucide-react";
import { AvisoCache, IndicadorConexion, useConexion } from "../conexion";
import { cargarApi, ErrorApi } from "../datos";
import { Logo } from "../encabezado";
import { TecladoNumerico } from "./teclado";

type Modo = "codigo" | "documento";
const MAXIMO = { codigo: 10, documento: 15 } as const;

export function EntradaQuiosco() {
  const router = useRouter();
  const { registrarOrigen } = useConexion();
  const [modo, setModo] = useState<Modo>("codigo");
  const [valor, setValor] = useState("");
  const [buscando, setBuscando] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const entrar = useCallback(async () => {
    if (!valor || buscando) return;
    setBuscando(true);
    setError(null);
    const parametro = modo === "codigo" ? "codigo_censo" : "documento";
    try {
      const r = await cargarApi<{ codigo_censo: string }>(`/api/quiosco/persona?${parametro}=${encodeURIComponent(valor)}`);
      registrarOrigen(r.desde_cache, r.fecha_cache);
      router.push(`/quiosco/${encodeURIComponent(r.datos.codigo_censo)}`);
    } catch (e) {
      setBuscando(false);
      if (e instanceof ErrorApi && e.noEncontrado) {
        setError(
          modo === "codigo"
            ? "Ese código no aparece en el censo. Revíselo e intente de nuevo."
            : "Ese número de documento no aparece en el censo. Revíselo o use su código.",
        );
      } else {
        setError(e instanceof Error ? e.message : "No se pudo consultar. Intente de nuevo.");
      }
    }
  }, [valor, buscando, modo, router, registrarOrigen]);

  // También funciona con el teclado físico.
  useEffect(() => {
    const alPulsar = (e: KeyboardEvent) => {
      if (/^\d$/.test(e.key)) setValor((v) => (v.length < MAXIMO[modo] ? v + e.key : v));
      else if (e.key === "Backspace") setValor((v) => v.slice(0, -1));
      else if (e.key === "Enter") void entrar();
    };
    window.addEventListener("keydown", alPulsar);
    return () => window.removeEventListener("keydown", alPulsar);
  }, [modo, entrar]);

  const cambiarModo = (m: Modo) => {
    setModo(m);
    setValor("");
    setError(null);
  };

  return (
    <div className="flex min-h-screen flex-col bg-arca-700 text-white">
      <AvisoCache />
      <header className="flex items-center justify-between px-8 py-5">
        <Link href="/" className="inline-flex items-center gap-2 rounded-lg px-2 py-1 text-arca-100 hover:bg-arca-800">
          <ArrowLeft className="size-5" aria-hidden /> Inicio
        </Link>
        <span className="text-2xl">
          <Logo claro />
        </span>
        <span className="rounded-full bg-white">
          <IndicadorConexion />
        </span>
      </header>

      <main className="mx-auto flex w-full max-w-xl flex-1 flex-col justify-center px-6 pb-12">
        <h1 className="text-center text-4xl font-extrabold leading-tight">Bienvenido</h1>
        <p className="mt-3 text-center text-2xl text-arca-100">
          {modo === "codigo" ? "Escriba su código de censo" : "Escriba su número de documento"}
        </p>

        <div
          aria-live="polite"
          className="cifra mt-8 flex h-24 items-center justify-center rounded-2xl bg-white text-6xl font-extrabold tracking-[0.2em] text-arca-900"
        >
          {valor || <span className="text-3xl font-semibold tracking-normal text-gray-500">{modo === "codigo" ? "Código" : "Documento"}</span>}
        </div>

        {error && (
          <p role="alert" className="mt-4 rounded-xl bg-rechazo-fondo p-4 text-center text-xl font-semibold text-rechazo">
            {error}
          </p>
        )}

        <div className="mt-6">
          <TecladoNumerico
            onTecla={(d) => setValor((v) => (v.length < MAXIMO[modo] ? v + d : v))}
            onBorrar={() => setValor((v) => v.slice(0, -1))}
            onEntrar={() => void entrar()}
            entrarDeshabilitado={!valor || buscando}
          />
        </div>

        {buscando && (
          <p className="mt-5 flex items-center justify-center gap-2 text-xl" role="status">
            <Loader2 className="size-6 animate-spin" aria-hidden /> Buscando…
          </p>
        )}

        <button
          type="button"
          onClick={() => cambiarModo(modo === "codigo" ? "documento" : "codigo")}
          className="mt-8 text-center text-2xl font-semibold text-naranja-100 underline underline-offset-4 hover:text-white"
        >
          {modo === "codigo" ? "No recuerdo mi código" : "Prefiero usar mi código de censo"}
        </button>
      </main>
    </div>
  );
}
