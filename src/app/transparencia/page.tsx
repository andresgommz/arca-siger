import type { Metadata } from "next";
import { PanelTransparencia } from "@/components/transparencia/panel";

export const metadata: Metadata = { title: "ARCA: Transparencia pública" };

export default function PaginaTransparencia() {
  return <PanelTransparencia />;
}
