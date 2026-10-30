import { formatearPorcentaje } from "@/lib/formatos";

/** Barra de ocupación de un albergue: roja al 100 %. */
export function BarraOcupacion({ porcentaje }: { porcentaje: number }) {
  const lleno = porcentaje >= 100;
  const ancho = Math.max(0, Math.min(100, porcentaje));
  return (
    <div className="flex min-w-44 items-center gap-2">
      <div
        className="h-3 flex-1 overflow-hidden rounded-full bg-gray-200"
        role="meter"
        aria-valuemin={0}
        aria-valuemax={100}
        aria-valuenow={Math.round(porcentaje)}
        aria-label="Ocupación"
      >
        <div className={`h-full rounded-full ${lleno ? "bg-rechazo" : "bg-arca-500"}`} style={{ width: `${ancho}%` }} />
      </div>
      <span className={`cifra w-16 text-right font-semibold ${lleno ? "text-rechazo" : "text-gray-800"}`}>
        {formatearPorcentaje(porcentaje)}
      </span>
    </div>
  );
}
