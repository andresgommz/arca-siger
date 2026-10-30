"use client";

import { MonitorSmartphone } from "lucide-react";
import { useDatos } from "../datos";
import { Tabla } from "../tabla";
import { Cargando, ErrorCarga, Insignia, Tarjeta } from "../ui";

interface Manifestacion {
  cod_manifestacion: number;
  fecha: string;
  damnificado: string;
  codigo_censo: string;
  tipo: string;
  canal: string;
  descripcion: string;
  estado: string;
  respuesta: string | null;
}

export function EstadoManifestacion({ estado }: { estado: string }) {
  const tono = estado === "Respondida" ? "exito" : estado === "Abierta" ? "advertencia" : "marca";
  return <Insignia tono={tono}>{estado}</Insignia>;
}

export function Manifestaciones() {
  const { datos, error, cargando, recargar } = useDatos<Manifestacion[]>("manifestaciones");
  return (
    <Tarjeta className="space-y-4">
      <div>
        <h2 className="text-3xl font-bold text-arca-700">Manifestaciones recibidas</h2>
        <p className="text-lg text-gray-700">La voz del damnificado: lo que piden, lo que no recibieron y lo que no les sirve. De la más reciente a la más antigua.</p>
      </div>
      {error ? (
        <ErrorCarga mensaje={error.message} onReintentar={recargar} />
      ) : cargando || !datos ? (
        <Cargando />
      ) : (
        <Tabla<Manifestacion>
          filas={datos}
          clave={(f) => f.cod_manifestacion}
          columnas={[
            { titulo: "Fecha", celda: (f) => <span className="cifra whitespace-nowrap">{f.fecha}</span> },
            {
              titulo: "Damnificado",
              celda: (f) => (
                <span>
                  <span className="font-medium">{f.damnificado}</span>
                  <span className="block text-sm text-gray-500">Código {f.codigo_censo}</span>
                </span>
              ),
            },
            { titulo: "Tipo", celda: (f) => <span className="whitespace-nowrap font-medium">{f.tipo}</span> },
            {
              titulo: "Canal",
              celda: (f) =>
                f.canal === "Quiosco" ? (
                  <Insignia tono="marca">
                    <MonitorSmartphone className="size-4" aria-hidden /> Quiosco
                  </Insignia>
                ) : (
                  <span className="whitespace-nowrap">{f.canal}</span>
                ),
            },
            { titulo: "Descripción", celda: (f) => f.descripcion },
            { titulo: "Estado", celda: (f) => <EstadoManifestacion estado={f.estado} /> },
            { titulo: "Respuesta", celda: (f) => f.respuesta ?? <span className="text-gray-500">Sin respuesta</span> },
          ]}
        />
      )}
    </Tarjeta>
  );
}
