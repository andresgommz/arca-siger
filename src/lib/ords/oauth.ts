/**
 * Token OAuth2 (client credentials) para ORDS, guardado en memoria hasta poco antes de vencer.
 */
import { leerConfig, TIEMPO_ESPERA_MS } from "../config";
import { fetchOrds } from "./http";

interface TokenGuardado {
  valor: string;
  venceEn: number; // epoch ms
}

let tokenGuardado: TokenGuardado | null = null;
let solicitudEnCurso: Promise<string> | null = null;

export class ErrorToken extends Error {}

async function pedirToken(): Promise<string> {
  const config = leerConfig();
  const basica = Buffer.from(`${config.clientId}:${config.clientSecret}`, "utf8").toString("base64");
  const respuesta = await fetchOrds(config.tokenUrl, {
    method: "POST",
    headers: {
      Authorization: `Basic ${basica}`,
      "Content-Type": "application/x-www-form-urlencoded",
      Accept: "application/json",
    },
    body: "grant_type=client_credentials",
    cache: "no-store",
    signal: AbortSignal.timeout(TIEMPO_ESPERA_MS),
  });
  if (!respuesta.ok) {
    const texto = (await respuesta.text()).slice(0, 300);
    throw new ErrorToken(`ORDS rechazó la solicitud de token (HTTP ${respuesta.status}). ${texto}`.trim());
  }
  const json = (await respuesta.json()) as { access_token?: string; expires_in?: number };
  if (!json.access_token) throw new ErrorToken("La respuesta de ORDS no trae access_token.");
  const segundos = typeof json.expires_in === "number" ? json.expires_in : 3600;
  // Se renueva un minuto antes del vencimiento.
  tokenGuardado = { valor: json.access_token, venceEn: Date.now() + Math.max(segundos - 60, 30) * 1000 };
  return json.access_token;
}

export async function obtenerToken(forzarNuevo = false): Promise<string> {
  if (!forzarNuevo && tokenGuardado && tokenGuardado.venceEn > Date.now()) return tokenGuardado.valor;
  if (!solicitudEnCurso) {
    solicitudEnCurso = pedirToken().finally(() => {
      solicitudEnCurso = null;
    });
  }
  return solicitudEnCurso;
}

export function olvidarToken(): void {
  tokenGuardado = null;
}
