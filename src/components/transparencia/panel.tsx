"use client";

import { Bar, BarChart, CartesianGrid, LabelList, Legend, ResponsiveContainer, Tooltip, XAxis, YAxis } from "recharts";
import { ShieldCheck } from "lucide-react";
import { BarraOcupacion } from "../barra-ocupacion";
import { useDatos } from "../datos";
import { usePrefiereMenosMovimiento } from "../movimiento";
import { Encabezado } from "../encabezado";
import { Tabla } from "../tabla";
import { Cargando, ErrorCarga, Insignia, Tarjeta } from "../ui";
import { formatearNumero, formatearPorcentaje } from "@/lib/formatos";

interface Zona {
  zona: string;
  municipio: string;
  nivel_dano: string;
  poblacion_riesgo: number;
  personas_censadas: number;
  entregas_registradas: number;
  necesidades_validadas: number;
  necesidades_atendidas: number;
}

interface Albergue {
  albergue: string;
  municipio: string;
  capacidad_maxima: number;
  personas_alojadas: number;
  cupos_disponibles: number;
  pct_ocupacion: number;
}

const ORDEN_NIVEL: Record<string, number> = { Crítico: 1, Alto: 2, Medio: 3, Bajo: 4 };

function suma(filas: Zona[], campo: keyof Zona): number {
  return filas.reduce((t, f) => t + Number(f[campo] ?? 0), 0);
}

function sinCeros(valor: unknown): string {
  return Number(valor) > 0 ? formatearNumero(Number(valor)) : "";
}

function listar(nombres: string[]): string {
  if (nombres.length <= 1) return nombres.join("");
  return `${nombres.slice(0, -1).join(", ")} y ${nombres[nombres.length - 1]}`;
}

/** Una frase con lo que hay que leer en el gráfico: avance general y zonas sin ninguna atención. */
function resumenGrafico(filas: Zona[]): string {
  const validadas = suma(filas, "necesidades_validadas");
  const atendidas = suma(filas, "necesidades_atendidas");
  const sinAtender = filas.filter((z) => z.necesidades_validadas > 0 && z.necesidades_atendidas === 0).map((z) => z.zona);
  const avance = `${formatearNumero(atendidas)} de ${formatearNumero(validadas)} necesidades validadas ya recibieron una entrega.`;
  if (sinAtender.length === 0) return avance;
  return `${avance} Sin ninguna atendida todavía: ${listar(sinAtender)}.`;
}

function Total({ titulo, valor, detalle }: { titulo: string; valor: string; detalle?: string }) {
  return (
    <Tarjeta>
      <p className="text-base font-medium text-gray-600">{titulo}</p>
      <p className="cifra mt-1 text-5xl font-extrabold text-naranja-600">{valor}</p>
      {detalle && <p className="mt-1 text-gray-600">{detalle}</p>}
    </Tarjeta>
  );
}

export function PanelTransparencia() {
  // Esta pantalla solo usa los endpoints publico/*.
  const zonas = useDatos<Zona[]>("publico/zonas");
  const albergues = useDatos<Albergue[]>("publico/albergues");
  const menosMovimiento = usePrefiereMenosMovimiento();

  const filasZonas = [...(zonas.datos ?? [])].sort(
    (a, b) => (ORDEN_NIVEL[a.nivel_dano] ?? 9) - (ORDEN_NIVEL[b.nivel_dano] ?? 9),
  );
  const validadas = suma(filasZonas, "necesidades_validadas");
  const atendidas = suma(filasZonas, "necesidades_atendidas");

  return (
    <div className="min-h-screen bg-gray-50">
      <Encabezado perfil="Transparencia pública" />
      <main className="mx-auto max-w-7xl space-y-6 px-6 py-8">
        <div>
          <h2 className="text-4xl font-extrabold text-arca-700">Así se distribuye la ayuda</h2>
          <p className="mt-2 text-lg text-gray-600">Cifras en vivo desde las vistas públicas de Oracle, por zona afectada y por albergue.</p>
        </div>

        {zonas.error ? (
          <ErrorCarga mensaje={zonas.error.message} onReintentar={zonas.recargar} />
        ) : zonas.cargando ? (
          <Cargando />
        ) : (
          <>
            <div className="grid gap-5 md:grid-cols-3">
              <Total titulo="Personas censadas" valor={formatearNumero(suma(filasZonas, "personas_censadas"))} />
              <Total titulo="Entregas registradas" valor={formatearNumero(suma(filasZonas, "entregas_registradas"))} />
              <Total
                titulo="Necesidades atendidas sobre validadas"
                valor={`${formatearNumero(atendidas)} de ${formatearNumero(validadas)}`}
                detalle={validadas ? formatearPorcentaje((atendidas * 100) / validadas) + " atendidas" : undefined}
              />
            </div>

            <Tarjeta>
              <h3 className="text-2xl font-bold text-arca-700">Necesidades por zona</h3>
              {/* Titular que dice qué aprender del gráfico (charting-data.md › Designing effective charts). */}
              <p className="mt-1 text-lg text-gray-800">{resumenGrafico(filasZonas)}</p>
              <p className="mb-4 text-gray-600">{filasZonas.length} zonas, ordenadas por nivel de daño (de Crítico a Bajo).</p>
              <div style={{ height: Math.max(360, filasZonas.length * 44) }} aria-hidden>
                <ResponsiveContainer width="100%" height="100%">
                  <BarChart data={filasZonas} layout="vertical" margin={{ left: 12, right: 24, top: 8, bottom: 8 }}>
                    <CartesianGrid strokeDasharray="3 3" horizontal={false} />
                    <XAxis type="number" allowDecimals={false} tick={{ fontSize: 14 }} />
                    <YAxis
                      type="category"
                      dataKey="zona"
                      width={230}
                      tick={{ fontSize: 14, fill: "#1f2937" }}
                      tickFormatter={(zona: string) => {
                        const f = filasZonas.find((z) => z.zona === zona);
                        return f ? `${zona} (${f.nivel_dano})` : zona;
                      }}
                    />
                    <Tooltip formatter={(v) => formatearNumero(Number(v))} />
                    <Legend wrapperStyle={{ fontSize: 15 }} />
                    {/* Cada barra lleva su número: la información no depende solo del color.
                        Naranja #B85A14: 4,66:1 sobre blanco (el #E8833A daba 2,71:1). */}
                    <Bar
                      dataKey="necesidades_validadas"
                      name="Validadas"
                      fill="#153D63"
                      radius={[0, 4, 4, 0]}
                      isAnimationActive={!menosMovimiento}
                    >
                      <LabelList dataKey="necesidades_validadas" position="right" formatter={sinCeros} style={{ fontSize: 14, fill: "#153D63", fontWeight: 600 }} />
                    </Bar>
                    <Bar
                      dataKey="necesidades_atendidas"
                      name="Atendidas"
                      fill="#B85A14"
                      radius={[0, 4, 4, 0]}
                      isAnimationActive={!menosMovimiento}
                    >
                      <LabelList dataKey="necesidades_atendidas" position="right" formatter={sinCeros} style={{ fontSize: 14, fill: "#96480F", fontWeight: 600 }} />
                    </Bar>
                  </BarChart>
                </ResponsiveContainer>
              </div>
              {/* Los mismos datos para lectores de pantalla. */}
              <table className="sr-only">
                <caption>Necesidades validadas y atendidas por zona</caption>
                <thead>
                  <tr>
                    <th scope="col">Zona</th>
                    <th scope="col">Nivel de daño</th>
                    <th scope="col">Validadas</th>
                    <th scope="col">Atendidas</th>
                  </tr>
                </thead>
                <tbody>
                  {filasZonas.map((z) => (
                    <tr key={z.zona}>
                      <th scope="row">{z.zona}</th>
                      <td>{z.nivel_dano}</td>
                      <td>{z.necesidades_validadas}</td>
                      <td>{z.necesidades_atendidas}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </Tarjeta>
          </>
        )}

        <Tarjeta>
          <h3 className="mb-4 text-2xl font-bold text-arca-700">Cupos por albergue</h3>
          {albergues.error ? (
            <ErrorCarga mensaje={albergues.error.message} onReintentar={albergues.recargar} />
          ) : albergues.cargando ? (
            <Cargando />
          ) : (
            <Tabla<Albergue>
              filas={albergues.datos ?? []}
              clave={(f) => f.albergue}
              columnas={[
                { titulo: "Albergue", celda: (f) => <span className="font-medium">{f.albergue}</span> },
                { titulo: "Municipio", celda: (f) => f.municipio },
                { titulo: "Capacidad", alinear: "derecha", celda: (f) => <span className="cifra">{formatearNumero(f.capacidad_maxima)}</span> },
                { titulo: "Alojadas", alinear: "derecha", celda: (f) => <span className="cifra">{formatearNumero(f.personas_alojadas)}</span> },
                {
                  titulo: "Cupos libres",
                  alinear: "derecha",
                  celda: (f) =>
                    f.cupos_disponibles <= 0 ? (
                      <Insignia tono="rechazo">Sin cupos</Insignia>
                    ) : (
                      <span className="cifra">{formatearNumero(f.cupos_disponibles)}</span>
                    ),
                },
                { titulo: "Ocupación", ancho: "16rem", celda: (f) => <BarraOcupacion porcentaje={Number(f.pct_ocupacion)} /> },
              ]}
            />
          )}
        </Tarjeta>

        <p className="flex items-center gap-2 rounded-lg bg-arca-50 px-4 py-3 text-arca-700">
          <ShieldCheck className="size-5 shrink-0" aria-hidden />
          Información agregada. No se muestran datos personales (Ley 1581 de 2012).
        </p>
      </main>
    </div>
  );
}
