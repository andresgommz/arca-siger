/**
 * Rutas de ORDS que la capa servidor acepta (lista blanca) y clave de caché de cada GET.
 * Lo comparten los route handlers y los scripts smoke y precargar.
 */

const RUTAS_GET: RegExp[] = [
  /^catalogos\/(centros|albergues|destinos|insumos|solicitudes|conductores|lotes|lotes-todos|familias|despachos-entregados|beneficiarios|personas|necesidades)$/,
  /^catalogos\/despachos\/\d{1,10}\/insumos$/,
  /^consultas\/(trazabilidad|ocupacion|prorrateo|indice-necesidades|vencimientos)$/,
  /^manifestaciones$/,
  /^quiosco\/persona$/,
  /^quiosco\/[A-Za-z0-9-]{1,10}\/(entregas|necesidades|manifestaciones)$/,
  /^publico\/(zonas|albergues)$/,
];

const RUTAS_POST: RegExp[] = [
  /^operaciones\/(alojar|ingresar-lote|despachar|entregar)$/,
  /^quiosco\/manifestaciones$/,
  /^admin\/restablecer$/,
];

/** Parámetros de consulta que se pasan a ORDS; cualquier otro se descarta. */
export const PARAMETROS_PERMITIDOS = ["codigo_censo", "documento", "insumo", "dias", "centro", "beneficiario"] as const;

export function esRutaGet(ruta: string): boolean {
  return RUTAS_GET.some((r) => r.test(ruta));
}

export function esRutaPost(ruta: string): boolean {
  return RUTAS_POST.some((r) => r.test(ruta));
}

/** Filtra y ordena los parámetros para que la misma consulta tenga siempre la misma clave. */
export function normalizarParametros(entrada: URLSearchParams | Record<string, string>): URLSearchParams {
  const origen = entrada instanceof URLSearchParams ? entrada : new URLSearchParams(entrada);
  const salida = new URLSearchParams();
  for (const nombre of PARAMETROS_PERMITIDOS) {
    const valor = origen.get(nombre);
    if (valor !== null && valor.trim() !== "") salida.set(nombre, valor.trim().slice(0, 100));
  }
  salida.sort();
  return salida;
}

/** Ruta con su consulta: "consultas/prorrateo?insumo=Agua+potable+bolsa+6+L". */
export function rutaConParametros(ruta: string, parametros: URLSearchParams): string {
  const q = parametros.toString();
  return q ? `${ruta}?${q}` : ruta;
}

/**
 * Archivo de caché relativo a data/cache/ para una ruta y sus parámetros.
 * Los segmentos de la ruta son carpetas; los parámetros van en el nombre con
 * caracteres seguros para Windows.
 */
export function archivoCache(ruta: string, parametros: URLSearchParams): string {
  const q = parametros.toString();
  const sufijo = q ? `__${q.replace(/[^A-Za-z0-9._=-]/g, "_")}` : "";
  return `${ruta}${sufijo}.json`;
}
