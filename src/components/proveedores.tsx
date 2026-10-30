"use client";

import { SWRConfig } from "swr";
import { ClaveDemoProvider } from "./clave-demo";
import { ConexionProvider } from "./conexion";

export function Proveedores({ children }: { children: React.ReactNode }) {
  return (
    <SWRConfig
      value={{
        revalidateOnFocus: false,
        shouldRetryOnError: false,
        keepPreviousData: true,
      }}
    >
      <ConexionProvider>
        <ClaveDemoProvider>{children}</ClaveDemoProvider>
      </ConexionProvider>
    </SWRConfig>
  );
}
