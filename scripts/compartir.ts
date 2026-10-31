/**
 * Publica la app con un link temporal que se puede abrir desde otro computador o celular,
 * mientras este PC esté encendido. Las llamadas a Oracle salen desde este PC (oracleapex.com
 * rechaza las que salen de servidores en la nube como Vercel).
 *
 *   npm run compartir              -> compila, arranca la app y abre un túnel de Cloudflare
 *   npm run compartir -- --sin-compilar   -> usa el último build
 *
 * Requiere cloudflared (winget install Cloudflare.cloudflared) y DEMO_CLAVE en .env.local:
 * con un link público, sin clave cualquiera podría modificar o restablecer la base.
 * Ctrl+C cierra la app y el túnel.
 */
import { spawn, spawnSync, type ChildProcess } from "node:child_process";
import { existsSync } from "node:fs";
import path from "node:path";
import { cargarEntorno } from "./comun";

const RAIZ = path.resolve(__dirname, "..");
const PUERTO = 3000;
const procesos: ChildProcess[] = [];

function terminar(codigo = 0): never {
  for (const p of procesos) {
    if (p.exitCode !== null || !p.pid) continue;
    // En Windows, kill() con shell solo cierra la consola intermedia y deja vivo el servidor:
    // se cierra el árbol completo de procesos.
    if (process.platform === "win32") spawnSync("taskkill", ["/pid", String(p.pid), "/T", "/F"], { stdio: "ignore" });
    else p.kill();
  }
  process.exit(codigo);
}
process.on("SIGINT", () => terminar(0));
process.on("SIGTERM", () => terminar(0));

function buscarCloudflared(): string | null {
  const enPath = spawnSync(process.platform === "win32" ? "where" : "which", ["cloudflared"], { encoding: "utf8" });
  if (enPath.status === 0) return enPath.stdout.split(/\r?\n/)[0]!.trim();
  const candidatos = [
    "C:\\Program Files (x86)\\cloudflared\\cloudflared.exe",
    "C:\\Program Files\\cloudflared\\cloudflared.exe",
    path.join(process.env.LOCALAPPDATA ?? "", "Microsoft", "WinGet", "Links", "cloudflared.exe"),
  ];
  return candidatos.find((c) => c && existsSync(c)) ?? null;
}

async function esperarApp(): Promise<boolean> {
  for (let i = 0; i < 60; i++) {
    try {
      const r = await fetch(`http://localhost:${PUERTO}/api/estado`);
      if (r.ok) return true;
    } catch {
      // todavía arrancando
    }
    await new Promise((r) => setTimeout(r, 1000));
  }
  return false;
}

async function main() {
  cargarEntorno();
  if (!process.env.DEMO_CLAVE?.trim()) {
    console.error(
      "DEMO_CLAVE está vacía en .env.local. Con un link público, cualquiera podría modificar o restablecer la base.\n" +
        "Escriba una clave en .env.local (DEMO_CLAVE=...) y vuelva a ejecutar npm run compartir.",
    );
    process.exit(1);
  }

  const cloudflared = buscarCloudflared();
  if (!cloudflared) {
    console.error("No se encontró cloudflared. Instálelo con: winget install Cloudflare.cloudflared");
    process.exit(1);
  }

  const npm = process.platform === "win32" ? "npm.cmd" : "npm";
  if (!process.argv.includes("--sin-compilar")) {
    console.log("Compilando la app (npm run build)…");
    const build = spawnSync(npm, ["run", "build"], { cwd: RAIZ, stdio: "inherit", shell: process.platform === "win32" });
    if (build.status !== 0) terminar(build.status ?? 1);
  }

  console.log(`Arrancando la app en http://localhost:${PUERTO}…`);
  const app = spawn(npm, ["run", "start", "--", "-p", String(PUERTO)], {
    cwd: RAIZ,
    stdio: ["ignore", "inherit", "inherit"],
    shell: process.platform === "win32",
  });
  procesos.push(app);
  app.on("exit", (c) => {
    console.error(`La app se detuvo (código ${c}).`);
    terminar(c ?? 1);
  });
  if (!(await esperarApp())) {
    console.error("La app no respondió en 60 segundos.");
    terminar(1);
  }

  console.log("Abriendo el túnel de Cloudflare…");
  const tunel = spawn(cloudflared, ["tunnel", "--no-autoupdate", "--url", `http://localhost:${PUERTO}`], {
    stdio: ["ignore", "pipe", "pipe"],
  });
  procesos.push(tunel);
  let anunciado = false;
  const leer = (bloque: Buffer) => {
    const m = /https:\/\/[a-z0-9-]+\.trycloudflare\.com/i.exec(bloque.toString());
    if (m && !anunciado) {
      anunciado = true;
      const raya = "=".repeat(m[0].length + 4);
      console.log(`\n${raya}\n  ${m[0]}\n${raya}`);
      console.log("Link listo para abrir desde otro computador o celular (puede tardar unos segundos en responder).");
      console.log("Mantenga este PC encendido y esta ventana abierta. Ctrl+C cierra la app y el túnel.\n");
    }
  };
  tunel.stdout.on("data", leer);
  tunel.stderr.on("data", leer);
  tunel.on("exit", (c) => {
    console.error(`El túnel se cerró (código ${c}).`);
    terminar(c ?? 1);
  });
}

void main();
