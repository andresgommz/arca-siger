/**
 * Clave de demostración para las operaciones de escritura (sección 6 del PRD).
 * Si DEMO_CLAVE tiene valor, todo POST debe traer el encabezado x-demo-clave con esa clave.
 */
import { createHash, timingSafeEqual } from "node:crypto";

export const ENCABEZADO_CLAVE = "x-demo-clave";

function resumen(texto: string): Buffer {
  return createHash("sha256").update(texto, "utf8").digest();
}

/** true si no se exige clave o si la clave recibida coincide. */
export function claveValida(claveConfigurada: string, recibida: string | null): boolean {
  if (!claveConfigurada) return true;
  if (!recibida) return false;
  return timingSafeEqual(resumen(claveConfigurada), resumen(recibida));
}
