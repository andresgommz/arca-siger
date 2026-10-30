import Link from "next/link";
import { BarChart3, ClipboardList, Hand } from "lucide-react";
import { IndicadorConexion } from "@/components/conexion";
import { Logo } from "@/components/encabezado";

const PERFILES = [
  {
    href: "/coordinador",
    titulo: "Coordinador",
    descripcion: "Las 5 consultas del proyecto, las operaciones que activan las reglas de Oracle y las manifestaciones recibidas.",
    Icono: ClipboardList,
  },
  {
    href: "/quiosco",
    titulo: "Quiosco del damnificado",
    descripcion: "La persona se identifica con su código de censo, ve lo que ha recibido y lo que necesita, y manifiesta algo.",
    Icono: Hand,
  },
  {
    href: "/transparencia",
    titulo: "Transparencia pública",
    descripcion: "Cifras agregadas por zona y cupos de albergues para ciudadanía y donantes, sin datos personales.",
    Icono: BarChart3,
  },
];

export default function Inicio() {
  return (
    <main className="mx-auto flex min-h-screen max-w-6xl flex-col px-6 py-10">
      <header className="flex flex-wrap items-center justify-between gap-4">
        <span className="text-3xl">
          <Logo />
        </span>
        <IndicadorConexion grande />
      </header>

      <section className="mt-16 text-center">
        <h1 className="text-5xl font-extrabold tracking-tight text-arca-700 md:text-6xl">Cada ayuda, a quien la necesita.</h1>
        <p className="mx-auto mt-5 max-w-3xl text-xl text-gray-600">
          Sistema de Gestión y Distribución Equitativa de Recursos para Emergencias y Desastres (SIGER-Emergencias).
          Escenario: terremoto del 03/10/2026.
        </p>
      </section>

      <nav aria-label="Perfiles" className="mt-14 grid gap-6 md:grid-cols-3">
        {PERFILES.map(({ href, titulo, descripcion, Icono }) => (
          <Link
            key={href}
            href={href}
            className="group flex flex-col rounded-2xl border-2 border-arca-100 bg-white p-7 shadow-sm transition hover:-translate-y-0.5 hover:border-naranja-400 hover:shadow-lg"
          >
            <span className="flex size-14 items-center justify-center rounded-xl bg-arca-700 text-white group-hover:bg-naranja-600">
              <Icono className="size-7" aria-hidden />
            </span>
            <h2 className="mt-5 text-2xl font-bold text-arca-700">{titulo}</h2>
            <p className="mt-2 text-lg text-gray-600">{descripcion}</p>
            <span className="mt-auto pt-6 font-semibold text-naranja-600">Entrar →</span>
          </Link>
        ))}
      </nav>

      <footer className="mt-auto pt-16 text-center text-sm text-gray-500">
        ARCA: Andrés Felipe Gómez Carrillo y Rodolfo José Hernández Luna. Datos de personas ficticios.
      </footer>
    </main>
  );
}
