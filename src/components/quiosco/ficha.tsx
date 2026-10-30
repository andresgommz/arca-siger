"use client";

import { useCallback, useEffect, useRef, useState } from "react";
import { useRouter } from "next/navigation";
import { CircleCheck, HeartHandshake, LogOut, MessageSquarePlus, PackageCheck, PackageX, ThumbsDown } from "lucide-react";
import { formatearNumero } from "@/lib/formatos";
import { useEnviar } from "../clave-demo";
import { AvisoCache, useConexion } from "../conexion";
import { conParametros, useDatos, useInvalidar } from "../datos";
import { Logo } from "../encabezado";
import { Cargando, ErrorCarga } from "../ui";

interface Persona {
  cod_persona: number;
  nombres: string;
  apellidos: string;
  codigo_censo: string;
  cod_familia: number;
  albergue_actual: string | null;
  zona: string;
  municipio: string;
}

interface Entrega {
  cod_entrega: number;
  insumo: string;
  cantidad: number;
  unidad: string;
  fecha: string;
  recogio: string;
  recogio_titular: "S" | "N";
  despacho: number;
  lugar: string;
}

interface Necesidad {
  cod_necesidad: number;
  categoria: string;
  estado: string;
  fecha_declaracion: string;
  vigencia_desde: string | null;
  vigencia_hasta: string | null;
}

interface Manifestacion {
  cod_manifestacion: number;
  fecha: string;
  tipo: string;
  descripcion: string;
  estado: string;
  respuesta: string | null;
  fecha_respuesta: string | null;
}

const INACTIVIDAD_MS = 2 * 60 * 1000;
const AVISO_MS = 20 * 1000;

const TIPOS = [
  { valor: "Necesidad nueva", etiqueta: "Necesidad nueva", detalle: "Necesito algo que no tengo", Icono: MessageSquarePlus },
  { valor: "No recibido", etiqueta: "No recibí", detalle: "Algo que me correspondía no llegó", Icono: PackageX },
  { valor: "No me sirve", etiqueta: "No me sirve", detalle: "Lo que recibí no me sirve", Icono: ThumbsDown },
] as const;

function Estado({ texto }: { texto: string }) {
  const color =
    texto === "Validada" || texto === "Respondida"
      ? "bg-exito-fondo text-exito border-exito-borde"
      : texto === "Rechazada"
        ? "bg-rechazo-fondo text-rechazo border-rechazo-borde"
        : "bg-advertencia-fondo text-advertencia border-advertencia-borde";
  return <span className={`rounded-full border-2 px-3 py-1 text-lg font-bold ${color}`}>{texto}</span>;
}

function Seccion({ titulo, Icono, children }: { titulo: string; Icono: typeof PackageCheck; children: React.ReactNode }) {
  return (
    <section className="rounded-2xl border-2 border-arca-100 bg-white p-6">
      <h2 className="mb-4 flex items-center gap-3 text-3xl font-extrabold text-arca-700">
        <Icono className="size-8" aria-hidden /> {titulo}
      </h2>
      {children}
    </section>
  );
}

/** Cierra la sesión del quiosco tras 2 minutos sin actividad; avisa en los últimos 20 segundos. */
function useInactividad(alVencer: () => void) {
  const [restante, setRestante] = useState(INACTIVIDAD_MS);
  const ultima = useRef(Date.now());
  useEffect(() => {
    const actividad = () => {
      ultima.current = Date.now();
      setRestante(INACTIVIDAD_MS);
    };
    const eventos = ["pointerdown", "keydown", "touchstart", "wheel"] as const;
    eventos.forEach((e) => window.addEventListener(e, actividad, { passive: true }));
    const reloj = window.setInterval(() => {
      const r = INACTIVIDAD_MS - (Date.now() - ultima.current);
      setRestante(r);
      if (r <= 0) alVencer();
    }, 1000);
    return () => {
      eventos.forEach((e) => window.removeEventListener(e, actividad));
      window.clearInterval(reloj);
    };
  }, [alVencer]);
  return restante;
}

export function FichaQuiosco({ codigo }: { codigo: string }) {
  const router = useRouter();
  const salir = useCallback(() => router.replace("/quiosco"), [router]);
  const restante = useInactividad(salir);

  const persona = useDatos<Persona>(conParametros("quiosco/persona", { codigo_censo: codigo }));
  const base = `quiosco/${encodeURIComponent(codigo)}`;
  const entregas = useDatos<Entrega[]>(persona.datos ? `${base}/entregas` : null);
  const necesidades = useDatos<Necesidad[]>(persona.datos ? `${base}/necesidades` : null);
  const manifestaciones = useDatos<Manifestacion[]>(persona.datos ? `${base}/manifestaciones` : null);

  const [manifestando, setManifestando] = useState(false);

  if (persona.error) {
    return (
      <Marco onSalir={salir} restante={restante}>
        {persona.error.noEncontrado ? (
          <p role="alert" className="rounded-2xl bg-rechazo-fondo p-8 text-center text-3xl font-bold text-rechazo">
            El código {codigo} no aparece o no tiene un registro activo en el censo.
          </p>
        ) : (
          <ErrorCarga mensaje={persona.error.message} onReintentar={persona.recargar} />
        )}
      </Marco>
    );
  }
  if (!persona.datos) {
    return (
      <Marco onSalir={salir} restante={restante}>
        <Cargando texto="Buscando sus datos" />
      </Marco>
    );
  }

  const p = persona.datos;
  return (
    <Marco onSalir={salir} restante={restante}>
      <div className="flex flex-wrap items-end justify-between gap-6">
        <div>
          <p className="text-2xl text-gray-600">Hola,</p>
          <h1 className="text-5xl font-extrabold text-arca-700">
            {p.nombres} {p.apellidos}
          </h1>
          <p className="mt-2 text-2xl text-gray-700">
            Código <strong className="cifra text-arca-700">{p.codigo_censo}</strong>
            {" · "}
            {p.albergue_actual ? `Albergue: ${p.albergue_actual}` : `Zona: ${p.zona} (${p.municipio})`}
          </p>
        </div>
        {!manifestando && (
          <button
            type="button"
            onClick={() => setManifestando(true)}
            className="inline-flex items-center gap-3 rounded-2xl bg-naranja-600 px-8 py-5 text-2xl font-bold text-white shadow-lg hover:bg-naranja-700"
          >
            <MessageSquarePlus className="size-8" aria-hidden /> Quiero manifestar algo
          </button>
        )}
      </div>

      {manifestando && (
        <FormManifestar
          codigo={p.codigo_censo}
          onTerminar={() => {
            setManifestando(false);
            manifestaciones.recargar();
          }}
        />
      )}

      <div className="mt-8 grid gap-6 lg:grid-cols-2">
        <Seccion titulo="Lo que he recibido" Icono={PackageCheck}>
          {entregas.error ? (
            <ErrorCarga mensaje={entregas.error.message} onReintentar={entregas.recargar} />
          ) : !entregas.datos ? (
            <Cargando />
          ) : entregas.datos.length === 0 ? (
            <p className="text-2xl text-gray-600">Todavía no hay entregas a su nombre. Si le falta algo, toque "Quiero manifestar algo".</p>
          ) : (
            <ul className="space-y-3">
              {entregas.datos.map((e) => (
                <li key={e.cod_entrega} className="rounded-xl bg-arca-50 p-4">
                  <p className="text-2xl font-bold text-arca-900">
                    {e.insumo}: <span className="cifra text-naranja-600">{formatearNumero(e.cantidad)}</span>{" "}
                    <span className="text-xl font-semibold text-gray-700">{e.unidad.toLowerCase()}</span>
                  </p>
                  <p className="text-xl text-gray-700">
                    {e.fecha}, despacho {e.despacho}, en {e.lugar}
                  </p>
                  <p className="text-xl text-gray-700">
                    {e.recogio_titular === "S" ? "Lo recogió usted" : <>Lo recogió <strong>{e.recogio}</strong></>}
                  </p>
                </li>
              ))}
            </ul>
          )}
        </Seccion>

        <div className="space-y-6">
          <Seccion titulo="Mis necesidades" Icono={HeartHandshake}>
            {necesidades.error ? (
              <ErrorCarga mensaje={necesidades.error.message} onReintentar={necesidades.recargar} />
            ) : !necesidades.datos ? (
              <Cargando />
            ) : necesidades.datos.length === 0 ? (
              <p className="text-2xl text-gray-600">No tiene necesidades registradas.</p>
            ) : (
              <ul className="space-y-3">
                {necesidades.datos.map((n) => (
                  <li key={n.cod_necesidad} className="flex flex-wrap items-center justify-between gap-3 rounded-xl bg-arca-50 p-4">
                    <span>
                      <span className="block text-2xl font-bold text-arca-900">{n.categoria}</span>
                      <span className="text-xl text-gray-700">
                        {n.vigencia_desde && n.vigencia_hasta
                          ? `Vigente del ${n.vigencia_desde} al ${n.vigencia_hasta}`
                          : `Declarada el ${n.fecha_declaracion}`}
                      </span>
                    </span>
                    <Estado texto={n.estado} />
                  </li>
                ))}
              </ul>
            )}
          </Seccion>

          <Seccion titulo="Mis manifestaciones" Icono={MessageSquarePlus}>
            {manifestaciones.error ? (
              <ErrorCarga mensaje={manifestaciones.error.message} onReintentar={manifestaciones.recargar} />
            ) : !manifestaciones.datos ? (
              <Cargando />
            ) : manifestaciones.datos.length === 0 ? (
              <p className="text-2xl text-gray-600">Aún no hay manifestaciones. Puede hacer una con el botón "Quiero manifestar algo".</p>
            ) : (
              <ul className="space-y-3">
                {manifestaciones.datos.map((m) => (
                  <li key={m.cod_manifestacion} className="rounded-xl bg-arca-50 p-4">
                    <div className="flex flex-wrap items-center justify-between gap-3">
                      <span className="text-2xl font-bold text-arca-900">
                        {m.tipo} <span className="text-xl font-normal text-gray-600">({m.fecha})</span>
                      </span>
                      <Estado texto={m.estado} />
                    </div>
                    <p className="mt-1 text-xl text-gray-800">{m.descripcion}</p>
                    {m.respuesta && (
                      <p className="mt-2 rounded-lg bg-white p-3 text-xl text-gray-800">
                        <strong>Respuesta{m.fecha_respuesta ? ` (${m.fecha_respuesta})` : ""}:</strong> {m.respuesta}
                      </p>
                    )}
                  </li>
                ))}
              </ul>
            )}
          </Seccion>
        </div>
      </div>
    </Marco>
  );
}

function Marco({ children, onSalir, restante }: { children: React.ReactNode; onSalir: () => void; restante: number }) {
  return (
    <div className="min-h-screen bg-gray-50">
      <header className="sticky top-0 z-10 bg-arca-700 text-white shadow">
        <div className="mx-auto flex max-w-7xl items-center justify-between px-6 py-4">
          <span className="text-2xl">
            <Logo claro />
          </span>
          <span className="text-xl text-arca-100">Quiosco del damnificado</span>
          <button
            type="button"
            onClick={onSalir}
            className="inline-flex items-center gap-2 rounded-xl bg-white px-6 py-3 text-xl font-bold text-arca-700 hover:bg-arca-50"
          >
            <LogOut className="size-6" aria-hidden /> Salir
          </button>
        </div>
        <AvisoCache />
        {restante <= AVISO_MS && (
          <p role="alert" className="bg-advertencia-fondo px-6 py-2 text-center text-xl font-semibold text-advertencia">
            Por su seguridad, la sesión se cerrará en {Math.max(0, Math.ceil(restante / 1000))} segundos. Toque la pantalla para seguir.
          </p>
        )}
      </header>
      <main className="mx-auto max-w-7xl px-6 py-8">{children}</main>
    </div>
  );
}

function FormManifestar({ codigo, onTerminar }: { codigo: string; onTerminar: () => void }) {
  const { conectado } = useConexion();
  const enviar = useEnviar();
  const invalidar = useInvalidar();
  const [tipo, setTipo] = useState<string>("");
  const [descripcion, setDescripcion] = useState("");
  const [enviando, setEnviando] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [creada, setCreada] = useState<number | null>(null);

  if (creada !== null) {
    return (
      <div role="status" className="mt-8 rounded-2xl border-4 border-exito-borde bg-exito-fondo p-8 text-center">
        <CircleCheck className="mx-auto size-16 text-exito" aria-hidden />
        <p className="mt-3 text-3xl font-extrabold text-exito">Su manifestación quedó registrada</p>
        <p className="mt-2 text-2xl text-gray-800">Número {creada}. El equipo de coordinación ya la puede ver.</p>
        <button type="button" onClick={onTerminar} className="mt-6 rounded-2xl bg-arca-700 px-8 py-4 text-2xl font-bold text-white hover:bg-arca-800">
          Listo
        </button>
      </div>
    );
  }

  return (
    <form
      className="mt-8 space-y-6 rounded-2xl border-4 border-naranja-400 bg-white p-6"
      onSubmit={async (e) => {
        e.preventDefault();
        setEnviando(true);
        setError(null);
        const r = await enviar("quiosco/manifestaciones", { codigo_censo: codigo, tipo, descripcion: descripcion.trim() });
        setEnviando(false);
        if (r.ok) {
          setCreada(Number(r.cod_manifestacion));
          await invalidar(["manifestaciones", `quiosco/${encodeURIComponent(codigo)}/manifestaciones`]);
        } else {
          setError(r.traduccion?.original ? `${r.mensaje} (${r.traduccion.original})` : r.mensaje);
        }
      }}
    >
      <h2 className="text-3xl font-extrabold text-arca-700">¿Qué quiere manifestar?</h2>
      <div className="grid gap-4 md:grid-cols-3" role="radiogroup" aria-label="Tipo de manifestación">
        {TIPOS.map(({ valor, etiqueta, detalle, Icono }) => {
          const sel = tipo === valor;
          return (
            <button
              key={valor}
              type="button"
              role="radio"
              aria-checked={sel}
              onClick={() => setTipo(valor)}
              className={`flex flex-col items-center gap-2 rounded-2xl border-4 p-6 text-center transition ${sel ? "border-arca-700 bg-arca-700 text-white" : "border-arca-200 bg-white text-arca-900 hover:border-arca-500"}`}
            >
              <Icono className="size-12" aria-hidden />
              <span className="text-3xl font-extrabold">{etiqueta}</span>
              <span className={`text-xl ${sel ? "text-arca-100" : "text-gray-600"}`}>{detalle}</span>
            </button>
          );
        })}
      </div>
      <label className="block">
        <span className="mb-2 block text-2xl font-bold text-gray-800">Cuéntenos con sus palabras</span>
        <textarea
          required
          maxLength={500}
          rows={3}
          value={descripcion}
          onChange={(e) => setDescripcion(e.target.value)}
          className="w-full rounded-xl border-2 border-gray-400 p-4 text-2xl focus:border-arca-500"
        />
      </label>
      {error && (
        <p role="alert" className="rounded-xl bg-rechazo-fondo p-4 text-xl font-semibold text-rechazo">
          {error}
        </p>
      )}
      {!conectado && (
        <p className="rounded-xl bg-advertencia-fondo p-4 text-xl font-semibold text-advertencia">
          Sin conexión: por ahora no se pueden enviar manifestaciones.
        </p>
      )}
      <div className="flex flex-wrap gap-4">
        <button
          type="submit"
          disabled={!tipo || !descripcion.trim() || enviando || !conectado}
          className="rounded-2xl bg-naranja-600 px-10 py-5 text-2xl font-bold text-white hover:bg-naranja-700 disabled:bg-gray-300 disabled:text-gray-600"
        >
          {enviando ? "Enviando…" : "Enviar"}
        </button>
        <button type="button" onClick={onTerminar} className="rounded-2xl bg-gray-200 px-8 py-5 text-2xl font-bold text-gray-800 hover:bg-gray-300">
          Cancelar
        </button>
      </div>
    </form>
  );
}
