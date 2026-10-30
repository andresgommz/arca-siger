import type { Metadata } from "next";
import { EntradaQuiosco } from "@/components/quiosco/entrada";

export const metadata: Metadata = { title: "ARCA: Quiosco del damnificado" };

export default function PaginaQuiosco() {
  return <EntradaQuiosco />;
}
