"use client";

import { useCallback, useEffect } from "react";
import useSWR, { useSWRConfig } from "swr";
import type { RespuestaGet, RespuestaGetOk } from "@/lib/tipos-api";
import { useConexion } from "./conexion";

export class ErrorApi extends Error {
  constructor(
    mensaje: string,
    readonly noEncontrado = false,
  ) {
    super(mensaje);
  }
}

export async function cargarApi<T>(url: string): Promise<RespuestaGetOk<T>> {
  let r: Response;
  try {
    r = await fetch(url, { cache: "no-store" });
  } catch {
    throw new ErrorApi("No se pudo conectar con el servidor de la aplicación.");
  }
  let json: RespuestaGet<T>;
  try {
    json = (await r.json()) as RespuestaGet<T>;
  } catch {
    throw new ErrorApi(`El servidor respondió HTTP ${r.status}.`);
  }
  if (!json.ok) throw new ErrorApi(json.error, Boolean(json.no_encontrado));
  return json;
}

/**
 * Datos de un GET de /api/<ruta>. Con ruta null no consulta nada.
 * Informa al contexto de conexión si los datos vienen de la caché local.
 */
export function useDatos<T>(ruta: string | null) {
  const { registrarOrigen } = useConexion();
  const { data, error, isLoading, isValidating, mutate } = useSWR<RespuestaGetOk<T>, ErrorApi>(
    ruta ? `/api/${ruta}` : null,
    cargarApi<T>,
  );

  useEffect(() => {
    if (data) registrarOrigen(data.desde_cache, data.fecha_cache);
  }, [data, registrarOrigen]);

  return {
    datos: data?.datos,
    desdeCache: data?.desde_cache ?? false,
    error,
    cargando: isLoading,
    actualizando: isValidating,
    recargar: useCallback(() => void mutate(), [mutate]),
  };
}

/** Vuelve a consultar las rutas que empiezan por alguno de los prefijos (o todas si no se dan). */
export function useInvalidar() {
  const { mutate } = useSWRConfig();
  return useCallback(
    (prefijos?: string[]) =>
      mutate(
        (clave) =>
          typeof clave === "string" &&
          clave.startsWith("/api/") &&
          clave !== "/api/estado" &&
          (!prefijos || prefijos.some((p) => clave.startsWith(`/api/${p}`))),
      ),
    [mutate],
  );
}

/** Construye "ruta?param=valor" omitiendo valores vacíos. */
export function conParametros(ruta: string, parametros: Record<string, string | number | null | undefined>): string {
  const p = new URLSearchParams();
  for (const [k, v] of Object.entries(parametros)) {
    if (v !== null && v !== undefined && String(v).trim() !== "") p.set(k, String(v).trim());
  }
  p.sort();
  const q = p.toString();
  return q ? `${ruta}?${q}` : ruta;
}
