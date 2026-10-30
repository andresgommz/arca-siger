/**
 * Prueba de humo: llama a cada endpoint GET e informa cuál falla.
 *
 *   npm run smoke                      -> directo a ORDS con las credenciales de .env.local
 *   npm run smoke -- --url https://... -> a la versión publicada (rutas /api/*), sin credenciales
 */
import { argumento, cargarEntorno, RUTAS_EJEMPLO, RUTAS_FIJAS, type RutaGet } from "./comun";

cargarEntorno();

interface Resultado {
  ruta: string;
  ok: boolean;
  detalle: string;
}

function rutaCompleta([ruta, parametros]: RutaGet): string {
  const q = new URLSearchParams(parametros);
  q.sort();
  const s = q.toString();
  return s ? `${ruta}?${s}` : ruta;
}

async function contraOrds(rutas: RutaGet[]): Promise<Resultado[]> {
  const { leerConfig } = await import("../src/lib/config");
  const { obtenerToken } = await import("../src/lib/ords/oauth");
  const { probarRuta } = await import("../src/lib/ords/cliente");

  const config = leerConfig();
  if (!config.configurado) {
    if (`${config.baseUrl}${config.tokenUrl}`.includes("<")) {
      console.error("ORDS_BASE_URL u ORDS_OAUTH_TOKEN_URL todavía tienen <alias_del_esquema>: cámbielo por el alias de APEX (SQL Workshop > RESTful Services).");
    } else {
      console.error("Faltan variables de ORDS en .env.local (ORDS_BASE_URL, ORDS_OAUTH_TOKEN_URL, ORDS_CLIENT_ID, ORDS_CLIENT_SECRET).");
    }
    process.exit(1);
  }
  console.log(`ORDS: ${config.baseUrl}`);
  try {
    await obtenerToken(true);
    console.log("✔ Token OAuth2 obtenido");
  } catch (e) {
    console.error(`✘ Token OAuth2: ${e instanceof Error ? e.message : String(e)}`);
    process.exit(1);
  }

  const resultados: Resultado[] = [];
  for (const r of rutas) {
    const completa = rutaCompleta(r);
    const inicio = Date.now();
    const p = await probarRuta(completa);
    const ms = Date.now() - inicio;
    const ok = p.estado === 200;
    resultados.push({
      ruta: completa,
      ok,
      detalle: ok ? `${p.filas ?? 0} filas, ${ms} ms` : `HTTP ${p.estado || "sin respuesta"} ${p.detalle}`,
    });
  }
  return resultados;
}

async function contraPublicada(base: string, rutas: RutaGet[]): Promise<Resultado[]> {
  const raiz = base.replace(/\/+$/, "");
  console.log(`Versión publicada: ${raiz}`);
  const resultados: Resultado[] = [];

  for (const r of rutas) {
    const completa = rutaCompleta(r);
    const inicio = Date.now();
    try {
      const respuesta = await fetch(`${raiz}/api/${completa}`, { signal: AbortSignal.timeout(20000) });
      const json = (await respuesta.json()) as { ok?: boolean; datos?: unknown; error?: string; desde_cache?: boolean };
      const ms = Date.now() - inicio;
      const filas = Array.isArray(json.datos) ? json.datos.length : json.datos ? 1 : 0;
      const ok = respuesta.ok && json.ok === true && !json.desde_cache;
      resultados.push({
        ruta: completa,
        ok,
        detalle: ok ? `${filas} filas, ${ms} ms` : `HTTP ${respuesta.status} ${json.error ?? (json.desde_cache ? "datos de caché" : "")}`,
      });
    } catch (e) {
      resultados.push({ ruta: completa, ok: false, detalle: e instanceof Error ? e.message : String(e) });
    }
  }

  // La clave de demostración: un POST sin clave debe responder 401. El cuerpo vacío
  // no modifica datos aunque no haya clave (Oracle rechazaría el INSERT con nulos).
  try {
    const respuesta = await fetch(`${raiz}/api/operaciones/alojar`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: "{}",
      signal: AbortSignal.timeout(20000),
    });
    resultados.push({
      ruta: "POST operaciones/alojar sin clave",
      ok: respuesta.status === 401,
      detalle: respuesta.status === 401 ? "401: la clave de demostración está activa" : `HTTP ${respuesta.status}: no se exige clave (DEMO_CLAVE vacía)`,
    });
  } catch (e) {
    resultados.push({ ruta: "POST operaciones/alojar sin clave", ok: false, detalle: e instanceof Error ? e.message : String(e) });
  }
  return resultados;
}

async function main() {
  const url = argumento("url");
  const rutas = [...RUTAS_FIJAS, ...RUTAS_EJEMPLO];
  const resultados = url ? await contraPublicada(url, rutas) : await contraOrds(rutas);

  for (const r of resultados) console.log(`${r.ok ? "✔" : "✘"} ${r.ruta.padEnd(58)} ${r.detalle}`);
  const fallas = resultados.filter((r) => !r.ok);
  console.log(`\n${resultados.length - fallas.length} de ${resultados.length} correctas.`);
  if (fallas.length) {
    console.log(`Fallan: ${fallas.map((f) => f.ruta).join(", ")}`);
    process.exit(1);
  }
}

void main();
