"use client";

import Link from "next/link";
import { ArrowLeft } from "lucide-react";
import { AvisoCache, IndicadorConexion } from "./conexion";

export function Logo({ claro = false }: { claro?: boolean }) {
  return (
    <span className={`inline-flex items-center gap-2 font-extrabold tracking-tight ${claro ? "text-white" : "text-arca-700"}`}>
      <svg viewBox="0 0 32 32" className="size-8" aria-hidden>
        <path d="M16 3 3 28h6l7-14 7 14h6L16 3Z" fill="currentColor" />
        <circle cx="16" cy="24" r="3" fill="#E8833A" />
      </svg>
      ARCA
    </span>
  );
}

/** Encabezado de cada perfil: logo, nombre del perfil, acciones y enlace al inicio. */
export function Encabezado({ perfil, acciones }: { perfil: string; acciones?: React.ReactNode }) {
  return (
    <header className="sticky top-0 z-20 bg-arca-700 text-white shadow">
      <div className="mx-auto flex max-w-7xl flex-wrap items-center gap-4 px-6 py-3">
        <Link href="/" className="inline-flex items-center gap-2 rounded-lg px-2 py-1 text-arca-100 hover:bg-arca-800 hover:text-white">
          <ArrowLeft className="size-5" aria-hidden />
          <span className="text-sm font-medium">Inicio</span>
        </Link>
        <Logo claro />
        <h1 className="text-xl font-semibold text-arca-100">{perfil}</h1>
        <div className="ml-auto flex flex-wrap items-center gap-3">
          <span className="rounded-full bg-white">
            <IndicadorConexion />
          </span>
          {acciones}
        </div>
      </div>
      <AvisoCache />
    </header>
  );
}
