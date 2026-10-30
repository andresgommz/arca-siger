/**
 * Genera db/3_ARCA_RESTABLECER.sql a partir de 0_ARCA_DROP.sql y 2_ARCA_DATOS.sql.
 *
 * - El orden de los DELETE sale de los DROP TABLE de 0_ARCA_DROP.sql (de hijas a padres).
 * - AUDITORIA se borra al final, porque los disparadores de auditoría registran las eliminaciones.
 * - Los INSERT y UPDATE se copian tal cual de 2_ARCA_DATOS.sql, sin el COMMIT final.
 *
 * Uso: npm run generar-restablecer
 */
import { readFileSync, writeFileSync } from "node:fs";
import path from "node:path";

const RAIZ = path.resolve(__dirname, "..");
const DB = path.join(RAIZ, "db");
const EOL = "\r\n";

function leer(nombre: string): string[] {
  return readFileSync(path.join(DB, nombre), "utf8").replace(/^﻿/, "").replace(/\r\n/g, "\n").split("\n");
}

// 1. Orden de borrado desde 0_ARCA_DROP.sql
const tablas = leer("0_ARCA_DROP.sql")
  .map((l) => /^DROP TABLE\s+([A-Z_]+)\s*;/i.exec(l.trim())?.[1])
  .filter((t): t is string => Boolean(t))
  .map((t) => t.toUpperCase());

if (tablas.length === 0) throw new Error("No se encontraron sentencias DROP TABLE en 0_ARCA_DROP.sql");
const tablasSinAuditoria = tablas.filter((t) => t !== "AUDITORIA");

// 2. Datos desde 2_ARCA_DATOS.sql
const lineasDatos = leer("2_ARCA_DATOS.sql");

// Se omite el encabezado del archivo original (primer bloque de comentarios).
let inicio = 0;
while (inicio < lineasDatos.length && (lineasDatos[inicio] ?? "").startsWith("--")) inicio++;

let commits = 0;
const cuerpo: string[] = [];
for (const linea of lineasDatos.slice(inicio)) {
  const t = linea.trim();
  if (t === "") continue; // sin líneas vacías dentro del bloque PL/SQL
  if (/^COMMIT\s*;$/i.test(t)) {
    commits++;
    continue;
  }
  if (/^(CREATE|DROP|ALTER|TRUNCATE|GRANT)\b/i.test(t)) {
    throw new Error(`2_ARCA_DATOS.sql contiene DDL que no puede ir en el procedimiento: ${t}`);
  }
  if (t === "/") throw new Error("2_ARCA_DATOS.sql contiene un separador '/' inesperado");
  cuerpo.push("  " + linea.trimEnd());
}

const texto = cuerpo.join("\n");
const inserts = (texto.match(/^\s*INSERT INTO/gim) ?? []).length;
const updates = (texto.match(/^\s*UPDATE\s/gim) ?? []).length;
if (commits !== 1) throw new Error(`Se esperaba un COMMIT en 2_ARCA_DATOS.sql y se encontraron ${commits}`);

const linea = "-- ============================================================================";
const lineaInterna = "  -- ==========================================================================";

const salida = [
  linea,
  "-- Script 3: procedimiento P_RESTABLECER_DEMO",
  "-- Deja la base exactamente como la deja 2_ARCA_DATOS.sql, para repetir la demostración.",
  "-- GENERADO por scripts/generar-restablecer.ts a partir de 0_ARCA_DROP.sql y 2_ARCA_DATOS.sql.",
  "-- No editar a mano: si cambian los datos, ejecutar npm run generar-restablecer.",
  "-- Ejecutar después de 2_ARCA_DATOS.sql.",
  linea,
  "",
  "-- Pasos:",
  "--   1. DELETE de todas las tablas en el orden de 0_ARCA_DROP.sql (de hijas a padres), sin DDL.",
  "--   2. DELETE FROM AUDITORIA al final, porque los disparadores registran las eliminaciones.",
  `--   3. Los mismos ${inserts} INSERT y ${updates} UPDATE de 2_ARCA_DATOS.sql, en el mismo orden; los`,
  "--      disparadores vuelven a descontar el inventario y a llenar la auditoría.",
  "--   4. COMMIT. Si algo falla, ROLLBACK y se propaga el error.",
  "-- La secuencia SEQ_AUDITORIA no se reinicia: los códigos de auditoría siguen creciendo.",
  "CREATE OR REPLACE PROCEDURE P_RESTABLECER_DEMO",
  "AS",
  "BEGIN",
  lineaInterna,
  "  -- Paso 1: borrado de los datos, de hijas a padres",
  lineaInterna,
  ...tablasSinAuditoria.map((t) => `  DELETE FROM ${t};`),
  lineaInterna,
  "  -- Paso 2: borrado de la auditoría generada por las eliminaciones",
  lineaInterna,
  "  DELETE FROM AUDITORIA;",
  lineaInterna,
  "  -- Paso 3: datos de prueba de 2_ARCA_DATOS.sql",
  lineaInterna,
  ...cuerpo,
  lineaInterna,
  "  -- Paso 4: confirmación de la transacción",
  lineaInterna,
  "  COMMIT;",
  "EXCEPTION",
  "  WHEN OTHERS THEN",
  "    ROLLBACK;",
  "    RAISE;",
  "END P_RESTABLECER_DEMO;",
  "/",
  "",
].join(EOL);

writeFileSync(path.join(DB, "3_ARCA_RESTABLECER.sql"), salida, "utf8");
console.log(
  `3_ARCA_RESTABLECER.sql generado: ${tablasSinAuditoria.length + 1} DELETE, ${inserts} INSERT, ${updates} UPDATE.`,
);
