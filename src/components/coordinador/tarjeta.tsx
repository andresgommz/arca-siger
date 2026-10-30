"use client";

import { FlaskConical } from "lucide-react";
import { Tarjeta } from "../ui";

/** Tarjeta de una operación con su título, las reglas que la protegen y el formulario. */
export function TarjetaOperacion({
  titulo,
  reglas,
  children,
}: {
  titulo: string;
  reglas: string;
  children: React.ReactNode;
}) {
  return (
    <Tarjeta className="flex flex-col gap-4">
      <div>
        <h3 className="text-2xl font-bold text-arca-700">{titulo}</h3>
        <p className="text-gray-600">Reglas en Oracle: {reglas}</p>
      </div>
      {children}
    </Tarjeta>
  );
}

/** Enlaces que llenan el formulario con casos preparados para la exposición. */
export function DatosDemo({ casos }: { casos: { etiqueta: string; aplicar: () => void }[] }) {
  return (
    <div className="flex flex-wrap items-center gap-x-4 gap-y-1 rounded-lg bg-naranja-50 px-3 py-2 text-sm">
      <FlaskConical className="size-4 text-naranja-600" aria-hidden />
      {casos.map((c) => (
        <button
          key={c.etiqueta}
          type="button"
          onClick={c.aplicar}
          className="font-semibold text-naranja-700 underline underline-offset-2 hover:text-arca-700"
        >
          {c.etiqueta}
        </button>
      ))}
    </div>
  );
}
