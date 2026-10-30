/**
 * Capa servidor entre el navegador y ORDS: /api/<ruta de ORDS>.
 * Solo acepta las rutas de la lista blanca de src/lib/rutas.ts.
 */
import { NextResponse, type NextRequest } from "next/server";
import { leerConfig } from "@/lib/config";
import { claveValida, ENCABEZADO_CLAVE } from "@/lib/clave-demo";
import { ordsGet, ordsPost } from "@/lib/ords/cliente";
import { esRutaGet, esRutaPost, normalizarParametros } from "@/lib/rutas";
import type { RespuestaPostError } from "@/lib/tipos-api";

export const dynamic = "force-dynamic";
export const runtime = "nodejs";
// P_RESTABLECER_DEMO vuelve a insertar los 598 registros: se le da más tiempo.
export const maxDuration = 60;

interface Contexto {
  params: Promise<{ ruta: string[] }>;
}

const SIN_CACHE = { "Cache-Control": "no-store" };

export async function GET(request: NextRequest, { params }: Contexto) {
  const ruta = (await params).ruta.join("/");
  if (!esRutaGet(ruta)) {
    return NextResponse.json({ ok: false, error: "Ruta no disponible." }, { status: 404, headers: SIN_CACHE });
  }
  const { estado, cuerpo } = await ordsGet(ruta, normalizarParametros(request.nextUrl.searchParams));
  return NextResponse.json(cuerpo, { status: estado, headers: SIN_CACHE });
}

export async function POST(request: NextRequest, { params }: Contexto) {
  const ruta = (await params).ruta.join("/");
  if (!esRutaPost(ruta)) {
    const error: RespuestaPostError = { ok: false, tipo: "solicitud", mensaje: "Ruta no disponible." };
    return NextResponse.json(error, { status: 404, headers: SIN_CACHE });
  }

  const config = leerConfig();
  if (!claveValida(config.demoClave, request.headers.get(ENCABEZADO_CLAVE))) {
    const error: RespuestaPostError = { ok: false, tipo: "clave", mensaje: "La clave de demostración no es válida." };
    return NextResponse.json(error, { status: 401, headers: SIN_CACHE });
  }

  let cuerpo: unknown = {};
  try {
    const texto = await request.text();
    cuerpo = texto ? JSON.parse(texto) : {};
  } catch {
    const error: RespuestaPostError = { ok: false, tipo: "solicitud", mensaje: "El cuerpo de la solicitud no es JSON válido." };
    return NextResponse.json(error, { status: 400, headers: SIN_CACHE });
  }
  if (!cuerpo || typeof cuerpo !== "object" || Array.isArray(cuerpo)) {
    const error: RespuestaPostError = { ok: false, tipo: "solicitud", mensaje: "El cuerpo debe ser un objeto JSON." };
    return NextResponse.json(error, { status: 400, headers: SIN_CACHE });
  }

  const espera = ruta === "admin/restablecer" ? 55000 : undefined;
  const { estado, cuerpo: respuesta } = await ordsPost(ruta, cuerpo, espera);
  return NextResponse.json(respuesta, { status: estado, headers: SIN_CACHE });
}
