import type { Metadata } from "next";
import { PanelCoordinador } from "@/components/coordinador/panel";

export const metadata: Metadata = { title: "ARCA: Coordinador" };

export default function PaginaCoordinador() {
  return <PanelCoordinador />;
}
