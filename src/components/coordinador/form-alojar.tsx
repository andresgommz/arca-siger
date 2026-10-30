"use client";

import { useState } from "react";
import type { RespuestaPost } from "@/lib/tipos-api";
import { useEnviar } from "../clave-demo";
import { useConexion } from "../conexion";
import { useDatos, useInvalidar } from "../datos";
import { Boton, Campo, estiloEntrada } from "../ui";
import { aNumero, type AlbergueCatalogo, type Familia } from "./catalogos";
import { DatosDemo, TarjetaOperacion } from "./tarjeta";
import { ResultadoOperacion } from "./resultado";

export function FormAlojar() {
  const { conectado } = useConexion();
  const enviar = useEnviar();
  const invalidar = useInvalidar();
  const familias = useDatos<Familia[]>("catalogos/familias");
  const albergues = useDatos<AlbergueCatalogo[]>("catalogos/albergues");

  const [familia, setFamilia] = useState("");
  const [albergue, setAlbergue] = useState("");
  const [enviando, setEnviando] = useState(false);
  const [respuesta, setRespuesta] = useState<RespuestaPost | null>(null);

  const usarCaso = (nombreAlbergue: string) => {
    setFamilia("5");
    const a = albergues.datos?.find((x) => x.nombre === nombreAlbergue);
    setAlbergue(a ? String(a.cod_albergue) : "");
    setRespuesta(null);
  };

  const nombreAlbergue = albergues.datos?.find((a) => String(a.cod_albergue) === albergue)?.nombre ?? "";

  return (
    <TarjetaOperacion titulo="Alojar familia" reglas="RN-03 capacidad del albergue (TRG_FAL_CAPACIDAD) y RN-13 un solo alojamiento activo (UX_FAL_ACTIVA)">
      <DatosDemo
        casos={[
          { etiqueta: "Usar datos de demostración (rechazo RN-03)", aplicar: () => usarCaso("Casa Comunal Río Otún") },
          { etiqueta: "Caso que Oracle acepta", aplicar: () => usarCaso("Coliseo Cubierto de Quibdó") },
        ]}
      />
      <form
        className="grid items-end gap-4 sm:grid-cols-2"
        onSubmit={async (e) => {
          e.preventDefault();
          setEnviando(true);
          setRespuesta(null);
          const r = await enviar("operaciones/alojar", { cod_familia: aNumero(familia), cod_albergue: aNumero(albergue) });
          setRespuesta(r);
          setEnviando(false);
          if (r.ok) await invalidar(["consultas/ocupacion", "catalogos/familias", "publico/albergues", "quiosco/"]);
        }}
      >
        <Campo etiqueta="Familia">
          <select required value={familia} onChange={(e) => setFamilia(e.target.value)} className={estiloEntrada}>
            <option value="">Elija una familia</option>
            {familias.datos?.map((f) => (
              <option key={f.cod_familia} value={f.cod_familia}>
                Familia {f.cod_familia} ({f.num_integrantes} personas): {f.albergue_actual ? `en ${f.albergue_actual}` : "sin alojamiento"}
              </option>
            ))}
          </select>
        </Campo>
        <Campo etiqueta="Albergue">
          <select required value={albergue} onChange={(e) => setAlbergue(e.target.value)} className={estiloEntrada}>
            <option value="">Elija un albergue</option>
            {albergues.datos?.map((a) => (
              <option key={a.cod_albergue} value={a.cod_albergue}>
                {a.nombre} ({a.municipio}, capacidad {a.capacidad_maxima})
              </option>
            ))}
          </select>
        </Campo>
        <Boton type="submit" cargando={enviando} disabled={!conectado} className="justify-self-start">
          Alojar familia
        </Boton>
      </form>
      <ResultadoOperacion
        respuesta={respuesta}
        exito={(r) => (
          <>
            Familia {String(r.cod_familia)} alojada en {nombreAlbergue || `el albergue ${String(r.cod_albergue)}`} desde el{" "}
            {String(r.fecha_ingreso)}. Personas alojadas ahora en ese albergue: <strong>{String(r.personas_alojadas)}</strong>.
          </>
        )}
      />
    </TarjetaOperacion>
  );
}
