"use client";

import { useState } from "react";
import { RotateCcw } from "lucide-react";
import { useEnviar } from "../clave-demo";
import { useConexion } from "../conexion";
import { useInvalidar } from "../datos";
import { Boton, Dialogo } from "../ui";

export function RestablecerDemo() {
  const { conectado } = useConexion();
  const enviar = useEnviar();
  const invalidar = useInvalidar();
  const [abierto, setAbierto] = useState(false);
  const [corriendo, setCorriendo] = useState(false);
  const [resultado, setResultado] = useState<{ ok: boolean; mensaje: string } | null>(null);

  const ejecutar = async () => {
    setCorriendo(true);
    setResultado(null);
    const r = await enviar("admin/restablecer", {});
    setCorriendo(false);
    if (r.ok) {
      setResultado({ ok: true, mensaje: "Listo: la base volvió a los datos originales." });
      await invalidar();
    } else {
      setResultado({ ok: false, mensaje: r.traduccion?.original ? `${r.mensaje} (${r.traduccion.original})` : r.mensaje });
    }
  };

  return (
    <>
      {/* Secundario: es una acción de administración destructiva, no la acción principal de la pantalla. */}
      <Boton
        variante="secundario"
        onClick={() => {
          setResultado(null);
          setAbierto(true);
        }}
        disabled={!conectado}
        title={conectado ? undefined : "Sin conexión con Oracle: restablecer está deshabilitado."}
      >
        <RotateCcw className="size-4" aria-hidden /> Restablecer demo
      </Boton>
      <Dialogo abierto={abierto} titulo="Restablecer demo" onCerrar={() => !corriendo && setAbierto(false)}>
        <div className="space-y-4 text-gray-800">
          <p>Se borrarán todos los cambios hechos en la demostración y se recargarán los datos originales.</p>
          <p className="text-sm text-gray-600">
            Oracle ejecuta P_RESTABLECER_DEMO: borra las tablas, vuelve a insertar los 598 registros y los disparadores
            recalculan el inventario y la auditoría.
          </p>
          {corriendo && (
            <div role="status" className="space-y-2">
              <p className="font-medium text-arca-700">Restableciendo en Oracle…</p>
              <div className="h-2 overflow-hidden rounded-full bg-arca-100">
                <div className="h-full w-1/3 animate-[progreso_1.2s_ease-in-out_infinite] rounded-full bg-naranja-400" />
              </div>
            </div>
          )}
          {resultado && (
            <p
              role="alert"
              className={`rounded-lg border p-3 ${resultado.ok ? "border-exito-borde bg-exito-fondo text-exito" : "border-rechazo-borde bg-rechazo-fondo text-rechazo"}`}
            >
              {resultado.mensaje}
            </p>
          )}
          <div className="flex justify-end gap-3">
            {resultado?.ok ? (
              <Boton onClick={() => setAbierto(false)}>Cerrar</Boton>
            ) : (
              <>
                <Boton variante="secundario" onClick={() => setAbierto(false)} disabled={corriendo}>
                  Cancelar
                </Boton>
                <Boton variante="peligro" onClick={ejecutar} cargando={corriendo} disabled={!conectado}>
                  Restablecer
                </Boton>
              </>
            )}
          </div>
        </div>
      </Dialogo>
    </>
  );
}
