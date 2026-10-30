"use client";

export interface Pestana<K extends string> {
  clave: K;
  titulo: string;
  icono?: React.ReactNode;
}

export function Pestanas<K extends string>({
  pestanas,
  activa,
  onCambiar,
  tamano = "grande",
}: {
  pestanas: Pestana<K>[];
  activa: K;
  onCambiar: (clave: K) => void;
  tamano?: "grande" | "pequena";
}) {
  const grande = tamano === "grande";
  return (
    <div role="tablist" className={`flex flex-wrap gap-2 ${grande ? "border-b-2 border-gray-200" : ""}`}>
      {pestanas.map((p) => {
        const sel = p.clave === activa;
        const estilo = grande
          ? `-mb-0.5 border-b-4 px-5 py-3 text-lg font-semibold ${sel ? "border-naranja-400 text-arca-700" : "border-transparent text-gray-600 hover:text-arca-700"}`
          : `rounded-full px-4 py-2 font-semibold ${sel ? "bg-arca-700 text-white" : "bg-white text-arca-700 ring-1 ring-gray-300 hover:bg-arca-50"}`;
        return (
          <button
            key={p.clave}
            role="tab"
            type="button"
            aria-selected={sel}
            onClick={() => onCambiar(p.clave)}
            className={`inline-flex items-center gap-2 ${estilo}`}
          >
            {p.icono}
            {p.titulo}
          </button>
        );
      })}
    </div>
  );
}
