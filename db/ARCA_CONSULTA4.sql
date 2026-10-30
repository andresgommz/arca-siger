SELECT ind.zona                                         AS "Zona",
       ind.nivel                                        AS "Nivel de daño",
       COUNT(*)                                         AS "Necesidades validadas",
       SUM(ind.atendida)                                AS "Atendidas",
       COUNT(*) - SUM(ind.atendida)                     AS "Pendientes",
       ROUND(SUM(ind.atendida) * 100 / COUNT(*), 1)     AS "Índice (%)"
FROM (SELECT zon.nombre      AS zona,
             zon.nivel_dano  AS nivel,
             nda.cod_necesidad,
             CASE WHEN (SELECT COUNT(*)
                        FROM ENTREGA ent
                        WHERE ent.cod_necesidad = nda.cod_necesidad) > 0
                  THEN 1 ELSE 0 END AS atendida
      FROM NECESIDAD_DAMNIFICADO nda, CENSO_DAMNIFICADO cda, CENSO cen, ZONA_AFECTADA zon
      WHERE cda.cod_damnificado = nda.cod_damnificado
      AND cda.estado = 'Activo'
      AND cen.cod_censo = cda.cod_censo
      AND zon.cod_zona = cen.cod_zona
      AND nda.estado = 'Validada'
      AND SYSDATE BETWEEN nda.fecha_inicio AND nda.fecha_fin) ind
GROUP BY ind.zona, ind.nivel
ORDER BY 6, 1;