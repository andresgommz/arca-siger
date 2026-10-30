/**
 * fetch que sigue las redirecciones de apex.oracle.com conservando el método y el cuerpo.
 * apex.oracle.com/pls/apex/... redirige (302) a apex.oracle.com/ords/... y de ahí a
 * oracleapex.com/ords/...; con un 302 el fetch estándar cambia el POST por GET y ORDS
 * responde 405. Solo se reenvía la autorización si el destino es un dominio de Oracle APEX.
 */
const DOMINIOS_CONFIABLES = /(^|\.)(oracle\.com|oracleapex\.com|oraclecloud\.com)$/i;
const MAXIMO_REDIRECCIONES = 3;

export async function fetchOrds(url: string, opciones: RequestInit): Promise<Response> {
  let actual = url;
  for (let i = 0; i <= MAXIMO_REDIRECCIONES; i++) {
    const respuesta = await fetch(actual, { ...opciones, redirect: "manual" });
    const destino = respuesta.headers.get("location");
    if (respuesta.status < 300 || respuesta.status >= 400 || !destino) return respuesta;

    const siguiente = new URL(destino, actual);
    const origen = new URL(actual);
    if (siguiente.protocol !== "https:" && origen.protocol === "https:") return respuesta;
    if (siguiente.host !== origen.host && !DOMINIOS_CONFIABLES.test(siguiente.hostname)) return respuesta;
    actual = siguiente.toString();
  }
  throw new Error(`Demasiadas redirecciones desde ${url}`);
}
