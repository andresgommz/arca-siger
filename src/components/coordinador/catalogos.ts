/** Filas de los catálogos de ORDS que usan los formularios. */

export interface Centro {
  cod_centro: number;
  nombre: string;
  municipio: string;
}

export interface AlbergueCatalogo {
  cod_albergue: number;
  nombre: string;
  municipio: string;
  capacidad_maxima: number;
}

export interface Destino {
  cod_destino: number;
  nombre: string;
  tipo: string;
  municipio: string;
}

export interface InsumoCatalogo {
  cod_insumo: number;
  nombre: string;
  perecedero: string;
  unidad: string;
  modalidad_entrega: string;
}

export interface Solicitud {
  cod_solicitud: number;
  zona: string;
  descripcion: string;
  estado: string;
  prioridad: string;
}

export interface Conductor {
  cod_conductor: number;
  nombre: string;
  disponibilidad: string;
}

export interface Lote {
  cod_lote: number;
  num_lote: string;
  insumo: string;
  vencimiento: string | null;
  disponible: number;
  unidad: string;
  cod_centro?: number;
  centro?: string;
}

export interface Familia {
  cod_familia: number;
  num_integrantes: number;
  integrantes: string | null;
  albergue_actual: string | null;
}

export interface DespachoEntregado {
  cod_despacho: number;
  destino: string;
  centro: string;
  fecha_entrega: string;
}

export interface InsumoDespacho {
  cod_insumo: number;
  insumo: string;
  unidad: string;
  cantidad_despachada: number;
  cantidad_entregada: number;
}

export interface Beneficiario {
  cod_beneficiario: number;
  codigo_censo: string;
  nombre: string;
  documento: string | null;
}

export interface Persona {
  cod_persona: number;
  nombre: string;
  documento: string | null;
}

export interface NecesidadCatalogo {
  cod_necesidad: number;
  categoria: string;
  vigencia_desde: string;
  vigencia_hasta: string;
}

/** Valor de un select: "" significa sin elegir. */
export function aNumero(valor: string): number | null {
  return valor === "" ? null : Number(valor);
}
