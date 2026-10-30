"use client";

import { useState } from "react";
import { AlertTriangle } from "lucide-react";
import { formatearNumero } from "@/lib/formatos";
import type { RespuestaPost } from "@/lib/tipos-api";
import { useEnviar } from "../clave-demo";
import { useConexion } from "../conexion";
import { conParametros, useDatos, useInvalidar } from "../datos";
import { Boton, Campo, estiloEntrada } from "../ui";
import {
  aNumero,
  type Beneficiario,
  type DespachoEntregado,
  type InsumoCatalogo,
  type InsumoDespacho,
  type NecesidadCatalogo,
  type Persona,
} from "./catalogos";
import { ResultadoOperacion } from "./resultado";
import { DatosDemo, TarjetaOperacion } from "./tarjeta";

const METODOS = ["Código de censo", "Documento"];

export function FormEntregar() {
  const { conectado } = useConexion();
  const enviar = useEnviar();
  const invalidar = useInvalidar();
  const despachos = useDatos<DespachoEntregado[]>("catalogos/despachos-entregados");
  const beneficiarios = useDatos<Beneficiario[]>("catalogos/beneficiarios");
  const personas = useDatos<Persona[]>("catalogos/personas");
  const catalogoInsumos = useDatos<InsumoCatalogo[]>("catalogos/insumos");

  const [despacho, setDespacho] = useState("");
  const [insumo, setInsumo] = useState("");
  const [beneficiario, setBeneficiario] = useState("");
  const [necesidad, setNecesidad] = useState("");
  const [receptor, setReceptor] = useState("");
  const [metodo, setMetodo] = useState(METODOS[0]!);
  const [cantidad, setCantidad] = useState("");
  const [enviando, setEnviando] = useState(false);
  const [respuesta, setRespuesta] = useState<RespuestaPost | null>(null);

  // Filtros en cascada: despacho entregado, insumos del despacho y necesidades que ese insumo cubre.
  const insumos = useDatos<InsumoDespacho[]>(despacho ? `catalogos/despachos/${despacho}/insumos` : null);
  const necesidades = useDatos<NecesidadCatalogo[]>(
    beneficiario && insumo ? conParametros("catalogos/necesidades", { beneficiario, insumo }) : null,
  );

  const insumoElegido = insumos.datos?.find((i) => String(i.cod_insumo) === insumo);
  const saldo = insumoElegido ? insumoElegido.cantidad_despachada - insumoElegido.cantidad_entregada : null;
  const superaSaldo = saldo !== null && cantidad.trim() !== "" && Number(cantidad) > saldo;
  const benef = beneficiarios.datos?.find((b) => String(b.cod_beneficiario) === beneficiario);

  const usarCaso = (cant: string) => {
    const ana = beneficiarios.datos?.find((b) => b.codigo_censo === "4821");
    const agua = catalogoInsumos.datos?.find((i) => i.nombre === "Agua potable bolsa 6 L");
    setDespacho("15");
    setInsumo(agua ? String(agua.cod_insumo) : "");
    setBeneficiario(ana ? String(ana.cod_beneficiario) : "");
    setReceptor(ana ? String(ana.cod_beneficiario) : "");
    setNecesidad("");
    setMetodo("Código de censo");
    setCantidad(cant);
    setRespuesta(null);
  };

  return (
    <TarjetaOperacion titulo="Registrar entrega" reglas="C_ENT_MET_CK método de identificación, C_ENT_CANT_CK cantidad positiva y llaves foráneas">
      <DatosDemo
        casos={[
          { etiqueta: "Usar datos de demostración (rechazo C_ENT_CANT_CK: cantidad 0)", aplicar: () => usarCaso("0") },
          { etiqueta: "Caso que Oracle acepta: 12 L de agua a Ana María", aplicar: () => usarCaso("12") },
        ]}
      />
      <form
        className="grid gap-4 sm:grid-cols-2"
        onSubmit={async (e) => {
          e.preventDefault();
          setEnviando(true);
          setRespuesta(null);
          const r = await enviar("operaciones/entregar", {
            cod_despacho: aNumero(despacho),
            cod_insumo: aNumero(insumo),
            cod_beneficiario: aNumero(beneficiario),
            cod_receptor: aNumero(receptor),
            metodo_identificacion: metodo,
            cantidad: cantidad.trim(),
            cod_necesidad: aNumero(necesidad),
          });
          setRespuesta(r);
          setEnviando(false);
          if (r.ok) {
            await invalidar([
              "consultas/trazabilidad",
              "consultas/indice-necesidades",
              `catalogos/despachos/${despacho}/insumos`,
              "publico/zonas",
              "quiosco/",
            ]);
          }
        }}
      >
        <Campo etiqueta="Despacho entregado">
          <select
            required
            value={despacho}
            onChange={(e) => {
              setDespacho(e.target.value);
              setInsumo("");
              setNecesidad("");
            }}
            className={estiloEntrada}
          >
            <option value="">Elija un despacho</option>
            {despachos.datos?.map((d) => (
              <option key={d.cod_despacho} value={d.cod_despacho}>
                Despacho {d.cod_despacho}: {d.destino} ({d.fecha_entrega})
              </option>
            ))}
          </select>
        </Campo>
        <Campo
          etiqueta="Insumo del despacho"
          ayuda={
            insumoElegido &&
            `Despachado ${formatearNumero(insumoElegido.cantidad_despachada)}, entregado ${formatearNumero(insumoElegido.cantidad_entregada)}, saldo ${formatearNumero(saldo)} ${insumoElegido.unidad.toLowerCase()}.`
          }
        >
          <select
            required
            value={insumo}
            onChange={(e) => {
              setInsumo(e.target.value);
              setNecesidad("");
            }}
            className={estiloEntrada}
            disabled={!despacho}
          >
            <option value="">{despacho ? "Elija un insumo" : "Primero elija el despacho"}</option>
            {insumos.datos?.map((i) => (
              <option key={i.cod_insumo} value={i.cod_insumo}>
                {i.insumo} (saldo {formatearNumero(i.cantidad_despachada - i.cantidad_entregada)} {i.unidad.toLowerCase()})
              </option>
            ))}
          </select>
        </Campo>
        <Campo etiqueta="Beneficiario (censo activo)">
          <select
            required
            value={beneficiario}
            onChange={(e) => {
              setBeneficiario(e.target.value);
              setNecesidad("");
              if (!receptor) setReceptor(e.target.value);
            }}
            className={estiloEntrada}
          >
            <option value="">Elija un beneficiario</option>
            {beneficiarios.datos?.map((b) => (
              <option key={b.cod_beneficiario} value={b.cod_beneficiario}>
                {b.nombre} (código {b.codigo_censo})
              </option>
            ))}
          </select>
        </Campo>
        <Campo
          etiqueta="Necesidad que atiende (opcional)"
          ayuda={beneficiario && insumo && necesidades.datos?.length === 0 ? "Este insumo no cubre ninguna necesidad validada y vigente del beneficiario." : undefined}
        >
          <select value={necesidad} onChange={(e) => setNecesidad(e.target.value)} className={estiloEntrada} disabled={!beneficiario || !insumo}>
            <option value="">Sin necesidad asociada</option>
            {necesidades.datos?.map((n) => (
              <option key={n.cod_necesidad} value={n.cod_necesidad}>
                {n.categoria} (vigente hasta {n.vigencia_hasta})
              </option>
            ))}
          </select>
        </Campo>
        <Campo etiqueta="Quién recoge">
          <select required value={receptor} onChange={(e) => setReceptor(e.target.value)} className={estiloEntrada}>
            <option value="">Elija la persona</option>
            {personas.datos?.map((p) => (
              <option key={p.cod_persona} value={p.cod_persona}>
                {p.nombre}
                {p.documento ? ` (doc. ${p.documento})` : ""}
              </option>
            ))}
          </select>
        </Campo>
        <Campo etiqueta="Identificado con">
          <select value={metodo} onChange={(e) => setMetodo(e.target.value)} className={estiloEntrada}>
            {METODOS.map((m) => (
              <option key={m}>{m}</option>
            ))}
          </select>
        </Campo>
        <Campo etiqueta={`Cantidad${insumoElegido ? ` (${insumoElegido.unidad.toLowerCase()})` : ""}`}>
          <input required type="number" step="any" value={cantidad} onChange={(e) => setCantidad(e.target.value)} className={estiloEntrada} />
        </Campo>
        <div className="flex items-end">
          <Boton type="submit" cargando={enviando} disabled={!conectado}>
            Registrar entrega
          </Boton>
        </div>
        {superaSaldo && (
          <p role="status" className="flex items-start gap-2 rounded-lg border border-advertencia-borde bg-advertencia-fondo p-3 text-advertencia sm:col-span-2">
            <AlertTriangle className="mt-0.5 size-5 shrink-0" aria-hidden />
            La cantidad supera el saldo del despacho ({formatearNumero(saldo)}). La regla RN-25 aún no está en la base, así
            que Oracle la aceptará; puede enviarla igual.
          </p>
        )}
      </form>
      <ResultadoOperacion
        respuesta={respuesta}
        exito={(r) => (
          <>
            Entrega <strong>{String(r.cod_entrega)}</strong> registrada a nombre de {benef?.nombre ?? "el beneficiario"}
            {benef ? ` (código ${benef.codigo_censo})` : ""}. Ya aparece en su trazabilidad.
          </>
        )}
      />
    </TarjetaOperacion>
  );
}
