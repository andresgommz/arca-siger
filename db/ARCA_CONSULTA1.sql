SELECT ben.nombres || ' ' || ben.apellidos             AS "Beneficiario",
       ins.nombre                                      AS "Insumo",
       ent.cantidad                                    AS "Cantidad",
       TO_CHAR(ent.fecha_hora, 'DD/MM/YYYY HH24:MI')   AS "Fecha entrega",
       rec.nombres || ' ' || rec.apellidos             AS "Recogió",
       ent.metodo_identificacion                       AS "Identificado con",
       des.cod_despacho                                AS "Despacho",
       ica.nombre                                      AS "Centro de acopio",
       ilo.num_lote                                    AS "Lote",
       ide.nombre                                      AS "Destino"
FROM DAMNIFICADO dam, PERSONA ben, ENTREGA ent, PERSONA rec, INSUMO ins,
     DESPACHO des, INSTALACION ica, INSTALACION ide, DESPACHO_LOTE dlo, INVENTARIO_LOTE ilo
WHERE dam.codigo_censo = '4821'
AND ben.cod_persona = dam.cod_persona
AND ent.cod_beneficiario = dam.cod_persona
AND rec.cod_persona = ent.cod_receptor
AND ins.cod_insumo = ent.cod_insumo
AND des.cod_despacho = ent.cod_despacho
AND ica.cod_instalacion = des.cod_centro
AND ide.cod_instalacion = des.cod_destino
AND dlo.cod_despacho = des.cod_despacho
AND ilo.cod_lote = dlo.cod_lote
AND ilo.cod_insumo = ent.cod_insumo
ORDER BY ent.fecha_hora;