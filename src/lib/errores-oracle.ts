/**
 * Traducción de errores de Oracle a mensajes de regla de negocio (sección 8 del PRD).
 * El texto original de Oracle nunca se oculta: la interfaz muestra los dos.
 */

export interface ErrorTraducido {
  /** Código ORA-nnnnn, si se pudo identificar. */
  codigo: string | null;
  /** Regla o tipo de restricción: RN-03, RN-05, Dominio, Integridad, Unicidad, o null. */
  regla: string | null;
  /** Mensaje de negocio para la pantalla. */
  mensaje: string;
  /** Nombre de la restricción violada, si el texto de Oracle la incluye. */
  restriccion: string | null;
  /** Texto original de Oracle. */
  original: string;
}

/** Extrae el nombre de la restricción del texto "(ESQUEMA.NOMBRE)". */
function restriccionDe(texto: string): string | null {
  const m = /\(\s*"?[A-Z0-9_$#]+"?\s*\.\s*"?([A-Z0-9_$#]+)"?\s*\)/i.exec(texto);
  return m?.[1]?.toUpperCase() ?? null;
}

function codigoDe(sqlcode: number | null | undefined, texto: string): string | null {
  if (typeof sqlcode === "number" && sqlcode < 0) {
    return `ORA-${String(Math.abs(sqlcode)).padStart(5, "0")}`;
  }
  const m = /ORA-(\d{5})/.exec(texto);
  return m ? `ORA-${m[1]}` : null;
}

export function traducirErrorOracle(entrada: { sqlcode?: number | null; mensaje?: string | null }): ErrorTraducido {
  const original = (entrada.mensaje ?? "").trim();
  const codigo = codigoDe(entrada.sqlcode, original);
  const restriccion = restriccionDe(original);
  const base = { codigo, restriccion, original };

  switch (codigo) {
    case "ORA-20003":
      return { ...base, regla: "RN-03", mensaje: "El albergue ya alcanzó su capacidad máxima." };
    case "ORA-20008":
      return { ...base, regla: "RN-08", mensaje: "La cantidad supera la disponibilidad real del lote." };
    case "ORA-20012":
      return { ...base, regla: "RN-12", mensaje: "El lote no pertenece al centro de acopio que emite el despacho." };
    case "ORA-02290":
      if (restriccion === "C_ILO_VENC_CK" || /C_ILO_VENC_CK/i.test(original)) {
        return {
          ...base,
          restriccion: "C_ILO_VENC_CK",
          regla: "RN-05",
          mensaje: "Los perecederos deben vencer al menos 30 días después de su recepción.",
        };
      }
      return {
        ...base,
        regla: "Dominio",
        mensaje: restriccion
          ? `Un valor no está permitido (restricción ${restriccion}).`
          : "Un valor no está permitido.",
      };
    case "ORA-00001":
      if (restriccion === "UX_FAL_ACTIVA" || /UX_FAL_ACTIVA/i.test(original)) {
        return { ...base, restriccion: "UX_FAL_ACTIVA", regla: "RN-13", mensaje: "La familia ya tiene un alojamiento activo." };
      }
      return { ...base, regla: "Unicidad", mensaje: "Ya existe un registro con ese valor." };
    case "ORA-02291":
      return { ...base, regla: "Integridad", mensaje: "Un dato referenciado no existe." };
    default:
      return {
        ...base,
        regla: null,
        mensaje: original ? `Error de la base de datos: ${original}` : "Error de la base de datos.",
      };
  }
}
