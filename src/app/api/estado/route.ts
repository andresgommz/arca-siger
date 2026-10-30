/**
 * Estado de la conexión con Oracle para el indicador de la interfaz.
 */
import { NextResponse } from "next/server";
import { leerConfig } from "@/lib/config";
import { probarConexion } from "@/lib/ords/cliente";
import type { EstadoConexion } from "@/lib/tipos-api";

export const dynamic = "force-dynamic";
export const runtime = "nodejs";

// Evita consultar ORDS en cada sondeo de cada pestaña abierta.
let ultimo: { en: number; resultado: { conectado: boolean; mensaje: string } } | null = null;
const VIGENCIA_MS = 10000;

export async function GET() {
  const config = leerConfig();
  let resultado: { conectado: boolean; mensaje: string };
  if (!config.configurado) {
    resultado = { conectado: false, mensaje: "ORDS no está configurado (revise las variables de entorno)." };
  } else if (ultimo && Date.now() - ultimo.en < VIGENCIA_MS) {
    resultado = ultimo.resultado;
  } else {
    resultado = await probarConexion();
    ultimo = { en: Date.now(), resultado };
  }

  const estado: EstadoConexion = {
    ...resultado,
    configurado: config.configurado,
    cache_local: config.cacheLocal,
    clave_requerida: Boolean(config.demoClave),
    zona_horaria: config.zonaHoraria,
  };
  return NextResponse.json(estado, { headers: { "Cache-Control": "no-store" } });
}
