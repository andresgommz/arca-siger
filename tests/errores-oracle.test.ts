import { describe, expect, it } from "vitest";
import { traducirErrorOracle } from "../src/lib/errores-oracle";

// Una prueba por cada fila de la tabla de la sección 8 del PRD.
describe("traducirErrorOracle", () => {
  it("ORA-20003: RN-03 capacidad del albergue", () => {
    const mensaje =
      "ORA-20003: RN-03: el albergue ya alcanzó su capacidad máxima; no se puede asignar la familia.\nORA-06512: en \"WKSP_ARCA.TRG_FAL_CAPACIDAD\", línea 12";
    const r = traducirErrorOracle({ sqlcode: -20003, mensaje });
    expect(r.codigo).toBe("ORA-20003");
    expect(r.regla).toBe("RN-03");
    expect(r.mensaje).toBe("El albergue ya alcanzó su capacidad máxima.");
    expect(r.original).toBe(mensaje);
  });

  it("ORA-20008: RN-08 disponibilidad del lote", () => {
    const r = traducirErrorOracle({ sqlcode: -20008, mensaje: "ORA-20008: RN-08: la cantidad supera la disponibilidad del lote (0)." });
    expect(r.regla).toBe("RN-08");
    expect(r.mensaje).toBe("La cantidad supera la disponibilidad real del lote.");
  });

  it("ORA-20012: RN-12 lote de otro centro", () => {
    const r = traducirErrorOracle({ sqlcode: -20012, mensaje: "ORA-20012: RN-12: el lote no pertenece al centro de acopio que emite el despacho." });
    expect(r.regla).toBe("RN-12");
    expect(r.mensaje).toBe("El lote no pertenece al centro de acopio que emite el despacho.");
  });

  it("ORA-02290 con C_ILO_VENC_CK: RN-05 vencimiento de perecederos", () => {
    const r = traducirErrorOracle({ sqlcode: -2290, mensaje: "ORA-02290: check constraint (WKSP_ARCA.C_ILO_VENC_CK) violated" });
    expect(r.codigo).toBe("ORA-02290");
    expect(r.regla).toBe("RN-05");
    expect(r.restriccion).toBe("C_ILO_VENC_CK");
    expect(r.mensaje).toBe("Los perecederos deben vencer al menos 30 días después de su recepción.");
  });

  it("ORA-00001 con UX_FAL_ACTIVA: RN-13 alojamiento activo", () => {
    const r = traducirErrorOracle({ sqlcode: -1, mensaje: "ORA-00001: unique constraint (WKSP_ARCA.UX_FAL_ACTIVA) violated" });
    expect(r.codigo).toBe("ORA-00001");
    expect(r.regla).toBe("RN-13");
    expect(r.mensaje).toBe("La familia ya tiene un alojamiento activo.");
  });

  it("ORA-02290 con otra restricción: Dominio e indica la restricción", () => {
    const r = traducirErrorOracle({ sqlcode: -2290, mensaje: "ORA-02290: restricción de control (WKSP_ARCA.C_ENT_CANT_CK) violada" });
    expect(r.regla).toBe("Dominio");
    expect(r.restriccion).toBe("C_ENT_CANT_CK");
    expect(r.mensaje).toBe("Un valor no está permitido (restricción C_ENT_CANT_CK).");
  });

  it("ORA-02291: Integridad", () => {
    const r = traducirErrorOracle({
      sqlcode: -2291,
      mensaje: "ORA-02291: integrity constraint (WKSP_ARCA.C_ENT_NDA_FK) violated - parent key not found",
    });
    expect(r.regla).toBe("Integridad");
    expect(r.restriccion).toBe("C_ENT_NDA_FK");
    expect(r.mensaje).toBe("Un dato referenciado no existe.");
  });

  it("ORA-00001 con otra restricción: Unicidad", () => {
    const r = traducirErrorOracle({ sqlcode: -1, mensaje: "ORA-00001: unique constraint (WKSP_ARCA.C_FAL_PK) violated" });
    expect(r.regla).toBe("Unicidad");
    expect(r.mensaje).toBe("Ya existe un registro con ese valor.");
  });

  it("Otro error: muestra el texto original", () => {
    const original = "ORA-01400: cannot insert NULL into (\"WKSP_ARCA\".\"INVENTARIO_LOTE\".\"NUM_LOTE\")";
    const r = traducirErrorOracle({ sqlcode: -1400, mensaje: original });
    expect(r.regla).toBeNull();
    expect(r.codigo).toBe("ORA-01400");
    expect(r.mensaje).toBe(`Error de la base de datos: ${original}`);
    expect(r.original).toBe(original);
  });

  it("Sin sqlcode: toma el código ORA del texto", () => {
    const r = traducirErrorOracle({ mensaje: "ORA-20003: RN-03: el albergue ya alcanzó su capacidad máxima" });
    expect(r.codigo).toBe("ORA-20003");
    expect(r.regla).toBe("RN-03");
  });

  it("NO_DATA_FOUND (sqlcode positivo 100): error genérico con texto original", () => {
    const r = traducirErrorOracle({ sqlcode: 100, mensaje: "ORA-01403: no data found" });
    expect(r.codigo).toBe("ORA-01403");
    expect(r.regla).toBeNull();
    expect(r.mensaje).toContain("ORA-01403");
  });
});
