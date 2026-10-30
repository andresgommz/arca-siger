import type { Metadata } from "next";
import "@fontsource-variable/inter";
import "./globals.css";
import { Proveedores } from "@/components/proveedores";

export const metadata: Metadata = {
  title: "ARCA: Cada ayuda, a quien la necesita",
  description: "Demostrador de la base de datos ARCA (SIGER-Emergencias).",
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="es">
      <body className="min-h-screen">
        <Proveedores>{children}</Proveedores>
      </body>
    </html>
  );
}
