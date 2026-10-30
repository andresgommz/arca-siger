"use client";

import { useState } from "react";
import { formatearNumero } from "@/lib/formatos";
import type { RespuestaPost } from "@/lib/tipos-api";
import { useEnviar } from "../clave-demo";
import { useConexion } from "../conexion";
import { conParametros, useDatos, useInvalidar } from "../datos";
import { Boton, Campo, estiloEntrada } from "../ui";
import { aNumero, type Centro, type Conductor, type Destino, type Lote, type Solicitud } from "./catalogos";
import { ResultadoOperacion } from "./resultado";
import { DatosDemo, TarjetaOperacion } from "./tarjeta";

export function FormDespachar() {
  const { conectado } = useConexion();
  const enviar = useEnviar();
  const invalidar = useInvalidar();
  const centros = useDatos<Centro[]>("catalogos/centros");
  const solicitudes = useDatos<Solicitud[]>("catalogos/solicitudes");
  const destinos = useDatos<Destino[]>("catalogos/destinos");
  const conductores = useDatos<Conductor[]>("catalogos/conductores");
  const todosLosLotes = useDatos<Lote[]>("catalogos/lotes-todos");

  const [centro, setCentro] = useState("");
  const [solicitud, setSolicitud] = useState("");
  const [destino, setDestino] = useState("");
  const [placa, setPlaca] = useState("");
  const [conductor, setConductor] = useState("");
  const [lote, setLote] = useState("");
  const [cantidad, setCantidad] = useState("");
  const [verTodos, setVerTodos] = useState(false);
  const [enviando, setEnviando] = useState(false);
  const [respuesta, setRespuesta] = useState<RespuestaPost | null>(null);

  // Por defecto, solo los lotes del centro con disponible mayor que 0 (catalogos/lotes).
  const lotesCentro = useDatos<Lote[]>(centro && !verTodos ? conParametros("catalogos/lotes", { centro }) : null);
  const lotes = verTodos ? todosLosLotes.datos : lotesCentro.datos;
  const loteElegido = todosLosLotes.datos?.find((l) => String(l.cod_lote) === lote);

  const usarCaso = (numLote: string, cant: string) => {
    const c = centros.datos?.find((x) => x.nombre === "Centro de Acopio Floridablanca");
    const s = solicitudes.datos?.find((x) => x.cod_solicitud === 16) ?? solicitudes.datos?.[0];
    const d = destinos.datos?.find((x) => x.nombre === "Escuela Alto Llano");
    const k = conductores.datos?.find((x) => x.nombre === "Carlos Pinto Rojas") ?? conductores.datos?.[0];
    const l = todosLosLotes.datos?.find((x) => x.num_lote === numLote);
    setCentro(c ? String(c.cod_centro) : "");
    setSolicitud(s ? String(s.cod_solicitud) : "");
    setDestino(d ? String(d.cod_destino) : "");
    setPlaca("STK482");
    setConductor(k ? String(k.cod_conductor) : "");
    setVerTodos(true);
    setLote(l ? String(l.cod_lote) : "");
    setCantidad(cant);
    setRespuesta(null);
  };

  return (
    <TarjetaOperacion titulo="Despachar lote" reglas="RN-08 disponibilidad real del lote y RN-12 lote del mismo centro (TRG_DLO_DESCUENTO)">
      <DatosDemo
        casos={[
          { etiqueta: "Usar datos de demostración (rechazo RN-08: L-031)", aplicar: () => usarCaso("L-031", "10") },
          { etiqueta: "Rechazo RN-12: L-070 de Quibdó", aplicar: () => usarCaso("L-070", "10") },
          { etiqueta: "Caso que Oracle acepta: L-044, 60 L", aplicar: () => usarCaso("L-044", "60") },
        ]}
      />
      <form
        className="grid gap-4 sm:grid-cols-2"
        onSubmit={async (e) => {
          e.preventDefault();
          setEnviando(true);
          setRespuesta(null);
          const r = await enviar("operaciones/despachar", {
            cod_centro: aNumero(centro),
            cod_solicitud: aNumero(solicitud),
            cod_destino: aNumero(destino),
            placa: placa.trim().toUpperCase(),
            cod_conductor: aNumero(conductor),
            cod_lote: aNumero(lote),
            cantidad: cantidad.trim(),
          });
          setRespuesta(r);
          setEnviando(false);
          if (r.ok) await invalidar(["consultas/vencimientos", "consultas/prorrateo", "catalogos/lotes"]);
        }}
      >
        <Campo etiqueta="Centro de acopio que despacha">
          <select required value={centro} onChange={(e) => setCentro(e.target.value)} className={estiloEntrada}>
            <option value="">Elija un centro</option>
            {centros.datos?.map((c) => (
              <option key={c.cod_centro} value={c.cod_centro}>
                {c.nombre}
              </option>
            ))}
          </select>
        </Campo>
        <Campo etiqueta="Solicitud que atiende">
          <select required value={solicitud} onChange={(e) => setSolicitud(e.target.value)} className={estiloEntrada}>
            <option value="">Elija una solicitud</option>
            {solicitudes.datos?.map((s) => (
              <option key={s.cod_solicitud} value={s.cod_solicitud}>
                {s.cod_solicitud}. {s.zona}: {s.descripcion}
              </option>
            ))}
          </select>
        </Campo>
        <Campo etiqueta="Destino">
          <select required value={destino} onChange={(e) => setDestino(e.target.value)} className={estiloEntrada}>
            <option value="">Elija un destino</option>
            {["Albergue", "Punto de entrega"].map((tipo) => (
              <optgroup key={tipo} label={tipo === "Albergue" ? "Albergues" : "Puntos de entrega"}>
                {destinos.datos
                  ?.filter((d) => d.tipo === tipo)
                  .map((d) => (
                    <option key={d.cod_destino} value={d.cod_destino}>
                      {d.nombre} ({d.municipio})
                    </option>
                  ))}
              </optgroup>
            ))}
          </select>
        </Campo>
        <div className="grid grid-cols-2 gap-4">
          <Campo etiqueta="Placa">
            <input required maxLength={6} value={placa} onChange={(e) => setPlaca(e.target.value.toUpperCase())} className={estiloEntrada} placeholder="ABC123" />
          </Campo>
          <Campo etiqueta="Conductor">
            <select value={conductor} onChange={(e) => setConductor(e.target.value)} className={estiloEntrada}>
              <option value="">Sin conductor</option>
              {conductores.datos?.map((k) => (
                <option key={k.cod_conductor} value={k.cod_conductor}>
                  {k.nombre}
                </option>
              ))}
            </select>
          </Campo>
        </div>
        <div className="sm:col-span-2">
          <Campo
            etiqueta="Lote"
            ayuda={
              loteElegido
                ? `Disponible: ${formatearNumero(loteElegido.disponible)} ${loteElegido.unidad.toLowerCase()}, en ${loteElegido.centro ?? "su centro"}.`
                : verTodos
                  ? "Se muestran todos los lotes, incluso agotados o de otros centros, para probar las reglas."
                  : "Lotes del centro elegido con disponible mayor que 0."
            }
          >
            <select required value={lote} onChange={(e) => setLote(e.target.value)} className={estiloEntrada} disabled={!verTodos && !centro}>
              <option value="">{!verTodos && !centro ? "Primero elija el centro" : "Elija un lote"}</option>
              {lotes?.map((l) => (
                <option key={l.cod_lote} value={l.cod_lote}>
                  {l.num_lote}: {l.insumo}, disponible {formatearNumero(l.disponible)}
                  {verTodos && l.centro ? ` (${l.centro})` : ""}
                </option>
              ))}
            </select>
          </Campo>
          <label className="mt-2 inline-flex items-center gap-2 text-sm text-gray-700">
            <input type="checkbox" checked={verTodos} onChange={(e) => setVerTodos(e.target.checked)} className="size-5 accent-arca-700" />
            Ver todos los lotes (para probar las reglas)
          </label>
        </div>
        <Campo etiqueta={`Cantidad${loteElegido ? ` (${loteElegido.unidad.toLowerCase()})` : ""}`}>
          <input required type="number" step="any" value={cantidad} onChange={(e) => setCantidad(e.target.value)} className={estiloEntrada} />
        </Campo>
        <div className="flex items-end">
          <Boton type="submit" cargando={enviando} disabled={!conectado}>
            Despachar
          </Boton>
        </div>
      </form>
      <ResultadoOperacion
        respuesta={respuesta}
        notaRechazo="Oracle deshizo la transacción completa: no quedó ningún despacho nuevo creado."
        exito={(r) => {
          const l = todosLosLotes.datos?.find((x) => x.cod_lote === Number(r.cod_lote));
          return (
            <>
              Despacho <strong>{String(r.cod_despacho)}</strong> creado en estado Pendiente. El disparador descontó el inventario:
              disponible del lote {l?.num_lote ?? String(r.cod_lote)} ahora{" "}
              <strong className="cifra">{formatearNumero(Number(r.disponible_lote))}</strong> {l?.unidad.toLowerCase() ?? ""}.
            </>
          );
        }}
      />
    </TarjetaOperacion>
  );
}
