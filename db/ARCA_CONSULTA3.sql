SELECT zon.nombre                                       AS "Zona",
       zon.poblacion_riesgo                             AS "Población en riesgo",
       soi.cantidad_solicitada                          AS "Solicitado (L)",
       (SELECT SUM(si2.cantidad_solicitada)
        FROM SOLICITUD so2, SOLICITUD_INSUMO si2
        WHERE si2.cod_solicitud = so2.cod_solicitud
        AND so2.estado = 'Registrada'
        AND si2.cod_insumo = soi.cod_insumo)            AS "Demanda total (L)",
       (SELECT SUM(ilo.cantidad_disponible)
        FROM INVENTARIO_LOTE ilo
        WHERE ilo.cod_insumo = soi.cod_insumo)          AS "Stock total (L)",
       ROUND((SELECT SUM(ilo.cantidad_disponible)
              FROM INVENTARIO_LOTE ilo
              WHERE ilo.cod_insumo = soi.cod_insumo)
             * zon.poblacion_riesgo
             / (SELECT SUM(zo2.poblacion_riesgo)
                FROM SOLICITUD so2, SOLICITUD_INSUMO si2, ZONA_AFECTADA zo2
                WHERE si2.cod_solicitud = so2.cod_solicitud
                AND zo2.cod_zona = so2.cod_zona
                AND so2.estado = 'Registrada'
                AND si2.cod_insumo = soi.cod_insumo), 2) AS "Asignación prorrateada (L)"
FROM SOLICITUD sol, SOLICITUD_INSUMO soi, ZONA_AFECTADA zon, INSUMO inu
WHERE soi.cod_solicitud = sol.cod_solicitud
AND zon.cod_zona = sol.cod_zona
AND inu.cod_insumo = soi.cod_insumo
AND sol.estado = 'Registrada'
AND inu.nombre = 'Agua potable bolsa 6 L'
ORDER BY 6 DESC;