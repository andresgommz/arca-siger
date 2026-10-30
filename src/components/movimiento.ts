"use client";

import { useSyncExternalStore } from "react";

const CONSULTA = "(prefers-reduced-motion: reduce)";

function suscribir(avisar: () => void) {
  const m = window.matchMedia(CONSULTA);
  m.addEventListener("change", avisar);
  return () => m.removeEventListener("change", avisar);
}

/** true si la persona pidió reducir el movimiento en su sistema. */
export function usePrefiereMenosMovimiento(): boolean {
  return useSyncExternalStore(
    suscribir,
    () => window.matchMedia(CONSULTA).matches,
    () => false,
  );
}
