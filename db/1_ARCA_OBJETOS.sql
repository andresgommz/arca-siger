-- ============================================================================
-- Script 1 de 3: creación de objetos
-- ============================================================================

-- ============================================================================
-- Creación tabla de DEPARTAMENTO
-- ============================================================================

CREATE TABLE DEPARTAMENTO
( cod_departamento  VARCHAR2(2)     NOT NULL,
  nombre            VARCHAR2(100)   NOT NULL
);

COMMENT ON TABLE DEPARTAMENTO IS 'Departamentos de Colombia (división político-administrativa de primer nivel).';
COMMENT ON COLUMN DEPARTAMENTO.cod_departamento IS 'Código DANE del departamento.';
COMMENT ON COLUMN DEPARTAMENTO.nombre IS 'Nombre del departamento.';

ALTER TABLE DEPARTAMENTO ADD CONSTRAINT C_DEP_PK PRIMARY KEY (cod_departamento);


-- ============================================================================
-- Creación tabla de MUNICIPIO
-- ============================================================================

CREATE TABLE MUNICIPIO
( cod_municipio     VARCHAR2(5)     NOT NULL,
  nombre            VARCHAR2(100)   NOT NULL,
  cod_departamento  VARCHAR2(2)     NOT NULL
);

COMMENT ON TABLE MUNICIPIO IS 'Municipios de Colombia y el departamento al que pertenece cada uno.';
COMMENT ON COLUMN MUNICIPIO.cod_municipio IS 'Código DANE del municipio.';
COMMENT ON COLUMN MUNICIPIO.nombre IS 'Nombre del municipio.';
COMMENT ON COLUMN MUNICIPIO.cod_departamento IS 'FK a DEPARTAMENTO. Departamento al que pertenece el municipio.';

ALTER TABLE MUNICIPIO ADD CONSTRAINT C_MUN_PK PRIMARY KEY (cod_municipio);
ALTER TABLE MUNICIPIO ADD CONSTRAINT C_MUN_DEP_FK FOREIGN KEY (cod_departamento) REFERENCES DEPARTAMENTO (cod_departamento);


-- ============================================================================
-- Creación tabla de ZONA_AFECTADA
-- ============================================================================

CREATE TABLE ZONA_AFECTADA
( cod_zona                          NUMBER(10)      NOT NULL,
  nombre                            VARCHAR2(100)   NOT NULL,
  tipo_division                     VARCHAR2(15)    NOT NULL,
  nivel_dano                        VARCHAR2(15)    NOT NULL,
  poblacion_riesgo                  NUMBER(8)       NOT NULL,
  pct_infraestructura_comprometida  NUMBER(5,2)     NOT NULL,
  falla_agua                        CHAR(1)         NOT NULL,
  falla_energia                     CHAR(1)         NOT NULL,
  cod_municipio                     VARCHAR2(5)     NOT NULL
);

COMMENT ON TABLE ZONA_AFECTADA IS 'Zonas afectadas por la emergencia, su nivel de daño y el estado de sus servicios.';
COMMENT ON COLUMN ZONA_AFECTADA.cod_zona IS 'Código de la zona afectada.';
COMMENT ON COLUMN ZONA_AFECTADA.nombre IS 'Nombre de la zona afectada.';
COMMENT ON COLUMN ZONA_AFECTADA.tipo_division IS 'Tipo de división territorial: Municipio, Comuna, Vereda.';
COMMENT ON COLUMN ZONA_AFECTADA.nivel_dano IS 'Nivel de daño: Bajo, Medio, Alto, Crítico.';
COMMENT ON COLUMN ZONA_AFECTADA.poblacion_riesgo IS 'Número de personas en riesgo en la zona.';
COMMENT ON COLUMN ZONA_AFECTADA.pct_infraestructura_comprometida IS 'Porcentaje de infraestructura comprometida (0 a 100).';
COMMENT ON COLUMN ZONA_AFECTADA.falla_agua IS 'Falla en el servicio de agua: S, N.';
COMMENT ON COLUMN ZONA_AFECTADA.falla_energia IS 'Falla en el servicio de energía: S, N.';
COMMENT ON COLUMN ZONA_AFECTADA.cod_municipio IS 'FK a MUNICIPIO. Municipio donde está la zona.';

ALTER TABLE ZONA_AFECTADA ADD CONSTRAINT C_ZON_PK PRIMARY KEY (cod_zona);
ALTER TABLE ZONA_AFECTADA ADD CONSTRAINT C_ZON_MUN_FK FOREIGN KEY (cod_municipio) REFERENCES MUNICIPIO (cod_municipio);
ALTER TABLE ZONA_AFECTADA ADD CONSTRAINT C_ZON_TDIV_CK CHECK (tipo_division IN ('Municipio','Comuna','Vereda'));
ALTER TABLE ZONA_AFECTADA ADD CONSTRAINT C_ZON_NIVEL_CK CHECK (nivel_dano IN ('Bajo','Medio','Alto','Crítico'));
ALTER TABLE ZONA_AFECTADA ADD CONSTRAINT C_ZON_POB_CK CHECK (poblacion_riesgo >= 0);
ALTER TABLE ZONA_AFECTADA ADD CONSTRAINT C_ZON_PCT_CK CHECK (pct_infraestructura_comprometida BETWEEN 0 AND 100);
ALTER TABLE ZONA_AFECTADA ADD CONSTRAINT C_ZON_AGUA_CK CHECK (falla_agua IN ('S','N'));
ALTER TABLE ZONA_AFECTADA ADD CONSTRAINT C_ZON_ENER_CK CHECK (falla_energia IN ('S','N'));
ALTER TABLE ZONA_AFECTADA ADD CONSTRAINT C_ZON_CRIT_CK CHECK (nivel_dano <> 'Crítico' OR pct_infraestructura_comprometida > 40 OR (falla_agua = 'S' AND falla_energia = 'S'));


-- ============================================================================
-- Creación tabla de TIPO_DOCUMENTO
-- ============================================================================

CREATE TABLE TIPO_DOCUMENTO
( cod_tipo_documento  VARCHAR2(2)     NOT NULL,
  nombre              VARCHAR2(100)   NOT NULL
);

COMMENT ON TABLE TIPO_DOCUMENTO IS 'Catálogo de tipos de documento de identidad.';
COMMENT ON COLUMN TIPO_DOCUMENTO.cod_tipo_documento IS 'Código del tipo de documento.';
COMMENT ON COLUMN TIPO_DOCUMENTO.nombre IS 'Nombre del tipo de documento.';

ALTER TABLE TIPO_DOCUMENTO ADD CONSTRAINT C_TDO_PK PRIMARY KEY (cod_tipo_documento);


-- ============================================================================
-- Creación tabla de PERSONA
-- ============================================================================

CREATE TABLE PERSONA
( cod_persona         NUMBER(10)      NOT NULL,
  num_documento       VARCHAR2(15),
  nombres             VARCHAR2(60)    NOT NULL,
  apellidos           VARCHAR2(60)    NOT NULL,
  fecha_nacimiento    DATE            NOT NULL,
  cod_tipo_documento  VARCHAR2(2)     NOT NULL
);

COMMENT ON TABLE PERSONA IS 'Supertipo: datos personales de damnificados y personal de socorro.';
COMMENT ON COLUMN PERSONA.cod_persona IS 'Código interno de la persona.';
COMMENT ON COLUMN PERSONA.num_documento IS 'Número del documento de identidad. Único y opcional.';
COMMENT ON COLUMN PERSONA.nombres IS 'Nombres de la persona.';
COMMENT ON COLUMN PERSONA.apellidos IS 'Apellidos de la persona.';
COMMENT ON COLUMN PERSONA.fecha_nacimiento IS 'Fecha de nacimiento; de ella se obtiene la edad.';
COMMENT ON COLUMN PERSONA.cod_tipo_documento IS 'FK a TIPO_DOCUMENTO. Tipo de documento de la persona.';

ALTER TABLE PERSONA ADD CONSTRAINT C_PER_PK PRIMARY KEY (cod_persona);
ALTER TABLE PERSONA ADD CONSTRAINT C_PER_TDO_FK FOREIGN KEY (cod_tipo_documento) REFERENCES TIPO_DOCUMENTO (cod_tipo_documento);
ALTER TABLE PERSONA ADD CONSTRAINT C_PER_DOC_UK UNIQUE (num_documento);


-- ============================================================================
-- Creación tabla de INSTITUCION
-- ============================================================================

CREATE TABLE INSTITUCION
( cod_institucion  NUMBER(10)      NOT NULL,
  nombre           VARCHAR2(100)   NOT NULL
);

COMMENT ON TABLE INSTITUCION IS 'Instituciones a las que pertenece el personal de socorro.';
COMMENT ON COLUMN INSTITUCION.cod_institucion IS 'Código de la institución.';
COMMENT ON COLUMN INSTITUCION.nombre IS 'Nombre de la institución.';

ALTER TABLE INSTITUCION ADD CONSTRAINT C_ITU_PK PRIMARY KEY (cod_institucion);


-- ============================================================================
-- Creación tabla de ESPECIALIDAD
-- ============================================================================

CREATE TABLE ESPECIALIDAD
( cod_especialidad  NUMBER(10)      NOT NULL,
  nombre            VARCHAR2(100)   NOT NULL,
  tipo              VARCHAR2(15)    NOT NULL
);

COMMENT ON TABLE ESPECIALIDAD IS 'Especialidades médicas o técnicas del personal de socorro.';
COMMENT ON COLUMN ESPECIALIDAD.cod_especialidad IS 'Código de la especialidad.';
COMMENT ON COLUMN ESPECIALIDAD.nombre IS 'Nombre de la especialidad.';
COMMENT ON COLUMN ESPECIALIDAD.tipo IS 'Tipo de especialidad: Médica, Técnica.';

ALTER TABLE ESPECIALIDAD ADD CONSTRAINT C_ESP_PK PRIMARY KEY (cod_especialidad);
ALTER TABLE ESPECIALIDAD ADD CONSTRAINT C_ESP_TIPO_CK CHECK (tipo IN ('Médica','Técnica'));


-- ============================================================================
-- Creación tabla de PERSONAL_SOCORRO
-- ============================================================================

CREATE TABLE PERSONAL_SOCORRO
( cod_persona       NUMBER(10)      NOT NULL,
  tipo_personal     VARCHAR2(15)    NOT NULL,
  disponibilidad    VARCHAR2(15)    NOT NULL,
  cod_institucion   NUMBER(10)      NOT NULL,
  cod_especialidad  NUMBER(10)
);

COMMENT ON TABLE PERSONAL_SOCORRO IS 'Subtipo de PERSONA: personal de socorro, su institución, especialidad y disponibilidad.';
COMMENT ON COLUMN PERSONAL_SOCORRO.cod_persona IS 'PK y FK a PERSONA. Código heredado de la persona.';
COMMENT ON COLUMN PERSONAL_SOCORRO.tipo_personal IS 'Tipo: Rescatista, Brigadista, Voluntario, Conductor, Coordinador.';
COMMENT ON COLUMN PERSONAL_SOCORRO.disponibilidad IS 'Disponibilidad: Disponible, Asignado, Descanso, Inactivo.';
COMMENT ON COLUMN PERSONAL_SOCORRO.cod_institucion IS 'FK a INSTITUCION. Institución a la que pertenece.';
COMMENT ON COLUMN PERSONAL_SOCORRO.cod_especialidad IS 'FK a ESPECIALIDAD. Especialidad de la persona. Opcional.';

ALTER TABLE PERSONAL_SOCORRO ADD CONSTRAINT C_PSO_PK PRIMARY KEY (cod_persona);
ALTER TABLE PERSONAL_SOCORRO ADD CONSTRAINT C_PSO_PER_FK FOREIGN KEY (cod_persona) REFERENCES PERSONA (cod_persona);
ALTER TABLE PERSONAL_SOCORRO ADD CONSTRAINT C_PSO_ITU_FK FOREIGN KEY (cod_institucion) REFERENCES INSTITUCION (cod_institucion);
ALTER TABLE PERSONAL_SOCORRO ADD CONSTRAINT C_PSO_ESP_FK FOREIGN KEY (cod_especialidad) REFERENCES ESPECIALIDAD (cod_especialidad);
ALTER TABLE PERSONAL_SOCORRO ADD CONSTRAINT C_PSO_TIPO_CK CHECK (tipo_personal IN ('Rescatista','Brigadista','Voluntario','Conductor','Coordinador'));
ALTER TABLE PERSONAL_SOCORRO ADD CONSTRAINT C_PSO_DISP_CK CHECK (disponibilidad IN ('Disponible','Asignado','Descanso','Inactivo'));


-- ============================================================================
-- Creación tabla de FAMILIA
-- ============================================================================

CREATE TABLE FAMILIA
( cod_familia  NUMBER(10)      NOT NULL
);

COMMENT ON TABLE FAMILIA IS 'Grupos familiares de damnificados.';
COMMENT ON COLUMN FAMILIA.cod_familia IS 'Código de la familia.';

ALTER TABLE FAMILIA ADD CONSTRAINT C_FAM_PK PRIMARY KEY (cod_familia);


-- ============================================================================
-- Creación tabla de DAMNIFICADO
-- ============================================================================

CREATE TABLE DAMNIFICADO
( cod_persona   NUMBER(10)      NOT NULL,
  codigo_censo  VARCHAR2(10)    NOT NULL,
  cod_familia   NUMBER(10)      NOT NULL
);

COMMENT ON TABLE DAMNIFICADO IS 'Subtipo de PERSONA: personas damnificadas y la familia a la que pertenecen.';
COMMENT ON COLUMN DAMNIFICADO.cod_persona IS 'PK y FK a PERSONA. Código heredado de la persona.';
COMMENT ON COLUMN DAMNIFICADO.codigo_censo IS 'Código único que la persona memoriza para identificarse.';
COMMENT ON COLUMN DAMNIFICADO.cod_familia IS 'FK a FAMILIA. Familia a la que pertenece el damnificado.';

ALTER TABLE DAMNIFICADO ADD CONSTRAINT C_DAM_PK PRIMARY KEY (cod_persona);
ALTER TABLE DAMNIFICADO ADD CONSTRAINT C_DAM_PER_FK FOREIGN KEY (cod_persona) REFERENCES PERSONA (cod_persona);
ALTER TABLE DAMNIFICADO ADD CONSTRAINT C_DAM_FAM_FK FOREIGN KEY (cod_familia) REFERENCES FAMILIA (cod_familia);
ALTER TABLE DAMNIFICADO ADD CONSTRAINT C_DAM_CCEN_UK UNIQUE (codigo_censo);


-- ============================================================================
-- Creación tabla de INSTALACION
-- ============================================================================

CREATE TABLE INSTALACION
( cod_instalacion  NUMBER(10)      NOT NULL,
  nombre           VARCHAR2(100)   NOT NULL,
  direccion        VARCHAR2(150)   NOT NULL,
  cod_municipio    VARCHAR2(5)     NOT NULL,
  cod_coordinador  NUMBER(10)      NOT NULL
);

COMMENT ON TABLE INSTALACION IS 'Supertipo: instalaciones de la emergencia (albergues, centros de acopio y puntos de entrega).';
COMMENT ON COLUMN INSTALACION.cod_instalacion IS 'Código de la instalación.';
COMMENT ON COLUMN INSTALACION.nombre IS 'Nombre de la instalación.';
COMMENT ON COLUMN INSTALACION.direccion IS 'Dirección de la instalación.';
COMMENT ON COLUMN INSTALACION.cod_municipio IS 'FK a MUNICIPIO. Municipio donde está la instalación.';
COMMENT ON COLUMN INSTALACION.cod_coordinador IS 'FK a PERSONAL_SOCORRO. Coordinador a cargo.';

ALTER TABLE INSTALACION ADD CONSTRAINT C_INS_PK PRIMARY KEY (cod_instalacion);
ALTER TABLE INSTALACION ADD CONSTRAINT C_INS_MUN_FK FOREIGN KEY (cod_municipio) REFERENCES MUNICIPIO (cod_municipio);
ALTER TABLE INSTALACION ADD CONSTRAINT C_INS_PSO_FK FOREIGN KEY (cod_coordinador) REFERENCES PERSONAL_SOCORRO (cod_persona);


-- ============================================================================
-- Creación tabla de ALBERGUE
-- ============================================================================

CREATE TABLE ALBERGUE
( cod_instalacion   NUMBER(10)      NOT NULL,
  capacidad_maxima  NUMBER(5)       NOT NULL
);

COMMENT ON TABLE ALBERGUE IS 'Subtipo de INSTALACION: albergues y su capacidad máxima.';
COMMENT ON COLUMN ALBERGUE.cod_instalacion IS 'PK y FK a INSTALACION. Código heredado.';
COMMENT ON COLUMN ALBERGUE.capacidad_maxima IS 'Capacidad máxima del albergue, en personas.';

ALTER TABLE ALBERGUE ADD CONSTRAINT C_ALB_PK PRIMARY KEY (cod_instalacion);
ALTER TABLE ALBERGUE ADD CONSTRAINT C_ALB_INS_FK FOREIGN KEY (cod_instalacion) REFERENCES INSTALACION (cod_instalacion);
ALTER TABLE ALBERGUE ADD CONSTRAINT C_ALB_CAP_CK CHECK (capacidad_maxima > 0);


-- ============================================================================
-- Creación tabla de CENTRO_ACOPIO
-- ============================================================================

CREATE TABLE CENTRO_ACOPIO
( cod_instalacion  NUMBER(10)      NOT NULL
);

COMMENT ON TABLE CENTRO_ACOPIO IS 'Subtipo de INSTALACION: centros de acopio de insumos.';
COMMENT ON COLUMN CENTRO_ACOPIO.cod_instalacion IS 'PK y FK a INSTALACION. Código heredado.';

ALTER TABLE CENTRO_ACOPIO ADD CONSTRAINT C_CAC_PK PRIMARY KEY (cod_instalacion);
ALTER TABLE CENTRO_ACOPIO ADD CONSTRAINT C_CAC_INS_FK FOREIGN KEY (cod_instalacion) REFERENCES INSTALACION (cod_instalacion);


-- ============================================================================
-- Creación tabla de PUNTO_ENTREGA
-- ============================================================================

CREATE TABLE PUNTO_ENTREGA
( cod_instalacion  NUMBER(10)      NOT NULL,
  cod_zona         NUMBER(10)      NOT NULL
);

COMMENT ON TABLE PUNTO_ENTREGA IS 'Subtipo de INSTALACION: puntos de entrega en zona y la zona que atienden.';
COMMENT ON COLUMN PUNTO_ENTREGA.cod_instalacion IS 'PK y FK a INSTALACION. Código heredado.';
COMMENT ON COLUMN PUNTO_ENTREGA.cod_zona IS 'FK a ZONA_AFECTADA. Zona que atiende el punto.';

ALTER TABLE PUNTO_ENTREGA ADD CONSTRAINT C_PEN_PK PRIMARY KEY (cod_instalacion);
ALTER TABLE PUNTO_ENTREGA ADD CONSTRAINT C_PEN_INS_FK FOREIGN KEY (cod_instalacion) REFERENCES INSTALACION (cod_instalacion);
ALTER TABLE PUNTO_ENTREGA ADD CONSTRAINT C_PEN_ZON_FK FOREIGN KEY (cod_zona) REFERENCES ZONA_AFECTADA (cod_zona);


-- ============================================================================
-- Creación tabla de CENSO
-- ============================================================================

CREATE TABLE CENSO
( cod_censo     NUMBER(10)      NOT NULL,
  fecha_censo   DATE            NOT NULL,
  cod_zona      NUMBER(10)      NOT NULL,
  cod_albergue  NUMBER(10)
);

COMMENT ON TABLE CENSO IS 'Censos de damnificados hechos en una zona afectada o en un albergue.';
COMMENT ON COLUMN CENSO.cod_censo IS 'Código del censo.';
COMMENT ON COLUMN CENSO.fecha_censo IS 'Fecha en que se hizo el censo.';
COMMENT ON COLUMN CENSO.cod_zona IS 'FK a ZONA_AFECTADA. Zona del censo.';
COMMENT ON COLUMN CENSO.cod_albergue IS 'FK a ALBERGUE. Albergue del censo. Opcional (censo en terreno).';

ALTER TABLE CENSO ADD CONSTRAINT C_CEN_PK PRIMARY KEY (cod_censo);
ALTER TABLE CENSO ADD CONSTRAINT C_CEN_ZON_FK FOREIGN KEY (cod_zona) REFERENCES ZONA_AFECTADA (cod_zona);
ALTER TABLE CENSO ADD CONSTRAINT C_CEN_ALB_FK FOREIGN KEY (cod_albergue) REFERENCES ALBERGUE (cod_instalacion);


-- ============================================================================
-- Creación tabla de CENSO_DAMNIFICADO
-- ============================================================================

CREATE TABLE CENSO_DAMNIFICADO
( cod_censo        NUMBER(10)      NOT NULL,
  cod_damnificado  NUMBER(10)      NOT NULL,
  fecha_registro   DATE            NOT NULL,
  estado           VARCHAR2(20)    NOT NULL
);

COMMENT ON TABLE CENSO_DAMNIFICADO IS 'Damnificados inscritos en cada censo (relación N:M registra).';
COMMENT ON COLUMN CENSO_DAMNIFICADO.cod_censo IS 'PK y FK a CENSO.';
COMMENT ON COLUMN CENSO_DAMNIFICADO.cod_damnificado IS 'PK y FK a DAMNIFICADO.';
COMMENT ON COLUMN CENSO_DAMNIFICADO.fecha_registro IS 'Fecha en que se registró al damnificado en el censo.';
COMMENT ON COLUMN CENSO_DAMNIFICADO.estado IS 'Estado del registro: Activo, Inactivo.';

ALTER TABLE CENSO_DAMNIFICADO ADD CONSTRAINT C_CDA_PK PRIMARY KEY (cod_censo, cod_damnificado);
ALTER TABLE CENSO_DAMNIFICADO ADD CONSTRAINT C_CDA_CEN_FK FOREIGN KEY (cod_censo) REFERENCES CENSO (cod_censo);
ALTER TABLE CENSO_DAMNIFICADO ADD CONSTRAINT C_CDA_DAM_FK FOREIGN KEY (cod_damnificado) REFERENCES DAMNIFICADO (cod_persona);
ALTER TABLE CENSO_DAMNIFICADO ADD CONSTRAINT C_CDA_EST_CK CHECK (estado IN ('Activo','Inactivo'));

-- RN-04: una persona solo puede tener un registro Activo en los censos.
CREATE UNIQUE INDEX UX_CDA_ACTIVO ON CENSO_DAMNIFICADO
  (CASE WHEN estado = 'Activo' THEN cod_damnificado END);


-- ============================================================================
-- Creación tabla de FAMILIA_ALBERGUE
-- ============================================================================

CREATE TABLE FAMILIA_ALBERGUE
( cod_familia    NUMBER(10)      NOT NULL,
  cod_albergue   NUMBER(10)      NOT NULL,
  fecha_ingreso  DATE            NOT NULL,
  fecha_salida   DATE
);

COMMENT ON TABLE FAMILIA_ALBERGUE IS 'Estancias de cada familia en los albergues (relación N:M se_aloja).';
COMMENT ON COLUMN FAMILIA_ALBERGUE.cod_familia IS 'PK y FK a FAMILIA.';
COMMENT ON COLUMN FAMILIA_ALBERGUE.cod_albergue IS 'PK y FK a ALBERGUE.';
COMMENT ON COLUMN FAMILIA_ALBERGUE.fecha_ingreso IS 'PK. Fecha de ingreso de la familia al albergue.';
COMMENT ON COLUMN FAMILIA_ALBERGUE.fecha_salida IS 'Fecha de salida. Vacía mientras la familia sigue en el albergue.';

ALTER TABLE FAMILIA_ALBERGUE ADD CONSTRAINT C_FAL_PK PRIMARY KEY (cod_familia, cod_albergue, fecha_ingreso);
ALTER TABLE FAMILIA_ALBERGUE ADD CONSTRAINT C_FAL_FAM_FK FOREIGN KEY (cod_familia) REFERENCES FAMILIA (cod_familia);
ALTER TABLE FAMILIA_ALBERGUE ADD CONSTRAINT C_FAL_ALB_FK FOREIGN KEY (cod_albergue) REFERENCES ALBERGUE (cod_instalacion);
ALTER TABLE FAMILIA_ALBERGUE ADD CONSTRAINT C_FAL_FEC_CK CHECK (fecha_salida IS NULL OR fecha_salida >= fecha_ingreso);

-- RN-13: una familia solo puede tener un alojamiento sin fecha de salida.
CREATE UNIQUE INDEX UX_FAL_ACTIVA ON FAMILIA_ALBERGUE
  (CASE WHEN fecha_salida IS NULL THEN cod_familia END);


-- ============================================================================
-- Creación tabla de CATEGORIA_NECESIDAD
-- ============================================================================

CREATE TABLE CATEGORIA_NECESIDAD
( cod_categoria     NUMBER(10)      NOT NULL,
  nombre            VARCHAR2(100)   NOT NULL,
  tipo_criterio     VARCHAR2(15)    NOT NULL,
  edad_minima       NUMBER(3),
  edad_maxima       NUMBER(3),
  cod_especialidad  NUMBER(10)
);

COMMENT ON TABLE CATEGORIA_NECESIDAD IS 'Catálogo de categorías de necesidad y criterio con que se asigna cada una.';
COMMENT ON COLUMN CATEGORIA_NECESIDAD.cod_categoria IS 'Código de la categoría de necesidad.';
COMMENT ON COLUMN CATEGORIA_NECESIDAD.nombre IS 'Nombre de la categoría.';
COMMENT ON COLUMN CATEGORIA_NECESIDAD.tipo_criterio IS 'Criterio: Por edad, Por validación.';
COMMENT ON COLUMN CATEGORIA_NECESIDAD.edad_minima IS 'Edad mínima en años (solo criterio Por edad).';
COMMENT ON COLUMN CATEGORIA_NECESIDAD.edad_maxima IS 'Edad máxima en años (solo criterio Por edad).';
COMMENT ON COLUMN CATEGORIA_NECESIDAD.cod_especialidad IS 'FK a ESPECIALIDAD. Especialidad que valida la necesidad. Opcional.';

ALTER TABLE CATEGORIA_NECESIDAD ADD CONSTRAINT C_CNE_PK PRIMARY KEY (cod_categoria);
ALTER TABLE CATEGORIA_NECESIDAD ADD CONSTRAINT C_CNE_ESP_FK FOREIGN KEY (cod_especialidad) REFERENCES ESPECIALIDAD (cod_especialidad);
ALTER TABLE CATEGORIA_NECESIDAD ADD CONSTRAINT C_CNE_CRIT_CK CHECK (tipo_criterio IN ('Por edad','Por validación'));
ALTER TABLE CATEGORIA_NECESIDAD ADD CONSTRAINT C_CNE_EDAD_CK CHECK ((tipo_criterio = 'Por edad' AND edad_minima IS NOT NULL AND edad_maxima IS NOT NULL AND edad_minima <= edad_maxima) OR (tipo_criterio = 'Por validación' AND edad_minima IS NULL AND edad_maxima IS NULL));


-- ============================================================================
-- Creación tabla de MANIFESTACION
-- ============================================================================

CREATE TABLE MANIFESTACION
( cod_manifestacion  NUMBER(10)      NOT NULL,
  fecha_registro     DATE            NOT NULL,
  tipo               VARCHAR2(15)    NOT NULL,
  canal              VARCHAR2(20)    NOT NULL,
  descripcion        VARCHAR2(500)   NOT NULL,
  estado             VARCHAR2(15)    NOT NULL,
  respuesta          VARCHAR2(1000),
  fecha_respuesta    DATE,
  cod_damnificado    NUMBER(10)      NOT NULL,
  cod_registrador    NUMBER(10)
);

COMMENT ON TABLE MANIFESTACION IS 'Manifestaciones de los damnificados (voz del damnificado) y su respuesta.';
COMMENT ON COLUMN MANIFESTACION.cod_manifestacion IS 'Código de la manifestación.';
COMMENT ON COLUMN MANIFESTACION.fecha_registro IS 'Fecha en que se registró la manifestación.';
COMMENT ON COLUMN MANIFESTACION.tipo IS 'Tipo: Necesidad nueva, No recibido, No me sirve.';
COMMENT ON COLUMN MANIFESTACION.canal IS 'Canal: Punto de atención, Quiosco.';
COMMENT ON COLUMN MANIFESTACION.descripcion IS 'Descripción de la manifestación.';
COMMENT ON COLUMN MANIFESTACION.estado IS 'Estado: Abierta, En trámite, Respondida.';
COMMENT ON COLUMN MANIFESTACION.respuesta IS 'Respuesta dada al damnificado. Vacía hasta que se responde.';
COMMENT ON COLUMN MANIFESTACION.fecha_respuesta IS 'Fecha de la respuesta. Vacía hasta que se responde.';
COMMENT ON COLUMN MANIFESTACION.cod_damnificado IS 'FK a DAMNIFICADO. Quien hace la manifestación.';
COMMENT ON COLUMN MANIFESTACION.cod_registrador IS 'FK a PERSONAL_SOCORRO. Quien la registra (solo en punto de atención).';

ALTER TABLE MANIFESTACION ADD CONSTRAINT C_MAN_PK PRIMARY KEY (cod_manifestacion);
ALTER TABLE MANIFESTACION ADD CONSTRAINT C_MAN_DAM_FK FOREIGN KEY (cod_damnificado) REFERENCES DAMNIFICADO (cod_persona);
ALTER TABLE MANIFESTACION ADD CONSTRAINT C_MAN_PSO_FK FOREIGN KEY (cod_registrador) REFERENCES PERSONAL_SOCORRO (cod_persona);
ALTER TABLE MANIFESTACION ADD CONSTRAINT C_MAN_TIPO_CK CHECK (tipo IN ('Necesidad nueva','No recibido','No me sirve'));
ALTER TABLE MANIFESTACION ADD CONSTRAINT C_MAN_CANAL_CK CHECK (canal IN ('Punto de atención','Quiosco'));
ALTER TABLE MANIFESTACION ADD CONSTRAINT C_MAN_EST_CK CHECK (estado IN ('Abierta','En trámite','Respondida'));
ALTER TABLE MANIFESTACION ADD CONSTRAINT C_MAN_REG_CK CHECK ((canal = 'Punto de atención' AND cod_registrador IS NOT NULL) OR (canal = 'Quiosco' AND cod_registrador IS NULL));
ALTER TABLE MANIFESTACION ADD CONSTRAINT C_MAN_FEC_CK CHECK (fecha_respuesta IS NULL OR fecha_respuesta >= fecha_registro);
ALTER TABLE MANIFESTACION ADD CONSTRAINT C_MAN_RESP_CK CHECK (estado <> 'Respondida' OR (respuesta IS NOT NULL AND fecha_respuesta IS NOT NULL));


-- ============================================================================
-- Creación tabla de NECESIDAD_DAMNIFICADO
-- ============================================================================

CREATE TABLE NECESIDAD_DAMNIFICADO
( cod_necesidad      NUMBER(10)      NOT NULL,
  fecha_declaracion  DATE            NOT NULL,
  estado             VARCHAR2(15)    NOT NULL,
  fecha_validacion   DATE,
  fecha_inicio       DATE,
  fecha_fin          DATE,
  cod_damnificado    NUMBER(10)      NOT NULL,
  cod_categoria      NUMBER(10)      NOT NULL,
  cod_validador      NUMBER(10),
  cod_manifestacion  NUMBER(10)
);

COMMENT ON TABLE NECESIDAD_DAMNIFICADO IS 'Necesidades declaradas por cada damnificado y su validación.';
COMMENT ON COLUMN NECESIDAD_DAMNIFICADO.cod_necesidad IS 'Código de la necesidad declarada.';
COMMENT ON COLUMN NECESIDAD_DAMNIFICADO.fecha_declaracion IS 'Fecha en que se declaró la necesidad.';
COMMENT ON COLUMN NECESIDAD_DAMNIFICADO.estado IS 'Estado: Declarada, Validada, Rechazada.';
COMMENT ON COLUMN NECESIDAD_DAMNIFICADO.fecha_validacion IS 'Fecha de validación o rechazo. Vacía mientras está Declarada.';
COMMENT ON COLUMN NECESIDAD_DAMNIFICADO.fecha_inicio IS 'Inicio de la vigencia. Se define al validar.';
COMMENT ON COLUMN NECESIDAD_DAMNIFICADO.fecha_fin IS 'Fin de la vigencia. Se define al validar.';
COMMENT ON COLUMN NECESIDAD_DAMNIFICADO.cod_damnificado IS 'FK a DAMNIFICADO. Quien declara la necesidad.';
COMMENT ON COLUMN NECESIDAD_DAMNIFICADO.cod_categoria IS 'FK a CATEGORIA_NECESIDAD. Categoría de la necesidad.';
COMMENT ON COLUMN NECESIDAD_DAMNIFICADO.cod_validador IS 'FK a PERSONAL_SOCORRO. Quien valida la necesidad. Opcional.';
COMMENT ON COLUMN NECESIDAD_DAMNIFICADO.cod_manifestacion IS 'FK a MANIFESTACION. Única. Manifestación de la que surge. Opcional.';

ALTER TABLE NECESIDAD_DAMNIFICADO ADD CONSTRAINT C_NDA_PK PRIMARY KEY (cod_necesidad);
ALTER TABLE NECESIDAD_DAMNIFICADO ADD CONSTRAINT C_NDA_DAM_FK FOREIGN KEY (cod_damnificado) REFERENCES DAMNIFICADO (cod_persona);
ALTER TABLE NECESIDAD_DAMNIFICADO ADD CONSTRAINT C_NDA_CNE_FK FOREIGN KEY (cod_categoria) REFERENCES CATEGORIA_NECESIDAD (cod_categoria);
ALTER TABLE NECESIDAD_DAMNIFICADO ADD CONSTRAINT C_NDA_PSO_FK FOREIGN KEY (cod_validador) REFERENCES PERSONAL_SOCORRO (cod_persona);
ALTER TABLE NECESIDAD_DAMNIFICADO ADD CONSTRAINT C_NDA_MAN_FK FOREIGN KEY (cod_manifestacion) REFERENCES MANIFESTACION (cod_manifestacion);
ALTER TABLE NECESIDAD_DAMNIFICADO ADD CONSTRAINT C_NDA_MAN_UK UNIQUE (cod_manifestacion);
ALTER TABLE NECESIDAD_DAMNIFICADO ADD CONSTRAINT C_NDA_EST_CK CHECK (estado IN ('Declarada','Validada','Rechazada'));
ALTER TABLE NECESIDAD_DAMNIFICADO ADD CONSTRAINT C_NDA_VIG_CK CHECK (fecha_inicio IS NULL OR fecha_fin IS NULL OR fecha_fin >= fecha_inicio);
ALTER TABLE NECESIDAD_DAMNIFICADO ADD CONSTRAINT C_NDA_FVAL_CK CHECK (fecha_validacion IS NULL OR fecha_validacion >= fecha_declaracion);
ALTER TABLE NECESIDAD_DAMNIFICADO ADD CONSTRAINT C_NDA_VAL_CK CHECK (estado <> 'Validada' OR (fecha_validacion IS NOT NULL AND cod_validador IS NOT NULL AND fecha_inicio IS NOT NULL AND fecha_fin IS NOT NULL));


-- ============================================================================
-- Creación tabla de TIPO_INSUMO
-- ============================================================================

CREATE TABLE TIPO_INSUMO
( cod_tipo_insumo  NUMBER(10)      NOT NULL,
  nombre           VARCHAR2(100)   NOT NULL
);

COMMENT ON TABLE TIPO_INSUMO IS 'Catálogo de tipos de insumo.';
COMMENT ON COLUMN TIPO_INSUMO.cod_tipo_insumo IS 'Código del tipo de insumo.';
COMMENT ON COLUMN TIPO_INSUMO.nombre IS 'Nombre del tipo de insumo.';

ALTER TABLE TIPO_INSUMO ADD CONSTRAINT C_TIN_PK PRIMARY KEY (cod_tipo_insumo);


-- ============================================================================
-- Creación tabla de UNIDAD_MEDIDA
-- ============================================================================

CREATE TABLE UNIDAD_MEDIDA
( cod_unidad_medida  VARCHAR2(3)     NOT NULL,
  nombre             VARCHAR2(100)   NOT NULL
);

COMMENT ON TABLE UNIDAD_MEDIDA IS 'Catálogo de unidades de medida estandarizadas de los insumos.';
COMMENT ON COLUMN UNIDAD_MEDIDA.cod_unidad_medida IS 'Código de la unidad de medida.';
COMMENT ON COLUMN UNIDAD_MEDIDA.nombre IS 'Nombre de la unidad de medida.';

ALTER TABLE UNIDAD_MEDIDA ADD CONSTRAINT C_UME_PK PRIMARY KEY (cod_unidad_medida);


-- ============================================================================
-- Creación tabla de INSUMO
-- ============================================================================

CREATE TABLE INSUMO
( cod_insumo         NUMBER(10)      NOT NULL,
  nombre             VARCHAR2(100)   NOT NULL,
  descripcion        VARCHAR2(500)   NOT NULL,
  perecedero         CHAR(1)         NOT NULL,
  modalidad_entrega  VARCHAR2(15)    NOT NULL,
  cod_tipo_insumo    NUMBER(10)      NOT NULL,
  cod_unidad_medida  VARCHAR2(3)     NOT NULL
);

COMMENT ON TABLE INSUMO IS 'Insumos y ayudas humanitarias que se reciben, almacenan y entregan.';
COMMENT ON COLUMN INSUMO.cod_insumo IS 'Código del insumo.';
COMMENT ON COLUMN INSUMO.nombre IS 'Nombre del insumo.';
COMMENT ON COLUMN INSUMO.descripcion IS 'Descripción del insumo.';
COMMENT ON COLUMN INSUMO.perecedero IS 'Indica si es perecedero: S, N.';
COMMENT ON COLUMN INSUMO.modalidad_entrega IS 'Modalidad: Por persona, Por familia.';
COMMENT ON COLUMN INSUMO.cod_tipo_insumo IS 'FK a TIPO_INSUMO. Tipo del insumo.';
COMMENT ON COLUMN INSUMO.cod_unidad_medida IS 'FK a UNIDAD_MEDIDA. Unidad en que se mide.';

ALTER TABLE INSUMO ADD CONSTRAINT C_INU_PK PRIMARY KEY (cod_insumo);
ALTER TABLE INSUMO ADD CONSTRAINT C_INU_TIN_FK FOREIGN KEY (cod_tipo_insumo) REFERENCES TIPO_INSUMO (cod_tipo_insumo);
ALTER TABLE INSUMO ADD CONSTRAINT C_INU_UME_FK FOREIGN KEY (cod_unidad_medida) REFERENCES UNIDAD_MEDIDA (cod_unidad_medida);
ALTER TABLE INSUMO ADD CONSTRAINT C_INU_PER_CK CHECK (perecedero IN ('S','N'));
ALTER TABLE INSUMO ADD CONSTRAINT C_INU_MOD_CK CHECK (modalidad_entrega IN ('Por persona','Por familia'));


-- ============================================================================
-- Creación tabla de CATEGORIA_INSUMO
-- ============================================================================

CREATE TABLE CATEGORIA_INSUMO
( cod_categoria  NUMBER(10)      NOT NULL,
  cod_insumo     NUMBER(10)      NOT NULL
);

COMMENT ON TABLE CATEGORIA_INSUMO IS 'Insumos con que se atiende cada categoría de necesidad (relación N:M cubre).';
COMMENT ON COLUMN CATEGORIA_INSUMO.cod_categoria IS 'PK y FK a CATEGORIA_NECESIDAD.';
COMMENT ON COLUMN CATEGORIA_INSUMO.cod_insumo IS 'PK y FK a INSUMO.';

ALTER TABLE CATEGORIA_INSUMO ADD CONSTRAINT C_CIN_PK PRIMARY KEY (cod_categoria, cod_insumo);
ALTER TABLE CATEGORIA_INSUMO ADD CONSTRAINT C_CIN_CNE_FK FOREIGN KEY (cod_categoria) REFERENCES CATEGORIA_NECESIDAD (cod_categoria);
ALTER TABLE CATEGORIA_INSUMO ADD CONSTRAINT C_CIN_INU_FK FOREIGN KEY (cod_insumo) REFERENCES INSUMO (cod_insumo);


-- ============================================================================
-- Creación tabla de INVENTARIO_LOTE
-- ============================================================================

CREATE TABLE INVENTARIO_LOTE
( cod_lote             NUMBER(10)      NOT NULL,
  num_lote             VARCHAR2(30)    NOT NULL,
  origen               VARCHAR2(30)    NOT NULL,
  fecha_recepcion      DATE            NOT NULL,
  fecha_vencimiento    DATE,
  cantidad_recibida    NUMBER(10,2)    NOT NULL,
  cantidad_disponible  NUMBER(10,2)    NOT NULL,
  cod_insumo           NUMBER(10)      NOT NULL,
  cod_centro           NUMBER(10)      NOT NULL
);

COMMENT ON TABLE INVENTARIO_LOTE IS 'Lotes de insumos recibidos en cada centro de acopio y su cantidad disponible.';
COMMENT ON COLUMN INVENTARIO_LOTE.cod_lote IS 'Código del lote.';
COMMENT ON COLUMN INVENTARIO_LOTE.num_lote IS 'Número del lote.';
COMMENT ON COLUMN INVENTARIO_LOTE.origen IS 'Origen: Donación particular, Compra pública, Cooperación internacional.';
COMMENT ON COLUMN INVENTARIO_LOTE.fecha_recepcion IS 'Fecha en que se recibió el lote.';
COMMENT ON COLUMN INVENTARIO_LOTE.fecha_vencimiento IS 'Fecha de vencimiento del lote. Opcional.';
COMMENT ON COLUMN INVENTARIO_LOTE.cantidad_recibida IS 'Cantidad recibida en el lote.';
COMMENT ON COLUMN INVENTARIO_LOTE.cantidad_disponible IS 'Cantidad disponible; la descuenta el disparador TRG_DLO_DESCUENTO.';
COMMENT ON COLUMN INVENTARIO_LOTE.cod_insumo IS 'FK a INSUMO. Insumo del lote.';
COMMENT ON COLUMN INVENTARIO_LOTE.cod_centro IS 'FK a CENTRO_ACOPIO. Centro donde está el lote.';

ALTER TABLE INVENTARIO_LOTE ADD CONSTRAINT C_ILO_PK PRIMARY KEY (cod_lote);
ALTER TABLE INVENTARIO_LOTE ADD CONSTRAINT C_ILO_INU_FK FOREIGN KEY (cod_insumo) REFERENCES INSUMO (cod_insumo);
ALTER TABLE INVENTARIO_LOTE ADD CONSTRAINT C_ILO_CAC_FK FOREIGN KEY (cod_centro) REFERENCES CENTRO_ACOPIO (cod_instalacion);
ALTER TABLE INVENTARIO_LOTE ADD CONSTRAINT C_ILO_ORIG_CK CHECK (origen IN ('Donación particular','Compra pública','Cooperación internacional'));
ALTER TABLE INVENTARIO_LOTE ADD CONSTRAINT C_ILO_VENC_CK CHECK (fecha_vencimiento IS NULL OR fecha_vencimiento >= fecha_recepcion + 30);
ALTER TABLE INVENTARIO_LOTE ADD CONSTRAINT C_ILO_CREC_CK CHECK (cantidad_recibida > 0);
ALTER TABLE INVENTARIO_LOTE ADD CONSTRAINT C_ILO_CDIS_CK CHECK (cantidad_disponible >= 0 AND cantidad_disponible <= cantidad_recibida);


-- ============================================================================
-- Creación tabla de SOLICITUD
-- ============================================================================

CREATE TABLE SOLICITUD
( cod_solicitud    NUMBER(10)      NOT NULL,
  fecha_solicitud  DATE            NOT NULL,
  tipo_solicitud   VARCHAR2(15)    NOT NULL,
  descripcion      VARCHAR2(500)   NOT NULL,
  prioridad        VARCHAR2(15)    NOT NULL,
  estado           VARCHAR2(15)    NOT NULL,
  cod_solicitante  NUMBER(10)      NOT NULL,
  cod_zona         NUMBER(10)      NOT NULL
);

COMMENT ON TABLE SOLICITUD IS 'Solicitudes de insumos o de auxilio hechas para una zona afectada.';
COMMENT ON COLUMN SOLICITUD.cod_solicitud IS 'Código de la solicitud.';
COMMENT ON COLUMN SOLICITUD.fecha_solicitud IS 'Fecha en que se hizo la solicitud.';
COMMENT ON COLUMN SOLICITUD.tipo_solicitud IS 'Tipo: Insumos, Auxilio.';
COMMENT ON COLUMN SOLICITUD.descripcion IS 'Descripción de la solicitud.';
COMMENT ON COLUMN SOLICITUD.prioridad IS 'Prioridad: Baja, Media, Alta, Urgente.';
COMMENT ON COLUMN SOLICITUD.estado IS 'Estado: Registrada, Asignada, Atendida, Rechazada.';
COMMENT ON COLUMN SOLICITUD.cod_solicitante IS 'FK a PERSONA. Persona que hace la solicitud.';
COMMENT ON COLUMN SOLICITUD.cod_zona IS 'FK a ZONA_AFECTADA. Zona para la que se pide.';

ALTER TABLE SOLICITUD ADD CONSTRAINT C_SOL_PK PRIMARY KEY (cod_solicitud);
ALTER TABLE SOLICITUD ADD CONSTRAINT C_SOL_PER_FK FOREIGN KEY (cod_solicitante) REFERENCES PERSONA (cod_persona);
ALTER TABLE SOLICITUD ADD CONSTRAINT C_SOL_ZON_FK FOREIGN KEY (cod_zona) REFERENCES ZONA_AFECTADA (cod_zona);
ALTER TABLE SOLICITUD ADD CONSTRAINT C_SOL_TIPO_CK CHECK (tipo_solicitud IN ('Insumos','Auxilio'));
ALTER TABLE SOLICITUD ADD CONSTRAINT C_SOL_PRIO_CK CHECK (prioridad IN ('Baja','Media','Alta','Urgente'));
ALTER TABLE SOLICITUD ADD CONSTRAINT C_SOL_EST_CK CHECK (estado IN ('Registrada','Asignada','Atendida','Rechazada'));


-- ============================================================================
-- Creación tabla de SOLICITUD_INSUMO
-- ============================================================================

CREATE TABLE SOLICITUD_INSUMO
( cod_solicitud        NUMBER(10)      NOT NULL,
  cod_insumo           NUMBER(10)      NOT NULL,
  cantidad_solicitada  NUMBER(10,2)    NOT NULL,
  cantidad_asignada    NUMBER(10,2)
);

COMMENT ON TABLE SOLICITUD_INSUMO IS 'Insumos pedidos en cada solicitud y cantidad asignada (relación N:M pide).';
COMMENT ON COLUMN SOLICITUD_INSUMO.cod_solicitud IS 'PK y FK a SOLICITUD.';
COMMENT ON COLUMN SOLICITUD_INSUMO.cod_insumo IS 'PK y FK a INSUMO.';
COMMENT ON COLUMN SOLICITUD_INSUMO.cantidad_solicitada IS 'Cantidad pedida del insumo.';
COMMENT ON COLUMN SOLICITUD_INSUMO.cantidad_asignada IS 'Cantidad asignada. Vacía hasta que se asigna.';

ALTER TABLE SOLICITUD_INSUMO ADD CONSTRAINT C_SIN_PK PRIMARY KEY (cod_solicitud, cod_insumo);
ALTER TABLE SOLICITUD_INSUMO ADD CONSTRAINT C_SIN_SOL_FK FOREIGN KEY (cod_solicitud) REFERENCES SOLICITUD (cod_solicitud);
ALTER TABLE SOLICITUD_INSUMO ADD CONSTRAINT C_SIN_INU_FK FOREIGN KEY (cod_insumo) REFERENCES INSUMO (cod_insumo);
ALTER TABLE SOLICITUD_INSUMO ADD CONSTRAINT C_SIN_CSOL_CK CHECK (cantidad_solicitada > 0);
ALTER TABLE SOLICITUD_INSUMO ADD CONSTRAINT C_SIN_CASI_CK CHECK (cantidad_asignada IS NULL OR (cantidad_asignada >= 0 AND cantidad_asignada <= cantidad_solicitada));


-- ============================================================================
-- Creación tabla de DESPACHO
-- ============================================================================

CREATE TABLE DESPACHO
( cod_despacho           NUMBER(10)      NOT NULL,
  fecha_emision          DATE            NOT NULL,
  estado                 VARCHAR2(15)    NOT NULL,
  placa_vehiculo         VARCHAR2(6)     NOT NULL,
  fecha_entrega          DATE,
  nombre_receptor        VARCHAR2(100),
  confirmacion_recibido  CHAR(1)         NOT NULL,
  cod_centro             NUMBER(10)      NOT NULL,
  cod_solicitud          NUMBER(10)      NOT NULL,
  cod_destino            NUMBER(10)      NOT NULL,
  cod_conductor          NUMBER(10)
);

COMMENT ON TABLE DESPACHO IS 'Despachos de insumos desde un centro de acopio hacia una instalación de destino.';
COMMENT ON COLUMN DESPACHO.cod_despacho IS 'Código del despacho.';
COMMENT ON COLUMN DESPACHO.fecha_emision IS 'Fecha en que se emitió el despacho.';
COMMENT ON COLUMN DESPACHO.estado IS 'Estado: Pendiente, En Tránsito, Entregado, Cancelado.';
COMMENT ON COLUMN DESPACHO.placa_vehiculo IS 'Placa del vehículo.';
COMMENT ON COLUMN DESPACHO.fecha_entrega IS 'Fecha de entrega en el destino. Vacía hasta la entrega.';
COMMENT ON COLUMN DESPACHO.nombre_receptor IS 'Quien recibe en el destino. Vacío hasta la entrega.';
COMMENT ON COLUMN DESPACHO.confirmacion_recibido IS 'Confirmación de recibido: S, N.';
COMMENT ON COLUMN DESPACHO.cod_centro IS 'FK a CENTRO_ACOPIO. Centro de donde sale.';
COMMENT ON COLUMN DESPACHO.cod_solicitud IS 'FK a SOLICITUD. Solicitud que atiende.';
COMMENT ON COLUMN DESPACHO.cod_destino IS 'FK a INSTALACION. Albergue o punto de entrega de destino.';
COMMENT ON COLUMN DESPACHO.cod_conductor IS 'FK a PERSONAL_SOCORRO. Conductor. Opcional.';

ALTER TABLE DESPACHO ADD CONSTRAINT C_DES_PK PRIMARY KEY (cod_despacho);
ALTER TABLE DESPACHO ADD CONSTRAINT C_DES_CAC_FK FOREIGN KEY (cod_centro) REFERENCES CENTRO_ACOPIO (cod_instalacion);
ALTER TABLE DESPACHO ADD CONSTRAINT C_DES_SOL_FK FOREIGN KEY (cod_solicitud) REFERENCES SOLICITUD (cod_solicitud);
ALTER TABLE DESPACHO ADD CONSTRAINT C_DES_INS_FK FOREIGN KEY (cod_destino) REFERENCES INSTALACION (cod_instalacion);
ALTER TABLE DESPACHO ADD CONSTRAINT C_DES_PSO_FK FOREIGN KEY (cod_conductor) REFERENCES PERSONAL_SOCORRO (cod_persona);
ALTER TABLE DESPACHO ADD CONSTRAINT C_DES_EST_CK CHECK (estado IN ('Pendiente','En Tránsito','Entregado','Cancelado'));
ALTER TABLE DESPACHO ADD CONSTRAINT C_DES_CONF_CK CHECK (confirmacion_recibido IN ('S','N'));
ALTER TABLE DESPACHO ADD CONSTRAINT C_DES_FEC_CK CHECK (fecha_entrega IS NULL OR fecha_entrega >= fecha_emision);
ALTER TABLE DESPACHO ADD CONSTRAINT C_DES_ENT_CK CHECK (estado <> 'Entregado' OR (fecha_entrega IS NOT NULL AND nombre_receptor IS NOT NULL AND confirmacion_recibido = 'S'));


-- ============================================================================
-- Creación tabla de DESPACHO_LOTE
-- ============================================================================

CREATE TABLE DESPACHO_LOTE
( cod_despacho         NUMBER(10)      NOT NULL,
  cod_lote             NUMBER(10)      NOT NULL,
  cantidad_despachada  NUMBER(10,2)    NOT NULL
);

COMMENT ON TABLE DESPACHO_LOTE IS 'Lotes de los que sale cada despacho y cantidad tomada de cada uno (relación N:M incluye).';
COMMENT ON COLUMN DESPACHO_LOTE.cod_despacho IS 'PK y FK a DESPACHO.';
COMMENT ON COLUMN DESPACHO_LOTE.cod_lote IS 'PK y FK a INVENTARIO_LOTE.';
COMMENT ON COLUMN DESPACHO_LOTE.cantidad_despachada IS 'Cantidad despachada del lote.';

ALTER TABLE DESPACHO_LOTE ADD CONSTRAINT C_DLO_PK PRIMARY KEY (cod_despacho, cod_lote);
ALTER TABLE DESPACHO_LOTE ADD CONSTRAINT C_DLO_DES_FK FOREIGN KEY (cod_despacho) REFERENCES DESPACHO (cod_despacho);
ALTER TABLE DESPACHO_LOTE ADD CONSTRAINT C_DLO_ILO_FK FOREIGN KEY (cod_lote) REFERENCES INVENTARIO_LOTE (cod_lote);
ALTER TABLE DESPACHO_LOTE ADD CONSTRAINT C_DLO_CANT_CK CHECK (cantidad_despachada > 0);


-- ============================================================================
-- Creación tabla de ENTREGA
-- ============================================================================

CREATE TABLE ENTREGA
( cod_entrega            NUMBER(10)      NOT NULL,
  fecha_hora             DATE            NOT NULL,
  cantidad               NUMBER(10,2)    NOT NULL,
  metodo_identificacion  VARCHAR2(20)    NOT NULL,
  cod_despacho           NUMBER(10)      NOT NULL,
  cod_insumo             NUMBER(10)      NOT NULL,
  cod_beneficiario       NUMBER(10)      NOT NULL,
  cod_receptor           NUMBER(10)      NOT NULL,
  cod_necesidad          NUMBER(10)
);

COMMENT ON TABLE ENTREGA IS 'Entregas de un insumo a una persona damnificada (trazabilidad hasta la persona).';
COMMENT ON COLUMN ENTREGA.cod_entrega IS 'Código de la entrega.';
COMMENT ON COLUMN ENTREGA.fecha_hora IS 'Fecha y hora de la entrega.';
COMMENT ON COLUMN ENTREGA.cantidad IS 'Cantidad entregada.';
COMMENT ON COLUMN ENTREGA.metodo_identificacion IS 'Identificación usada: Código de censo, Documento.';
COMMENT ON COLUMN ENTREGA.cod_despacho IS 'FK a DESPACHO. Despacho del que sale la ayuda.';
COMMENT ON COLUMN ENTREGA.cod_insumo IS 'FK a INSUMO. Insumo entregado.';
COMMENT ON COLUMN ENTREGA.cod_beneficiario IS 'FK a DAMNIFICADO. Quien tiene la necesidad.';
COMMENT ON COLUMN ENTREGA.cod_receptor IS 'FK a PERSONA. Quien recoge físicamente la ayuda.';
COMMENT ON COLUMN ENTREGA.cod_necesidad IS 'FK a NECESIDAD_DAMNIFICADO. Necesidad que atiende. Opcional.';

ALTER TABLE ENTREGA ADD CONSTRAINT C_ENT_PK PRIMARY KEY (cod_entrega);
ALTER TABLE ENTREGA ADD CONSTRAINT C_ENT_DES_FK FOREIGN KEY (cod_despacho) REFERENCES DESPACHO (cod_despacho);
ALTER TABLE ENTREGA ADD CONSTRAINT C_ENT_INU_FK FOREIGN KEY (cod_insumo) REFERENCES INSUMO (cod_insumo);
ALTER TABLE ENTREGA ADD CONSTRAINT C_ENT_DAM_FK FOREIGN KEY (cod_beneficiario) REFERENCES DAMNIFICADO (cod_persona);
ALTER TABLE ENTREGA ADD CONSTRAINT C_ENT_PER_FK FOREIGN KEY (cod_receptor) REFERENCES PERSONA (cod_persona);
ALTER TABLE ENTREGA ADD CONSTRAINT C_ENT_NDA_FK FOREIGN KEY (cod_necesidad) REFERENCES NECESIDAD_DAMNIFICADO (cod_necesidad);
ALTER TABLE ENTREGA ADD CONSTRAINT C_ENT_CANT_CK CHECK (cantidad > 0);
ALTER TABLE ENTREGA ADD CONSTRAINT C_ENT_MET_CK CHECK (metodo_identificacion IN ('Código de censo','Documento'));


-- ============================================================================
-- Creación tabla de CUADRILLA
-- ============================================================================

CREATE TABLE CUADRILLA
( cod_cuadrilla  NUMBER(10)      NOT NULL,
  nombre         VARCHAR2(100)   NOT NULL
);

COMMENT ON TABLE CUADRILLA IS 'Cuadrillas de trabajo del personal de socorro.';
COMMENT ON COLUMN CUADRILLA.cod_cuadrilla IS 'Código de la cuadrilla.';
COMMENT ON COLUMN CUADRILLA.nombre IS 'Nombre de la cuadrilla.';

ALTER TABLE CUADRILLA ADD CONSTRAINT C_CUA_PK PRIMARY KEY (cod_cuadrilla);


-- ============================================================================
-- Creación tabla de PERSONAL_CUADRILLA
-- ============================================================================

CREATE TABLE PERSONAL_CUADRILLA
( cod_personal   NUMBER(10)      NOT NULL,
  cod_cuadrilla  NUMBER(10)      NOT NULL,
  fecha_ingreso  DATE            NOT NULL,
  fecha_salida   DATE
);

COMMENT ON TABLE PERSONAL_CUADRILLA IS 'Periodos en que cada persona integra una cuadrilla (relación N:M integra).';
COMMENT ON COLUMN PERSONAL_CUADRILLA.cod_personal IS 'PK y FK a PERSONAL_SOCORRO.';
COMMENT ON COLUMN PERSONAL_CUADRILLA.cod_cuadrilla IS 'PK y FK a CUADRILLA.';
COMMENT ON COLUMN PERSONAL_CUADRILLA.fecha_ingreso IS 'PK. Fecha de ingreso a la cuadrilla.';
COMMENT ON COLUMN PERSONAL_CUADRILLA.fecha_salida IS 'Fecha de salida. Vacía mientras sigue en la cuadrilla.';

ALTER TABLE PERSONAL_CUADRILLA ADD CONSTRAINT C_PCU_PK PRIMARY KEY (cod_personal, cod_cuadrilla, fecha_ingreso);
ALTER TABLE PERSONAL_CUADRILLA ADD CONSTRAINT C_PCU_PSO_FK FOREIGN KEY (cod_personal) REFERENCES PERSONAL_SOCORRO (cod_persona);
ALTER TABLE PERSONAL_CUADRILLA ADD CONSTRAINT C_PCU_CUA_FK FOREIGN KEY (cod_cuadrilla) REFERENCES CUADRILLA (cod_cuadrilla);
ALTER TABLE PERSONAL_CUADRILLA ADD CONSTRAINT C_PCU_FEC_CK CHECK (fecha_salida IS NULL OR fecha_salida >= fecha_ingreso);


-- ============================================================================
-- Creación tabla de ORDEN_ASIGNACION
-- ============================================================================

CREATE TABLE ORDEN_ASIGNACION
( cod_orden          NUMBER(10)      NOT NULL,
  fecha_hora_inicio  DATE            NOT NULL,
  fecha_hora_fin     DATE,
  estado             VARCHAR2(15)    NOT NULL,
  cod_cuadrilla      NUMBER(10)      NOT NULL,
  cod_zona           NUMBER(10),
  cod_albergue       NUMBER(10)
);

COMMENT ON TABLE ORDEN_ASIGNACION IS 'Órdenes que asignan una cuadrilla a una zona afectada o a un albergue.';
COMMENT ON COLUMN ORDEN_ASIGNACION.cod_orden IS 'Código de la orden de asignación.';
COMMENT ON COLUMN ORDEN_ASIGNACION.fecha_hora_inicio IS 'Fecha y hora de inicio.';
COMMENT ON COLUMN ORDEN_ASIGNACION.fecha_hora_fin IS 'Fecha y hora de fin. Vacía mientras la orden está activa.';
COMMENT ON COLUMN ORDEN_ASIGNACION.estado IS 'Estado: Activa, Finalizada, Cancelada.';
COMMENT ON COLUMN ORDEN_ASIGNACION.cod_cuadrilla IS 'FK a CUADRILLA. Cuadrilla asignada.';
COMMENT ON COLUMN ORDEN_ASIGNACION.cod_zona IS 'FK a ZONA_AFECTADA. Zona de destino (excluyente con albergue).';
COMMENT ON COLUMN ORDEN_ASIGNACION.cod_albergue IS 'FK a ALBERGUE. Albergue de destino (excluyente con zona).';

ALTER TABLE ORDEN_ASIGNACION ADD CONSTRAINT C_OAS_PK PRIMARY KEY (cod_orden);
ALTER TABLE ORDEN_ASIGNACION ADD CONSTRAINT C_OAS_CUA_FK FOREIGN KEY (cod_cuadrilla) REFERENCES CUADRILLA (cod_cuadrilla);
ALTER TABLE ORDEN_ASIGNACION ADD CONSTRAINT C_OAS_ZON_FK FOREIGN KEY (cod_zona) REFERENCES ZONA_AFECTADA (cod_zona);
ALTER TABLE ORDEN_ASIGNACION ADD CONSTRAINT C_OAS_ALB_FK FOREIGN KEY (cod_albergue) REFERENCES ALBERGUE (cod_instalacion);
ALTER TABLE ORDEN_ASIGNACION ADD CONSTRAINT C_OAS_EST_CK CHECK (estado IN ('Activa','Finalizada','Cancelada'));
ALTER TABLE ORDEN_ASIGNACION ADD CONSTRAINT C_OAS_DEST_CK CHECK ((cod_zona IS NOT NULL AND cod_albergue IS NULL) OR (cod_zona IS NULL AND cod_albergue IS NOT NULL));
ALTER TABLE ORDEN_ASIGNACION ADD CONSTRAINT C_OAS_FEC_CK CHECK (fecha_hora_fin IS NULL OR fecha_hora_fin > fecha_hora_inicio);


-- ============================================================================
-- Creación tabla de AUDITORIA
-- ============================================================================

CREATE TABLE AUDITORIA
( cod_auditoria   NUMBER(10)      NOT NULL,
  tabla_afectada  VARCHAR2(30)    NOT NULL,
  operacion       VARCHAR2(15)    NOT NULL,
  usuario         VARCHAR2(50)    NOT NULL,
  fecha_hora      DATE            NOT NULL,
  valor_anterior  VARCHAR2(4000),
  valor_nuevo     VARCHAR2(4000)
);

COMMENT ON TABLE AUDITORIA IS 'Bitácora de cambios sobre datos críticos; la llenan disparadores.';
COMMENT ON COLUMN AUDITORIA.cod_auditoria IS 'Código del registro (secuencia SEQ_AUDITORIA).';
COMMENT ON COLUMN AUDITORIA.tabla_afectada IS 'Tabla en la que se hizo el cambio.';
COMMENT ON COLUMN AUDITORIA.operacion IS 'Operación: Inserción, Actualización, Eliminación.';
COMMENT ON COLUMN AUDITORIA.usuario IS 'Usuario de base de datos que hizo el cambio.';
COMMENT ON COLUMN AUDITORIA.fecha_hora IS 'Fecha y hora del cambio.';
COMMENT ON COLUMN AUDITORIA.valor_anterior IS 'Valor antes del cambio. Vacío en una inserción.';
COMMENT ON COLUMN AUDITORIA.valor_nuevo IS 'Valor después del cambio. Vacío en una eliminación.';

ALTER TABLE AUDITORIA ADD CONSTRAINT C_AUD_PK PRIMARY KEY (cod_auditoria);
ALTER TABLE AUDITORIA ADD CONSTRAINT C_AUD_OPE_CK CHECK (operacion IN ('Inserción','Actualización','Eliminación'));


-- ============================================================================
-- SECUENCIA DE LA AUDITORIA
-- ============================================================================

CREATE SEQUENCE SEQ_AUDITORIA
START WITH 1
INCREMENT BY 1
MINVALUE 1
MAXVALUE 9999999999
ORDER;


-- ============================================================================
-- DISPARADOR RN-03: capacidad máxima de los albergues
-- ============================================================================

-- Después de asignar o modificar una estancia, cuenta las personas alojadas
-- (familias sin fecha de salida) en cada albergue. Si algún albergue supera
-- su capacidad, la operación se rechaza y Oracle la deshace.
CREATE OR REPLACE TRIGGER TRG_FAL_CAPACIDAD
AFTER INSERT OR UPDATE ON FAMILIA_ALBERGUE
DECLARE
  v_albergues_excedidos NUMBER := 0;
BEGIN
  SELECT COUNT(*) INTO v_albergues_excedidos
  FROM ALBERGUE alb
  WHERE alb.capacidad_maxima < (SELECT COUNT(*)
                                FROM FAMILIA_ALBERGUE fal, DAMNIFICADO dam
                                WHERE fal.cod_albergue = alb.cod_instalacion
                                AND fal.fecha_salida IS NULL
                                AND dam.cod_familia = fal.cod_familia);
  IF v_albergues_excedidos > 0 THEN
    RAISE_APPLICATION_ERROR(-20003, 'RN-03: el albergue ya alcanzó su capacidad máxima; no se puede asignar la familia.');
  END IF;
END TRG_FAL_CAPACIDAD;
/


-- ============================================================================
-- DISPARADORES RN-10: un rescatista no puede estar en dos asignaciones activas a la vez
-- ============================================================================

-- Busca dos órdenes activas distintas cuyas cuadrillas compartan a una persona
-- y en las que los cuatro periodos (las dos órdenes y las dos membresías de la
-- persona) se crucen. Hay cruce si el mayor de los inicios es menor que el
-- menor de los fines. Un fin vacío significa "sigue vigente".
CREATE OR REPLACE TRIGGER TRG_OAS_CRUCE
AFTER INSERT OR UPDATE ON ORDEN_ASIGNACION
DECLARE
  v_cruces NUMBER := 0;
BEGIN
  SELECT COUNT(*) INTO v_cruces
  FROM ORDEN_ASIGNACION oa1, ORDEN_ASIGNACION oa2, PERSONAL_CUADRILLA pc1, PERSONAL_CUADRILLA pc2
  WHERE oa1.cod_orden < oa2.cod_orden
  AND oa1.estado = 'Activa'
  AND oa2.estado = 'Activa'
  AND pc1.cod_cuadrilla = oa1.cod_cuadrilla
  AND pc2.cod_cuadrilla = oa2.cod_cuadrilla
  AND pc1.cod_personal = pc2.cod_personal
  AND GREATEST(oa1.fecha_hora_inicio, oa2.fecha_hora_inicio, pc1.fecha_ingreso, pc2.fecha_ingreso)
      < LEAST(NVL(oa1.fecha_hora_fin, TO_DATE('31/12/9999','DD/MM/YYYY')), NVL(oa2.fecha_hora_fin, TO_DATE('31/12/9999','DD/MM/YYYY')),
              NVL(pc1.fecha_salida, TO_DATE('31/12/9999','DD/MM/YYYY')), NVL(pc2.fecha_salida, TO_DATE('31/12/9999','DD/MM/YYYY')));
  IF v_cruces > 0 THEN
    RAISE_APPLICATION_ERROR(-20010, 'RN-10: una persona quedaría en dos asignaciones activas que se cruzan en fecha y hora.');
  END IF;
END TRG_OAS_CRUCE;
/

-- La misma verificación cuando cambia la membresía de las cuadrillas.
CREATE OR REPLACE TRIGGER TRG_PCU_CRUCE
AFTER INSERT OR UPDATE ON PERSONAL_CUADRILLA
DECLARE
  v_cruces NUMBER := 0;
BEGIN
  SELECT COUNT(*) INTO v_cruces
  FROM ORDEN_ASIGNACION oa1, ORDEN_ASIGNACION oa2, PERSONAL_CUADRILLA pc1, PERSONAL_CUADRILLA pc2
  WHERE oa1.cod_orden < oa2.cod_orden
  AND oa1.estado = 'Activa'
  AND oa2.estado = 'Activa'
  AND pc1.cod_cuadrilla = oa1.cod_cuadrilla
  AND pc2.cod_cuadrilla = oa2.cod_cuadrilla
  AND pc1.cod_personal = pc2.cod_personal
  AND GREATEST(oa1.fecha_hora_inicio, oa2.fecha_hora_inicio, pc1.fecha_ingreso, pc2.fecha_ingreso)
      < LEAST(NVL(oa1.fecha_hora_fin, TO_DATE('31/12/9999','DD/MM/YYYY')), NVL(oa2.fecha_hora_fin, TO_DATE('31/12/9999','DD/MM/YYYY')),
              NVL(pc1.fecha_salida, TO_DATE('31/12/9999','DD/MM/YYYY')), NVL(pc2.fecha_salida, TO_DATE('31/12/9999','DD/MM/YYYY')));
  IF v_cruces > 0 THEN
    RAISE_APPLICATION_ERROR(-20010, 'RN-10: una persona quedaría en dos asignaciones activas que se cruzan en fecha y hora.');
  END IF;
END TRG_PCU_CRUCE;
/


-- ============================================================================
-- DISPARADOR RN-08 y RN-12: descuento de existencias al despachar
-- ============================================================================

-- Por cada lote que se carga en un despacho:
--   1. Bloquea la fila del lote (FOR UPDATE) para que nadie más la cambie.
--   2. RN-12: el lote debe estar en el mismo centro de acopio que emite el despacho.
--   3. RN-08: la cantidad no puede superar la disponibilidad real del lote.
--   4. Descuenta la cantidad en INVENTARIO_LOTE.
-- Si algo falla, Oracle deshace la sentencia completa: el despacho del lote y el
-- descuento se guardan juntos o no se guarda ninguno (transacción atómica).
CREATE OR REPLACE TRIGGER TRG_DLO_DESCUENTO
BEFORE INSERT ON DESPACHO_LOTE
FOR EACH ROW
DECLARE
  v_centro_lote     INVENTARIO_LOTE.cod_centro%TYPE;
  v_disponible      INVENTARIO_LOTE.cantidad_disponible%TYPE;
  v_centro_despacho DESPACHO.cod_centro%TYPE;
BEGIN
  SELECT ilo.cod_centro, ilo.cantidad_disponible
  INTO v_centro_lote, v_disponible
  FROM INVENTARIO_LOTE ilo
  WHERE ilo.cod_lote = :NEW.cod_lote
  FOR UPDATE;

  SELECT des.cod_centro
  INTO v_centro_despacho
  FROM DESPACHO des
  WHERE des.cod_despacho = :NEW.cod_despacho;

  IF v_centro_lote <> v_centro_despacho THEN
    RAISE_APPLICATION_ERROR(-20012, 'RN-12: el lote no pertenece al centro de acopio que emite el despacho.');
  END IF;

  IF :NEW.cantidad_despachada > v_disponible THEN
    RAISE_APPLICATION_ERROR(-20008, 'RN-08: la cantidad supera la disponibilidad del lote (' || v_disponible || ').');
  END IF;

  UPDATE INVENTARIO_LOTE
  SET cantidad_disponible = cantidad_disponible - :NEW.cantidad_despachada
  WHERE cod_lote = :NEW.cod_lote;
END TRG_DLO_DESCUENTO;
/


-- ============================================================================
-- DISPARADORES DE AUDITORIA (funcionalidad innovadora 8)
-- ============================================================================

-- Registran en AUDITORIA quién cambió qué y cuándo, con el valor anterior y el
-- nuevo, sobre inventario, despachos, entregas y validaciones de necesidades.
CREATE OR REPLACE TRIGGER TRG_AUD_INVENTARIO_LOTE
AFTER INSERT OR UPDATE OR DELETE ON INVENTARIO_LOTE
FOR EACH ROW
DECLARE
  v_operacion VARCHAR2(15);
  v_anterior  VARCHAR2(4000);
  v_nuevo     VARCHAR2(4000);
BEGIN
  IF INSERTING THEN
    v_operacion := 'Inserción';
  ELSIF UPDATING THEN
    v_operacion := 'Actualización';
  ELSE
    v_operacion := 'Eliminación';
  END IF;
  IF NOT INSERTING THEN
    v_anterior := 'lote=' || :OLD.cod_lote || '; insumo=' || :OLD.cod_insumo
               || '; centro=' || :OLD.cod_centro || '; disponible=' || :OLD.cantidad_disponible;
  END IF;
  IF NOT DELETING THEN
    v_nuevo := 'lote=' || :NEW.cod_lote || '; insumo=' || :NEW.cod_insumo
            || '; centro=' || :NEW.cod_centro || '; disponible=' || :NEW.cantidad_disponible;
  END IF;
  INSERT INTO AUDITORIA (cod_auditoria, tabla_afectada, operacion, usuario, fecha_hora, valor_anterior, valor_nuevo)
  VALUES (SEQ_AUDITORIA.NEXTVAL, 'INVENTARIO_LOTE', v_operacion, SUBSTR(USER, 1, 50), SYSDATE, v_anterior, v_nuevo);
END TRG_AUD_INVENTARIO_LOTE;
/

CREATE OR REPLACE TRIGGER TRG_AUD_DESPACHO
AFTER INSERT OR UPDATE OR DELETE ON DESPACHO
FOR EACH ROW
DECLARE
  v_operacion VARCHAR2(15);
  v_anterior  VARCHAR2(4000);
  v_nuevo     VARCHAR2(4000);
BEGIN
  IF INSERTING THEN
    v_operacion := 'Inserción';
  ELSIF UPDATING THEN
    v_operacion := 'Actualización';
  ELSE
    v_operacion := 'Eliminación';
  END IF;
  IF NOT INSERTING THEN
    v_anterior := 'despacho=' || :OLD.cod_despacho || '; estado=' || :OLD.estado
               || '; entrega=' || TO_CHAR(:OLD.fecha_entrega, 'DD/MM/YYYY')
               || '; recibido=' || :OLD.confirmacion_recibido;
  END IF;
  IF NOT DELETING THEN
    v_nuevo := 'despacho=' || :NEW.cod_despacho || '; estado=' || :NEW.estado
            || '; entrega=' || TO_CHAR(:NEW.fecha_entrega, 'DD/MM/YYYY')
            || '; recibido=' || :NEW.confirmacion_recibido;
  END IF;
  INSERT INTO AUDITORIA (cod_auditoria, tabla_afectada, operacion, usuario, fecha_hora, valor_anterior, valor_nuevo)
  VALUES (SEQ_AUDITORIA.NEXTVAL, 'DESPACHO', v_operacion, SUBSTR(USER, 1, 50), SYSDATE, v_anterior, v_nuevo);
END TRG_AUD_DESPACHO;
/

CREATE OR REPLACE TRIGGER TRG_AUD_ENTREGA
AFTER INSERT OR UPDATE OR DELETE ON ENTREGA
FOR EACH ROW
DECLARE
  v_operacion VARCHAR2(15);
  v_anterior  VARCHAR2(4000);
  v_nuevo     VARCHAR2(4000);
BEGIN
  IF INSERTING THEN
    v_operacion := 'Inserción';
  ELSIF UPDATING THEN
    v_operacion := 'Actualización';
  ELSE
    v_operacion := 'Eliminación';
  END IF;
  IF NOT INSERTING THEN
    v_anterior := 'entrega=' || :OLD.cod_entrega || '; despacho=' || :OLD.cod_despacho
               || '; insumo=' || :OLD.cod_insumo || '; cantidad=' || :OLD.cantidad
               || '; beneficiario=' || :OLD.cod_beneficiario || '; receptor=' || :OLD.cod_receptor;
  END IF;
  IF NOT DELETING THEN
    v_nuevo := 'entrega=' || :NEW.cod_entrega || '; despacho=' || :NEW.cod_despacho
            || '; insumo=' || :NEW.cod_insumo || '; cantidad=' || :NEW.cantidad
            || '; beneficiario=' || :NEW.cod_beneficiario || '; receptor=' || :NEW.cod_receptor;
  END IF;
  INSERT INTO AUDITORIA (cod_auditoria, tabla_afectada, operacion, usuario, fecha_hora, valor_anterior, valor_nuevo)
  VALUES (SEQ_AUDITORIA.NEXTVAL, 'ENTREGA', v_operacion, SUBSTR(USER, 1, 50), SYSDATE, v_anterior, v_nuevo);
END TRG_AUD_ENTREGA;
/

CREATE OR REPLACE TRIGGER TRG_AUD_NECESIDAD
AFTER INSERT OR UPDATE OR DELETE ON NECESIDAD_DAMNIFICADO
FOR EACH ROW
DECLARE
  v_operacion VARCHAR2(15);
  v_anterior  VARCHAR2(4000);
  v_nuevo     VARCHAR2(4000);
BEGIN
  IF INSERTING THEN
    v_operacion := 'Inserción';
  ELSIF UPDATING THEN
    v_operacion := 'Actualización';
  ELSE
    v_operacion := 'Eliminación';
  END IF;
  IF NOT INSERTING THEN
    v_anterior := 'necesidad=' || :OLD.cod_necesidad || '; damnificado=' || :OLD.cod_damnificado
               || '; categoria=' || :OLD.cod_categoria || '; estado=' || :OLD.estado
               || '; validador=' || :OLD.cod_validador;
  END IF;
  IF NOT DELETING THEN
    v_nuevo := 'necesidad=' || :NEW.cod_necesidad || '; damnificado=' || :NEW.cod_damnificado
            || '; categoria=' || :NEW.cod_categoria || '; estado=' || :NEW.estado
            || '; validador=' || :NEW.cod_validador;
  END IF;
  INSERT INTO AUDITORIA (cod_auditoria, tabla_afectada, operacion, usuario, fecha_hora, valor_anterior, valor_nuevo)
  VALUES (SEQ_AUDITORIA.NEXTVAL, 'NECESIDAD_DAMNIFICADO', v_operacion, SUBSTR(USER, 1, 50), SYSDATE, v_anterior, v_nuevo);
END TRG_AUD_NECESIDAD;
/


-- ============================================================================
-- VISTAS DE TRANSPARENCIA PUBLICA (funcionalidad innovadora 7)
-- ============================================================================

-- Información agregada para ciudadanía y donantes. No muestran nombres,
-- documentos ni necesidades de personas concretas.
CREATE OR REPLACE VIEW V_TRANSPARENCIA_ZONA AS
SELECT zon.nombre AS zona,
       mun.nombre AS municipio,
       zon.nivel_dano,
       zon.poblacion_riesgo,
       (SELECT COUNT(*)
        FROM CENSO cen, CENSO_DAMNIFICADO cda
        WHERE cda.cod_censo = cen.cod_censo
        AND cda.estado = 'Activo'
        AND cen.cod_zona = zon.cod_zona) AS personas_censadas,
       (SELECT COUNT(*)
        FROM ENTREGA ent, CENSO_DAMNIFICADO cda, CENSO cen
        WHERE cda.cod_damnificado = ent.cod_beneficiario
        AND cda.estado = 'Activo'
        AND cen.cod_censo = cda.cod_censo
        AND cen.cod_zona = zon.cod_zona) AS entregas_registradas,
       (SELECT COUNT(*)
        FROM NECESIDAD_DAMNIFICADO nda, CENSO_DAMNIFICADO cda, CENSO cen
        WHERE cda.cod_damnificado = nda.cod_damnificado
        AND cda.estado = 'Activo'
        AND cen.cod_censo = cda.cod_censo
        AND cen.cod_zona = zon.cod_zona
        AND nda.estado = 'Validada') AS necesidades_validadas,
       (SELECT COUNT(*)
        FROM NECESIDAD_DAMNIFICADO nda, CENSO_DAMNIFICADO cda, CENSO cen
        WHERE cda.cod_damnificado = nda.cod_damnificado
        AND cda.estado = 'Activo'
        AND cen.cod_censo = cda.cod_censo
        AND cen.cod_zona = zon.cod_zona
        AND nda.estado = 'Validada'
        AND EXISTS (SELECT 1 FROM ENTREGA ent WHERE ent.cod_necesidad = nda.cod_necesidad)) AS necesidades_atendidas
FROM ZONA_AFECTADA zon, MUNICIPIO mun
WHERE mun.cod_municipio = zon.cod_municipio;

CREATE OR REPLACE VIEW V_CUPOS_ALBERGUE AS
SELECT ins.nombre AS albergue,
       mun.nombre AS municipio,
       alb.capacidad_maxima,
       (SELECT COUNT(*)
        FROM FAMILIA_ALBERGUE fal, DAMNIFICADO dam
        WHERE fal.cod_albergue = alb.cod_instalacion
        AND fal.fecha_salida IS NULL
        AND dam.cod_familia = fal.cod_familia) AS personas_alojadas,
       alb.capacidad_maxima - (SELECT COUNT(*)
                               FROM FAMILIA_ALBERGUE fal, DAMNIFICADO dam
                               WHERE fal.cod_albergue = alb.cod_instalacion
                               AND fal.fecha_salida IS NULL
                               AND dam.cod_familia = fal.cod_familia) AS cupos_disponibles
FROM ALBERGUE alb, INSTALACION ins, MUNICIPIO mun
WHERE ins.cod_instalacion = alb.cod_instalacion
AND mun.cod_municipio = ins.cod_municipio;
