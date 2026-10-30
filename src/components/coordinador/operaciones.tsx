"use client";

import { useState } from "react";
import { CloudOff } from "lucide-react";
import { useConexion } from "../conexion";
import { FormAlojar } from "./form-alojar";
import { FormDespachar } from "./form-despachar";
import { FormEntregar } from "./form-entregar";
import { FormIngresarLote } from "./form-ingresar-lote";
import { Pestanas } from "./pestanas";

type Operacion = "alojar" | "lote" | "despachar" | "entregar";

const OPERACIONES: { clave: Operacion; titulo: string; Formulario: () => React.ReactNode }[] = [
  { clave: "alojar", titulo: "1. Alojar familia", Formulario: FormAlojar },
  { clave: "lote", titulo: "2. Ingresar lote", Formulario: FormIngresarLote },
  { clave: "despachar", titulo: "3. Despachar lote", Formulario: FormDespachar },
  { clave: "entregar", titulo: "4. Registrar entrega", Formulario: FormEntregar },
];

export function Operaciones() {
  const { conectado, comprobando } = useConexion();
  const [activa, setActiva] = useState<Operacion>("alojar");
  return (
    <div className="space-y-5">
      {!conectado && !comprobando && (
        <p role="status" className="flex items-center gap-2 rounded-lg border border-advertencia-borde bg-advertencia-fondo p-4 font-medium text-advertencia">
          <CloudOff className="size-5 shrink-0" aria-hidden />
          Sin conexión con Oracle: las operaciones están deshabilitadas, porque solo Oracle puede aceptarlas o
          rechazarlas y nunca se usan datos guardados.
        </p>
      )}
      <Pestanas<Operacion>
        tamano="pequena"
        activa={activa}
        onCambiar={setActiva}
        pestanas={OPERACIONES.map(({ clave, titulo }) => ({ clave, titulo }))}
      />
      <p className="text-gray-700">
        La aplicación no valida las reglas de negocio: envía la operación y es Oracle (disparador, CHECK o índice único)
        quien la acepta o la rechaza.
      </p>
      {/* Una operación a la vez y a todo el ancho; las demás siguen montadas para no perder su resultado. */}
      {OPERACIONES.map(({ clave, Formulario }) => (
        <div key={clave} hidden={clave !== activa}>
          <Formulario />
        </div>
      ))}
    </div>
  );
}
