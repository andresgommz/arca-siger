-- ============================================================================
-- Script 4: API REST de ARCA en ORDS (módulo "arca", ruta base /arca/)
-- Define el paquete de apoyo PKG_ARCA_API, el módulo REST con sus plantillas y
-- manejadores, el privilegio que lo protege y el cliente OAuth2 (client credentials).
-- Ejecutar en APEX (SQL Workshop > SQL Scripts) después de 3_ARCA_RESTABLECER.sql.
-- Se puede volver a ejecutar: redefine el módulo y crea un cliente nuevo.
-- Al final imprime ORDS_CLIENT_ID y ORDS_CLIENT_SECRET para copiarlos a
-- .env.local y a las variables de entorno de Vercel.
-- ============================================================================


-- ============================================================================
-- Paquete de apoyo PKG_ARCA_API
-- ============================================================================

-- Funciones comunes de los manejadores POST:
--   numero:    convierte el valor recibido en el JSON a NUMBER sin depender de la
--              configuración regional de la sesión (acepta punto o coma decimal).
--   hoy/ahora: fecha y fecha-hora actuales en la zona horaria de la demo (Bogotá),
--              porque SYSDATE devuelve la hora del servidor de apex.oracle.com.
--   responder: escribe la respuesta JSON del manejador.
CREATE OR REPLACE PACKAGE PKG_ARCA_API AS
  FUNCTION numero(p_valor IN VARCHAR2) RETURN NUMBER;
  FUNCTION hoy RETURN DATE;
  FUNCTION ahora RETURN DATE;
  PROCEDURE responder(p_json IN JSON_OBJECT_T);
  PROCEDURE responder_error(p_sqlcode IN NUMBER, p_mensaje IN VARCHAR2);
END PKG_ARCA_API;
/

CREATE OR REPLACE PACKAGE BODY PKG_ARCA_API AS
  FUNCTION numero(p_valor IN VARCHAR2) RETURN NUMBER IS
  BEGIN
    IF p_valor IS NULL THEN
      RETURN NULL;
    END IF;
    RETURN TO_NUMBER(REPLACE(TRIM(p_valor), ',', '.'), '999999999999D999999', 'NLS_NUMERIC_CHARACTERS=''.,''');
  END numero;

  FUNCTION ahora RETURN DATE IS
  BEGIN
    RETURN CAST(SYSTIMESTAMP AT TIME ZONE 'America/Bogota' AS DATE);
  END ahora;

  FUNCTION hoy RETURN DATE IS
  BEGIN
    RETURN TRUNC(ahora);
  END hoy;

  PROCEDURE responder(p_json IN JSON_OBJECT_T) IS
  BEGIN
    OWA_UTIL.MIME_HEADER('application/json', TRUE, 'utf-8');
    HTP.P(p_json.to_string);
  END responder;

  PROCEDURE responder_error(p_sqlcode IN NUMBER, p_mensaje IN VARCHAR2) IS
    v_json JSON_OBJECT_T := JSON_OBJECT_T();
  BEGIN
    v_json.put('ok', FALSE);
    v_json.put('sqlcode', p_sqlcode);
    v_json.put('mensaje', p_mensaje);
    responder(v_json);
  END responder_error;
END PKG_ARCA_API;
/


-- ============================================================================
-- Módulo REST "arca": catálogos, consultas, quiosco, transparencia y operaciones
-- ============================================================================

-- Convenciones:
--   GET:  tipo colección, sin paginación (p_items_per_page => 0), alias en
--         snake_case sin comillas (ORDS los usa como nombre del campo JSON) y
--         fechas ya formateadas con TO_CHAR.
--   POST: tipo PL/SQL; los campos del cuerpo JSON llegan como binds (:campo); el
--         código nuevo se calcula con NVL(MAX(cod), 0) + 1. Ante cualquier error:
--         ROLLBACK, :status_code := 422 y {"ok": false, "sqlcode", "mensaje"}.
--   Mismo estilo SQL del proyecto: sin JOIN y sin SELECT *.
DECLARE
  -- Plantilla con un manejador GET de tipo colección.
  PROCEDURE definir_get(p_patron IN VARCHAR2,
                        p_sql    IN VARCHAR2,
                        p_tipo   IN VARCHAR2 DEFAULT ORDS.source_type_collection_feed) IS
  BEGIN
    ORDS.DEFINE_TEMPLATE(p_module_name => 'arca', p_pattern => p_patron);
    ORDS.DEFINE_HANDLER(p_module_name    => 'arca',
                        p_pattern        => p_patron,
                        p_method         => 'GET',
                        p_source_type    => p_tipo,
                        p_items_per_page => 0,
                        p_source         => p_sql);
  END definir_get;

  -- Plantilla con un manejador POST de tipo PL/SQL.
  PROCEDURE definir_post(p_patron IN VARCHAR2, p_plsql IN VARCHAR2) IS
  BEGIN
    ORDS.DEFINE_TEMPLATE(p_module_name => 'arca', p_pattern => p_patron);
    ORDS.DEFINE_HANDLER(p_module_name    => 'arca',
                        p_pattern        => p_patron,
                        p_method         => 'POST',
                        p_source_type    => ORDS.source_type_plsql,
                        p_mimes_allowed  => 'application/json',
                        p_items_per_page => 0,
                        p_source         => p_plsql);
  END definir_post;
BEGIN
  ORDS.DEFINE_MODULE(p_module_name    => 'arca',
                     p_base_path      => '/arca/',
                     p_items_per_page => 0,
                     p_status         => 'PUBLISHED',
                     p_comments       => 'API REST de ARCA para la aplicación web de demostración.');

  -- ==========================================================================
  -- Catálogos para formularios
  -- ==========================================================================

  definir_get('catalogos/centros', q'~
SELECT ins.cod_instalacion AS cod_centro,
       ins.nombre          AS nombre,
       mun.nombre          AS municipio
FROM CENTRO_ACOPIO cac, INSTALACION ins, MUNICIPIO mun
WHERE ins.cod_instalacion = cac.cod_instalacion
AND mun.cod_municipio = ins.cod_municipio
ORDER BY ins.nombre~');

  definir_get('catalogos/albergues', q'~
SELECT ins.cod_instalacion  AS cod_albergue,
       ins.nombre           AS nombre,
       mun.nombre           AS municipio,
       alb.capacidad_maxima AS capacidad_maxima
FROM ALBERGUE alb, INSTALACION ins, MUNICIPIO mun
WHERE ins.cod_instalacion = alb.cod_instalacion
AND mun.cod_municipio = ins.cod_municipio
ORDER BY ins.nombre~');

  definir_get('catalogos/destinos', q'~
SELECT ins.cod_instalacion AS cod_destino,
       ins.nombre          AS nombre,
       'Albergue'          AS tipo,
       mun.nombre          AS municipio
FROM ALBERGUE alb, INSTALACION ins, MUNICIPIO mun
WHERE ins.cod_instalacion = alb.cod_instalacion
AND mun.cod_municipio = ins.cod_municipio
UNION ALL
SELECT ins.cod_instalacion AS cod_destino,
       ins.nombre          AS nombre,
       'Punto de entrega'  AS tipo,
       mun.nombre          AS municipio
FROM PUNTO_ENTREGA pen, INSTALACION ins, MUNICIPIO mun
WHERE ins.cod_instalacion = pen.cod_instalacion
AND mun.cod_municipio = ins.cod_municipio
ORDER BY 3, 2~');

  definir_get('catalogos/insumos', q'~
SELECT inu.cod_insumo        AS cod_insumo,
       inu.nombre            AS nombre,
       inu.perecedero        AS perecedero,
       ume.nombre            AS unidad,
       inu.modalidad_entrega AS modalidad_entrega
FROM INSUMO inu, UNIDAD_MEDIDA ume
WHERE ume.cod_unidad_medida = inu.cod_unidad_medida
ORDER BY inu.nombre~');

  definir_get('catalogos/solicitudes', q'~
SELECT sol.cod_solicitud AS cod_solicitud,
       zon.nombre        AS zona,
       sol.descripcion   AS descripcion,
       sol.estado        AS estado,
       sol.prioridad     AS prioridad
FROM SOLICITUD sol, ZONA_AFECTADA zon
WHERE zon.cod_zona = sol.cod_zona
AND sol.estado <> 'Rechazada'
ORDER BY sol.cod_solicitud~');

  definir_get('catalogos/conductores', q'~
SELECT pso.cod_persona                   AS cod_conductor,
       per.nombres || ' ' || per.apellidos AS nombre,
       pso.disponibilidad                AS disponibilidad
FROM PERSONAL_SOCORRO pso, PERSONA per
WHERE per.cod_persona = pso.cod_persona
AND pso.tipo_personal = 'Conductor'
ORDER BY 2~');

  definir_get('catalogos/lotes', q'~
SELECT ilo.cod_lote                                AS cod_lote,
       ilo.num_lote                                AS num_lote,
       inu.nombre                                  AS insumo,
       TO_CHAR(ilo.fecha_vencimiento, 'DD/MM/YYYY') AS vencimiento,
       ilo.cantidad_disponible                     AS disponible,
       ume.nombre                                  AS unidad
FROM INVENTARIO_LOTE ilo, INSUMO inu, UNIDAD_MEDIDA ume
WHERE ilo.cod_centro = :centro
AND ilo.cantidad_disponible > 0
AND inu.cod_insumo = ilo.cod_insumo
AND ume.cod_unidad_medida = inu.cod_unidad_medida
ORDER BY ilo.num_lote~');

  -- Todos los lotes, incluso agotados o de otros centros, para poder enviar en
  -- la demostración un despacho que Oracle rechace (RN-08 y RN-12).
  definir_get('catalogos/lotes-todos', q'~
SELECT ilo.cod_lote                                AS cod_lote,
       ilo.num_lote                                AS num_lote,
       inu.nombre                                  AS insumo,
       TO_CHAR(ilo.fecha_vencimiento, 'DD/MM/YYYY') AS vencimiento,
       ilo.cantidad_disponible                     AS disponible,
       ume.nombre                                  AS unidad,
       ilo.cod_centro                              AS cod_centro,
       ins.nombre                                  AS centro
FROM INVENTARIO_LOTE ilo, INSUMO inu, UNIDAD_MEDIDA ume, INSTALACION ins
WHERE inu.cod_insumo = ilo.cod_insumo
AND ume.cod_unidad_medida = inu.cod_unidad_medida
AND ins.cod_instalacion = ilo.cod_centro
ORDER BY ilo.num_lote~');

  definir_get('catalogos/familias', q'~
SELECT fam.cod_familia AS cod_familia,
       (SELECT COUNT(*)
        FROM DAMNIFICADO dam
        WHERE dam.cod_familia = fam.cod_familia) AS num_integrantes,
       (SELECT LISTAGG(per.nombres || ' ' || per.apellidos, ', ') WITHIN GROUP (ORDER BY per.cod_persona)
        FROM DAMNIFICADO dam, PERSONA per
        WHERE dam.cod_familia = fam.cod_familia
        AND per.cod_persona = dam.cod_persona) AS integrantes,
       (SELECT ins.nombre
        FROM FAMILIA_ALBERGUE fal, INSTALACION ins
        WHERE fal.cod_familia = fam.cod_familia
        AND fal.fecha_salida IS NULL
        AND ins.cod_instalacion = fal.cod_albergue) AS albergue_actual
FROM FAMILIA fam
ORDER BY fam.cod_familia~');

  definir_get('catalogos/despachos-entregados', q'~
SELECT des.cod_despacho                         AS cod_despacho,
       ide.nombre                               AS destino,
       ica.nombre                               AS centro,
       TO_CHAR(des.fecha_entrega, 'DD/MM/YYYY') AS fecha_entrega
FROM DESPACHO des, INSTALACION ide, INSTALACION ica
WHERE ide.cod_instalacion = des.cod_destino
AND ica.cod_instalacion = des.cod_centro
AND des.estado = 'Entregado'
ORDER BY des.cod_despacho~');

  definir_get('catalogos/despachos/:id/insumos', q'~
SELECT inu.cod_insumo               AS cod_insumo,
       inu.nombre                   AS insumo,
       ume.nombre                   AS unidad,
       SUM(dlo.cantidad_despachada) AS cantidad_despachada,
       (SELECT NVL(SUM(ent.cantidad), 0)
        FROM ENTREGA ent
        WHERE ent.cod_despacho = dlo.cod_despacho
        AND ent.cod_insumo = inu.cod_insumo) AS cantidad_entregada
FROM DESPACHO_LOTE dlo, INVENTARIO_LOTE ilo, INSUMO inu, UNIDAD_MEDIDA ume
WHERE dlo.cod_despacho = :id
AND ilo.cod_lote = dlo.cod_lote
AND inu.cod_insumo = ilo.cod_insumo
AND ume.cod_unidad_medida = inu.cod_unidad_medida
GROUP BY dlo.cod_despacho, inu.cod_insumo, inu.nombre, ume.nombre
ORDER BY inu.nombre~');

  definir_get('catalogos/beneficiarios', q'~
SELECT dam.cod_persona                     AS cod_beneficiario,
       dam.codigo_censo                    AS codigo_censo,
       per.nombres || ' ' || per.apellidos AS nombre,
       per.num_documento                   AS documento
FROM DAMNIFICADO dam, PERSONA per, CENSO_DAMNIFICADO cda
WHERE per.cod_persona = dam.cod_persona
AND cda.cod_damnificado = dam.cod_persona
AND cda.estado = 'Activo'
ORDER BY 3~');

  definir_get('catalogos/personas', q'~
SELECT per.cod_persona                     AS cod_persona,
       per.nombres || ' ' || per.apellidos AS nombre,
       per.num_documento                   AS documento
FROM PERSONA per
ORDER BY 2~');

  definir_get('catalogos/necesidades', q'~
SELECT nda.cod_necesidad                       AS cod_necesidad,
       cne.nombre                              AS categoria,
       TO_CHAR(nda.fecha_inicio, 'DD/MM/YYYY') AS vigencia_desde,
       TO_CHAR(nda.fecha_fin, 'DD/MM/YYYY')    AS vigencia_hasta
FROM NECESIDAD_DAMNIFICADO nda, CATEGORIA_NECESIDAD cne, CATEGORIA_INSUMO cin
WHERE nda.cod_damnificado = :beneficiario
AND nda.estado = 'Validada'
AND SYSDATE BETWEEN nda.fecha_inicio AND nda.fecha_fin
AND cne.cod_categoria = nda.cod_categoria
AND cin.cod_categoria = nda.cod_categoria
AND cin.cod_insumo = :insumo
ORDER BY nda.cod_necesidad~');

  -- ==========================================================================
  -- Consultas del panel (misma lógica de ARCA_CONSULTA1.sql a ARCA_CONSULTA5.sql)
  -- ==========================================================================

  -- ARCA_CONSULTA1: trazabilidad de las entregas de un damnificado.
  definir_get('consultas/trazabilidad', q'~
SELECT ben.nombres || ' ' || ben.apellidos             AS beneficiario,
       ins.nombre                                      AS insumo,
       ent.cantidad                                    AS cantidad,
       TO_CHAR(ent.fecha_hora, 'DD/MM/YYYY HH24:MI')   AS fecha_entrega,
       rec.nombres || ' ' || rec.apellidos             AS recogio,
       ent.metodo_identificacion                       AS identificado_con,
       des.cod_despacho                                AS despacho,
       ica.nombre                                      AS centro_acopio,
       ilo.num_lote                                    AS lote,
       ide.nombre                                      AS destino
FROM DAMNIFICADO dam, PERSONA ben, ENTREGA ent, PERSONA rec, INSUMO ins,
     DESPACHO des, INSTALACION ica, INSTALACION ide, DESPACHO_LOTE dlo, INVENTARIO_LOTE ilo
WHERE dam.codigo_censo = :codigo_censo
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
ORDER BY ent.fecha_hora~');

  -- ARCA_CONSULTA2: ocupación de los albergues.
  definir_get('consultas/ocupacion', q'~
SELECT ocu.albergue                                     AS albergue,
       ocu.municipio                                    AS municipio,
       ocu.capacidad                                    AS capacidad,
       ocu.personas                                     AS personas_alojadas,
       ocu.capacidad - ocu.personas                     AS cupos_libres,
       ROUND(ocu.personas * 100 / ocu.capacidad, 1)     AS pct_ocupacion
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
ORDER BY 6 DESC, 1~');

  -- ARCA_CONSULTA3: prorrateo de un insumo entre las solicitudes registradas.
  definir_get('consultas/prorrateo', q'~
SELECT zon.nombre                                       AS zona,
       zon.poblacion_riesgo                             AS poblacion_riesgo,
       soi.cantidad_solicitada                          AS solicitado,
       (SELECT SUM(si2.cantidad_solicitada)
        FROM SOLICITUD so2, SOLICITUD_INSUMO si2
        WHERE si2.cod_solicitud = so2.cod_solicitud
        AND so2.estado = 'Registrada'
        AND si2.cod_insumo = soi.cod_insumo)            AS demanda_total,
       (SELECT SUM(ilo.cantidad_disponible)
        FROM INVENTARIO_LOTE ilo
        WHERE ilo.cod_insumo = soi.cod_insumo)          AS stock_total,
       ROUND((SELECT SUM(ilo.cantidad_disponible)
              FROM INVENTARIO_LOTE ilo
              WHERE ilo.cod_insumo = soi.cod_insumo)
             * zon.poblacion_riesgo
             / (SELECT SUM(zo2.poblacion_riesgo)
                FROM SOLICITUD so2, SOLICITUD_INSUMO si2, ZONA_AFECTADA zo2
                WHERE si2.cod_solicitud = so2.cod_solicitud
                AND zo2.cod_zona = so2.cod_zona
                AND so2.estado = 'Registrada'
                AND si2.cod_insumo = soi.cod_insumo), 2) AS asignacion_prorrateada
FROM SOLICITUD sol, SOLICITUD_INSUMO soi, ZONA_AFECTADA zon, INSUMO inu
WHERE soi.cod_solicitud = sol.cod_solicitud
AND zon.cod_zona = sol.cod_zona
AND inu.cod_insumo = soi.cod_insumo
AND sol.estado = 'Registrada'
AND inu.nombre = :insumo
ORDER BY 6 DESC~');

  -- ARCA_CONSULTA4: índice de atención de necesidades por zona.
  definir_get('consultas/indice-necesidades', q'~
SELECT ind.zona                                         AS zona,
       ind.nivel                                        AS nivel_dano,
       COUNT(*)                                         AS necesidades_validadas,
       SUM(ind.atendida)                                AS atendidas,
       COUNT(*) - SUM(ind.atendida)                     AS pendientes,
       ROUND(SUM(ind.atendida) * 100 / COUNT(*), 1)     AS indice
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
ORDER BY 6, 1~');

  -- ARCA_CONSULTA5: lotes con vencimiento en los próximos :dias días.
  definir_get('consultas/vencimientos', q'~
SELECT ica.nombre                                       AS centro_acopio,
       mun.nombre                                       AS municipio,
       inu.nombre                                       AS insumo,
       ilo.num_lote                                     AS lote,
       TO_CHAR(ilo.fecha_vencimiento, 'DD/MM/YYYY')     AS vence,
       TRUNC(ilo.fecha_vencimiento) - TRUNC(SYSDATE)    AS dias_restantes,
       ilo.cantidad_disponible                          AS disponible,
       ume.nombre                                       AS unidad
FROM INVENTARIO_LOTE ilo, INSTALACION ica, MUNICIPIO mun, INSUMO inu, UNIDAD_MEDIDA ume
WHERE ica.cod_instalacion = ilo.cod_centro
AND mun.cod_municipio = ica.cod_municipio
AND inu.cod_insumo = ilo.cod_insumo
AND ume.cod_unidad_medida = inu.cod_unidad_medida
AND ilo.fecha_vencimiento IS NOT NULL
AND ilo.cantidad_disponible > 0
AND ilo.fecha_vencimiento <= SYSDATE + TO_NUMBER(:dias)
ORDER BY ilo.fecha_vencimiento~');

  -- Manifestaciones recibidas, de la más reciente a la más antigua.
  definir_get('manifestaciones', q'~
SELECT man.cod_manifestacion                      AS cod_manifestacion,
       TO_CHAR(man.fecha_registro, 'DD/MM/YYYY')  AS fecha,
       per.nombres || ' ' || per.apellidos        AS damnificado,
       dam.codigo_censo                           AS codigo_censo,
       man.tipo                                   AS tipo,
       man.canal                                  AS canal,
       man.descripcion                            AS descripcion,
       man.estado                                 AS estado,
       man.respuesta                              AS respuesta
FROM MANIFESTACION man, DAMNIFICADO dam, PERSONA per
WHERE dam.cod_persona = man.cod_damnificado
AND per.cod_persona = dam.cod_persona
ORDER BY man.fecha_registro DESC, man.cod_manifestacion DESC~');

  -- ==========================================================================
  -- Quiosco del damnificado
  -- ==========================================================================

  -- Tipo elemento: si la persona no existe o no tiene censo activo, ORDS responde 404.
  definir_get('quiosco/persona', q'~
SELECT per.cod_persona  AS cod_persona,
       per.nombres      AS nombres,
       per.apellidos    AS apellidos,
       dam.codigo_censo AS codigo_censo,
       dam.cod_familia  AS cod_familia,
       (SELECT ins.nombre
        FROM FAMILIA_ALBERGUE fal, INSTALACION ins
        WHERE fal.cod_familia = dam.cod_familia
        AND fal.fecha_salida IS NULL
        AND ins.cod_instalacion = fal.cod_albergue) AS albergue_actual,
       zon.nombre       AS zona,
       mun.nombre       AS municipio
FROM PERSONA per, DAMNIFICADO dam, CENSO_DAMNIFICADO cda, CENSO cen, ZONA_AFECTADA zon, MUNICIPIO mun
WHERE per.cod_persona = dam.cod_persona
AND cda.cod_damnificado = dam.cod_persona
AND cda.estado = 'Activo'
AND cen.cod_censo = cda.cod_censo
AND zon.cod_zona = cen.cod_zona
AND mun.cod_municipio = zon.cod_municipio
AND (dam.codigo_censo = :codigo_censo OR per.num_documento = :documento)~',
    ORDS.source_type_collection_item);

  definir_get('quiosco/:codigo_censo/entregas', q'~
SELECT ent.cod_entrega                               AS cod_entrega,
       ins.nombre                                    AS insumo,
       ent.cantidad                                  AS cantidad,
       ume.nombre                                    AS unidad,
       TO_CHAR(ent.fecha_hora, 'DD/MM/YYYY HH24:MI') AS fecha,
       rec.nombres || ' ' || rec.apellidos           AS recogio,
       CASE WHEN rec.cod_persona = dam.cod_persona THEN 'S' ELSE 'N' END AS recogio_titular,
       ent.cod_despacho                              AS despacho,
       ide.nombre                                    AS lugar
FROM DAMNIFICADO dam, ENTREGA ent, PERSONA rec, INSUMO ins, UNIDAD_MEDIDA ume, DESPACHO des, INSTALACION ide
WHERE dam.codigo_censo = :codigo_censo
AND ent.cod_beneficiario = dam.cod_persona
AND rec.cod_persona = ent.cod_receptor
AND ins.cod_insumo = ent.cod_insumo
AND ume.cod_unidad_medida = ins.cod_unidad_medida
AND des.cod_despacho = ent.cod_despacho
AND ide.cod_instalacion = des.cod_destino
ORDER BY ent.fecha_hora DESC~');

  definir_get('quiosco/:codigo_censo/necesidades', q'~
SELECT nda.cod_necesidad                            AS cod_necesidad,
       cne.nombre                                   AS categoria,
       nda.estado                                   AS estado,
       TO_CHAR(nda.fecha_declaracion, 'DD/MM/YYYY') AS fecha_declaracion,
       TO_CHAR(nda.fecha_inicio, 'DD/MM/YYYY')      AS vigencia_desde,
       TO_CHAR(nda.fecha_fin, 'DD/MM/YYYY')         AS vigencia_hasta
FROM DAMNIFICADO dam, NECESIDAD_DAMNIFICADO nda, CATEGORIA_NECESIDAD cne
WHERE dam.codigo_censo = :codigo_censo
AND nda.cod_damnificado = dam.cod_persona
AND cne.cod_categoria = nda.cod_categoria
ORDER BY nda.fecha_declaracion DESC, nda.cod_necesidad~');

  definir_get('quiosco/:codigo_censo/manifestaciones', q'~
SELECT man.cod_manifestacion                      AS cod_manifestacion,
       TO_CHAR(man.fecha_registro, 'DD/MM/YYYY')  AS fecha,
       man.tipo                                   AS tipo,
       man.canal                                  AS canal,
       man.descripcion                            AS descripcion,
       man.estado                                 AS estado,
       man.respuesta                              AS respuesta,
       TO_CHAR(man.fecha_respuesta, 'DD/MM/YYYY') AS fecha_respuesta
FROM DAMNIFICADO dam, MANIFESTACION man
WHERE dam.codigo_censo = :codigo_censo
AND man.cod_damnificado = dam.cod_persona
ORDER BY man.fecha_registro DESC, man.cod_manifestacion DESC~');

  definir_post('quiosco/manifestaciones', q'~
DECLARE
  v_cod_damnificado  DAMNIFICADO.cod_persona%TYPE;
  v_cod              MANIFESTACION.cod_manifestacion%TYPE;
  v_json             JSON_OBJECT_T := JSON_OBJECT_T();
  v_sqlcode          NUMBER;
  v_mensaje          VARCHAR2(4000);
BEGIN
  SELECT dam.cod_persona INTO v_cod_damnificado
  FROM DAMNIFICADO dam
  WHERE dam.codigo_censo = :codigo_censo;

  SELECT NVL(MAX(man.cod_manifestacion), 0) + 1 INTO v_cod FROM MANIFESTACION man;

  INSERT INTO MANIFESTACION (cod_manifestacion, fecha_registro, tipo, canal, descripcion, estado,
                             respuesta, fecha_respuesta, cod_damnificado, cod_registrador)
  VALUES (v_cod, PKG_ARCA_API.hoy, :tipo, 'Quiosco', :descripcion, 'Abierta',
          NULL, NULL, v_cod_damnificado, NULL);
  COMMIT;

  v_json.put('ok', TRUE);
  v_json.put('cod_manifestacion', v_cod);
  PKG_ARCA_API.responder(v_json);
EXCEPTION
  WHEN OTHERS THEN
    v_sqlcode := SQLCODE;
    v_mensaje := SQLERRM;
    ROLLBACK;
    :status_code := 422;
    PKG_ARCA_API.responder_error(v_sqlcode, v_mensaje);
END;~');

  -- ==========================================================================
  -- Transparencia pública (solo vistas agregadas, sin datos personales)
  -- ==========================================================================

  definir_get('publico/zonas', q'~
SELECT vtz.zona                  AS zona,
       vtz.municipio             AS municipio,
       vtz.nivel_dano            AS nivel_dano,
       vtz.poblacion_riesgo      AS poblacion_riesgo,
       vtz.personas_censadas     AS personas_censadas,
       vtz.entregas_registradas  AS entregas_registradas,
       vtz.necesidades_validadas AS necesidades_validadas,
       vtz.necesidades_atendidas AS necesidades_atendidas
FROM V_TRANSPARENCIA_ZONA vtz
ORDER BY DECODE(vtz.nivel_dano, 'Crítico', 1, 'Alto', 2, 'Medio', 3, 'Bajo', 4, 5), vtz.zona~');

  definir_get('publico/albergues', q'~
SELECT vca.albergue                                                  AS albergue,
       vca.municipio                                                 AS municipio,
       vca.capacidad_maxima                                          AS capacidad_maxima,
       vca.personas_alojadas                                         AS personas_alojadas,
       vca.cupos_disponibles                                         AS cupos_disponibles,
       ROUND(vca.personas_alojadas * 100 / vca.capacidad_maxima, 1)  AS pct_ocupacion
FROM V_CUPOS_ALBERGUE vca
ORDER BY 6 DESC, 1~');

  -- ==========================================================================
  -- Operaciones que activan reglas de Oracle
  -- ==========================================================================

  -- Alojar familia: RN-03 (TRG_FAL_CAPACIDAD) y RN-13 (UX_FAL_ACTIVA).
  definir_post('operaciones/alojar', q'~
DECLARE
  v_cod_familia   FAMILIA_ALBERGUE.cod_familia%TYPE  := PKG_ARCA_API.numero(:cod_familia);
  v_cod_albergue  FAMILIA_ALBERGUE.cod_albergue%TYPE := PKG_ARCA_API.numero(:cod_albergue);
  v_personas      NUMBER;
  v_json          JSON_OBJECT_T := JSON_OBJECT_T();
  v_sqlcode       NUMBER;
  v_mensaje       VARCHAR2(4000);
BEGIN
  INSERT INTO FAMILIA_ALBERGUE (cod_familia, cod_albergue, fecha_ingreso, fecha_salida)
  VALUES (v_cod_familia, v_cod_albergue, PKG_ARCA_API.hoy, NULL);
  COMMIT;

  SELECT COUNT(*) INTO v_personas
  FROM FAMILIA_ALBERGUE fal, DAMNIFICADO dam
  WHERE fal.cod_albergue = v_cod_albergue
  AND fal.fecha_salida IS NULL
  AND dam.cod_familia = fal.cod_familia;

  v_json.put('ok', TRUE);
  v_json.put('cod_familia', v_cod_familia);
  v_json.put('cod_albergue', v_cod_albergue);
  v_json.put('fecha_ingreso', TO_CHAR(PKG_ARCA_API.hoy, 'DD/MM/YYYY'));
  v_json.put('personas_alojadas', v_personas);
  PKG_ARCA_API.responder(v_json);
EXCEPTION
  WHEN OTHERS THEN
    v_sqlcode := SQLCODE;
    v_mensaje := SQLERRM;
    ROLLBACK;
    :status_code := 422;
    PKG_ARCA_API.responder_error(v_sqlcode, v_mensaje);
END;~');

  -- Ingresar lote: RN-05 (C_ILO_VENC_CK), C_ILO_ORIG_CK y C_ILO_CREC_CK.
  definir_post('operaciones/ingresar-lote', q'~
DECLARE
  v_cod       INVENTARIO_LOTE.cod_lote%TYPE;
  v_cantidad  INVENTARIO_LOTE.cantidad_recibida%TYPE := PKG_ARCA_API.numero(:cantidad);
  v_json      JSON_OBJECT_T := JSON_OBJECT_T();
  v_sqlcode   NUMBER;
  v_mensaje   VARCHAR2(4000);
BEGIN
  SELECT NVL(MAX(ilo.cod_lote), 0) + 1 INTO v_cod FROM INVENTARIO_LOTE ilo;

  INSERT INTO INVENTARIO_LOTE (cod_lote, num_lote, origen, fecha_recepcion, fecha_vencimiento,
                               cantidad_recibida, cantidad_disponible, cod_insumo, cod_centro)
  VALUES (v_cod, :num_lote, :origen,
          TO_DATE(:fecha_recepcion, 'DD/MM/YYYY'), TO_DATE(:fecha_vencimiento, 'DD/MM/YYYY'),
          v_cantidad, v_cantidad, PKG_ARCA_API.numero(:cod_insumo), PKG_ARCA_API.numero(:cod_centro));
  COMMIT;

  v_json.put('ok', TRUE);
  v_json.put('cod_lote', v_cod);
  PKG_ARCA_API.responder(v_json);
EXCEPTION
  WHEN OTHERS THEN
    v_sqlcode := SQLCODE;
    v_mensaje := SQLERRM;
    ROLLBACK;
    :status_code := 422;
    PKG_ARCA_API.responder_error(v_sqlcode, v_mensaje);
END;~');

  -- Despachar lote: RN-08 y RN-12 (TRG_DLO_DESCUENTO). El despacho y su lote van
  -- en una sola transacción: si el disparador rechaza el lote, el ROLLBACK
  -- deshace también el despacho.
  definir_post('operaciones/despachar', q'~
DECLARE
  v_cod         DESPACHO.cod_despacho%TYPE;
  v_cod_lote    INVENTARIO_LOTE.cod_lote%TYPE := PKG_ARCA_API.numero(:cod_lote);
  v_disponible  INVENTARIO_LOTE.cantidad_disponible%TYPE;
  v_json        JSON_OBJECT_T := JSON_OBJECT_T();
  v_sqlcode     NUMBER;
  v_mensaje     VARCHAR2(4000);
BEGIN
  SELECT NVL(MAX(des.cod_despacho), 0) + 1 INTO v_cod FROM DESPACHO des;

  INSERT INTO DESPACHO (cod_despacho, fecha_emision, estado, placa_vehiculo, fecha_entrega, nombre_receptor,
                        confirmacion_recibido, cod_centro, cod_solicitud, cod_destino, cod_conductor)
  VALUES (v_cod, PKG_ARCA_API.hoy, 'Pendiente', UPPER(:placa), NULL, NULL,
          'N', PKG_ARCA_API.numero(:cod_centro), PKG_ARCA_API.numero(:cod_solicitud),
          PKG_ARCA_API.numero(:cod_destino), PKG_ARCA_API.numero(:cod_conductor));

  INSERT INTO DESPACHO_LOTE (cod_despacho, cod_lote, cantidad_despachada)
  VALUES (v_cod, v_cod_lote, PKG_ARCA_API.numero(:cantidad));
  COMMIT;

  SELECT ilo.cantidad_disponible INTO v_disponible
  FROM INVENTARIO_LOTE ilo
  WHERE ilo.cod_lote = v_cod_lote;

  v_json.put('ok', TRUE);
  v_json.put('cod_despacho', v_cod);
  v_json.put('cod_lote', v_cod_lote);
  v_json.put('disponible_lote', v_disponible);
  PKG_ARCA_API.responder(v_json);
EXCEPTION
  WHEN OTHERS THEN
    v_sqlcode := SQLCODE;
    v_mensaje := SQLERRM;
    ROLLBACK;
    :status_code := 422;
    PKG_ARCA_API.responder_error(v_sqlcode, v_mensaje);
END;~');

  -- Registrar entrega: C_ENT_MET_CK, C_ENT_CANT_CK y llaves foráneas.
  definir_post('operaciones/entregar', q'~
DECLARE
  v_cod      ENTREGA.cod_entrega%TYPE;
  v_json     JSON_OBJECT_T := JSON_OBJECT_T();
  v_sqlcode  NUMBER;
  v_mensaje  VARCHAR2(4000);
BEGIN
  SELECT NVL(MAX(ent.cod_entrega), 0) + 1 INTO v_cod FROM ENTREGA ent;

  INSERT INTO ENTREGA (cod_entrega, fecha_hora, cantidad, metodo_identificacion, cod_despacho,
                       cod_insumo, cod_beneficiario, cod_receptor, cod_necesidad)
  VALUES (v_cod, PKG_ARCA_API.ahora, PKG_ARCA_API.numero(:cantidad), :metodo_identificacion,
          PKG_ARCA_API.numero(:cod_despacho), PKG_ARCA_API.numero(:cod_insumo),
          PKG_ARCA_API.numero(:cod_beneficiario), PKG_ARCA_API.numero(:cod_receptor),
          PKG_ARCA_API.numero(:cod_necesidad));
  COMMIT;

  v_json.put('ok', TRUE);
  v_json.put('cod_entrega', v_cod);
  PKG_ARCA_API.responder(v_json);
EXCEPTION
  WHEN OTHERS THEN
    v_sqlcode := SQLCODE;
    v_mensaje := SQLERRM;
    ROLLBACK;
    :status_code := 422;
    PKG_ARCA_API.responder_error(v_sqlcode, v_mensaje);
END;~');

  -- ==========================================================================
  -- Administración
  -- ==========================================================================

  definir_post('admin/restablecer', q'~
DECLARE
  v_json     JSON_OBJECT_T := JSON_OBJECT_T();
  v_sqlcode  NUMBER;
  v_mensaje  VARCHAR2(4000);
BEGIN
  P_RESTABLECER_DEMO;
  v_json.put('ok', TRUE);
  v_json.put('mensaje', 'Datos de la demostración restablecidos.');
  PKG_ARCA_API.responder(v_json);
EXCEPTION
  WHEN OTHERS THEN
    v_sqlcode := SQLCODE;
    v_mensaje := SQLERRM;
    ROLLBACK;
    :status_code := 422;
    PKG_ARCA_API.responder_error(v_sqlcode, v_mensaje);
END;~');

  COMMIT;
END;
/


-- ============================================================================
-- Seguridad: rol y privilegio que protegen todo el módulo "arca"
-- ============================================================================

-- Sin un token OAuth2 válido, ORDS responde 401 a cualquier ruta del módulo.
DECLARE
  l_roles    OWA.VC_ARR;
  l_patrones OWA.VC_ARR;
  l_modulos  OWA.VC_ARR;
BEGIN
  BEGIN
    ORDS.CREATE_ROLE(p_role_name => 'arca_api_rol');
  EXCEPTION
    WHEN OTHERS THEN
      NULL; -- el rol ya existe (el script se está ejecutando de nuevo)
  END;

  l_roles(1)   := 'arca_api_rol';
  l_modulos(1) := 'arca';

  ORDS.DEFINE_PRIVILEGE(p_privilege_name => 'arca.api',
                        p_roles          => l_roles,
                        p_patterns       => l_patrones,
                        p_modules        => l_modulos,
                        p_label          => 'API ARCA',
                        p_description    => 'Acceso a la API REST de ARCA para la aplicación web.');
  COMMIT;
END;
/


-- ============================================================================
-- Cliente OAuth2 de tipo client credentials para el servidor Next.js
-- ============================================================================

-- Usa ORDS_SECURITY (ORDS 23.3 o superior; el paquete OAUTH quedó sin soporte en
-- ORDS 25.3). Con p_client_secret => NULL, ORDS genera el secreto, que solo se
-- puede ver en este momento: copiar las dos líneas que imprime DBMS_OUTPUT.
-- Si el cliente ya existía, se borra y se crea uno nuevo con credenciales nuevas.
-- APEX muestra la salida de DBMS_OUTPUT en el resultado del script; en SQLcl o
-- SQL Developer, activar antes SET SERVEROUTPUT ON.
DECLARE
  l_credenciales ORDS_TYPES.T_CLIENT_CREDENTIALS;
BEGIN
  BEGIN
    ORDS_SECURITY.DELETE_CLIENT(p_name => 'arca_web');
  EXCEPTION
    WHEN OTHERS THEN
      NULL; -- no existía
  END;

  l_credenciales := ORDS_SECURITY.REGISTER_CLIENT(
    p_name            => 'arca_web',
    p_grant_type      => 'client_credentials',
    p_description     => 'Servidor de la aplicación web ARCA (demostración).',
    p_client_secret   => NULL,
    p_support_email   => 'arca@example.org',
    p_privilege_names => 'arca.api');

  ORDS_SECURITY.GRANT_CLIENT_ROLE(p_client_name => 'arca_web',
                                  p_role_name   => 'arca_api_rol');
  COMMIT;

  DBMS_OUTPUT.PUT_LINE('Copiar a .env.local y a las variables de entorno de Vercel:');
  DBMS_OUTPUT.PUT_LINE('ORDS_CLIENT_ID=' || l_credenciales.client_key.client_id);
  DBMS_OUTPUT.PUT_LINE('ORDS_CLIENT_SECRET=' || l_credenciales.client_secret.secret);
END;
/

-- ----------------------------------------------------------------------------
-- Alternativa solo para ORDS anterior a 23.3 (si ORDS_SECURITY no existe).
-- Quitar los comentarios y ejecutar este bloque en lugar del anterior.
-- ----------------------------------------------------------------------------
-- DECLARE
--   l_id      USER_ORDS_CLIENTS.client_id%TYPE;
--   l_secreto USER_ORDS_CLIENTS.client_secret%TYPE;
-- BEGIN
--   OAUTH.CREATE_CLIENT(p_name            => 'arca_web',
--                       p_grant_type      => 'client_credentials',
--                       p_owner           => 'ARCA',
--                       p_description     => 'Servidor de la aplicación web ARCA (demostración).',
--                       p_support_email   => 'arca@example.org',
--                       p_privilege_names => 'arca.api');
--   OAUTH.GRANT_CLIENT_ROLE(p_client_name => 'arca_web', p_role_name => 'arca_api_rol');
--   COMMIT;
--   SELECT client_id, client_secret INTO l_id, l_secreto
--   FROM USER_ORDS_CLIENTS
--   WHERE name = 'arca_web';
--   DBMS_OUTPUT.PUT_LINE('ORDS_CLIENT_ID=' || l_id);
--   DBMS_OUTPUT.PUT_LINE('ORDS_CLIENT_SECRET=' || l_secreto);
-- END;
-- /
