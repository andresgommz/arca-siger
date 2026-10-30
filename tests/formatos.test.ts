import { describe, expect, it } from "vitest";
import {
  formatearFecha,
  formatearFechaHora,
  formatearNumero,
  formatearPorcentaje,
  hoyISO,
  isoADMA,
  sumarDiasISO,
} from "../src/lib/formatos";

describe("formatearNumero", () => {
  it("usa punto de miles y coma decimal (cifras del guion)", () => {
    expect(formatearNumero(1552.79)).toBe("1.552,79");
    expect(formatearNumero(997.06)).toBe("997,06");
    expect(formatearNumero(670.15)).toBe("670,15");
    expect(formatearNumero(1020)).toBe("1.020");
    expect(formatearNumero(960)).toBe("960");
  });

  it("no rellena con ceros salvo que se pida", () => {
    expect(formatearNumero(66.7)).toBe("66,7");
    expect(formatearNumero(12.5, { minDecimales: 2 })).toBe("12,50");
    expect(formatearNumero(3, { minDecimales: 1 })).toBe("3,0");
  });

  it("redondea al máximo de decimales", () => {
    expect(formatearNumero(66.666666, { maxDecimales: 1 })).toBe("66,7");
    expect(formatearNumero(1234567.891)).toBe("1.234.567,89");
  });

  it("acepta texto, negativos, cero y vacío", () => {
    expect(formatearNumero("3000")).toBe("3.000");
    expect(formatearNumero(-1500.5)).toBe("-1.500,5");
    expect(formatearNumero(0)).toBe("0");
    expect(formatearNumero(null)).toBe("");
    expect(formatearNumero("abc")).toBe("abc");
  });

  it("formatea porcentajes", () => {
    expect(formatearPorcentaje(100)).toBe("100 %");
    expect(formatearPorcentaje(66.67)).toBe("66,7 %");
    expect(formatearPorcentaje(0)).toBe("0 %");
  });
});

describe("fechas en America/Bogota", () => {
  // 30/10/2026 03:15 UTC es 29/10/2026 22:15 en Bogotá (UTC-5).
  const instante = new Date("2026-10-30T03:15:00Z");

  it("formatea fecha DD/MM/AAAA en la zona de Bogotá", () => {
    expect(formatearFecha(instante)).toBe("29/10/2026");
    expect(formatearFecha(instante, "UTC")).toBe("30/10/2026");
  });

  it("formatea fecha y hora DD/MM/AAAA HH:MM", () => {
    expect(formatearFechaHora(instante)).toBe("29/10/2026 22:15");
    expect(formatearFechaHora("2026-10-03T05:07:00Z")).toBe("03/10/2026 00:07");
  });

  it("calcula el día de hoy en la zona indicada", () => {
    expect(hoyISO("America/Bogota", instante)).toBe("2026-10-29");
  });

  it("suma días y convierte a DD/MM/AAAA", () => {
    expect(sumarDiasISO("2026-10-29", 20)).toBe("2026-11-18");
    expect(sumarDiasISO("2026-12-20", 60)).toBe("2027-02-18");
    expect(isoADMA("2026-11-18")).toBe("18/11/2026");
    expect(isoADMA("texto")).toBe("texto");
  });
});
