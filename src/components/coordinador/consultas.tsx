"use client";

import { useState } from "react";
import { Code2, Search } from "lucide-react";
import { CONSULTAS_SQL } from "@/generated/consultas-sql";
import { formatearNumero, formatearPorcentaje } from "@/lib/formatos";
import { BarraOcupacion } from "../barra-ocupacion";
import { conParametros, useDatos } from "../datos";
import { Tabla, type Columna } from "../tabla";
import { Boton, Cargando, ErrorCarga, Insignia, Tarjeta, estiloEntrada } from "../ui";
import { Pestanas } from "./pestanas";
import { RutaAyuda, type EntregaTrazada } from "./ruta-ayuda";

type NumConsulta = 1 | 2 | 3 | 4 | 5;

interface Definicion {
  n: NumConsulta;
  titulo: string;
  pregunta: string;
}

const CONSULTAS: Definicion[] = [
  {
    n: 1,
    titulo: "Trazabilidad",
    pregunta: "¿Qué ayudas recibió una persona, quién las recogió y de qué despacho, centro de acopio y lote salieron?",
  },
  {
    n: 2,
    titulo: "Ocupación de albergues",
    pregunta: "¿Cuántas personas hay hoy en cada albergue y cuántos cupos le quedan?",
  },
  {
    n: 3,
    titulo: "Prorrateo",
    pregunta:
      "¿Cómo repartir el inventario disponible de un insumo entre las zonas que lo solicitaron, en proporción a su población en riesgo?",
  },
  {
    n: 4,
    titulo: "Índice de atención",
    pregunta: "¿Qué porcentaje de las necesidades validadas y vigentes de cada zona ya fue atendido con una entrega?",
  },
  {
    n: 5,
    titulo: "Vencimientos",
    pregunta: "¿Qué lotes con existencias vencen en los próximos días y dónde están?",
  },
];

function PanelSql({ n }: { n: NumConsulta }) {
  return (
    <details className="group rounded-lg border border-gray-200 bg-white">
      <summary className="flex cursor-pointer list-none items-center gap-2 px-4 py-3 font-semibold text-arca-700 hover:bg-arca-50">
        <Code2 className="size-5" aria-hidden />
        Ver SQL
        <span className="text-sm font-normal text-gray-500">(ARCA_CONSULTA{n}.sql, tal como está en db/)</span>
      </summary>
      <pre className="overflow-x-auto border-t border-gray-200 bg-arca-900 p-4 font-mono text-sm leading-relaxed text-arca-50">
        {CONSULTAS_SQL[n]}
      </pre>
    </details>
  );
}

/** Contenido común: estado de carga, error con Reintentar o tabla. */
function Resultado<T>({
  ruta,
  columnas,
  clave,
  arriba,
}: {
  ruta: string | null;
  columnas: Columna<T>[];
  clave: (f: T, i: number) => string | number;
  arriba?: (filas: T[]) => React.ReactNode;
}) {
  const { datos, error, cargando, recargar } = useDatos<T[]>(ruta);
  if (error) return <ErrorCarga mensaje={error.message} onReintentar={recargar} />;
  if (cargando || !datos) return <Cargando />;
  return (
    <div className="space-y-3">
      {arriba?.(datos)}
      <Tabla<T> filas={datos} columnas={columnas} clave={clave} />
      <p className="text-sm text-gray-500">{datos.length} filas</p>
    </div>
  );
}

function FormParametro({
  etiqueta,
  valorInicial,
  onAplicar,
  tipo = "text",
  opciones,
}: {
  etiqueta: string;
  valorInicial: string;
  onAplicar: (v: string) => void;
  tipo?: "text" | "number";
  opciones?: string[];
}) {
  const [valor, setValor] = useState(valorInicial);
  return (
    <form
      className="flex flex-wrap items-end gap-3"
      onSubmit={(e) => {
        e.preventDefault();
        onAplicar(valor.trim());
      }}
    >
      <label className="block">
        <span className="mb-1 block text-sm font-semibold text-gray-700">{etiqueta}</span>
        {opciones ? (
          <select value={valor} onChange={(e) => setValor(e.target.value)} className={`${estiloEntrada} min-w-72`}>
            {!opciones.includes(valor) && <option value={valor}>{valor}</option>}
            {opciones.map((o) => (
              <option key={o} value={o}>
                {o}
              </option>
            ))}
          </select>
        ) : (
          <input
            type={tipo}
            min={tipo === "number" ? 0 : undefined}
            value={valor}
            onChange={(e) => setValor(e.target.value)}
            className={`${estiloEntrada} w-48`}
          />
        )}
      </label>
      <Boton type="submit">
        <Search className="size-4" aria-hidden /> Consultar
      </Boton>
    </form>
  );
}

// ---------------------------------------------------------------------------
// 1. Trazabilidad
// ---------------------------------------------------------------------------
type FilaTrazabilidad = EntregaTrazada;

function Trazabilidad() {
  const [codigo, setCodigo] = useState("4821");
  return (
    <div className="space-y-4">
      <FormParametro etiqueta="Código de censo" valorInicial={codigo} onAplicar={setCodigo} />
      <Resultado<FilaTrazabilidad>
        ruta={codigo ? conParametros("consultas/trazabilidad", { codigo_censo: codigo }) : null}
        clave={(f, i) => `${f.despacho}-${f.fecha_entrega}-${f.lote}-${i}`}
        arriba={(filas) =>
          filas[0] && (
            <div className="space-y-4">
              <p className="text-lg">
                <span className="font-bold text-arca-700">{filas[0].beneficiario}</span> (código {codigo}):{" "}
                <span className="cifra font-bold text-naranja-600">{filas.length}</span> entregas registradas a su nombre.
              </p>
              <RutaAyuda entregas={filas} />
              <h3 className="pt-2 text-lg font-semibold text-gray-800">Resultado de la consulta, tal como lo devuelve Oracle</h3>
            </div>
          )
        }
        columnas={[
          { titulo: "Insumo", celda: (f) => <span className="font-medium">{f.insumo}</span> },
          { titulo: "Cantidad", alinear: "derecha", celda: (f) => <span className="cifra">{formatearNumero(f.cantidad)}</span> },
          { titulo: "Fecha entrega", celda: (f) => <span className="cifra whitespace-nowrap">{f.fecha_entrega}</span> },
          {
            titulo: "Recogió",
            celda: (f) =>
              f.recogio === f.beneficiario ? (
                f.recogio
              ) : (
                <span>
                  <span className="font-semibold text-arca-700">{f.recogio}</span>
                  <span className="block text-sm text-gray-600">en su nombre</span>
                </span>
              ),
          },
          { titulo: "Identificado con", celda: (f) => f.identificado_con },
          { titulo: "Despacho", alinear: "derecha", celda: (f) => <span className="cifra">{f.despacho}</span> },
          { titulo: "Centro de acopio", celda: (f) => f.centro_acopio },
          { titulo: "Lote", celda: (f) => <span className="cifra">{f.lote}</span> },
          { titulo: "Destino", celda: (f) => f.destino },
        ]}
      />
    </div>
  );
}

// ---------------------------------------------------------------------------
// 2. Ocupación
// ---------------------------------------------------------------------------
interface FilaOcupacion {
  albergue: string;
  municipio: string;
  capacidad: number;
  personas_alojadas: number;
  cupos_libres: number;
  pct_ocupacion: number;
}

function Ocupacion() {
  return (
    <Resultado<FilaOcupacion>
      ruta="consultas/ocupacion"
      clave={(f) => f.albergue}
      columnas={[
        { titulo: "Albergue", celda: (f) => <span className="font-medium">{f.albergue}</span> },
        { titulo: "Municipio", celda: (f) => f.municipio },
        { titulo: "Capacidad", alinear: "derecha", celda: (f) => <span className="cifra">{formatearNumero(f.capacidad)}</span> },
        { titulo: "Personas alojadas", alinear: "derecha", celda: (f) => <span className="cifra">{formatearNumero(f.personas_alojadas)}</span> },
        { titulo: "Cupos libres", alinear: "derecha", celda: (f) => <span className="cifra">{formatearNumero(f.cupos_libres)}</span> },
        { titulo: "% ocupación", ancho: "16rem", celda: (f) => <BarraOcupacion porcentaje={Number(f.pct_ocupacion)} /> },
      ]}
    />
  );
}

// ---------------------------------------------------------------------------
// 3. Prorrateo
// ---------------------------------------------------------------------------
interface FilaProrrateo {
  zona: string;
  poblacion_riesgo: number;
  solicitado: number;
  demanda_total: number;
  stock_total: number;
  asignacion_prorrateada: number;
}

interface Insumo {
  cod_insumo: number;
  nombre: string;
  unidad: string;
}

function Prorrateo() {
  const [insumo, setInsumo] = useState("Agua potable bolsa 6 L");
  const insumos = useDatos<Insumo[]>("catalogos/insumos");
  const unidad = insumos.datos?.find((i) => i.nombre === insumo)?.unidad;
  const u = unidad === "Litros" ? " (L)" : unidad ? ` (${unidad.toLowerCase()})` : "";
  return (
    <div className="space-y-4">
      <FormParametro
        key={insumos.datos ? "con-opciones" : "sin-opciones"}
        etiqueta="Insumo"
        valorInicial={insumo}
        onAplicar={setInsumo}
        opciones={insumos.datos?.map((i) => i.nombre)}
      />
      <Resultado<FilaProrrateo>
        ruta={insumo ? conParametros("consultas/prorrateo", { insumo }) : null}
        clave={(f, i) => `${f.zona}-${i}`}
        columnas={[
          { titulo: "Zona", celda: (f) => <span className="font-medium">{f.zona}</span> },
          { titulo: "Población en riesgo", alinear: "derecha", celda: (f) => <span className="cifra">{formatearNumero(f.poblacion_riesgo)}</span> },
          { titulo: `Solicitado${u}`, alinear: "derecha", celda: (f) => <span className="cifra">{formatearNumero(f.solicitado)}</span> },
          { titulo: `Demanda total${u}`, alinear: "derecha", celda: (f) => <span className="cifra">{formatearNumero(f.demanda_total)}</span> },
          { titulo: `Stock total${u}`, alinear: "derecha", celda: (f) => <span className="cifra">{formatearNumero(f.stock_total)}</span> },
          {
            titulo: `Asignación prorrateada${u}`,
            alinear: "derecha",
            celda: (f) => (
              <span className="cifra text-lg font-bold text-naranja-600">{formatearNumero(f.asignacion_prorrateada, { minDecimales: 2 })}</span>
            ),
          },
        ]}
      />
    </div>
  );
}

// ---------------------------------------------------------------------------
// 4. Índice de atención
// ---------------------------------------------------------------------------
interface FilaIndice {
  zona: string;
  nivel_dano: string;
  necesidades_validadas: number;
  atendidas: number;
  pendientes: number;
  indice: number;
}

function IndicePorcentaje({ valor }: { valor: number }) {
  const tono = valor <= 0 ? "rechazo" : valor < 100 ? "advertencia" : "exito";
  return (
    <Insignia tono={tono}>
      <span className="cifra text-base font-bold">{formatearPorcentaje(valor)}</span>
    </Insignia>
  );
}

function Indice() {
  return (
    <Resultado<FilaIndice>
      ruta="consultas/indice-necesidades"
      clave={(f) => f.zona}
      columnas={[
        { titulo: "Zona", celda: (f) => <span className="font-medium">{f.zona}</span> },
        { titulo: "Nivel de daño", celda: (f) => f.nivel_dano },
        { titulo: "Necesidades validadas", alinear: "derecha", celda: (f) => <span className="cifra">{f.necesidades_validadas}</span> },
        { titulo: "Atendidas", alinear: "derecha", celda: (f) => <span className="cifra">{f.atendidas}</span> },
        { titulo: "Pendientes", alinear: "derecha", celda: (f) => <span className="cifra">{f.pendientes}</span> },
        { titulo: "Índice", alinear: "centro", celda: (f) => <IndicePorcentaje valor={Number(f.indice)} /> },
      ]}
    />
  );
}

// ---------------------------------------------------------------------------
// 5. Vencimientos
// ---------------------------------------------------------------------------
interface FilaVencimiento {
  centro_acopio: string;
  municipio: string;
  insumo: string;
  lote: string;
  vence: string;
  dias_restantes: number;
  disponible: number;
  unidad: string;
}

function Vencimientos() {
  const [dias, setDias] = useState("90");
  return (
    <div className="space-y-4">
      <FormParametro etiqueta="Días hacia adelante" tipo="number" valorInicial={dias} onAplicar={setDias} />
      <Resultado<FilaVencimiento>
        ruta={dias ? conParametros("consultas/vencimientos", { dias }) : null}
        clave={(f, i) => `${f.lote}-${f.centro_acopio}-${i}`}
        columnas={[
          { titulo: "Centro de acopio", celda: (f) => <span className="font-medium">{f.centro_acopio}</span> },
          { titulo: "Municipio", celda: (f) => f.municipio },
          { titulo: "Insumo", celda: (f) => f.insumo },
          { titulo: "Lote", celda: (f) => <span className="cifra">{f.lote}</span> },
          { titulo: "Vence", celda: (f) => <span className="cifra whitespace-nowrap">{f.vence}</span> },
          {
            titulo: "Días restantes",
            alinear: "centro",
            celda: (f) =>
              f.dias_restantes < 30 ? (
                <Insignia tono="advertencia">
                  <span className="cifra font-bold">{f.dias_restantes}</span>
                </Insignia>
              ) : (
                <span className="cifra">{f.dias_restantes}</span>
              ),
          },
          { titulo: "Disponible", alinear: "derecha", celda: (f) => <span className="cifra">{formatearNumero(f.disponible)}</span> },
          { titulo: "Unidad", celda: (f) => f.unidad },
        ]}
      />
    </div>
  );
}

const COMPONENTES: Record<NumConsulta, () => React.ReactNode> = {
  1: Trazabilidad,
  2: Ocupacion,
  3: Prorrateo,
  4: Indice,
  5: Vencimientos,
};

export function Consultas() {
  const [n, setN] = useState<NumConsulta>(1);
  const def = CONSULTAS.find((c) => c.n === n) ?? CONSULTAS[0]!;
  const Componente = COMPONENTES[n];
  return (
    <div className="space-y-5">
      <Pestanas<`${NumConsulta}`>
        tamano="pequena"
        activa={`${n}`}
        onCambiar={(c) => setN(Number(c) as NumConsulta)}
        pestanas={CONSULTAS.map((c) => ({ clave: `${c.n}` as `${NumConsulta}`, titulo: `${c.n}. ${c.titulo}` }))}
      />
      <Tarjeta className="space-y-5">
        <div>
          <h2 className="text-3xl font-bold text-arca-700">
            Consulta {def.n}: {def.titulo}
          </h2>
          <p className="mt-1 text-lg text-gray-700">{def.pregunta}</p>
        </div>
        <Componente />
        <PanelSql n={n} />
      </Tarjeta>
    </div>
  );
}
