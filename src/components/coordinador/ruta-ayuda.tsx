"use client";

import { ChevronRight, CornerDownRight, House, Package, Truck, UserRound, Warehouse } from "lucide-react";
import { formatearNumero } from "@/lib/formatos";

export interface EntregaTrazada {
  beneficiario: string;
  insumo: string;
  cantidad: number;
  fecha_entrega: string;
  recogio: string;
  identificado_con: string;
  despacho: number;
  centro_acopio: string;
  lote: string;
  destino: string;
}

function Estacion({ Icono, etiqueta, valor }: { Icono: typeof Warehouse; etiqueta: string; valor: string }) {
  return (
    <li className="flex items-center gap-2">
      <span className="flex size-8 shrink-0 items-center justify-center rounded-full bg-arca-50 text-arca-700 ring-1 ring-arca-100">
        <Icono className="size-4" aria-hidden />
      </span>
      <span className="leading-tight">
        <span className="block text-xs font-semibold uppercase tracking-wide text-gray-600">{etiqueta}</span>
        <span className="block font-medium text-gray-900">{valor}</span>
      </span>
    </li>
  );
}

function Flecha() {
  return (
    <li aria-hidden className="text-arca-200">
      <ChevronRight className="size-5" />
    </li>
  );
}

/**
 * La ruta de cada entrega, del centro de acopio hasta la persona: lo que hace distinto a ARCA.
 * Sigue el mismo encadenamiento de la consulta 1 (centro, lote, despacho, destino y persona).
 */
export function RutaAyuda({ entregas }: { entregas: EntregaTrazada[] }) {
  return (
    <ol className="space-y-3" aria-label="Ruta de cada entrega, del centro de acopio a la persona">
      {entregas.map((e, i) => {
        const otraPersona = e.recogio !== e.beneficiario;
        return (
          <li
            key={`${e.despacho}-${e.lote}-${e.fecha_entrega}-${i}`}
            className="grid gap-3 rounded-xl border border-gray-200 bg-white p-4 lg:grid-cols-[11rem_1fr] lg:items-center"
          >
            <div>
              <p className="font-bold text-arca-900">{e.insumo}</p>
              <p className="text-gray-700">
                Cantidad <span className="cifra font-semibold text-naranja-600">{formatearNumero(e.cantidad)}</span>
              </p>
              <p className="cifra text-sm text-gray-600">{e.fecha_entrega}</p>
            </div>
            <ol className="flex flex-col gap-3" aria-label={`Ruta de ${e.insumo}`}>
              <li>
                <ol className="flex flex-wrap items-center gap-x-2 gap-y-3">
              {/* La etiqueta ya dice "Centro de acopio": el valor muestra solo el lugar. */}
              <Estacion Icono={Warehouse} etiqueta="Centro de acopio" valor={e.centro_acopio.replace(/^Centro de Acopio\s+/i, "")} />
              <Flecha />
              <Estacion Icono={Package} etiqueta="Lote" valor={e.lote} />
              <Flecha />
              <Estacion Icono={Truck} etiqueta="Despacho" valor={String(e.despacho)} />
              <Flecha />
              <Estacion Icono={House} etiqueta="Destino" valor={e.destino} />
                </ol>
              </li>
              {/* El final de la ruta es una persona: el único punto resaltado. */}
              <li className="flex items-center gap-2">
                <CornerDownRight className="ml-3 size-5 text-arca-200" aria-hidden />
                <span className="flex items-center gap-2 rounded-full bg-naranja-50 py-1 pl-1 pr-4 ring-2 ring-naranja-400">
                <span className="flex size-8 shrink-0 items-center justify-center rounded-full bg-naranja-600 text-white">
                  <UserRound className="size-4" aria-hidden />
                </span>
                <span className="leading-tight">
                  <span className="block text-xs font-semibold uppercase tracking-wide text-naranja-700">
                    {otraPersona ? "Recogió en su nombre" : "Recibió"}
                  </span>
                  <span className="block font-bold text-arca-900">{e.recogio}</span>
                  <span className="block text-sm text-gray-700">
                    {otraPersona ? `A nombre de ${e.beneficiario}` : `Identificación: ${e.identificado_con.toLowerCase()}`}
                  </span>
                </span>
                </span>
              </li>
            </ol>
          </li>
        );
      })}
    </ol>
  );
}
