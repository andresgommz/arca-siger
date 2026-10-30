SELECT ica.nombre                                       AS "Centro de acopio",
       mun.nombre                                       AS "Municipio",
       inu.nombre                                       AS "Insumo",
       ilo.num_lote                                     AS "Lote",
       TO_CHAR(ilo.fecha_vencimiento, 'DD/MM/YYYY')     AS "Vence",
       TRUNC(ilo.fecha_vencimiento) - TRUNC(SYSDATE)    AS "Días restantes",
       ilo.cantidad_disponible                          AS "Disponible",
       ume.nombre                                       AS "Unidad"
FROM INVENTARIO_LOTE ilo, INSTALACION ica, MUNICIPIO mun, INSUMO inu, UNIDAD_MEDIDA ume
WHERE ica.cod_instalacion = ilo.cod_centro
AND mun.cod_municipio = ica.cod_municipio
AND inu.cod_insumo = ilo.cod_insumo
AND ume.cod_unidad_medida = inu.cod_unidad_medida
AND ilo.fecha_vencimiento IS NOT NULL
AND ilo.cantidad_disponible > 0
AND ilo.fecha_vencimiento <= SYSDATE + 90
ORDER BY ilo.fecha_vencimiento;