/**
 * Copia el texto de db/ARCA_CONSULTA1.sql a db/ARCA_CONSULTA5.sql a
 * src/generated/consultas-sql.ts, para el panel "Ver SQL".
 * Se ejecuta antes de cada build (prebuild), porque en Vercel no se garantiza
 * leer archivos del repositorio en tiempo de ejecución.
 */
import { mkdirSync, readFileSync, writeFileSync } from "node:fs";
import path from "node:path";

const RAIZ = path.resolve(__dirname, "..");
const consultas: Record<number, string> = {};

for (let n = 1; n <= 5; n++) {
  const archivo = path.join(RAIZ, "db", `ARCA_CONSULTA${n}.sql`);
  consultas[n] = readFileSync(archivo, "utf8").replace(/^﻿/, "").replace(/\r\n/g, "\n").trimEnd();
}

const salida = `// GENERADO por scripts/generar-sql.ts a partir de db/ARCA_CONSULTA1.sql a ARCA_CONSULTA5.sql.
// No editar a mano.
export const CONSULTAS_SQL: Record<1 | 2 | 3 | 4 | 5, string> = ${JSON.stringify(consultas, null, 2)};
`;

const destino = path.join(RAIZ, "src", "generated", "consultas-sql.ts");
mkdirSync(path.dirname(destino), { recursive: true });
writeFileSync(destino, salida, "utf8");
console.log("src/generated/consultas-sql.ts generado con 5 consultas.");
