import type { Metadata } from "next";
import { FichaQuiosco } from "@/components/quiosco/ficha";

export const metadata: Metadata = { title: "ARCA: Quiosco del damnificado" };

export default async function PaginaFicha({ params }: { params: Promise<{ codigo: string }> }) {
  const { codigo } = await params;
  return <FichaQuiosco codigo={decodeURIComponent(codigo)} />;
}
