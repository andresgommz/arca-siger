"use client";

import { useState } from "react";
import { hoyISO, isoADMA, sumarDiasISO } from "@/lib/formatos";
import type { RespuestaPost } from "@/lib/tipos-api";
import { useEnviar } from "../clave-demo";
import { useConexion } from "../conexion";
import { useDatos, useInvalidar } from "../datos";
import { Boton, Campo, estiloEntrada } from "../ui";
import { aNumero, type Centro, type InsumoCatalogo } from "./catalogos";
import { ResultadoOperacion } from "./resultado";
import { DatosDemo, TarjetaOperacion } from "./tarjeta";

const ORIGENES = ["Donación particular", "Compra pública", "Cooperación internacional"];

export function FormIngresarLote() {
  const { conectado, estado } = useConexion();
  const enviar = useEnviar();
  const invalidar = useInvalidar();
  const centros = useDatos<Centro[]>("catalogos/centros");
  const insumos = useDatos<InsumoCatalogo[]>("catalogos/insumos");
  const hoy = hoyISO(estado?.zona_horaria);

  const [centro, setCentro] = useState("");
  const [insumo, setInsumo] = useState("");
  const [numLote, setNumLote] = useState("");
  const [origen, setOrigen] = useState(ORIGENES[0]!);
  const [recepcion, setRecepcion] = useState(hoy);
  const [vencimiento, setVencimiento] = useState("");
  const [cantidad, setCantidad] = useState("");
  const [enviando, setEnviando] = useState(false);
  const [respuesta, setRespuesta] = useState<RespuestaPost | null>(null);

  const insumoElegido = insumos.datos?.find((i) => String(i.cod_insumo) === insumo);

  const usarCaso = (diasVencimiento: number) => {
    const c = centros.datos?.find((x) => x.nombre === "Centro de Acopio Floridablanca");
    const i = insumos.datos?.find((x) => x.nombre.startsWith("Leche de fórmula"));
    setCentro(c ? String(c.cod_centro) : "");
    setInsumo(i ? String(i.cod_insumo) : "");
    setNumLote("L-200");
    setOrigen("Donación particular");
    setRecepcion(hoy);
    setVencimiento(sumarDiasISO(hoy, diasVencimiento));
    setCantidad("30");
    setRespuesta(null);
  };

  return (
    <TarjetaOperacion titulo="Ingresar lote" reglas="RN-05 vencimiento de perecederos (C_ILO_VENC_CK), C_ILO_ORIG_CK y C_ILO_CREC_CK">
      <DatosDemo
        casos={[
          { etiqueta: "Usar datos de demostración (rechazo RN-05: vence a 20 días)", aplicar: () => usarCaso(20) },
          { etiqueta: "Caso que Oracle acepta (vence a 60 días)", aplicar: () => usarCaso(60) },
        ]}
      />
      <form
        className="grid gap-4 sm:grid-cols-2"
        onSubmit={async (e) => {
          e.preventDefault();
          setEnviando(true);
          setRespuesta(null);
          const r = await enviar("operaciones/ingresar-lote", {
            cod_centro: aNumero(centro),
            cod_insumo: aNumero(insumo),
            num_lote: numLote.trim(),
            origen,
            fecha_recepcion: isoADMA(recepcion),
            fecha_vencimiento: vencimiento ? isoADMA(vencimiento) : null,
            cantidad: cantidad.trim(),
          });
          setRespuesta(r);
          setEnviando(false);
          if (r.ok) await invalidar(["consultas/vencimientos", "consultas/prorrateo", "catalogos/lotes"]);
        }}
      >
        <Campo etiqueta="Centro de acopio">
          <select required value={centro} onChange={(e) => setCentro(e.target.value)} className={estiloEntrada}>
            <option value="">Elija un centro</option>
            {centros.datos?.map((c) => (
              <option key={c.cod_centro} value={c.cod_centro}>
                {c.nombre}
              </option>
            ))}
          </select>
        </Campo>
        <Campo
          etiqueta="Insumo"
          ayuda={insumoElegido ? `${insumoElegido.perecedero === "S" ? "Perecedero" : "No perecedero"}, en ${insumoElegido.unidad.toLowerCase()}` : undefined}
        >
          <select required value={insumo} onChange={(e) => setInsumo(e.target.value)} className={estiloEntrada}>
            <option value="">Elija un insumo</option>
            {insumos.datos?.map((i) => (
              <option key={i.cod_insumo} value={i.cod_insumo}>
                {i.nombre}
                {i.perecedero === "S" ? " (perecedero)" : ""}
              </option>
            ))}
          </select>
        </Campo>
        <Campo etiqueta="Número de lote">
          <input required maxLength={30} value={numLote} onChange={(e) => setNumLote(e.target.value)} className={estiloEntrada} placeholder="L-200" />
        </Campo>
        <Campo etiqueta="Origen">
          <select value={origen} onChange={(e) => setOrigen(e.target.value)} className={estiloEntrada}>
            {ORIGENES.map((o) => (
              <option key={o}>{o}</option>
            ))}
          </select>
        </Campo>
        <Campo etiqueta="Fecha de recepción">
          <input required type="date" value={recepcion} onChange={(e) => setRecepcion(e.target.value)} className={estiloEntrada} />
        </Campo>
        <Campo etiqueta="Fecha de vencimiento (opcional)">
          <input type="date" value={vencimiento} onChange={(e) => setVencimiento(e.target.value)} className={estiloEntrada} />
        </Campo>
        <Campo etiqueta={`Cantidad recibida${insumoElegido ? ` (${insumoElegido.unidad.toLowerCase()})` : ""}`}>
          <input required type="number" step="any" value={cantidad} onChange={(e) => setCantidad(e.target.value)} className={estiloEntrada} />
        </Campo>
        <div className="flex items-end">
          <Boton type="submit" cargando={enviando} disabled={!conectado}>
            Ingresar lote
          </Boton>
        </div>
      </form>
      <ResultadoOperacion
        respuesta={respuesta}
        exito={(r) => (
          <>
            Lote {numLote} registrado con el código <strong>{String(r.cod_lote)}</strong>. Si vence en los próximos 90 días,
            ya aparece en la consulta de Vencimientos.
          </>
        )}
      />
    </TarjetaOperacion>
  );
}
