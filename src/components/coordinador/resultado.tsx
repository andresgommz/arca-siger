"use client";

import { CircleCheck, ShieldX } from "lucide-react";
import type { RespuestaPost } from "@/lib/tipos-api";
import { Insignia } from "../ui";

/** Panel de resultado: verde con lo creado o rojo con la regla violada y el texto de Oracle. */
export function ResultadoOperacion({
  respuesta,
  exito,
  notaRechazo,
}: {
  respuesta: RespuestaPost | null;
  /** Texto de éxito construido con la respuesta de Oracle. */
  exito: (r: Record<string, unknown>) => React.ReactNode;
  notaRechazo?: string;
}) {
  if (!respuesta) return null;

  if (respuesta.ok) {
    return (
      <div role="status" className="rounded-lg border-2 border-exito-borde bg-exito-fondo p-4 text-exito">
        <p className="flex items-center gap-2 text-lg font-bold">
          <CircleCheck className="size-6" aria-hidden /> Oracle aceptó la operación
        </p>
        <div className="mt-1 text-gray-800">{exito(respuesta)}</div>
      </div>
    );
  }

  const t = respuesta.traduccion;
  return (
    <div role="alert" className="rounded-lg border-2 border-rechazo-borde bg-rechazo-fondo p-4">
      <p className="flex flex-wrap items-center gap-2 text-lg font-bold text-rechazo">
        <ShieldX className="size-6" aria-hidden />
        {respuesta.tipo === "oracle" ? "Oracle rechazó la operación" : "No se pudo completar la operación"}
        {t?.regla && <Insignia tono="rechazo">{t.regla}</Insignia>}
      </p>
      <p className="mt-1 text-lg text-gray-900">{respuesta.mensaje}</p>
      {respuesta.tipo === "oracle" && notaRechazo && <p className="mt-1 text-gray-700">{notaRechazo}</p>}
      {t?.original && (
        <pre className="mt-3 whitespace-pre-wrap break-words rounded-md bg-white/80 p-3 font-mono text-sm text-rechazo ring-1 ring-rechazo-borde">
          {t.original}
        </pre>
      )}
    </div>
  );
}
