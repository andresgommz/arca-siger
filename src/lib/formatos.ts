/**
 * Formateadores de número y fecha para la interfaz (formato colombiano).
 * Se implementan a mano, sin depender de los datos de idioma del navegador o de
 * Node, para que el resultado sea siempre el mismo: 1.552,79 y 29/10/2026.
 */

export const ZONA_HORARIA = "America/Bogota";

/**
 * Número con punto de miles y coma decimal.
 * Por defecto muestra hasta 2 decimales y no rellena con ceros (66,7; 1.020; 1.552,79).
 */
export function formatearNumero(
  valor: number | string | null | undefined,
  opciones: { maxDecimales?: number; minDecimales?: number } = {},
): string {
  if (valor === null || valor === undefined || valor === "") return "";
  const n = typeof valor === "number" ? valor : Number(valor);
  if (!Number.isFinite(n)) return String(valor);
  const maxDecimales = opciones.maxDecimales ?? 2;
  const minDecimales = Math.min(opciones.minDecimales ?? 0, maxDecimales);

  const negativo = n < 0;
  let [entero = "0", decimales = ""] = Math.abs(n).toFixed(maxDecimales).split(".");
  decimales = decimales.replace(/0+$/, "");
  while (decimales.length < minDecimales) decimales += "0";

  const conMiles = entero.replace(/\B(?=(\d{3})+(?!\d))/g, ".");
  const resultado = decimales ? `${conMiles},${decimales}` : conMiles;
  return negativo && resultado !== "0" ? `-${resultado}` : resultado;
}

/** Porcentaje con una cifra decimal como máximo: 66,7 % */
export function formatearPorcentaje(valor: number | null | undefined): string {
  if (valor === null || valor === undefined) return "";
  return `${formatearNumero(valor, { maxDecimales: 1 })} %`;
}

function partes(fecha: Date, zona: string): Record<string, string> {
  const formato = new Intl.DateTimeFormat("en-GB", {
    timeZone: zona,
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
    hour: "2-digit",
    minute: "2-digit",
    hourCycle: "h23",
  });
  const r: Record<string, string> = {};
  for (const p of formato.formatToParts(fecha)) r[p.type] = p.value;
  return r;
}

/** DD/MM/AAAA en la zona horaria indicada. */
export function formatearFecha(fecha: Date | string, zona: string = ZONA_HORARIA): string {
  const p = partes(typeof fecha === "string" ? new Date(fecha) : fecha, zona);
  return `${p.day}/${p.month}/${p.year}`;
}

/** DD/MM/AAAA HH:MM en la zona horaria indicada. */
export function formatearFechaHora(fecha: Date | string, zona: string = ZONA_HORARIA): string {
  const p = partes(typeof fecha === "string" ? new Date(fecha) : fecha, zona);
  return `${p.day}/${p.month}/${p.year} ${p.hour}:${p.minute}`;
}

/** Fecha de hoy en la zona horaria indicada, en formato AAAA-MM-DD (valor de un input date). */
export function hoyISO(zona: string = ZONA_HORARIA, ahora: Date = new Date()): string {
  const p = partes(ahora, zona);
  return `${p.year}-${p.month}-${p.day}`;
}

/** Suma días a una fecha AAAA-MM-DD sin pasar por zonas horarias. */
export function sumarDiasISO(fechaISO: string, dias: number): string {
  const [a, m, d] = fechaISO.split("-").map(Number);
  const f = new Date(Date.UTC(a ?? 1970, (m ?? 1) - 1, d ?? 1));
  f.setUTCDate(f.getUTCDate() + dias);
  return f.toISOString().slice(0, 10);
}

/** AAAA-MM-DD a DD/MM/AAAA (formato que esperan los manejadores de ORDS). */
export function isoADMA(fechaISO: string): string {
  const m = /^(\d{4})-(\d{2})-(\d{2})$/.exec(fechaISO.trim());
  if (!m) return fechaISO;
  return `${m[3]}/${m[2]}/${m[1]}`;
}
