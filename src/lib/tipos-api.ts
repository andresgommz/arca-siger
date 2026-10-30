/**
 * Formato de las respuestas de /api/* (lo comparten servidor y cliente).
 */
import type { ErrorTraducido } from "./errores-oracle";

export interface RespuestaGetOk<T = unknown> {
  ok: true;
  datos: T;
  /** true si ORDS no respondió y los datos vienen de data/cache/ (solo local). */
  desde_cache: boolean;
  /** Fecha y hora (ISO) en que se guardó la copia, si desde_cache. */
  fecha_cache: string | null;
}

export interface RespuestaGetError {
  ok: false;
  error: string;
  no_encontrado?: boolean;
}

export type RespuestaGet<T = unknown> = RespuestaGetOk<T> | RespuestaGetError;

export type TipoErrorPost = "oracle" | "clave" | "conexion" | "servidor" | "solicitud";

export interface RespuestaPostError {
  ok: false;
  tipo: TipoErrorPost;
  mensaje: string;
  sqlcode?: number;
  traduccion?: ErrorTraducido;
}

export type RespuestaPost = ({ ok: true } & Record<string, unknown>) | RespuestaPostError;

export interface EstadoConexion {
  conectado: boolean;
  configurado: boolean;
  cache_local: boolean;
  clave_requerida: boolean;
  zona_horaria: string;
  mensaje: string;
}
