/**
 * Caché en archivos para el modo sin conexión (solo local, CACHE_LOCAL=true).
 * Cada GET exitoso se guarda en data/cache/<ruta>.json con su fecha y hora.
 */
import { mkdir, readFile, rename, rm, writeFile } from "node:fs/promises";
import path from "node:path";

export interface EntradaCache {
  ruta: string;
  guardado_en: string; // ISO 8601
  datos: unknown;
}

const DIRECTORIO = path.join(process.cwd(), "data", "cache");

function rutaArchivo(archivo: string): string {
  const completo = path.join(DIRECTORIO, archivo);
  // Evita salir de data/cache con rutas manipuladas.
  if (!completo.startsWith(DIRECTORIO)) throw new Error("Ruta de caché no válida");
  return completo;
}

export async function guardarCache(archivo: string, ruta: string, datos: unknown): Promise<void> {
  const destino = rutaArchivo(archivo);
  await mkdir(path.dirname(destino), { recursive: true });
  const entrada: EntradaCache = { ruta, guardado_en: new Date().toISOString(), datos };
  // Escritura atómica: primero un temporal y luego se renombra, para que nadie lea un JSON a medias.
  const temporal = `${destino}.${process.pid}.${Date.now()}.tmp`;
  await writeFile(temporal, JSON.stringify(entrada, null, 2), "utf8");
  try {
    await rename(temporal, destino);
  } catch (error) {
    await rm(temporal, { force: true });
    throw error;
  }
}

export async function leerCache(archivo: string): Promise<EntradaCache | null> {
  try {
    const texto = await readFile(rutaArchivo(archivo), "utf8");
    return JSON.parse(texto) as EntradaCache;
  } catch {
    return null;
  }
}
