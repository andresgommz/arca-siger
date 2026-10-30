import { describe, expect, it } from "vitest";
import { claveValida } from "../src/lib/clave-demo";
import { archivoCache, esRutaGet, esRutaPost, normalizarParametros, rutaConParametros } from "../src/lib/rutas";

describe("lista blanca de rutas", () => {
  it("acepta las rutas GET del PRD", () => {
    expect(esRutaGet("catalogos/lotes")).toBe(true);
    expect(esRutaGet("catalogos/despachos/15/insumos")).toBe(true);
    expect(esRutaGet("consultas/trazabilidad")).toBe(true);
    expect(esRutaGet("quiosco/4821/entregas")).toBe(true);
    expect(esRutaGet("publico/zonas")).toBe(true);
  });

  it("rechaza rutas desconocidas o con métodos cruzados", () => {
    expect(esRutaGet("admin/restablecer")).toBe(false);
    expect(esRutaGet("../oauth/token")).toBe(false);
    expect(esRutaPost("consultas/ocupacion")).toBe(false);
    expect(esRutaPost("operaciones/alojar")).toBe(true);
  });
});

describe("parámetros y caché", () => {
  it("descarta parámetros no permitidos y ordena", () => {
    const p = normalizarParametros(new URLSearchParams("z=1&insumo=Agua potable bolsa 6 L&codigo_censo=4821"));
    expect(p.toString()).toBe("codigo_censo=4821&insumo=Agua+potable+bolsa+6+L");
  });

  it("genera nombres de archivo seguros", () => {
    const p = normalizarParametros({ insumo: "Agua potable bolsa 6 L" });
    expect(rutaConParametros("consultas/prorrateo", p)).toBe("consultas/prorrateo?insumo=Agua+potable+bolsa+6+L");
    expect(archivoCache("consultas/prorrateo", p)).toBe("consultas/prorrateo__insumo=Agua_potable_bolsa_6_L.json");
    expect(archivoCache("publico/zonas", new URLSearchParams())).toBe("publico/zonas.json");
  });
});

describe("clave de demostración", () => {
  it("no exige clave si DEMO_CLAVE está vacía", () => {
    expect(claveValida("", null)).toBe(true);
  });
  it("exige la clave exacta si está configurada", () => {
    expect(claveValida("arca2026", "arca2026")).toBe(true);
    expect(claveValida("arca2026", "otra")).toBe(false);
    expect(claveValida("arca2026", null)).toBe(false);
  });
});
