/**
 * Cliente de ORDS: único lugar que conoce la URL y las credenciales.
 * - GET: normaliza la respuesta, guarda la copia en caché (solo local) y, si ORDS
 *   no responde en 8 segundos, devuelve la última copia guardada.
 * - POST: nunca usa caché; traduce los errores de Oracle.
 */
import { leerConfig, TIEMPO_ESPERA_MS } from "../config";
import { guardarCache, leerCache } from "../cache";
import { traducirErrorOracle } from "../errores-oracle";
import { archivoCache, rutaConParametros } from "../rutas";
import type { RespuestaGet, RespuestaPost } from "../tipos-api";
import { fetchOrds } from "./http";
import { obtenerToken, olvidarToken } from "./oauth";

/** Error con el estado HTTP que debe devolver la capa servidor. */
class ErrorOrds extends Error {
  constructor(
    mensaje: string,
    readonly estado: number,
  ) {
    super(mensaje);
  }
}

async function llamarOrds(metodo: "GET" | "POST", rutaCompleta: string, cuerpo?: unknown, esperaMs = TIEMPO_ESPERA_MS) {
  const config = leerConfig();
  if (!config.configurado) throw new ErrorOrds("ORDS no está configurado (revise las variables de entorno).", 503);
  const url = new URL(rutaCompleta, config.baseUrl).toString();

  const enviar = async (token: string) =>
    fetchOrds(url, {
      method: metodo,
      headers: {
        Authorization: `Bearer ${token}`,
        Accept: "application/json",
        ...(cuerpo !== undefined ? { "Content-Type": "application/json" } : {}),
      },
      body: cuerpo !== undefined ? JSON.stringify(cuerpo) : undefined,
      cache: "no-store",
      signal: AbortSignal.timeout(esperaMs),
    });

  let respuesta = await enviar(await obtenerToken());
  if (respuesta.status === 401) {
    // El token pudo vencer o revocarse: se pide uno nuevo una sola vez.
    olvidarToken();
    respuesta = await enviar(await obtenerToken(true));
  }
  return respuesta;
}

async function leerJson(respuesta: Response): Promise<unknown> {
  const texto = await respuesta.text();
  try {
    return JSON.parse(texto);
  } catch {
    return { texto: texto.slice(0, 500) };
  }
}

function sinEnlaces(fila: unknown): unknown {
  if (fila && typeof fila === "object" && !Array.isArray(fila)) {
    const { links: _links, ...resto } = fila as Record<string, unknown>;
    return resto;
  }
  return fila;
}

/** Colección de ORDS ({items: [...]}) a arreglo; elemento único a objeto. */
function normalizar(json: unknown): unknown {
  if (json && typeof json === "object" && Array.isArray((json as { items?: unknown }).items)) {
    return ((json as { items: unknown[] }).items).map(sinEnlaces);
  }
  return sinEnlaces(json);
}

function esReintentable(error: unknown): boolean {
  if (error instanceof ErrorOrds) return error.estado === 502;
  if (error instanceof Error) return error.name !== "TimeoutError" && error.name !== "AbortError";
  return false;
}

function describirFallo(error: unknown): string {
  if (error instanceof ErrorOrds) return error.message;
  if (error instanceof Error) {
    if (error.name === "TimeoutError" || error.name === "AbortError") return "ORDS no respondió en 8 segundos.";
    return `No se pudo conectar con ORDS (${error.message}).`;
  }
  return "No se pudo conectar con ORDS.";
}

export async function ordsGet(ruta: string, parametros: URLSearchParams): Promise<{ estado: number; cuerpo: RespuestaGet }> {
  const config = leerConfig();
  const rutaCompleta = rutaConParametros(ruta, parametros);
  const archivo = archivoCache(ruta, parametros);

  try {
    let respuesta: Response;
    try {
      respuesta = await llamarOrds("GET", rutaCompleta);
      if (respuesta.status >= 500) throw new ErrorOrds(`ORDS respondió HTTP ${respuesta.status}`, 502);
    } catch (error) {
      // apex.oracle.com a veces corta una conexión o responde 5xx un momento: se reintenta una vez.
      // Si ORDS no respondió en el tiempo de espera, no se reintenta y se pasa a la caché.
      if (!esReintentable(error)) throw error;
      respuesta = await llamarOrds("GET", rutaCompleta);
    }
    if (respuesta.status === 404) {
      return { estado: 404, cuerpo: { ok: false, error: "No se encontró el registro.", no_encontrado: true } };
    }
    if (!respuesta.ok) {
      const detalle = await leerJson(respuesta);
      throw new ErrorOrds(`ORDS respondió HTTP ${respuesta.status}: ${JSON.stringify(detalle).slice(0, 300)}`, 502);
    }
    const datos = normalizar(await leerJson(respuesta));
    if (config.cacheLocal) {
      await guardarCache(archivo, rutaCompleta, datos).catch(() => undefined);
    }
    return { estado: 200, cuerpo: { ok: true, datos, desde_cache: false, fecha_cache: null } };
  } catch (error) {
    const motivo = describirFallo(error);
    if (config.cacheLocal) {
      const copia = await leerCache(archivo);
      if (copia) {
        return { estado: 200, cuerpo: { ok: true, datos: copia.datos, desde_cache: true, fecha_cache: copia.guardado_en } };
      }
      return { estado: 503, cuerpo: { ok: false, error: `${motivo} No hay datos guardados para esta consulta.` } };
    }
    return { estado: error instanceof ErrorOrds ? error.estado : 503, cuerpo: { ok: false, error: motivo } };
  }
}

export async function ordsPost(ruta: string, cuerpo: unknown, esperaMs = TIEMPO_ESPERA_MS): Promise<{ estado: number; cuerpo: RespuestaPost }> {
  let respuesta: Response;
  try {
    respuesta = await llamarOrds("POST", ruta, cuerpo, esperaMs);
  } catch (error) {
    return { estado: 503, cuerpo: { ok: false, tipo: "conexion", mensaje: describirFallo(error) } };
  }

  const json = (await leerJson(respuesta)) as Record<string, unknown>;
  if (respuesta.ok && json.ok === true) {
    return { estado: 200, cuerpo: json as { ok: true } & Record<string, unknown> };
  }
  if (typeof json.mensaje === "string" && json.ok === false) {
    const sqlcode = typeof json.sqlcode === "number" ? json.sqlcode : Number(json.sqlcode);
    const traduccion = traducirErrorOracle({ sqlcode: Number.isFinite(sqlcode) ? sqlcode : null, mensaje: json.mensaje });
    return {
      estado: 422,
      cuerpo: { ok: false, tipo: "oracle", mensaje: traduccion.mensaje, sqlcode, traduccion },
    };
  }
  return {
    estado: 502,
    cuerpo: { ok: false, tipo: "servidor", mensaje: `ORDS respondió HTTP ${respuesta.status}: ${JSON.stringify(json).slice(0, 300)}` },
  };
}

/** GET directo a ORDS, sin caché, para el smoke: devuelve el estado HTTP y cuántas filas llegaron. */
export async function probarRuta(rutaCompleta: string): Promise<{ estado: number; filas: number | null; detalle: string }> {
  try {
    const respuesta = await llamarOrds("GET", rutaCompleta);
    const json = await leerJson(respuesta);
    const datos = normalizar(json);
    const filas = Array.isArray(datos) ? datos.length : respuesta.ok ? 1 : null;
    return { estado: respuesta.status, filas, detalle: respuesta.ok ? "" : JSON.stringify(json).slice(0, 200) };
  } catch (error) {
    return { estado: 0, filas: null, detalle: describirFallo(error) };
  }
}

/** Comprueba la conexión pidiendo un catálogo pequeño. */
export async function probarConexion(): Promise<{ conectado: boolean; mensaje: string }> {
  // Un corte momentáneo de apex.oracle.com no debe marcar la app "sin conexión": se reintenta una vez.
  for (let intento = 1; ; intento++) {
    try {
      const respuesta = await llamarOrds("GET", "catalogos/centros");
      if (respuesta.ok) return { conectado: true, mensaje: "Conectado con Oracle." };
      if (respuesta.status < 500 || intento > 1) return { conectado: false, mensaje: `ORDS respondió HTTP ${respuesta.status}.` };
    } catch (error) {
      if (!esReintentable(error) || intento > 1) return { conectado: false, mensaje: describirFallo(error) };
    }
  }
}
