/**
 * Llena data/cache/ con la respuesta de todos los GET, para el modo sin conexión.
 * Ejecutar con conexión a internet antes de la exposición: npm run precargar
 */
import { cargarEntorno, RUTAS_FIJAS, type RutaGet } from "./comun";

cargarEntorno();
// La precarga siempre escribe en la caché local, aunque CACHE_LOCAL no esté en true.
process.env.CACHE_LOCAL = "true";

async function main() {
  const { leerConfig } = await import("../src/lib/config");
  const { ordsGet } = await import("../src/lib/ords/cliente");
  const { normalizarParametros } = await import("../src/lib/rutas");

  if (!leerConfig().configurado) {
    console.error("Faltan variables de ORDS en .env.local.");
    process.exit(1);
  }

  let correctas = 0;
  const fallas: string[] = [];

  async function cargar([ruta, parametros]: RutaGet): Promise<unknown> {
    const p = normalizarParametros(parametros);
    const etiqueta = p.toString() ? `${ruta}?${p.toString()}` : ruta;
    // Hasta 3 intentos: el servidor gratuito de apex.oracle.com a veces falla un momento.
    let { cuerpo } = await ordsGet(ruta, p);
    for (let intento = 2; intento <= 3 && !(cuerpo.ok && !cuerpo.desde_cache) && !(!cuerpo.ok && cuerpo.no_encontrado); intento++) {
      ({ cuerpo } = await ordsGet(ruta, p));
    }
    if (cuerpo.ok && !cuerpo.desde_cache) {
      correctas++;
      const n = Array.isArray(cuerpo.datos) ? `${cuerpo.datos.length} filas` : "1 registro";
      console.log(`✔ ${etiqueta.padEnd(60)} ${n}`);
      return cuerpo.datos;
    }
    fallas.push(etiqueta);
    console.log(`✘ ${etiqueta.padEnd(60)} ${cuerpo.ok ? "ORDS no respondió (se mantuvo la copia anterior)" : cuerpo.error}`);
    return null;
  }

  const datos = new Map<string, unknown>();
  for (const r of RUTAS_FIJAS) datos.set(r[0], await cargar(r));

  // Rutas que dependen de los catálogos.
  const centros = (datos.get("catalogos/centros") as { cod_centro: number }[] | null) ?? [];
  for (const c of centros) await cargar(["catalogos/lotes", { centro: String(c.cod_centro) }]);

  const despachos = (datos.get("catalogos/despachos-entregados") as { cod_despacho: number }[] | null) ?? [];
  for (const d of despachos) await cargar([`catalogos/despachos/${d.cod_despacho}/insumos`, {}]);

  const insumos = (datos.get("catalogos/insumos") as { nombre: string }[] | null) ?? [];
  for (const i of insumos) {
    if (i.nombre !== "Agua potable bolsa 6 L") await cargar(["consultas/prorrateo", { insumo: i.nombre }]);
  }

  console.log(`\nCaché lista en data/cache/: ${correctas} respuestas guardadas.`);
  if (fallas.length) {
    console.log(`No se pudieron guardar: ${fallas.join(", ")}`);
    process.exit(1);
  }
}

void main();
