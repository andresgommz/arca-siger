"use client";

export interface Columna<T> {
  titulo: string;
  /** Contenido de la celda. */
  celda: (fila: T) => React.ReactNode;
  alinear?: "izquierda" | "derecha" | "centro";
  ancho?: string;
}

const ALINEAR = { izquierda: "text-left", derecha: "text-right", centro: "text-center" } as const;

export function Tabla<T>({
  columnas,
  filas,
  clave,
  vacio = "La consulta no devolvió filas.",
}: {
  columnas: Columna<T>[];
  filas: T[];
  clave: (fila: T, i: number) => string | number;
  vacio?: string;
}) {
  if (filas.length === 0) {
    return <p className="rounded-lg border border-dashed border-gray-300 p-6 text-center text-gray-600">{vacio}</p>;
  }
  return (
    <div className="overflow-x-auto rounded-lg border border-gray-200">
      <table className="w-full border-collapse text-[0.95rem]">
        <thead className="bg-arca-700 text-white">
          <tr>
            {columnas.map((c) => (
              <th
                key={c.titulo}
                scope="col"
                style={c.ancho ? { width: c.ancho } : undefined}
                className={`px-3 py-2.5 font-semibold ${ALINEAR[c.alinear ?? "izquierda"]}`}
              >
                {c.titulo}
              </th>
            ))}
          </tr>
        </thead>
        <tbody>
          {filas.map((fila, i) => (
            <tr key={clave(fila, i)} className="border-t border-gray-200 odd:bg-white even:bg-gray-50">
              {columnas.map((c) => (
                <td key={c.titulo} className={`px-3 py-2 align-middle ${ALINEAR[c.alinear ?? "izquierda"]}`}>
                  {c.celda(fila)}
                </td>
              ))}
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
