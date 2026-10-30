"use client";

import { useState } from "react";
import { Database, MessageSquareText, Wrench } from "lucide-react";
import { Encabezado } from "../encabezado";
import { Consultas } from "./consultas";
import { Manifestaciones } from "./manifestaciones";
import { Operaciones } from "./operaciones";
import { Pestanas } from "./pestanas";
import { RestablecerDemo } from "./restablecer";

type Seccion = "consultas" | "operaciones" | "manifestaciones";

export function PanelCoordinador() {
  const [seccion, setSeccion] = useState<Seccion>("consultas");
  return (
    <div className="min-h-screen bg-gray-50">
      <Encabezado perfil="Coordinador" acciones={<RestablecerDemo />} />
      <main className="mx-auto max-w-7xl px-6 py-6">
        <Pestanas<Seccion>
          activa={seccion}
          onCambiar={setSeccion}
          pestanas={[
            { clave: "consultas", titulo: "Consultas", icono: <Database className="size-5" aria-hidden /> },
            { clave: "operaciones", titulo: "Operaciones", icono: <Wrench className="size-5" aria-hidden /> },
            { clave: "manifestaciones", titulo: "Manifestaciones", icono: <MessageSquareText className="size-5" aria-hidden /> },
          ]}
        />
        <div className="pt-6">
          {seccion === "consultas" && <Consultas />}
          {seccion === "operaciones" && <Operaciones />}
          {seccion === "manifestaciones" && <Manifestaciones />}
        </div>
      </main>
    </div>
  );
}
