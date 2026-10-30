"use client";

import { Delete } from "lucide-react";

/** Teclado numérico grande en pantalla para el quiosco. */
export function TecladoNumerico({
  onTecla,
  onBorrar,
  onEntrar,
  entrarDeshabilitado,
}: {
  onTecla: (d: string) => void;
  onBorrar: () => void;
  onEntrar: () => void;
  entrarDeshabilitado: boolean;
}) {
  const tecla =
    "flex h-20 items-center justify-center rounded-2xl text-4xl font-bold shadow-sm transition active:scale-95 focus-visible:outline-4";
  return (
    <div className="grid grid-cols-3 gap-3">
      {["1", "2", "3", "4", "5", "6", "7", "8", "9"].map((d) => (
        <button key={d} type="button" onClick={() => onTecla(d)} className={`${tecla} bg-white text-arca-900 ring-2 ring-arca-200 hover:bg-arca-50`}>
          {d}
        </button>
      ))}
      <button type="button" onClick={onBorrar} className={`${tecla} bg-gray-200 text-gray-900 hover:bg-gray-300`} aria-label="Borrar">
        <Delete className="size-9" aria-hidden />
      </button>
      <button type="button" onClick={() => onTecla("0")} className={`${tecla} bg-white text-arca-900 ring-2 ring-arca-200 hover:bg-arca-50`}>
        0
      </button>
      <button
        type="button"
        onClick={onEntrar}
        disabled={entrarDeshabilitado}
        className={`${tecla} bg-naranja-600 text-2xl text-white hover:bg-naranja-700 disabled:bg-gray-300 disabled:text-gray-600`}
      >
        Entrar
      </button>
    </div>
  );
}
