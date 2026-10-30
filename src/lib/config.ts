/**
 * Configuración del servidor, leída de las variables de entorno.
 * Solo se usa en la capa servidor: nunca se importa desde componentes de cliente.
 */
export interface Config {
  baseUrl: string;
  tokenUrl: string;
  clientId: string;
  clientSecret: string;
  zonaHoraria: string;
  demoClave: string;
  cacheLocal: boolean;
  /** true cuando están las cuatro variables necesarias para hablar con ORDS. */
  configurado: boolean;
}

function texto(nombre: string): string {
  return (process.env[nombre] ?? "").trim();
}

export function leerConfig(): Config {
  let baseUrl = texto("ORDS_BASE_URL");
  if (baseUrl && !baseUrl.endsWith("/")) baseUrl += "/";
  const tokenUrl = texto("ORDS_OAUTH_TOKEN_URL");
  const clientId = texto("ORDS_CLIENT_ID");
  const clientSecret = texto("ORDS_CLIENT_SECRET");
  const configurado = Boolean(baseUrl && tokenUrl && clientId && clientSecret) && !baseUrl.includes("<");
  return {
    baseUrl,
    tokenUrl,
    clientId,
    clientSecret,
    zonaHoraria: texto("DEMO_TIMEZONE") || "America/Bogota",
    demoClave: texto("DEMO_CLAVE"),
    // En Vercel el sistema de archivos es de solo lectura: la caché se activa solo con CACHE_LOCAL=true.
    cacheLocal: texto("CACHE_LOCAL").toLowerCase() === "true" && !process.env.VERCEL,
    configurado,
  };
}

/** Tiempo máximo de espera de una respuesta de ORDS antes de usar la caché (sección 12 del PRD). */
export const TIEMPO_ESPERA_MS = 8000;
