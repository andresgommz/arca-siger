SELECT ocu.albergue                                     AS "Albergue",
       ocu.municipio                                    AS "Municipio",
       ocu.capacidad                                    AS "Capacidad",
       ocu.personas                                     AS "Personas alojadas",
       ocu.capacidad - ocu.personas                     AS "Cupos libres",
       ROUND(ocu.personas * 100 / ocu.capacidad, 1)     AS "% ocupación"
FROM (SELECT ins.nombre            AS albergue,
             mun.nombre            AS municipio,
             alb.capacidad_maxima  AS capacidad,
             (SELECT COUNT(*)
              FROM FAMILIA_ALBERGUE fal, DAMNIFICADO dam
              WHERE fal.cod_albergue = alb.cod_instalacion
              AND fal.fecha_salida IS NULL
              AND dam.cod_familia = fal.cod_familia) AS personas
      FROM ALBERGUE alb, INSTALACION ins, MUNICIPIO mun
      WHERE ins.cod_instalacion = alb.cod_instalacion
      AND mun.cod_municipio = ins.cod_municipio) ocu
ORDER BY 6 DESC, 1;