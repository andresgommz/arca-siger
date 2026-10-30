"use client";

import { useEffect, useRef } from "react";
import { AlertTriangle, Loader2, RotateCw, X } from "lucide-react";

type Variante = "primario" | "acento" | "secundario" | "peligro";

const VARIANTES: Record<Variante, string> = {
  primario: "bg-arca-700 text-white hover:bg-arca-800 disabled:bg-gray-300 disabled:text-gray-600",
  acento: "bg-naranja-600 text-white hover:bg-naranja-700 disabled:bg-gray-300 disabled:text-gray-600",
  secundario: "border border-gray-300 bg-white text-arca-700 hover:bg-arca-50 disabled:text-gray-400",
  peligro: "bg-rechazo text-white hover:bg-red-800 disabled:bg-gray-300 disabled:text-gray-600",
};

export function Boton({
  variante = "primario",
  cargando = false,
  className = "",
  children,
  disabled,
  ...resto
}: React.ButtonHTMLAttributes<HTMLButtonElement> & { variante?: Variante; cargando?: boolean }) {
  return (
    <button
      {...resto}
      disabled={disabled || cargando}
      className={`inline-flex items-center justify-center gap-2 rounded-lg px-4 py-2.5 font-semibold transition-colors disabled:cursor-not-allowed ${VARIANTES[variante]} ${className}`}
    >
      {cargando && <Loader2 className="size-4 animate-spin" aria-hidden />}
      {children}
    </button>
  );
}

export function Tarjeta({ className = "", children }: { className?: string; children: React.ReactNode }) {
  return <section className={`rounded-xl border border-gray-200 bg-white p-5 shadow-sm ${className}`}>{children}</section>;
}

export function Cargando({ texto = "Consultando Oracle" }: { texto?: string }) {
  return (
    <div className="flex items-center gap-2 py-6 text-gray-600" role="status">
      <Loader2 className="size-5 animate-spin" aria-hidden /> {texto}…
    </div>
  );
}

export function ErrorCarga({ mensaje, onReintentar }: { mensaje: string; onReintentar?: () => void }) {
  return (
    <div role="alert" className="flex flex-wrap items-center gap-3 rounded-lg border border-rechazo-borde bg-rechazo-fondo p-4 text-rechazo">
      <AlertTriangle className="size-5 shrink-0" aria-hidden />
      <span className="flex-1">{mensaje}</span>
      {onReintentar && (
        <Boton variante="secundario" onClick={onReintentar}>
          <RotateCw className="size-4" aria-hidden /> Reintentar
        </Boton>
      )}
    </div>
  );
}

type Tono = "neutro" | "marca" | "rechazo" | "advertencia" | "exito";
const TONOS: Record<Tono, string> = {
  neutro: "bg-gray-100 text-gray-700 border-gray-200",
  marca: "bg-arca-50 text-arca-700 border-arca-100",
  rechazo: "bg-rechazo-fondo text-rechazo border-rechazo-borde",
  advertencia: "bg-advertencia-fondo text-advertencia border-advertencia-borde",
  exito: "bg-exito-fondo text-exito border-exito-borde",
};

export function Insignia({ tono = "neutro", children }: { tono?: Tono; children: React.ReactNode }) {
  return (
    <span className={`inline-flex items-center gap-1 whitespace-nowrap rounded-full border px-2.5 py-0.5 text-sm font-medium ${TONOS[tono]}`}>
      {children}
    </span>
  );
}

export function Dialogo({
  abierto,
  titulo,
  onCerrar,
  children,
}: {
  abierto: boolean;
  titulo: string;
  onCerrar: () => void;
  children: React.ReactNode;
}) {
  const ref = useRef<HTMLDialogElement>(null);
  useEffect(() => {
    const d = ref.current;
    if (!d) return;
    if (abierto && !d.open) d.showModal();
    if (!abierto && d.open) d.close();
  }, [abierto]);

  return (
    <dialog
      ref={ref}
      onCancel={(e) => {
        e.preventDefault();
        onCerrar();
      }}
      className="m-auto w-full max-w-lg rounded-xl p-0 shadow-2xl backdrop:bg-arca-900/50"
    >
      <div className="flex items-center justify-between border-b border-gray-200 px-6 py-4">
        <h2 className="text-xl font-bold text-arca-700">{titulo}</h2>
        <button type="button" onClick={onCerrar} className="rounded p-1 text-gray-500 hover:bg-gray-100" aria-label="Cerrar">
          <X className="size-5" />
        </button>
      </div>
      <div className="px-6 py-5">{children}</div>
    </dialog>
  );
}

/** Campo de formulario con etiqueta. */
export function Campo({ etiqueta, ayuda, children }: { etiqueta: string; ayuda?: React.ReactNode; children: React.ReactNode }) {
  return (
    <label className="block">
      <span className="mb-1 block text-sm font-semibold text-gray-700">{etiqueta}</span>
      {children}
      {ayuda && <span className="mt-1 block text-sm text-gray-500">{ayuda}</span>}
    </label>
  );
}

export const estiloEntrada =
  "w-full rounded-lg border border-gray-300 bg-white px-3 py-2 text-base text-gray-900 focus:border-arca-500 disabled:bg-gray-100";
