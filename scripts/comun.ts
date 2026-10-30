/**
 * Utilidades de los scripts: carga de variables de entorno y lista de rutas GET.
 */
import { existsSync, readFileSync } from "node:fs";
import path from "node:path";

/** Carga .env.local y .env (sin reemplazar variables ya definidas). */
export function cargarEntorno(): void {
  for (const nombre of [".env.local", ".env"]) {
    const archivo = path.resolve(__dirname, "..", nombre);
    if (!existsSync(archivo)) continue;
    for (const linea of readFileSync(archivo, "utf8").split(/\r?\n/)) {
      const m = /^\s*([A-Za-z_][A-Za-z0-9_]*)\s*=\s*(.*)\s*$/.exec(linea);
      if (!m || linea.trim().startsWith("#")) continue;
      const clave = m[1]!;
      let valor = m[2]!.replace(/\s+#.*$/, "").trim();
      if (/^(["']).*\1$/.test(valor)) valor = valor.slice(1, -1);
      if (process.env[clave] === undefined) process.env[clave] = valor;
    }
  }
}

export type RutaGet = [ruta: string, parametros: Record<string, string>];

/** GET sin parámetros dinámicos, con los valores por defecto de la interfaz. */
export const RUTAS_FIJAS: RutaGet[] = [
  ["catalogos/centros", {}],
  ["catalogos/albergues", {}],
  ["catalogos/destinos", {}],
  ["catalogos/insumos", {}],
  ["catalogos/solicitudes", {}],
  ["catalogos/conductores", {}],
  ["catalogos/lotes-todos", {}],
  ["catalogos/familias", {}],
  ["catalogos/despachos-entregados", {}],
  ["catalogos/beneficiarios", {}],
  ["catalogos/personas", {}],
  ["catalogos/necesidades", { beneficiario: "1001", insumo: "18" }],
  ["consultas/trazabilidad", { codigo_censo: "4821" }],
  ["consultas/ocupacion", {}],
  ["consultas/prorrateo", { insumo: "Agua potable bolsa 6 L" }],
  ["consultas/indice-necesidades", {}],
  ["consultas/vencimientos", { dias: "90" }],
  ["manifestaciones", {}],
  ["quiosco/persona", { codigo_censo: "4821" }],
  ["quiosco/persona", { documento: "63500111" }],
  ["quiosco/4821/entregas", {}],
  ["quiosco/4821/necesidades", {}],
  ["quiosco/4821/manifestaciones", {}],
  ["publico/zonas", {}],
  ["publico/albergues", {}],
];

/** Ejemplos de las rutas con parámetros de catálogos, para el smoke. */
export const RUTAS_EJEMPLO: RutaGet[] = [
  ["catalogos/lotes", { centro: "201" }],
  ["catalogos/despachos/15/insumos", {}],
];

/** Lee el argumento --nombre=valor o --nombre valor. */
export function argumento(nombre: string): string | undefined {
  const args = process.argv.slice(2);
  for (let i = 0; i < args.length; i++) {
    const a = args[i]!;
    if (a === `--${nombre}`) return args[i + 1];
    if (a.startsWith(`--${nombre}=`)) return a.slice(nombre.length + 3);
  }
  return undefined;
}
