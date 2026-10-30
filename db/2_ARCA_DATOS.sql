-- ============================================================================
-- Script 2 de 3: datos de prueba
-- Escenario: terremoto de magnitud 7,4 del 03/10/2026 en el occidente de Colombia, con réplicas en Chocó, Valle del Cauca, Eje Cafetero y Santander.
-- Todos los datos de personas son ficticios.
-- Ejecutar después de 1_ARCA_OBJETOS.sql.
-- ============================================================================

-- ============================================================================
-- Datos tabla DEPARTAMENTO (10 registros)
-- ============================================================================

INSERT INTO DEPARTAMENTO (cod_departamento, nombre)
     VALUES ('05', 'Antioquia');
INSERT INTO DEPARTAMENTO (cod_departamento, nombre)
     VALUES ('17', 'Caldas');
INSERT INTO DEPARTAMENTO (cod_departamento, nombre)
     VALUES ('19', 'Cauca');
INSERT INTO DEPARTAMENTO (cod_departamento, nombre)
     VALUES ('27', 'Chocó');
INSERT INTO DEPARTAMENTO (cod_departamento, nombre)
     VALUES ('54', 'Norte de Santander');
INSERT INTO DEPARTAMENTO (cod_departamento, nombre)
     VALUES ('63', 'Quindío');
INSERT INTO DEPARTAMENTO (cod_departamento, nombre)
     VALUES ('66', 'Risaralda');
INSERT INTO DEPARTAMENTO (cod_departamento, nombre)
     VALUES ('68', 'Santander');
INSERT INTO DEPARTAMENTO (cod_departamento, nombre)
     VALUES ('73', 'Tolima');
INSERT INTO DEPARTAMENTO (cod_departamento, nombre)
     VALUES ('76', 'Valle del Cauca');


-- ============================================================================
-- Datos tabla MUNICIPIO (17 registros)
-- ============================================================================

INSERT INTO MUNICIPIO (cod_municipio, nombre, cod_departamento)
     VALUES ('05001', 'Medellín', '05');
INSERT INTO MUNICIPIO (cod_municipio, nombre, cod_departamento)
     VALUES ('17001', 'Manizales', '17');
INSERT INTO MUNICIPIO (cod_municipio, nombre, cod_departamento)
     VALUES ('19001', 'Popayán', '19');
INSERT INTO MUNICIPIO (cod_municipio, nombre, cod_departamento)
     VALUES ('27001', 'Quibdó', '27');
INSERT INTO MUNICIPIO (cod_municipio, nombre, cod_departamento)
     VALUES ('27075', 'Bahía Solano', '27');
INSERT INTO MUNICIPIO (cod_municipio, nombre, cod_departamento)
     VALUES ('27361', 'Istmina', '27');
INSERT INTO MUNICIPIO (cod_municipio, nombre, cod_departamento)
     VALUES ('54001', 'Cúcuta', '54');
INSERT INTO MUNICIPIO (cod_municipio, nombre, cod_departamento)
     VALUES ('63001', 'Armenia', '63');
INSERT INTO MUNICIPIO (cod_municipio, nombre, cod_departamento)
     VALUES ('63130', 'Calarcá', '63');
INSERT INTO MUNICIPIO (cod_municipio, nombre, cod_departamento)
     VALUES ('66001', 'Pereira', '66');
INSERT INTO MUNICIPIO (cod_municipio, nombre, cod_departamento)
     VALUES ('66170', 'Dosquebradas', '66');
INSERT INTO MUNICIPIO (cod_municipio, nombre, cod_departamento)
     VALUES ('68001', 'Bucaramanga', '68');
INSERT INTO MUNICIPIO (cod_municipio, nombre, cod_departamento)
     VALUES ('68276', 'Floridablanca', '68');
INSERT INTO MUNICIPIO (cod_municipio, nombre, cod_departamento)
     VALUES ('68547', 'Piedecuesta', '68');
INSERT INTO MUNICIPIO (cod_municipio, nombre, cod_departamento)
     VALUES ('73001', 'Ibagué', '73');
INSERT INTO MUNICIPIO (cod_municipio, nombre, cod_departamento)
     VALUES ('76001', 'Cali', '76');
INSERT INTO MUNICIPIO (cod_municipio, nombre, cod_departamento)
     VALUES ('76109', 'Buenaventura', '76');


-- ============================================================================
-- Datos tabla ZONA_AFECTADA (12 registros)
-- ============================================================================

INSERT INTO ZONA_AFECTADA (cod_zona, nombre, tipo_division, nivel_dano, poblacion_riesgo, pct_infraestructura_comprometida, falla_agua, falla_energia, cod_municipio)
     VALUES (1, 'Vereda Alto Llano', 'Vereda', 'Crítico', 850, 55, 'S', 'S', '68547');
INSERT INTO ZONA_AFECTADA (cod_zona, nombre, tipo_division, nivel_dano, poblacion_riesgo, pct_infraestructura_comprometida, falla_agua, falla_energia, cod_municipio)
     VALUES (2, 'Quibdó', 'Municipio', 'Crítico', 42000, 62, 'S', 'S', '27001');
INSERT INTO ZONA_AFECTADA (cod_zona, nombre, tipo_division, nivel_dano, poblacion_riesgo, pct_infraestructura_comprometida, falla_agua, falla_energia, cod_municipio)
     VALUES (3, 'Istmina', 'Municipio', 'Alto', 9500, 38, 'S', 'N', '27361');
INSERT INTO ZONA_AFECTADA (cod_zona, nombre, tipo_division, nivel_dano, poblacion_riesgo, pct_infraestructura_comprometida, falla_agua, falla_energia, cod_municipio)
     VALUES (4, 'Bahía Solano', 'Municipio', 'Crítico', 6100, 30, 'S', 'S', '27075');
INSERT INTO ZONA_AFECTADA (cod_zona, nombre, tipo_division, nivel_dano, poblacion_riesgo, pct_infraestructura_comprometida, falla_agua, falla_energia, cod_municipio)
     VALUES (5, 'Comuna 12 Buenaventura', 'Comuna', 'Alto', 18000, 35, 'N', 'S', '76109');
INSERT INTO ZONA_AFECTADA (cod_zona, nombre, tipo_division, nivel_dano, poblacion_riesgo, pct_infraestructura_comprometida, falla_agua, falla_energia, cod_municipio)
     VALUES (6, 'Comuna 20 Siloé', 'Comuna', 'Medio', 12000, 18, 'N', 'N', '76001');
INSERT INTO ZONA_AFECTADA (cod_zona, nombre, tipo_division, nivel_dano, poblacion_riesgo, pct_infraestructura_comprometida, falla_agua, falla_energia, cod_municipio)
     VALUES (7, 'Comuna Río Otún', 'Comuna', 'Medio', 7000, 22, 'N', 'S', '66001');
INSERT INTO ZONA_AFECTADA (cod_zona, nombre, tipo_division, nivel_dano, poblacion_riesgo, pct_infraestructura_comprometida, falla_agua, falla_energia, cod_municipio)
     VALUES (8, 'Dosquebradas', 'Municipio', 'Bajo', 3000, 8, 'N', 'N', '66170');
INSERT INTO ZONA_AFECTADA (cod_zona, nombre, tipo_division, nivel_dano, poblacion_riesgo, pct_infraestructura_comprometida, falla_agua, falla_energia, cod_municipio)
     VALUES (9, 'Comuna San José', 'Comuna', 'Alto', 5200, 41, 'N', 'N', '17001');
INSERT INTO ZONA_AFECTADA (cod_zona, nombre, tipo_division, nivel_dano, poblacion_riesgo, pct_infraestructura_comprometida, falla_agua, falla_energia, cod_municipio)
     VALUES (10, 'Calarcá', 'Municipio', 'Medio', 4100, 15, 'N', 'N', '63130');
INSERT INTO ZONA_AFECTADA (cod_zona, nombre, tipo_division, nivel_dano, poblacion_riesgo, pct_infraestructura_comprometida, falla_agua, falla_energia, cod_municipio)
     VALUES (11, 'Vereda Helechales', 'Vereda', 'Medio', 900, 20, 'N', 'N', '68276');
INSERT INTO ZONA_AFECTADA (cod_zona, nombre, tipo_division, nivel_dano, poblacion_riesgo, pct_infraestructura_comprometida, falla_agua, falla_energia, cod_municipio)
     VALUES (12, 'Comuna 14 Morrorico', 'Comuna', 'Bajo', 2500, 6, 'N', 'N', '68001');


-- ============================================================================
-- Datos tabla TIPO_DOCUMENTO (12 registros)
-- ============================================================================

INSERT INTO TIPO_DOCUMENTO (cod_tipo_documento, nombre)
     VALUES ('CC', 'Cédula de ciudadanía');
INSERT INTO TIPO_DOCUMENTO (cod_tipo_documento, nombre)
     VALUES ('TI', 'Tarjeta de identidad');
INSERT INTO TIPO_DOCUMENTO (cod_tipo_documento, nombre)
     VALUES ('RC', 'Registro civil de nacimiento');
INSERT INTO TIPO_DOCUMENTO (cod_tipo_documento, nombre)
     VALUES ('CE', 'Cédula de extranjería');
INSERT INTO TIPO_DOCUMENTO (cod_tipo_documento, nombre)
     VALUES ('PA', 'Pasaporte');
INSERT INTO TIPO_DOCUMENTO (cod_tipo_documento, nombre)
     VALUES ('PE', 'Permiso especial de permanencia');
INSERT INTO TIPO_DOCUMENTO (cod_tipo_documento, nombre)
     VALUES ('PT', 'Permiso por protección temporal');
INSERT INTO TIPO_DOCUMENTO (cod_tipo_documento, nombre)
     VALUES ('SC', 'Salvoconducto de permanencia');
INSERT INTO TIPO_DOCUMENTO (cod_tipo_documento, nombre)
     VALUES ('CD', 'Carné diplomático');
INSERT INTO TIPO_DOCUMENTO (cod_tipo_documento, nombre)
     VALUES ('CN', 'Certificado de nacido vivo');
INSERT INTO TIPO_DOCUMENTO (cod_tipo_documento, nombre)
     VALUES ('AS', 'Adulto sin identificación');
INSERT INTO TIPO_DOCUMENTO (cod_tipo_documento, nombre)
     VALUES ('MS', 'Menor sin identificación');


-- ============================================================================
-- Datos tabla PERSONA (52 registros)
-- ============================================================================

INSERT INTO PERSONA (cod_persona, num_documento, nombres, apellidos, fecha_nacimiento, cod_tipo_documento)
     VALUES (1001, '63500111', 'Ana María', 'Ruiz Peña', TO_DATE('12/03/1958', 'DD/MM/YYYY'), 'CC');
INSERT INTO PERSONA (cod_persona, num_documento, nombres, apellidos, fecha_nacimiento, cod_tipo_documento)
     VALUES (1002, '1098700222', 'Luis', 'Ruiz Peña', TO_DATE('20/07/2014', 'DD/MM/YYYY'), 'TI');
INSERT INTO PERSONA (cod_persona, num_documento, nombres, apellidos, fecha_nacimiento, cod_tipo_documento)
     VALUES (1003, '63512345', 'Martha Lucía', 'Ruiz Peña', TO_DATE('04/05/1988', 'DD/MM/YYYY'), 'CC');
INSERT INTO PERSONA (cod_persona, num_documento, nombres, apellidos, fecha_nacimiento, cod_tipo_documento)
     VALUES (1004, '91200333', 'Jorge', 'Díaz Rueda', TO_DATE('02/11/1980', 'DD/MM/YYYY'), 'CC');
INSERT INTO PERSONA (cod_persona, num_documento, nombres, apellidos, fecha_nacimiento, cod_tipo_documento)
     VALUES (1005, '1098900444', 'Sara', 'Díaz Gómez', TO_DATE('15/01/2025', 'DD/MM/YYYY'), 'RC');
INSERT INTO PERSONA (cod_persona, num_documento, nombres, apellidos, fecha_nacimiento, cod_tipo_documento)
     VALUES (1006, '1098654321', 'Laura Marcela', 'Gómez Ardila', TO_DATE('09/09/1993', 'DD/MM/YYYY'), 'CC');
INSERT INTO PERSONA (cod_persona, num_documento, nombres, apellidos, fecha_nacimiento, cod_tipo_documento)
     VALUES (1007, '13800555', 'Pedro', 'Gómez León', TO_DATE('30/05/1990', 'DD/MM/YYYY'), 'CC');
INSERT INTO PERSONA (cod_persona, num_documento, nombres, apellidos, fecha_nacimiento, cod_tipo_documento)
     VALUES (1008, '1098765432', 'Rosa Elena', 'Delgado Mantilla', TO_DATE('14/02/1992', 'DD/MM/YYYY'), 'CC');
INSERT INTO PERSONA (cod_persona, num_documento, nombres, apellidos, fecha_nacimiento, cod_tipo_documento)
     VALUES (1009, '1097111222', 'Tomás', 'Gómez Delgado', TO_DATE('22/08/2021', 'DD/MM/YYYY'), 'RC');
INSERT INTO PERSONA (cod_persona, num_documento, nombres, apellidos, fecha_nacimiento, cod_tipo_documento)
     VALUES (1010, '1077432100', 'Yeison', 'Mosquera Palacios', TO_DATE('10/06/1988', 'DD/MM/YYYY'), 'CC');
INSERT INTO PERSONA (cod_persona, num_documento, nombres, apellidos, fecha_nacimiento, cod_tipo_documento)
     VALUES (1011, '35600222', 'Luz Dary', 'Palacios Córdoba', TO_DATE('18/11/1990', 'DD/MM/YYYY'), 'CC');
INSERT INTO PERSONA (cod_persona, num_documento, nombres, apellidos, fecha_nacimiento, cod_tipo_documento)
     VALUES (1012, '1077999888', 'Kevin', 'Mosquera Palacios', TO_DATE('03/03/2012', 'DD/MM/YYYY'), 'TI');
INSERT INTO PERSONA (cod_persona, num_documento, nombres, apellidos, fecha_nacimiento, cod_tipo_documento)
     VALUES (1013, NULL, 'Ángel', 'Mosquera Palacios', TO_DATE('25/12/2023', 'DD/MM/YYYY'), 'MS');
INSERT INTO PERSONA (cod_persona, num_documento, nombres, apellidos, fecha_nacimiento, cod_tipo_documento)
     VALUES (1014, '26300444', 'Esneda', 'Rentería Asprilla', TO_DATE('07/07/1950', 'DD/MM/YYYY'), 'CC');
INSERT INTO PERSONA (cod_persona, num_documento, nombres, apellidos, fecha_nacimiento, cod_tipo_documento)
     VALUES (1015, '11800555', 'Wilmar', 'Rentería Asprilla', TO_DATE('12/12/1975', 'DD/MM/YYYY'), 'CC');
INSERT INTO PERSONA (cod_persona, num_documento, nombres, apellidos, fecha_nacimiento, cod_tipo_documento)
     VALUES (1016, '35700666', 'Nelly Johana', 'Valencia Murillo', TO_DATE('21/04/1997', 'DD/MM/YYYY'), 'CC');
INSERT INTO PERSONA (cod_persona, num_documento, nombres, apellidos, fecha_nacimiento, cod_tipo_documento)
     VALUES (1017, '1078333444', 'Jhon Fredy', 'Valencia Murillo', TO_DATE('30/09/2010', 'DD/MM/YYYY'), 'TI');
INSERT INTO PERSONA (cod_persona, num_documento, nombres, apellidos, fecha_nacimiento, cod_tipo_documento)
     VALUES (1018, '1078555666', 'Daniela', 'Cuesta Moreno', TO_DATE('15/05/2011', 'DD/MM/YYYY'), 'TI');
INSERT INTO PERSONA (cod_persona, num_documento, nombres, apellidos, fecha_nacimiento, cod_tipo_documento)
     VALUES (1019, '4800777', 'Fabio', 'Hinestroza Perea', TO_DATE('02/02/1960', 'DD/MM/YYYY'), 'CC');
INSERT INTO PERSONA (cod_persona, num_documento, nombres, apellidos, fecha_nacimiento, cod_tipo_documento)
     VALUES (1020, '26900888', 'Gloria', 'Perea de Hinestroza', TO_DATE('19/08/1962', 'DD/MM/YYYY'), 'CC');
INSERT INTO PERSONA (cod_persona, num_documento, nombres, apellidos, fecha_nacimiento, cod_tipo_documento)
     VALUES (1021, '16500999', 'Marlon', 'Angulo Caicedo', TO_DATE('11/01/1983', 'DD/MM/YYYY'), 'CC');
INSERT INTO PERSONA (cod_persona, num_documento, nombres, apellidos, fecha_nacimiento, cod_tipo_documento)
     VALUES (1022, '1111222333', 'Yuliana', 'Caicedo Riascos', TO_DATE('05/05/2000', 'DD/MM/YYYY'), 'CC');
INSERT INTO PERSONA (cod_persona, num_documento, nombres, apellidos, fecha_nacimiento, cod_tipo_documento)
     VALUES (1023, '1111444555', 'Samuel', 'Angulo Caicedo', TO_DATE('20/08/2025', 'DD/MM/YYYY'), 'RC');
INSERT INTO PERSONA (cod_persona, num_documento, nombres, apellidos, fecha_nacimiento, cod_tipo_documento)
     VALUES (1024, '94400111', 'Héctor Fabio', 'Quiñones Ortiz', TO_DATE('13/03/1970', 'DD/MM/YYYY'), 'CC');
INSERT INTO PERSONA (cod_persona, num_documento, nombres, apellidos, fecha_nacimiento, cod_tipo_documento)
     VALUES (1025, '5567890', 'Adriana', 'Ortiz Lasso', TO_DATE('27/10/1972', 'DD/MM/YYYY'), 'PT');
INSERT INTO PERSONA (cod_persona, num_documento, nombres, apellidos, fecha_nacimiento, cod_tipo_documento)
     VALUES (1026, '75100333', 'Julián', 'Ospina Arango', TO_DATE('08/08/1995', 'DD/MM/YYYY'), 'CC');
INSERT INTO PERSONA (cod_persona, num_documento, nombres, apellidos, fecha_nacimiento, cod_tipo_documento)
     VALUES (1027, '1053777888', 'Valentina', 'Arango Giraldo', TO_DATE('16/12/1998', 'DD/MM/YYYY'), 'CC');
INSERT INTO PERSONA (cod_persona, num_documento, nombres, apellidos, fecha_nacimiento, cod_tipo_documento)
     VALUES (1028, '10200444', 'Rubén Darío', 'Cardona Henao', TO_DATE('04/04/1957', 'DD/MM/YYYY'), 'CC');
INSERT INTO PERSONA (cod_persona, num_documento, nombres, apellidos, fecha_nacimiento, cod_tipo_documento)
     VALUES (1029, '42000555', 'Amparo', 'Henao Ríos', TO_DATE('23/09/1959', 'DD/MM/YYYY'), 'CC');
INSERT INTO PERSONA (cod_persona, num_documento, nombres, apellidos, fecha_nacimiento, cod_tipo_documento)
     VALUES (1030, NULL, 'José Antonio', 'Rentería Mena', TO_DATE('17/03/1968', 'DD/MM/YYYY'), 'AS');
INSERT INTO PERSONA (cod_persona, num_documento, nombres, apellidos, fecha_nacimiento, cod_tipo_documento)
     VALUES (1031, '1088111222', 'Mateo', 'Cardona Vélez', TO_DATE('10/10/2013', 'DD/MM/YYYY'), 'TI');
INSERT INTO PERSONA (cod_persona, num_documento, nombres, apellidos, fecha_nacimiento, cod_tipo_documento)
     VALUES (1032, '1088333444', 'Sofía', 'Cardona Vélez', TO_DATE('02/02/2022', 'DD/MM/YYYY'), 'RC');
INSERT INTO PERSONA (cod_persona, num_documento, nombres, apellidos, fecha_nacimiento, cod_tipo_documento)
     VALUES (2001, '1098600777', 'Carlos', 'Pinto Rojas', TO_DATE('14/06/1985', 'DD/MM/YYYY'), 'CC');
INSERT INTO PERSONA (cod_persona, num_documento, nombres, apellidos, fecha_nacimiento, cod_tipo_documento)
     VALUES (2002, '63540111', 'María', 'Torres Silva', TO_DATE('22/01/1979', 'DD/MM/YYYY'), 'CC');
INSERT INTO PERSONA (cod_persona, num_documento, nombres, apellidos, fecha_nacimiento, cod_tipo_documento)
     VALUES (2003, '37800222', 'Diana Patricia', 'Rueda Méndez', TO_DATE('03/09/1982', 'DD/MM/YYYY'), 'CC');
INSERT INTO PERSONA (cod_persona, num_documento, nombres, apellidos, fecha_nacimiento, cod_tipo_documento)
     VALUES (2004, '91500333', 'Andrés Felipe', 'Serrano Lozano', TO_DATE('17/02/1984', 'DD/MM/YYYY'), 'CC');
INSERT INTO PERSONA (cod_persona, num_documento, nombres, apellidos, fecha_nacimiento, cod_tipo_documento)
     VALUES (2005, '1098111444', 'Paola Andrea', 'Castro Niño', TO_DATE('29/07/1994', 'DD/MM/YYYY'), 'CC');
INSERT INTO PERSONA (cod_persona, num_documento, nombres, apellidos, fecha_nacimiento, cod_tipo_documento)
     VALUES (2006, '1098222555', 'Luisa Fernanda', 'Prada Ortiz', TO_DATE('11/11/1990', 'DD/MM/YYYY'), 'CC');
INSERT INTO PERSONA (cod_persona, num_documento, nombres, apellidos, fecha_nacimiento, cod_tipo_documento)
     VALUES (2007, '1098333666', 'Camilo Ernesto', 'Vargas Pinzón', TO_DATE('05/04/1992', 'DD/MM/YYYY'), 'CC');
INSERT INTO PERSONA (cod_persona, num_documento, nombres, apellidos, fecha_nacimiento, cod_tipo_documento)
     VALUES (2008, '1098444777', 'Natalia', 'Suárez Becerra', TO_DATE('23/10/1996', 'DD/MM/YYYY'), 'CC');
INSERT INTO PERSONA (cod_persona, num_documento, nombres, apellidos, fecha_nacimiento, cod_tipo_documento)
     VALUES (2009, '1077555888', 'Óscar Iván', 'Mena Lozano', TO_DATE('08/03/1987', 'DD/MM/YYYY'), 'CC');
INSERT INTO PERSONA (cod_persona, num_documento, nombres, apellidos, fecha_nacimiento, cod_tipo_documento)
     VALUES (2010, '1077666999', 'Yesenia', 'Córdoba Lemos', TO_DATE('15/12/1989', 'DD/MM/YYYY'), 'CC');
INSERT INTO PERSONA (cod_persona, num_documento, nombres, apellidos, fecha_nacimiento, cod_tipo_documento)
     VALUES (2011, '16600111', 'Ramiro', 'Hurtado Valencia', TO_DATE('26/05/1978', 'DD/MM/YYYY'), 'CC');
INSERT INTO PERSONA (cod_persona, num_documento, nombres, apellidos, fecha_nacimiento, cod_tipo_documento)
     VALUES (2012, '30300222', 'Sandra Milena', 'Ocampo Ríos', TO_DATE('09/08/1981', 'DD/MM/YYYY'), 'CC');
INSERT INTO PERSONA (cod_persona, num_documento, nombres, apellidos, fecha_nacimiento, cod_tipo_documento)
     VALUES (2013, '16700333', 'Jaime Andrés', 'Riascos Angulo', TO_DATE('01/03/1986', 'DD/MM/YYYY'), 'CC');
INSERT INTO PERSONA (cod_persona, num_documento, nombres, apellidos, fecha_nacimiento, cod_tipo_documento)
     VALUES (2014, '31950444', 'Mónica', 'Lasso Bermúdez', TO_DATE('18/06/1983', 'DD/MM/YYYY'), 'CC');
INSERT INTO PERSONA (cod_persona, num_documento, nombres, apellidos, fecha_nacimiento, cod_tipo_documento)
     VALUES (2015, '1077888000', 'Edwin', 'Palacios Mosquera', TO_DATE('12/09/1993', 'DD/MM/YYYY'), 'CC');
INSERT INTO PERSONA (cod_persona, num_documento, nombres, apellidos, fecha_nacimiento, cod_tipo_documento)
     VALUES (2016, '75200555', 'Gustavo Adolfo', 'Henao Marín', TO_DATE('30/01/1980', 'DD/MM/YYYY'), 'CC');
INSERT INTO PERSONA (cod_persona, num_documento, nombres, apellidos, fecha_nacimiento, cod_tipo_documento)
     VALUES (2017, '24300666', 'Liliana', 'Patiño Gil', TO_DATE('07/07/1988', 'DD/MM/YYYY'), 'CC');
INSERT INTO PERSONA (cod_persona, num_documento, nombres, apellidos, fecha_nacimiento, cod_tipo_documento)
     VALUES (2018, '1098999111', 'Fernando José', 'Ruiz Cárdenas', TO_DATE('21/02/1991', 'DD/MM/YYYY'), 'CC');
INSERT INTO PERSONA (cod_persona, num_documento, nombres, apellidos, fecha_nacimiento, cod_tipo_documento)
     VALUES (2019, '1053111222', 'Paula', 'Gómez Quintero', TO_DATE('13/05/1994', 'DD/MM/YYYY'), 'CC');
INSERT INTO PERSONA (cod_persona, num_documento, nombres, apellidos, fecha_nacimiento, cod_tipo_documento)
     VALUES (2020, '10250333', 'Hernán Darío', 'Arias Ochoa', TO_DATE('04/11/1977', 'DD/MM/YYYY'), 'CC');


-- ============================================================================
-- Datos tabla INSTITUCION (10 registros)
-- ============================================================================

INSERT INTO INSTITUCION (cod_institucion, nombre)
     VALUES (1, 'Cruz Roja Colombiana');
INSERT INTO INSTITUCION (cod_institucion, nombre)
     VALUES (2, 'Cuerpo de Bomberos');
INSERT INTO INSTITUCION (cod_institucion, nombre)
     VALUES (3, 'Defensa Civil Colombiana');
INSERT INTO INSTITUCION (cod_institucion, nombre)
     VALUES (4, 'UNGRD');
INSERT INTO INSTITUCION (cod_institucion, nombre)
     VALUES (5, 'Ejército Nacional');
INSERT INTO INSTITUCION (cod_institucion, nombre)
     VALUES (6, 'Policía Nacional');
INSERT INTO INSTITUCION (cod_institucion, nombre)
     VALUES (7, 'Armada Nacional');
INSERT INTO INSTITUCION (cod_institucion, nombre)
     VALUES (8, 'Secretaría de Salud Departamental');
INSERT INTO INSTITUCION (cod_institucion, nombre)
     VALUES (9, 'ICBF');
INSERT INTO INSTITUCION (cod_institucion, nombre)
     VALUES (10, 'Médicos Sin Fronteras');


-- ============================================================================
-- Datos tabla ESPECIALIDAD (12 registros)
-- ============================================================================

INSERT INTO ESPECIALIDAD (cod_especialidad, nombre, tipo)
     VALUES (1, 'Medicina general', 'Médica');
INSERT INTO ESPECIALIDAD (cod_especialidad, nombre, tipo)
     VALUES (2, 'Enfermería', 'Médica');
INSERT INTO ESPECIALIDAD (cod_especialidad, nombre, tipo)
     VALUES (3, 'Pediatría', 'Médica');
INSERT INTO ESPECIALIDAD (cod_especialidad, nombre, tipo)
     VALUES (4, 'Ginecología y obstetricia', 'Médica');
INSERT INTO ESPECIALIDAD (cod_especialidad, nombre, tipo)
     VALUES (5, 'Psicología', 'Médica');
INSERT INTO ESPECIALIDAD (cod_especialidad, nombre, tipo)
     VALUES (6, 'Fisioterapia', 'Médica');
INSERT INTO ESPECIALIDAD (cod_especialidad, nombre, tipo)
     VALUES (7, 'Nutrición y dietética', 'Médica');
INSERT INTO ESPECIALIDAD (cod_especialidad, nombre, tipo)
     VALUES (8, 'Trabajo social', 'Técnica');
INSERT INTO ESPECIALIDAD (cod_especialidad, nombre, tipo)
     VALUES (9, 'Rescate en estructuras colapsadas', 'Técnica');
INSERT INTO ESPECIALIDAD (cod_especialidad, nombre, tipo)
     VALUES (10, 'Logística humanitaria', 'Técnica');
INSERT INTO ESPECIALIDAD (cod_especialidad, nombre, tipo)
     VALUES (11, 'Conducción de vehículos de emergencia', 'Técnica');
INSERT INTO ESPECIALIDAD (cod_especialidad, nombre, tipo)
     VALUES (12, 'Atención prehospitalaria', 'Médica');


-- ============================================================================
-- Datos tabla PERSONAL_SOCORRO (20 registros)
-- ============================================================================

INSERT INTO PERSONAL_SOCORRO (cod_persona, tipo_personal, disponibilidad, cod_institucion, cod_especialidad)
     VALUES (2001, 'Conductor', 'Asignado', 3, 11);
INSERT INTO PERSONAL_SOCORRO (cod_persona, tipo_personal, disponibilidad, cod_institucion, cod_especialidad)
     VALUES (2002, 'Coordinador', 'Asignado', 1, 10);
INSERT INTO PERSONAL_SOCORRO (cod_persona, tipo_personal, disponibilidad, cod_institucion, cod_especialidad)
     VALUES (2003, 'Coordinador', 'Asignado', 4, 10);
INSERT INTO PERSONAL_SOCORRO (cod_persona, tipo_personal, disponibilidad, cod_institucion, cod_especialidad)
     VALUES (2004, 'Brigadista', 'Asignado', 1, 1);
INSERT INTO PERSONAL_SOCORRO (cod_persona, tipo_personal, disponibilidad, cod_institucion, cod_especialidad)
     VALUES (2005, 'Brigadista', 'Asignado', 1, 2);
INSERT INTO PERSONAL_SOCORRO (cod_persona, tipo_personal, disponibilidad, cod_institucion, cod_especialidad)
     VALUES (2006, 'Voluntario', 'Asignado', 8, 4);
INSERT INTO PERSONAL_SOCORRO (cod_persona, tipo_personal, disponibilidad, cod_institucion, cod_especialidad)
     VALUES (2007, 'Voluntario', 'Asignado', 9, 5);
INSERT INTO PERSONAL_SOCORRO (cod_persona, tipo_personal, disponibilidad, cod_institucion, cod_especialidad)
     VALUES (2008, 'Brigadista', 'Asignado', 1, 6);
INSERT INTO PERSONAL_SOCORRO (cod_persona, tipo_personal, disponibilidad, cod_institucion, cod_especialidad)
     VALUES (2009, 'Rescatista', 'Asignado', 2, 9);
INSERT INTO PERSONAL_SOCORRO (cod_persona, tipo_personal, disponibilidad, cod_institucion, cod_especialidad)
     VALUES (2010, 'Coordinador', 'Asignado', 3, 10);
INSERT INTO PERSONAL_SOCORRO (cod_persona, tipo_personal, disponibilidad, cod_institucion, cod_especialidad)
     VALUES (2011, 'Rescatista', 'Asignado', 2, 9);
INSERT INTO PERSONAL_SOCORRO (cod_persona, tipo_personal, disponibilidad, cod_institucion, cod_especialidad)
     VALUES (2012, 'Coordinador', 'Asignado', 4, 10);
INSERT INTO PERSONAL_SOCORRO (cod_persona, tipo_personal, disponibilidad, cod_institucion, cod_especialidad)
     VALUES (2013, 'Conductor', 'Asignado', 7, 11);
INSERT INTO PERSONAL_SOCORRO (cod_persona, tipo_personal, disponibilidad, cod_institucion, cod_especialidad)
     VALUES (2014, 'Brigadista', 'Asignado', 1, 12);
INSERT INTO PERSONAL_SOCORRO (cod_persona, tipo_personal, disponibilidad, cod_institucion, cod_especialidad)
     VALUES (2015, 'Voluntario', 'Asignado', 3, NULL);
INSERT INTO PERSONAL_SOCORRO (cod_persona, tipo_personal, disponibilidad, cod_institucion, cod_especialidad)
     VALUES (2016, 'Rescatista', 'Asignado', 5, 9);
INSERT INTO PERSONAL_SOCORRO (cod_persona, tipo_personal, disponibilidad, cod_institucion, cod_especialidad)
     VALUES (2017, 'Brigadista', 'Asignado', 10, 8);
INSERT INTO PERSONAL_SOCORRO (cod_persona, tipo_personal, disponibilidad, cod_institucion, cod_especialidad)
     VALUES (2018, 'Conductor', 'Asignado', 2, 11);
INSERT INTO PERSONAL_SOCORRO (cod_persona, tipo_personal, disponibilidad, cod_institucion, cod_especialidad)
     VALUES (2019, 'Rescatista', 'Asignado', 6, 12);
INSERT INTO PERSONAL_SOCORRO (cod_persona, tipo_personal, disponibilidad, cod_institucion, cod_especialidad)
     VALUES (2020, 'Coordinador', 'Disponible', 1, 10);


-- ============================================================================
-- Datos tabla FAMILIA (13 registros)
-- ============================================================================

INSERT INTO FAMILIA (cod_familia)
     VALUES (1);
INSERT INTO FAMILIA (cod_familia)
     VALUES (2);
INSERT INTO FAMILIA (cod_familia)
     VALUES (3);
INSERT INTO FAMILIA (cod_familia)
     VALUES (4);
INSERT INTO FAMILIA (cod_familia)
     VALUES (5);
INSERT INTO FAMILIA (cod_familia)
     VALUES (6);
INSERT INTO FAMILIA (cod_familia)
     VALUES (7);
INSERT INTO FAMILIA (cod_familia)
     VALUES (8);
INSERT INTO FAMILIA (cod_familia)
     VALUES (9);
INSERT INTO FAMILIA (cod_familia)
     VALUES (10);
INSERT INTO FAMILIA (cod_familia)
     VALUES (11);
INSERT INTO FAMILIA (cod_familia)
     VALUES (12);
INSERT INTO FAMILIA (cod_familia)
     VALUES (13);


-- ============================================================================
-- Datos tabla DAMNIFICADO (33 registros)
-- ============================================================================

INSERT INTO DAMNIFICADO (cod_persona, codigo_censo, cod_familia)
     VALUES (1001, '4821', 1);
INSERT INTO DAMNIFICADO (cod_persona, codigo_censo, cod_familia)
     VALUES (1002, '4822', 1);
INSERT INTO DAMNIFICADO (cod_persona, codigo_censo, cod_familia)
     VALUES (1003, '4825', 1);
INSERT INTO DAMNIFICADO (cod_persona, codigo_censo, cod_familia)
     VALUES (1004, '4823', 2);
INSERT INTO DAMNIFICADO (cod_persona, codigo_censo, cod_familia)
     VALUES (1005, '4824', 2);
INSERT INTO DAMNIFICADO (cod_persona, codigo_censo, cod_familia)
     VALUES (1006, '4826', 2);
INSERT INTO DAMNIFICADO (cod_persona, codigo_censo, cod_familia)
     VALUES (1007, '4831', 3);
INSERT INTO DAMNIFICADO (cod_persona, codigo_censo, cod_familia)
     VALUES (1008, '4832', 3);
INSERT INTO DAMNIFICADO (cod_persona, codigo_censo, cod_familia)
     VALUES (1009, '4833', 3);
INSERT INTO DAMNIFICADO (cod_persona, codigo_censo, cod_familia)
     VALUES (1010, '5101', 4);
INSERT INTO DAMNIFICADO (cod_persona, codigo_censo, cod_familia)
     VALUES (1011, '5102', 4);
INSERT INTO DAMNIFICADO (cod_persona, codigo_censo, cod_familia)
     VALUES (1012, '5103', 4);
INSERT INTO DAMNIFICADO (cod_persona, codigo_censo, cod_familia)
     VALUES (1013, '5104', 4);
INSERT INTO DAMNIFICADO (cod_persona, codigo_censo, cod_familia)
     VALUES (1014, '5201', 5);
INSERT INTO DAMNIFICADO (cod_persona, codigo_censo, cod_familia)
     VALUES (1015, '5202', 5);
INSERT INTO DAMNIFICADO (cod_persona, codigo_censo, cod_familia)
     VALUES (1030, '5203', 5);
INSERT INTO DAMNIFICADO (cod_persona, codigo_censo, cod_familia)
     VALUES (1016, '5301', 6);
INSERT INTO DAMNIFICADO (cod_persona, codigo_censo, cod_familia)
     VALUES (1017, '5302', 6);
INSERT INTO DAMNIFICADO (cod_persona, codigo_censo, cod_familia)
     VALUES (1018, '5303', 7);
INSERT INTO DAMNIFICADO (cod_persona, codigo_censo, cod_familia)
     VALUES (1019, '5401', 8);
INSERT INTO DAMNIFICADO (cod_persona, codigo_censo, cod_familia)
     VALUES (1020, '5402', 8);
INSERT INTO DAMNIFICADO (cod_persona, codigo_censo, cod_familia)
     VALUES (1021, '5501', 9);
INSERT INTO DAMNIFICADO (cod_persona, codigo_censo, cod_familia)
     VALUES (1022, '5502', 9);
INSERT INTO DAMNIFICADO (cod_persona, codigo_censo, cod_familia)
     VALUES (1023, '5503', 9);
INSERT INTO DAMNIFICADO (cod_persona, codigo_censo, cod_familia)
     VALUES (1024, '5601', 10);
INSERT INTO DAMNIFICADO (cod_persona, codigo_censo, cod_familia)
     VALUES (1025, '5602', 10);
INSERT INTO DAMNIFICADO (cod_persona, codigo_censo, cod_familia)
     VALUES (1026, '5701', 11);
INSERT INTO DAMNIFICADO (cod_persona, codigo_censo, cod_familia)
     VALUES (1027, '5702', 11);
INSERT INTO DAMNIFICADO (cod_persona, codigo_censo, cod_familia)
     VALUES (1028, '5801', 12);
INSERT INTO DAMNIFICADO (cod_persona, codigo_censo, cod_familia)
     VALUES (1029, '5802', 12);
INSERT INTO DAMNIFICADO (cod_persona, codigo_censo, cod_familia)
     VALUES (1031, '5803', 12);
INSERT INTO DAMNIFICADO (cod_persona, codigo_censo, cod_familia)
     VALUES (1032, '5804', 12);
INSERT INTO DAMNIFICADO (cod_persona, codigo_censo, cod_familia)
     VALUES (2015, '5204', 13);


-- ============================================================================
-- Datos tabla INSTALACION (30 registros)
-- ============================================================================

INSERT INTO INSTALACION (cod_instalacion, nombre, direccion, cod_municipio, cod_coordinador)
     VALUES (101, 'Coliseo Municipal de Piedecuesta', 'Calle 10 # 5-20', '68547', 2002);
INSERT INTO INSTALACION (cod_instalacion, nombre, direccion, cod_municipio, cod_coordinador)
     VALUES (102, 'Escuela Alto Llano', 'Vereda Alto Llano, sede escolar', '68547', 2002);
INSERT INTO INSTALACION (cod_instalacion, nombre, direccion, cod_municipio, cod_coordinador)
     VALUES (103, 'Coliseo Cubierto de Quibdó', 'Carrera 1 # 25-40', '27001', 2010);
INSERT INTO INSTALACION (cod_instalacion, nombre, direccion, cod_municipio, cod_coordinador)
     VALUES (104, 'Institución Educativa de Istmina', 'Calle 3 # 8-15', '27361', 2010);
INSERT INTO INSTALACION (cod_instalacion, nombre, direccion, cod_municipio, cod_coordinador)
     VALUES (105, 'Albergue Bahía Solano Centro', 'Barrio El Carmen, frente al muelle', '27075', 2010);
INSERT INTO INSTALACION (cod_instalacion, nombre, direccion, cod_municipio, cod_coordinador)
     VALUES (106, 'Polideportivo de Buenaventura', 'Avenida Simón Bolívar km 9', '76109', 2020);
INSERT INTO INSTALACION (cod_instalacion, nombre, direccion, cod_municipio, cod_coordinador)
     VALUES (107, 'Coliseo de Siloé', 'Calle 2 Oeste # 50-12', '76001', 2020);
INSERT INTO INSTALACION (cod_instalacion, nombre, direccion, cod_municipio, cod_coordinador)
     VALUES (108, 'Casa Comunal Río Otún', 'Carrera 9 # 48-30', '66001', 2012);
INSERT INTO INSTALACION (cod_instalacion, nombre, direccion, cod_municipio, cod_coordinador)
     VALUES (109, 'Coliseo Mayor de Manizales', 'Avenida Santander # 45-10', '17001', 2012);
INSERT INTO INSTALACION (cod_instalacion, nombre, direccion, cod_municipio, cod_coordinador)
     VALUES (110, 'Escuela Normal de Calarcá', 'Carrera 25 # 40-20', '63130', 2012);
INSERT INTO INSTALACION (cod_instalacion, nombre, direccion, cod_municipio, cod_coordinador)
     VALUES (201, 'Centro de Acopio Floridablanca', 'Autopista Floridablanca # 150-60', '68276', 2003);
INSERT INTO INSTALACION (cod_instalacion, nombre, direccion, cod_municipio, cod_coordinador)
     VALUES (202, 'Centro de Acopio Bucaramanga', 'Carrera 27 # 36-15', '68001', 2003);
INSERT INTO INSTALACION (cod_instalacion, nombre, direccion, cod_municipio, cod_coordinador)
     VALUES (203, 'Centro de Acopio Quibdó', 'Calle 31 # 4-50', '27001', 2010);
INSERT INTO INSTALACION (cod_instalacion, nombre, direccion, cod_municipio, cod_coordinador)
     VALUES (204, 'Centro de Acopio Cali', 'Calle 70 # 8-25', '76001', 2020);
INSERT INTO INSTALACION (cod_instalacion, nombre, direccion, cod_municipio, cod_coordinador)
     VALUES (205, 'Centro de Acopio Pereira', 'Avenida 30 de Agosto # 80-10', '66001', 2012);
INSERT INTO INSTALACION (cod_instalacion, nombre, direccion, cod_municipio, cod_coordinador)
     VALUES (206, 'Centro de Acopio Manizales', 'Kilómetro 3 vía Magdalena', '17001', 2012);
INSERT INTO INSTALACION (cod_instalacion, nombre, direccion, cod_municipio, cod_coordinador)
     VALUES (207, 'Centro de Acopio Armenia', 'Carrera 19 # 12-40', '63001', 2012);
INSERT INTO INSTALACION (cod_instalacion, nombre, direccion, cod_municipio, cod_coordinador)
     VALUES (208, 'Centro de Acopio Medellín', 'Carrera 65 # 10-50', '05001', 2003);
INSERT INTO INSTALACION (cod_instalacion, nombre, direccion, cod_municipio, cod_coordinador)
     VALUES (209, 'Centro de Acopio Buenaventura', 'Muelle 13, bodega 2', '76109', 2020);
INSERT INTO INSTALACION (cod_instalacion, nombre, direccion, cod_municipio, cod_coordinador)
     VALUES (210, 'Centro de Acopio Ibagué', 'Calle 60 # 5-30', '73001', 2003);
INSERT INTO INSTALACION (cod_instalacion, nombre, direccion, cod_municipio, cod_coordinador)
     VALUES (301, 'Punto de Entrega Cancha Alto Llano', 'Cancha veredal Alto Llano', '68547', 2002);
INSERT INTO INSTALACION (cod_instalacion, nombre, direccion, cod_municipio, cod_coordinador)
     VALUES (302, 'Punto de Entrega Quibdó Norte', 'Barrio Zona Minera, salón comunal', '27001', 2010);
INSERT INTO INSTALACION (cod_instalacion, nombre, direccion, cod_municipio, cod_coordinador)
     VALUES (303, 'Punto de Entrega Plaza de Istmina', 'Plaza principal de Istmina', '27361', 2010);
INSERT INTO INSTALACION (cod_instalacion, nombre, direccion, cod_municipio, cod_coordinador)
     VALUES (304, 'Punto de Entrega Muelle Bahía Solano', 'Muelle turístico', '27075', 2010);
INSERT INTO INSTALACION (cod_instalacion, nombre, direccion, cod_municipio, cod_coordinador)
     VALUES (305, 'Punto de Entrega Comuna 12', 'Parque de la Comuna 12', '76109', 2020);
INSERT INTO INSTALACION (cod_instalacion, nombre, direccion, cod_municipio, cod_coordinador)
     VALUES (306, 'Punto de Entrega Siloé', 'Plazoleta de Siloé', '76001', 2020);
INSERT INTO INSTALACION (cod_instalacion, nombre, direccion, cod_municipio, cod_coordinador)
     VALUES (307, 'Punto de Entrega Río Otún', 'Parque lineal Río Otún', '66001', 2012);
INSERT INTO INSTALACION (cod_instalacion, nombre, direccion, cod_municipio, cod_coordinador)
     VALUES (308, 'Punto de Entrega San José', 'Parroquia San José', '17001', 2012);
INSERT INTO INSTALACION (cod_instalacion, nombre, direccion, cod_municipio, cod_coordinador)
     VALUES (309, 'Punto de Entrega Calarcá', 'Parque principal de Calarcá', '63130', 2012);
INSERT INTO INSTALACION (cod_instalacion, nombre, direccion, cod_municipio, cod_coordinador)
     VALUES (310, 'Punto de Entrega Helechales', 'Escuela Helechales', '68276', 2002);


-- ============================================================================
-- Datos tabla ALBERGUE (10 registros)
-- ============================================================================

INSERT INTO ALBERGUE (cod_instalacion, capacidad_maxima)
     VALUES (101, 120);
INSERT INTO ALBERGUE (cod_instalacion, capacidad_maxima)
     VALUES (102, 40);
INSERT INTO ALBERGUE (cod_instalacion, capacidad_maxima)
     VALUES (103, 300);
INSERT INTO ALBERGUE (cod_instalacion, capacidad_maxima)
     VALUES (104, 150);
INSERT INTO ALBERGUE (cod_instalacion, capacidad_maxima)
     VALUES (105, 80);
INSERT INTO ALBERGUE (cod_instalacion, capacidad_maxima)
     VALUES (106, 200);
INSERT INTO ALBERGUE (cod_instalacion, capacidad_maxima)
     VALUES (107, 150);
INSERT INTO ALBERGUE (cod_instalacion, capacidad_maxima)
     VALUES (108, 4);
INSERT INTO ALBERGUE (cod_instalacion, capacidad_maxima)
     VALUES (109, 250);
INSERT INTO ALBERGUE (cod_instalacion, capacidad_maxima)
     VALUES (110, 90);


-- ============================================================================
-- Datos tabla CENTRO_ACOPIO (10 registros)
-- ============================================================================

INSERT INTO CENTRO_ACOPIO (cod_instalacion)
     VALUES (201);
INSERT INTO CENTRO_ACOPIO (cod_instalacion)
     VALUES (202);
INSERT INTO CENTRO_ACOPIO (cod_instalacion)
     VALUES (203);
INSERT INTO CENTRO_ACOPIO (cod_instalacion)
     VALUES (204);
INSERT INTO CENTRO_ACOPIO (cod_instalacion)
     VALUES (205);
INSERT INTO CENTRO_ACOPIO (cod_instalacion)
     VALUES (206);
INSERT INTO CENTRO_ACOPIO (cod_instalacion)
     VALUES (207);
INSERT INTO CENTRO_ACOPIO (cod_instalacion)
     VALUES (208);
INSERT INTO CENTRO_ACOPIO (cod_instalacion)
     VALUES (209);
INSERT INTO CENTRO_ACOPIO (cod_instalacion)
     VALUES (210);


-- ============================================================================
-- Datos tabla PUNTO_ENTREGA (10 registros)
-- ============================================================================

INSERT INTO PUNTO_ENTREGA (cod_instalacion, cod_zona)
     VALUES (301, 1);
INSERT INTO PUNTO_ENTREGA (cod_instalacion, cod_zona)
     VALUES (302, 2);
INSERT INTO PUNTO_ENTREGA (cod_instalacion, cod_zona)
     VALUES (303, 3);
INSERT INTO PUNTO_ENTREGA (cod_instalacion, cod_zona)
     VALUES (304, 4);
INSERT INTO PUNTO_ENTREGA (cod_instalacion, cod_zona)
     VALUES (305, 5);
INSERT INTO PUNTO_ENTREGA (cod_instalacion, cod_zona)
     VALUES (306, 6);
INSERT INTO PUNTO_ENTREGA (cod_instalacion, cod_zona)
     VALUES (307, 7);
INSERT INTO PUNTO_ENTREGA (cod_instalacion, cod_zona)
     VALUES (308, 9);
INSERT INTO PUNTO_ENTREGA (cod_instalacion, cod_zona)
     VALUES (309, 10);
INSERT INTO PUNTO_ENTREGA (cod_instalacion, cod_zona)
     VALUES (310, 11);


-- ============================================================================
-- Datos tabla CENSO (11 registros)
-- ============================================================================

INSERT INTO CENSO (cod_censo, fecha_censo, cod_zona, cod_albergue)
     VALUES (1, TO_DATE('04/10/2026', 'DD/MM/YYYY'), 1, 102);
INSERT INTO CENSO (cod_censo, fecha_censo, cod_zona, cod_albergue)
     VALUES (2, TO_DATE('05/10/2026', 'DD/MM/YYYY'), 1, 101);
INSERT INTO CENSO (cod_censo, fecha_censo, cod_zona, cod_albergue)
     VALUES (3, TO_DATE('06/10/2026', 'DD/MM/YYYY'), 1, 102);
INSERT INTO CENSO (cod_censo, fecha_censo, cod_zona, cod_albergue)
     VALUES (4, TO_DATE('05/10/2026', 'DD/MM/YYYY'), 2, 103);
INSERT INTO CENSO (cod_censo, fecha_censo, cod_zona, cod_albergue)
     VALUES (5, TO_DATE('06/10/2026', 'DD/MM/YYYY'), 2, NULL);
INSERT INTO CENSO (cod_censo, fecha_censo, cod_zona, cod_albergue)
     VALUES (6, TO_DATE('06/10/2026', 'DD/MM/YYYY'), 3, 104);
INSERT INTO CENSO (cod_censo, fecha_censo, cod_zona, cod_albergue)
     VALUES (7, TO_DATE('07/10/2026', 'DD/MM/YYYY'), 4, 105);
INSERT INTO CENSO (cod_censo, fecha_censo, cod_zona, cod_albergue)
     VALUES (8, TO_DATE('07/10/2026', 'DD/MM/YYYY'), 5, 106);
INSERT INTO CENSO (cod_censo, fecha_censo, cod_zona, cod_albergue)
     VALUES (9, TO_DATE('08/10/2026', 'DD/MM/YYYY'), 6, 107);
INSERT INTO CENSO (cod_censo, fecha_censo, cod_zona, cod_albergue)
     VALUES (10, TO_DATE('08/10/2026', 'DD/MM/YYYY'), 9, 109);
INSERT INTO CENSO (cod_censo, fecha_censo, cod_zona, cod_albergue)
     VALUES (11, TO_DATE('09/10/2026', 'DD/MM/YYYY'), 7, 108);


-- ============================================================================
-- Datos tabla CENSO_DAMNIFICADO (36 registros)
-- ============================================================================

INSERT INTO CENSO_DAMNIFICADO (cod_censo, cod_damnificado, fecha_registro, estado)
     VALUES (1, 1001, TO_DATE('04/10/2026', 'DD/MM/YYYY'), 'Inactivo');
INSERT INTO CENSO_DAMNIFICADO (cod_censo, cod_damnificado, fecha_registro, estado)
     VALUES (1, 1002, TO_DATE('04/10/2026', 'DD/MM/YYYY'), 'Inactivo');
INSERT INTO CENSO_DAMNIFICADO (cod_censo, cod_damnificado, fecha_registro, estado)
     VALUES (1, 1003, TO_DATE('04/10/2026', 'DD/MM/YYYY'), 'Inactivo');
INSERT INTO CENSO_DAMNIFICADO (cod_censo, cod_damnificado, fecha_registro, estado)
     VALUES (2, 1001, TO_DATE('05/10/2026', 'DD/MM/YYYY'), 'Activo');
INSERT INTO CENSO_DAMNIFICADO (cod_censo, cod_damnificado, fecha_registro, estado)
     VALUES (2, 1002, TO_DATE('05/10/2026', 'DD/MM/YYYY'), 'Activo');
INSERT INTO CENSO_DAMNIFICADO (cod_censo, cod_damnificado, fecha_registro, estado)
     VALUES (2, 1003, TO_DATE('05/10/2026', 'DD/MM/YYYY'), 'Activo');
INSERT INTO CENSO_DAMNIFICADO (cod_censo, cod_damnificado, fecha_registro, estado)
     VALUES (2, 1004, TO_DATE('05/10/2026', 'DD/MM/YYYY'), 'Activo');
INSERT INTO CENSO_DAMNIFICADO (cod_censo, cod_damnificado, fecha_registro, estado)
     VALUES (2, 1005, TO_DATE('05/10/2026', 'DD/MM/YYYY'), 'Activo');
INSERT INTO CENSO_DAMNIFICADO (cod_censo, cod_damnificado, fecha_registro, estado)
     VALUES (2, 1006, TO_DATE('05/10/2026', 'DD/MM/YYYY'), 'Activo');
INSERT INTO CENSO_DAMNIFICADO (cod_censo, cod_damnificado, fecha_registro, estado)
     VALUES (3, 1007, TO_DATE('06/10/2026', 'DD/MM/YYYY'), 'Activo');
INSERT INTO CENSO_DAMNIFICADO (cod_censo, cod_damnificado, fecha_registro, estado)
     VALUES (3, 1008, TO_DATE('06/10/2026', 'DD/MM/YYYY'), 'Activo');
INSERT INTO CENSO_DAMNIFICADO (cod_censo, cod_damnificado, fecha_registro, estado)
     VALUES (3, 1009, TO_DATE('06/10/2026', 'DD/MM/YYYY'), 'Activo');
INSERT INTO CENSO_DAMNIFICADO (cod_censo, cod_damnificado, fecha_registro, estado)
     VALUES (4, 1010, TO_DATE('05/10/2026', 'DD/MM/YYYY'), 'Activo');
INSERT INTO CENSO_DAMNIFICADO (cod_censo, cod_damnificado, fecha_registro, estado)
     VALUES (4, 1011, TO_DATE('05/10/2026', 'DD/MM/YYYY'), 'Activo');
INSERT INTO CENSO_DAMNIFICADO (cod_censo, cod_damnificado, fecha_registro, estado)
     VALUES (4, 1012, TO_DATE('05/10/2026', 'DD/MM/YYYY'), 'Activo');
INSERT INTO CENSO_DAMNIFICADO (cod_censo, cod_damnificado, fecha_registro, estado)
     VALUES (4, 1013, TO_DATE('05/10/2026', 'DD/MM/YYYY'), 'Activo');
INSERT INTO CENSO_DAMNIFICADO (cod_censo, cod_damnificado, fecha_registro, estado)
     VALUES (5, 1014, TO_DATE('06/10/2026', 'DD/MM/YYYY'), 'Activo');
INSERT INTO CENSO_DAMNIFICADO (cod_censo, cod_damnificado, fecha_registro, estado)
     VALUES (5, 1015, TO_DATE('06/10/2026', 'DD/MM/YYYY'), 'Activo');
INSERT INTO CENSO_DAMNIFICADO (cod_censo, cod_damnificado, fecha_registro, estado)
     VALUES (5, 1030, TO_DATE('06/10/2026', 'DD/MM/YYYY'), 'Activo');
INSERT INTO CENSO_DAMNIFICADO (cod_censo, cod_damnificado, fecha_registro, estado)
     VALUES (5, 2015, TO_DATE('06/10/2026', 'DD/MM/YYYY'), 'Activo');
INSERT INTO CENSO_DAMNIFICADO (cod_censo, cod_damnificado, fecha_registro, estado)
     VALUES (6, 1016, TO_DATE('06/10/2026', 'DD/MM/YYYY'), 'Activo');
INSERT INTO CENSO_DAMNIFICADO (cod_censo, cod_damnificado, fecha_registro, estado)
     VALUES (6, 1017, TO_DATE('06/10/2026', 'DD/MM/YYYY'), 'Activo');
INSERT INTO CENSO_DAMNIFICADO (cod_censo, cod_damnificado, fecha_registro, estado)
     VALUES (6, 1018, TO_DATE('06/10/2026', 'DD/MM/YYYY'), 'Activo');
INSERT INTO CENSO_DAMNIFICADO (cod_censo, cod_damnificado, fecha_registro, estado)
     VALUES (7, 1019, TO_DATE('07/10/2026', 'DD/MM/YYYY'), 'Activo');
INSERT INTO CENSO_DAMNIFICADO (cod_censo, cod_damnificado, fecha_registro, estado)
     VALUES (7, 1020, TO_DATE('07/10/2026', 'DD/MM/YYYY'), 'Activo');
INSERT INTO CENSO_DAMNIFICADO (cod_censo, cod_damnificado, fecha_registro, estado)
     VALUES (8, 1021, TO_DATE('07/10/2026', 'DD/MM/YYYY'), 'Activo');
INSERT INTO CENSO_DAMNIFICADO (cod_censo, cod_damnificado, fecha_registro, estado)
     VALUES (8, 1022, TO_DATE('07/10/2026', 'DD/MM/YYYY'), 'Activo');
INSERT INTO CENSO_DAMNIFICADO (cod_censo, cod_damnificado, fecha_registro, estado)
     VALUES (8, 1023, TO_DATE('07/10/2026', 'DD/MM/YYYY'), 'Activo');
INSERT INTO CENSO_DAMNIFICADO (cod_censo, cod_damnificado, fecha_registro, estado)
     VALUES (9, 1024, TO_DATE('08/10/2026', 'DD/MM/YYYY'), 'Activo');
INSERT INTO CENSO_DAMNIFICADO (cod_censo, cod_damnificado, fecha_registro, estado)
     VALUES (9, 1025, TO_DATE('08/10/2026', 'DD/MM/YYYY'), 'Activo');
INSERT INTO CENSO_DAMNIFICADO (cod_censo, cod_damnificado, fecha_registro, estado)
     VALUES (10, 1026, TO_DATE('08/10/2026', 'DD/MM/YYYY'), 'Activo');
INSERT INTO CENSO_DAMNIFICADO (cod_censo, cod_damnificado, fecha_registro, estado)
     VALUES (10, 1027, TO_DATE('08/10/2026', 'DD/MM/YYYY'), 'Activo');
INSERT INTO CENSO_DAMNIFICADO (cod_censo, cod_damnificado, fecha_registro, estado)
     VALUES (11, 1028, TO_DATE('09/10/2026', 'DD/MM/YYYY'), 'Activo');
INSERT INTO CENSO_DAMNIFICADO (cod_censo, cod_damnificado, fecha_registro, estado)
     VALUES (11, 1029, TO_DATE('09/10/2026', 'DD/MM/YYYY'), 'Activo');
INSERT INTO CENSO_DAMNIFICADO (cod_censo, cod_damnificado, fecha_registro, estado)
     VALUES (11, 1031, TO_DATE('09/10/2026', 'DD/MM/YYYY'), 'Activo');
INSERT INTO CENSO_DAMNIFICADO (cod_censo, cod_damnificado, fecha_registro, estado)
     VALUES (11, 1032, TO_DATE('09/10/2026', 'DD/MM/YYYY'), 'Activo');


-- ============================================================================
-- Datos tabla FAMILIA_ALBERGUE (12 registros)
-- ============================================================================

INSERT INTO FAMILIA_ALBERGUE (cod_familia, cod_albergue, fecha_ingreso, fecha_salida)
     VALUES (1, 102, TO_DATE('04/10/2026', 'DD/MM/YYYY'), TO_DATE('05/10/2026', 'DD/MM/YYYY'));
INSERT INTO FAMILIA_ALBERGUE (cod_familia, cod_albergue, fecha_ingreso, fecha_salida)
     VALUES (1, 101, TO_DATE('05/10/2026', 'DD/MM/YYYY'), NULL);
INSERT INTO FAMILIA_ALBERGUE (cod_familia, cod_albergue, fecha_ingreso, fecha_salida)
     VALUES (2, 101, TO_DATE('05/10/2026', 'DD/MM/YYYY'), NULL);
INSERT INTO FAMILIA_ALBERGUE (cod_familia, cod_albergue, fecha_ingreso, fecha_salida)
     VALUES (3, 102, TO_DATE('06/10/2026', 'DD/MM/YYYY'), NULL);
INSERT INTO FAMILIA_ALBERGUE (cod_familia, cod_albergue, fecha_ingreso, fecha_salida)
     VALUES (4, 103, TO_DATE('05/10/2026', 'DD/MM/YYYY'), NULL);
INSERT INTO FAMILIA_ALBERGUE (cod_familia, cod_albergue, fecha_ingreso, fecha_salida)
     VALUES (6, 104, TO_DATE('06/10/2026', 'DD/MM/YYYY'), NULL);
INSERT INTO FAMILIA_ALBERGUE (cod_familia, cod_albergue, fecha_ingreso, fecha_salida)
     VALUES (7, 104, TO_DATE('06/10/2026', 'DD/MM/YYYY'), NULL);
INSERT INTO FAMILIA_ALBERGUE (cod_familia, cod_albergue, fecha_ingreso, fecha_salida)
     VALUES (8, 105, TO_DATE('07/10/2026', 'DD/MM/YYYY'), NULL);
INSERT INTO FAMILIA_ALBERGUE (cod_familia, cod_albergue, fecha_ingreso, fecha_salida)
     VALUES (9, 106, TO_DATE('07/10/2026', 'DD/MM/YYYY'), NULL);
INSERT INTO FAMILIA_ALBERGUE (cod_familia, cod_albergue, fecha_ingreso, fecha_salida)
     VALUES (10, 107, TO_DATE('08/10/2026', 'DD/MM/YYYY'), NULL);
INSERT INTO FAMILIA_ALBERGUE (cod_familia, cod_albergue, fecha_ingreso, fecha_salida)
     VALUES (11, 109, TO_DATE('08/10/2026', 'DD/MM/YYYY'), NULL);
INSERT INTO FAMILIA_ALBERGUE (cod_familia, cod_albergue, fecha_ingreso, fecha_salida)
     VALUES (12, 108, TO_DATE('09/10/2026', 'DD/MM/YYYY'), NULL);


-- ============================================================================
-- Datos tabla CATEGORIA_NECESIDAD (10 registros)
-- ============================================================================

INSERT INTO CATEGORIA_NECESIDAD (cod_categoria, nombre, tipo_criterio, edad_minima, edad_maxima, cod_especialidad)
     VALUES (1, 'Lactante', 'Por edad', 0, 1, NULL);
INSERT INTO CATEGORIA_NECESIDAD (cod_categoria, nombre, tipo_criterio, edad_minima, edad_maxima, cod_especialidad)
     VALUES (2, 'Primera infancia', 'Por edad', 2, 5, NULL);
INSERT INTO CATEGORIA_NECESIDAD (cod_categoria, nombre, tipo_criterio, edad_minima, edad_maxima, cod_especialidad)
     VALUES (3, 'Adulto mayor', 'Por edad', 60, 120, NULL);
INSERT INTO CATEGORIA_NECESIDAD (cod_categoria, nombre, tipo_criterio, edad_minima, edad_maxima, cod_especialidad)
     VALUES (4, 'Gestante', 'Por validación', NULL, NULL, 4);
INSERT INTO CATEGORIA_NECESIDAD (cod_categoria, nombre, tipo_criterio, edad_minima, edad_maxima, cod_especialidad)
     VALUES (5, 'Madre lactante', 'Por validación', NULL, NULL, 2);
INSERT INTO CATEGORIA_NECESIDAD (cod_categoria, nombre, tipo_criterio, edad_minima, edad_maxima, cod_especialidad)
     VALUES (6, 'Discapacidad o movilidad reducida', 'Por validación', NULL, NULL, 6);
INSERT INTO CATEGORIA_NECESIDAD (cod_categoria, nombre, tipo_criterio, edad_minima, edad_maxima, cod_especialidad)
     VALUES (7, 'Tratamiento permanente', 'Por validación', NULL, NULL, 1);
INSERT INTO CATEGORIA_NECESIDAD (cod_categoria, nombre, tipo_criterio, edad_minima, edad_maxima, cod_especialidad)
     VALUES (8, 'Lesionado', 'Por validación', NULL, NULL, 12);
INSERT INTO CATEGORIA_NECESIDAD (cod_categoria, nombre, tipo_criterio, edad_minima, edad_maxima, cod_especialidad)
     VALUES (9, 'Apoyo psicosocial', 'Por validación', NULL, NULL, 5);
INSERT INTO CATEGORIA_NECESIDAD (cod_categoria, nombre, tipo_criterio, edad_minima, edad_maxima, cod_especialidad)
     VALUES (10, 'Menor no acompañado', 'Por validación', NULL, NULL, 8);


-- ============================================================================
-- Datos tabla MANIFESTACION (11 registros)
-- ============================================================================

INSERT INTO MANIFESTACION (cod_manifestacion, fecha_registro, tipo, canal, descripcion, estado, respuesta, fecha_respuesta, cod_damnificado, cod_registrador)
     VALUES (1, TO_DATE('11/10/2026', 'DD/MM/YYYY'), 'Necesidad nueva', 'Quiosco', 'No logro dormir desde el terremoto y me siento muy angustiada. Pido apoyo psicológico.', 'Respondida', 'Se validó la necesidad de apoyo psicosocial y se asignó acompañamiento de psicología.', TO_DATE('12/10/2026', 'DD/MM/YYYY'), 1029, NULL);
INSERT INTO MANIFESTACION (cod_manifestacion, fecha_registro, tipo, canal, descripcion, estado, respuesta, fecha_respuesta, cod_damnificado, cod_registrador)
     VALUES (2, TO_DATE('10/10/2026', 'DD/MM/YYYY'), 'Necesidad nueva', 'Punto de atención', 'Desde el terremoto tengo miedo de entrar a cualquier edificio y no he vuelto a clases.', 'En trámite', NULL, NULL, 1012, 2010);
INSERT INTO MANIFESTACION (cod_manifestacion, fecha_registro, tipo, canal, descripcion, estado, respuesta, fecha_respuesta, cod_damnificado, cod_registrador)
     VALUES (3, TO_DATE('08/10/2026', 'DD/MM/YYYY'), 'No recibido', 'Quiosco', 'No he recibido el kit de medicamentos de uso continuo que me corresponde.', 'Respondida', 'El kit llegó en el despacho 13 y se entrega el 09/10 en el Coliseo Municipal.', TO_DATE('09/10/2026', 'DD/MM/YYYY'), 1001, NULL);
INSERT INTO MANIFESTACION (cod_manifestacion, fecha_registro, tipo, canal, descripcion, estado, respuesta, fecha_respuesta, cod_damnificado, cod_registrador)
     VALUES (4, TO_DATE('08/10/2026', 'DD/MM/YYYY'), 'No me sirve', 'Punto de atención', 'La ropa de abrigo que recibí no es de mi talla.', 'Respondida', 'Se cambió la prenda por una de talla L.', TO_DATE('10/10/2026', 'DD/MM/YYYY'), 1004, 2002);
INSERT INTO MANIFESTACION (cod_manifestacion, fecha_registro, tipo, canal, descripcion, estado, respuesta, fecha_respuesta, cod_damnificado, cod_registrador)
     VALUES (5, TO_DATE('09/10/2026', 'DD/MM/YYYY'), 'No recibido', 'Punto de atención', 'Mi familia no ha recibido el mercado familiar.', 'Abierta', NULL, NULL, 1014, 2010);
INSERT INTO MANIFESTACION (cod_manifestacion, fecha_registro, tipo, canal, descripcion, estado, respuesta, fecha_respuesta, cod_damnificado, cod_registrador)
     VALUES (6, TO_DATE('10/10/2026', 'DD/MM/YYYY'), 'No recibido', 'Quiosco', 'No he recibido el suplemento nutricional para gestantes.', 'En trámite', NULL, NULL, 1016, NULL);
INSERT INTO MANIFESTACION (cod_manifestacion, fecha_registro, tipo, canal, descripcion, estado, respuesta, fecha_respuesta, cod_damnificado, cod_registrador)
     VALUES (7, TO_DATE('09/10/2026', 'DD/MM/YYYY'), 'No recibido', 'Quiosco', 'No recibimos el kit de cocina familiar.', 'Respondida', 'Se entregó el kit de cocina el 11/10.', TO_DATE('11/10/2026', 'DD/MM/YYYY'), 1021, NULL);
INSERT INTO MANIFESTACION (cod_manifestacion, fecha_registro, tipo, canal, descripcion, estado, respuesta, fecha_respuesta, cod_damnificado, cod_registrador)
     VALUES (8, TO_DATE('10/10/2026', 'DD/MM/YYYY'), 'No me sirve', 'Punto de atención', 'La colchoneta llegó rota y no se puede usar.', 'Respondida', 'Se reemplazó la colchoneta.', TO_DATE('11/10/2026', 'DD/MM/YYYY'), 1024, 2020);
INSERT INTO MANIFESTACION (cod_manifestacion, fecha_registro, tipo, canal, descripcion, estado, respuesta, fecha_respuesta, cod_damnificado, cod_registrador)
     VALUES (9, TO_DATE('09/10/2026', 'DD/MM/YYYY'), 'No recibido', 'Punto de atención', 'No he recibido la silla de ruedas que necesito para moverme.', 'Respondida', 'La silla de ruedas se entregó el 10/10 en el Coliseo Mayor.', TO_DATE('10/10/2026', 'DD/MM/YYYY'), 1026, 2012);
INSERT INTO MANIFESTACION (cod_manifestacion, fecha_registro, tipo, canal, descripcion, estado, respuesta, fecha_respuesta, cod_damnificado, cod_registrador)
     VALUES (10, TO_DATE('12/10/2026', 'DD/MM/YYYY'), 'No recibido', 'Quiosco', 'No hemos recibido kits de aseo en la Casa Comunal.', 'Abierta', NULL, NULL, 1028, NULL);
INSERT INTO MANIFESTACION (cod_manifestacion, fecha_registro, tipo, canal, descripcion, estado, respuesta, fecha_respuesta, cod_damnificado, cod_registrador)
     VALUES (11, TO_DATE('08/10/2026', 'DD/MM/YYYY'), 'Necesidad nueva', 'Punto de atención', 'Mi hijo de dos años necesita pañales.', 'Respondida', 'Ángel ya está priorizado por edad (primera infancia); recibió pañales el 05/10.', TO_DATE('08/10/2026', 'DD/MM/YYYY'), 1011, 2010);


-- ============================================================================
-- Datos tabla NECESIDAD_DAMNIFICADO (16 registros)
-- ============================================================================

INSERT INTO NECESIDAD_DAMNIFICADO (cod_necesidad, fecha_declaracion, estado, fecha_validacion, fecha_inicio, fecha_fin, cod_damnificado, cod_categoria, cod_validador, cod_manifestacion)
     VALUES (1, TO_DATE('05/10/2026', 'DD/MM/YYYY'), 'Validada', TO_DATE('06/10/2026', 'DD/MM/YYYY'), TO_DATE('06/10/2026', 'DD/MM/YYYY'), TO_DATE('31/03/2027', 'DD/MM/YYYY'), 1001, 7, 2004, NULL);
INSERT INTO NECESIDAD_DAMNIFICADO (cod_necesidad, fecha_declaracion, estado, fecha_validacion, fecha_inicio, fecha_fin, cod_damnificado, cod_categoria, cod_validador, cod_manifestacion)
     VALUES (2, TO_DATE('05/10/2026', 'DD/MM/YYYY'), 'Validada', TO_DATE('07/10/2026', 'DD/MM/YYYY'), TO_DATE('07/10/2026', 'DD/MM/YYYY'), TO_DATE('31/12/2026', 'DD/MM/YYYY'), 1001, 6, 2008, NULL);
INSERT INTO NECESIDAD_DAMNIFICADO (cod_necesidad, fecha_declaracion, estado, fecha_validacion, fecha_inicio, fecha_fin, cod_damnificado, cod_categoria, cod_validador, cod_manifestacion)
     VALUES (3, TO_DATE('05/10/2026', 'DD/MM/YYYY'), 'Validada', TO_DATE('06/10/2026', 'DD/MM/YYYY'), TO_DATE('06/10/2026', 'DD/MM/YYYY'), TO_DATE('31/12/2026', 'DD/MM/YYYY'), 1002, 9, 2007, NULL);
INSERT INTO NECESIDAD_DAMNIFICADO (cod_necesidad, fecha_declaracion, estado, fecha_validacion, fecha_inicio, fecha_fin, cod_damnificado, cod_categoria, cod_validador, cod_manifestacion)
     VALUES (4, TO_DATE('05/10/2026', 'DD/MM/YYYY'), 'Validada', TO_DATE('06/10/2026', 'DD/MM/YYYY'), TO_DATE('06/10/2026', 'DD/MM/YYYY'), TO_DATE('28/02/2027', 'DD/MM/YYYY'), 1003, 4, 2006, NULL);
INSERT INTO NECESIDAD_DAMNIFICADO (cod_necesidad, fecha_declaracion, estado, fecha_validacion, fecha_inicio, fecha_fin, cod_damnificado, cod_categoria, cod_validador, cod_manifestacion)
     VALUES (5, TO_DATE('05/10/2026', 'DD/MM/YYYY'), 'Validada', TO_DATE('05/10/2026', 'DD/MM/YYYY'), TO_DATE('05/10/2026', 'DD/MM/YYYY'), TO_DATE('31/12/2026', 'DD/MM/YYYY'), 1004, 8, 2014, NULL);
INSERT INTO NECESIDAD_DAMNIFICADO (cod_necesidad, fecha_declaracion, estado, fecha_validacion, fecha_inicio, fecha_fin, cod_damnificado, cod_categoria, cod_validador, cod_manifestacion)
     VALUES (6, TO_DATE('05/10/2026', 'DD/MM/YYYY'), 'Validada', TO_DATE('06/10/2026', 'DD/MM/YYYY'), TO_DATE('06/10/2026', 'DD/MM/YYYY'), TO_DATE('15/01/2027', 'DD/MM/YYYY'), 1006, 5, 2005, NULL);
INSERT INTO NECESIDAD_DAMNIFICADO (cod_necesidad, fecha_declaracion, estado, fecha_validacion, fecha_inicio, fecha_fin, cod_damnificado, cod_categoria, cod_validador, cod_manifestacion)
     VALUES (7, TO_DATE('06/10/2026', 'DD/MM/YYYY'), 'Validada', TO_DATE('07/10/2026', 'DD/MM/YYYY'), TO_DATE('07/10/2026', 'DD/MM/YYYY'), TO_DATE('31/12/2026', 'DD/MM/YYYY'), 1015, 8, 2019, NULL);
INSERT INTO NECESIDAD_DAMNIFICADO (cod_necesidad, fecha_declaracion, estado, fecha_validacion, fecha_inicio, fecha_fin, cod_damnificado, cod_categoria, cod_validador, cod_manifestacion)
     VALUES (8, TO_DATE('06/10/2026', 'DD/MM/YYYY'), 'Declarada', NULL, NULL, NULL, 1014, 7, NULL, NULL);
INSERT INTO NECESIDAD_DAMNIFICADO (cod_necesidad, fecha_declaracion, estado, fecha_validacion, fecha_inicio, fecha_fin, cod_damnificado, cod_categoria, cod_validador, cod_manifestacion)
     VALUES (9, TO_DATE('06/10/2026', 'DD/MM/YYYY'), 'Validada', TO_DATE('08/10/2026', 'DD/MM/YYYY'), TO_DATE('08/10/2026', 'DD/MM/YYYY'), TO_DATE('30/04/2027', 'DD/MM/YYYY'), 1016, 4, 2006, NULL);
INSERT INTO NECESIDAD_DAMNIFICADO (cod_necesidad, fecha_declaracion, estado, fecha_validacion, fecha_inicio, fecha_fin, cod_damnificado, cod_categoria, cod_validador, cod_manifestacion)
     VALUES (10, TO_DATE('06/10/2026', 'DD/MM/YYYY'), 'Validada', TO_DATE('06/10/2026', 'DD/MM/YYYY'), TO_DATE('06/10/2026', 'DD/MM/YYYY'), TO_DATE('31/12/2026', 'DD/MM/YYYY'), 1018, 10, 2017, NULL);
INSERT INTO NECESIDAD_DAMNIFICADO (cod_necesidad, fecha_declaracion, estado, fecha_validacion, fecha_inicio, fecha_fin, cod_damnificado, cod_categoria, cod_validador, cod_manifestacion)
     VALUES (11, TO_DATE('08/10/2026', 'DD/MM/YYYY'), 'Validada', TO_DATE('09/10/2026', 'DD/MM/YYYY'), TO_DATE('09/10/2026', 'DD/MM/YYYY'), TO_DATE('31/03/2027', 'DD/MM/YYYY'), 1024, 7, 2004, NULL);
INSERT INTO NECESIDAD_DAMNIFICADO (cod_necesidad, fecha_declaracion, estado, fecha_validacion, fecha_inicio, fecha_fin, cod_damnificado, cod_categoria, cod_validador, cod_manifestacion)
     VALUES (12, TO_DATE('08/10/2026', 'DD/MM/YYYY'), 'Validada', TO_DATE('10/10/2026', 'DD/MM/YYYY'), TO_DATE('10/10/2026', 'DD/MM/YYYY'), TO_DATE('31/12/2026', 'DD/MM/YYYY'), 1026, 6, 2008, NULL);
INSERT INTO NECESIDAD_DAMNIFICADO (cod_necesidad, fecha_declaracion, estado, fecha_validacion, fecha_inicio, fecha_fin, cod_damnificado, cod_categoria, cod_validador, cod_manifestacion)
     VALUES (13, TO_DATE('07/10/2026', 'DD/MM/YYYY'), 'Validada', TO_DATE('08/10/2026', 'DD/MM/YYYY'), TO_DATE('08/10/2026', 'DD/MM/YYYY'), TO_DATE('15/02/2027', 'DD/MM/YYYY'), 1022, 5, 2005, NULL);
INSERT INTO NECESIDAD_DAMNIFICADO (cod_necesidad, fecha_declaracion, estado, fecha_validacion, fecha_inicio, fecha_fin, cod_damnificado, cod_categoria, cod_validador, cod_manifestacion)
     VALUES (14, TO_DATE('11/10/2026', 'DD/MM/YYYY'), 'Declarada', NULL, NULL, NULL, 1029, 9, NULL, 1);
INSERT INTO NECESIDAD_DAMNIFICADO (cod_necesidad, fecha_declaracion, estado, fecha_validacion, fecha_inicio, fecha_fin, cod_damnificado, cod_categoria, cod_validador, cod_manifestacion)
     VALUES (15, TO_DATE('07/10/2026', 'DD/MM/YYYY'), 'Rechazada', TO_DATE('09/10/2026', 'DD/MM/YYYY'), NULL, NULL, 1019, 6, 2008, NULL);
INSERT INTO NECESIDAD_DAMNIFICADO (cod_necesidad, fecha_declaracion, estado, fecha_validacion, fecha_inicio, fecha_fin, cod_damnificado, cod_categoria, cod_validador, cod_manifestacion)
     VALUES (16, TO_DATE('10/10/2026', 'DD/MM/YYYY'), 'Declarada', NULL, NULL, NULL, 1012, 9, NULL, 2);


-- ============================================================================
-- Datos tabla TIPO_INSUMO (10 registros)
-- ============================================================================

INSERT INTO TIPO_INSUMO (cod_tipo_insumo, nombre)
     VALUES (1, 'Alimentos');
INSERT INTO TIPO_INSUMO (cod_tipo_insumo, nombre)
     VALUES (2, 'Insumos médicos');
INSERT INTO TIPO_INSUMO (cod_tipo_insumo, nombre)
     VALUES (3, 'Herramientas de rescate');
INSERT INTO TIPO_INSUMO (cod_tipo_insumo, nombre)
     VALUES (4, 'Prendas de vestir');
INSERT INTO TIPO_INSUMO (cod_tipo_insumo, nombre)
     VALUES (5, 'Agua potable');
INSERT INTO TIPO_INSUMO (cod_tipo_insumo, nombre)
     VALUES (6, 'Higiene y aseo');
INSERT INTO TIPO_INSUMO (cod_tipo_insumo, nombre)
     VALUES (7, 'Alojamiento');
INSERT INTO TIPO_INSUMO (cod_tipo_insumo, nombre)
     VALUES (8, 'Cocina y menaje');
INSERT INTO TIPO_INSUMO (cod_tipo_insumo, nombre)
     VALUES (9, 'Saneamiento');
INSERT INTO TIPO_INSUMO (cod_tipo_insumo, nombre)
     VALUES (10, 'Comunicaciones');


-- ============================================================================
-- Datos tabla UNIDAD_MEDIDA (11 registros)
-- ============================================================================

INSERT INTO UNIDAD_MEDIDA (cod_unidad_medida, nombre)
     VALUES ('KG', 'Kilos');
INSERT INTO UNIDAD_MEDIDA (cod_unidad_medida, nombre)
     VALUES ('L', 'Litros');
INSERT INTO UNIDAD_MEDIDA (cod_unidad_medida, nombre)
     VALUES ('CJ', 'Cajas');
INSERT INTO UNIDAD_MEDIDA (cod_unidad_medida, nombre)
     VALUES ('UND', 'Unidades');
INSERT INTO UNIDAD_MEDIDA (cod_unidad_medida, nombre)
     VALUES ('G', 'Gramos');
INSERT INTO UNIDAD_MEDIDA (cod_unidad_medida, nombre)
     VALUES ('ML', 'Mililitros');
INSERT INTO UNIDAD_MEDIDA (cod_unidad_medida, nombre)
     VALUES ('GAL', 'Galones');
INSERT INTO UNIDAD_MEDIDA (cod_unidad_medida, nombre)
     VALUES ('PAQ', 'Paquetes');
INSERT INTO UNIDAD_MEDIDA (cod_unidad_medida, nombre)
     VALUES ('BOL', 'Bolsas');
INSERT INTO UNIDAD_MEDIDA (cod_unidad_medida, nombre)
     VALUES ('PAR', 'Pares');
INSERT INTO UNIDAD_MEDIDA (cod_unidad_medida, nombre)
     VALUES ('KIT', 'Kits');


-- ============================================================================
-- Datos tabla INSUMO (19 registros)
-- ============================================================================

INSERT INTO INSUMO (cod_insumo, nombre, descripcion, perecedero, modalidad_entrega, cod_tipo_insumo, cod_unidad_medida)
     VALUES (1, 'Leche de fórmula 400 g', 'Leche de fórmula infantil en polvo, lata de 400 g.', 'S', 'Por persona', 1, 'UND');
INSERT INTO INSUMO (cod_insumo, nombre, descripcion, perecedero, modalidad_entrega, cod_tipo_insumo, cod_unidad_medida)
     VALUES (2, 'Mercado familiar básico', 'Caja con arroz, granos, aceite, panela y enlatados para una familia por una semana.', 'S', 'Por familia', 1, 'CJ');
INSERT INTO INSUMO (cod_insumo, nombre, descripcion, perecedero, modalidad_entrega, cod_tipo_insumo, cod_unidad_medida)
     VALUES (3, 'Pañales para bebé', 'Paquete de 30 pañales desechables.', 'N', 'Por persona', 6, 'PAQ');
INSERT INTO INSUMO (cod_insumo, nombre, descripcion, perecedero, modalidad_entrega, cod_tipo_insumo, cod_unidad_medida)
     VALUES (4, 'Agua potable bolsa 6 L', 'Agua potable en bolsa sellada de 6 litros; se registra en litros.', 'S', 'Por persona', 5, 'L');
INSERT INTO INSUMO (cod_insumo, nombre, descripcion, perecedero, modalidad_entrega, cod_tipo_insumo, cod_unidad_medida)
     VALUES (5, 'Kit de aseo personal', 'Jabón, crema dental, cepillo, toalla y toallas higiénicas.', 'N', 'Por persona', 6, 'KIT');
INSERT INTO INSUMO (cod_insumo, nombre, descripcion, perecedero, modalidad_entrega, cod_tipo_insumo, cod_unidad_medida)
     VALUES (6, 'Frazada térmica', 'Frazada térmica de lana para clima frío.', 'N', 'Por persona', 7, 'UND');
INSERT INTO INSUMO (cod_insumo, nombre, descripcion, perecedero, modalidad_entrega, cod_tipo_insumo, cod_unidad_medida)
     VALUES (7, 'Kit de curación', 'Gasas, vendas, antiséptico y esparadrapo.', 'S', 'Por persona', 2, 'CJ');
INSERT INTO INSUMO (cod_insumo, nombre, descripcion, perecedero, modalidad_entrega, cod_tipo_insumo, cod_unidad_medida)
     VALUES (8, 'Suero de rehidratación oral', 'Sobre de sales de rehidratación oral.', 'S', 'Por persona', 2, 'UND');
INSERT INTO INSUMO (cod_insumo, nombre, descripcion, perecedero, modalidad_entrega, cod_tipo_insumo, cod_unidad_medida)
     VALUES (9, 'Colchoneta', 'Colchoneta de espuma de 1,90 x 0,70 m.', 'N', 'Por persona', 7, 'UND');
INSERT INTO INSUMO (cod_insumo, nombre, descripcion, perecedero, modalidad_entrega, cod_tipo_insumo, cod_unidad_medida)
     VALUES (10, 'Kit de cocina familiar', 'Olla, sartén, platos, vasos y cubiertos para cinco personas.', 'N', 'Por familia', 8, 'KIT');
INSERT INTO INSUMO (cod_insumo, nombre, descripcion, perecedero, modalidad_entrega, cod_tipo_insumo, cod_unidad_medida)
     VALUES (11, 'Linterna recargable', 'Linterna LED recargable con panel solar.', 'N', 'Por familia', 3, 'UND');
INSERT INTO INSUMO (cod_insumo, nombre, descripcion, perecedero, modalidad_entrega, cod_tipo_insumo, cod_unidad_medida)
     VALUES (12, 'Casco de seguridad', 'Casco para personal de rescate.', 'N', 'Por persona', 3, 'UND');
INSERT INTO INSUMO (cod_insumo, nombre, descripcion, perecedero, modalidad_entrega, cod_tipo_insumo, cod_unidad_medida)
     VALUES (13, 'Ropa de abrigo adulto', 'Chaqueta de abrigo para adulto, tallas S a XL.', 'N', 'Por persona', 4, 'UND');
INSERT INTO INSUMO (cod_insumo, nombre, descripcion, perecedero, modalidad_entrega, cod_tipo_insumo, cod_unidad_medida)
     VALUES (14, 'Suplemento nutricional para gestantes', 'Paquete de micronutrientes para gestantes y madres lactantes.', 'S', 'Por persona', 1, 'PAQ');
INSERT INTO INSUMO (cod_insumo, nombre, descripcion, perecedero, modalidad_entrega, cod_tipo_insumo, cod_unidad_medida)
     VALUES (15, 'Silla de ruedas plegable', 'Silla de ruedas plegable estándar.', 'N', 'Por persona', 2, 'UND');
INSERT INTO INSUMO (cod_insumo, nombre, descripcion, perecedero, modalidad_entrega, cod_tipo_insumo, cod_unidad_medida)
     VALUES (16, 'Kit de saneamiento familiar', 'Letrina portátil, bolsas y desinfectante.', 'N', 'Por familia', 9, 'KIT');
INSERT INTO INSUMO (cod_insumo, nombre, descripcion, perecedero, modalidad_entrega, cod_tipo_insumo, cod_unidad_medida)
     VALUES (17, 'Radio de comunicaciones', 'Radio portátil de dos vías para albergues.', 'N', 'Por familia', 10, 'UND');
INSERT INTO INSUMO (cod_insumo, nombre, descripcion, perecedero, modalidad_entrega, cod_tipo_insumo, cod_unidad_medida)
     VALUES (18, 'Kit de medicamentos de uso continuo', 'Dispensación de un mes de medicamentos formulados de uso continuo.', 'S', 'Por persona', 2, 'KIT');
INSERT INTO INSUMO (cod_insumo, nombre, descripcion, perecedero, modalidad_entrega, cod_tipo_insumo, cod_unidad_medida)
     VALUES (19, 'Kit lúdico psicosocial', 'Juegos, cuadernos y material para actividades de apoyo psicosocial.', 'N', 'Por persona', 8, 'KIT');


-- ============================================================================
-- Datos tabla CATEGORIA_INSUMO (16 registros)
-- ============================================================================

INSERT INTO CATEGORIA_INSUMO (cod_categoria, cod_insumo)
     VALUES (1, 1);
INSERT INTO CATEGORIA_INSUMO (cod_categoria, cod_insumo)
     VALUES (1, 3);
INSERT INTO CATEGORIA_INSUMO (cod_categoria, cod_insumo)
     VALUES (2, 3);
INSERT INTO CATEGORIA_INSUMO (cod_categoria, cod_insumo)
     VALUES (2, 19);
INSERT INTO CATEGORIA_INSUMO (cod_categoria, cod_insumo)
     VALUES (3, 6);
INSERT INTO CATEGORIA_INSUMO (cod_categoria, cod_insumo)
     VALUES (3, 13);
INSERT INTO CATEGORIA_INSUMO (cod_categoria, cod_insumo)
     VALUES (4, 14);
INSERT INTO CATEGORIA_INSUMO (cod_categoria, cod_insumo)
     VALUES (5, 14);
INSERT INTO CATEGORIA_INSUMO (cod_categoria, cod_insumo)
     VALUES (6, 9);
INSERT INTO CATEGORIA_INSUMO (cod_categoria, cod_insumo)
     VALUES (6, 15);
INSERT INTO CATEGORIA_INSUMO (cod_categoria, cod_insumo)
     VALUES (7, 18);
INSERT INTO CATEGORIA_INSUMO (cod_categoria, cod_insumo)
     VALUES (8, 7);
INSERT INTO CATEGORIA_INSUMO (cod_categoria, cod_insumo)
     VALUES (8, 8);
INSERT INTO CATEGORIA_INSUMO (cod_categoria, cod_insumo)
     VALUES (9, 19);
INSERT INTO CATEGORIA_INSUMO (cod_categoria, cod_insumo)
     VALUES (10, 5);
INSERT INTO CATEGORIA_INSUMO (cod_categoria, cod_insumo)
     VALUES (10, 19);


-- ============================================================================
-- Datos tabla INVENTARIO_LOTE (29 registros)
-- ============================================================================

-- cantidad_disponible empieza igual a cantidad_recibida; el disparador
-- TRG_DLO_DESCUENTO la descuenta cuando los lotes salen en un despacho.
INSERT INTO INVENTARIO_LOTE (cod_lote, num_lote, origen, fecha_recepcion, fecha_vencimiento, cantidad_recibida, cantidad_disponible, cod_insumo, cod_centro)
     VALUES (1, 'L-031', 'Donación particular', TO_DATE('04/10/2026', 'DD/MM/YYYY'), TO_DATE('30/03/2027', 'DD/MM/YYYY'), 20, 20, 1, 201);
INSERT INTO INVENTARIO_LOTE (cod_lote, num_lote, origen, fecha_recepcion, fecha_vencimiento, cantidad_recibida, cantidad_disponible, cod_insumo, cod_centro)
     VALUES (2, 'L-036', 'Cooperación internacional', TO_DATE('06/10/2026', 'DD/MM/YYYY'), TO_DATE('28/04/2027', 'DD/MM/YYYY'), 40, 40, 1, 201);
INSERT INTO INVENTARIO_LOTE (cod_lote, num_lote, origen, fecha_recepcion, fecha_vencimiento, cantidad_recibida, cantidad_disponible, cod_insumo, cod_centro)
     VALUES (3, 'L-044', 'Compra pública', TO_DATE('04/10/2026', 'DD/MM/YYYY'), TO_DATE('15/01/2027', 'DD/MM/YYYY'), 1200, 1200, 4, 201);
INSERT INTO INVENTARIO_LOTE (cod_lote, num_lote, origen, fecha_recepcion, fecha_vencimiento, cantidad_recibida, cantidad_disponible, cod_insumo, cod_centro)
     VALUES (4, 'L-052', 'Cooperación internacional', TO_DATE('05/10/2026', 'DD/MM/YYYY'), TO_DATE('10/08/2028', 'DD/MM/YYYY'), 50, 50, 7, 201);
INSERT INTO INVENTARIO_LOTE (cod_lote, num_lote, origen, fecha_recepcion, fecha_vencimiento, cantidad_recibida, cantidad_disponible, cod_insumo, cod_centro)
     VALUES (5, 'L-060', 'Donación particular', TO_DATE('05/10/2026', 'DD/MM/YYYY'), TO_DATE('05/02/2027', 'DD/MM/YYYY'), 100, 100, 2, 202);
INSERT INTO INVENTARIO_LOTE (cod_lote, num_lote, origen, fecha_recepcion, fecha_vencimiento, cantidad_recibida, cantidad_disponible, cod_insumo, cod_centro)
     VALUES (6, 'L-061', 'Compra pública', TO_DATE('05/10/2026', 'DD/MM/YYYY'), TO_DATE('30/06/2027', 'DD/MM/YYYY'), 40, 40, 18, 202);
INSERT INTO INVENTARIO_LOTE (cod_lote, num_lote, origen, fecha_recepcion, fecha_vencimiento, cantidad_recibida, cantidad_disponible, cod_insumo, cod_centro)
     VALUES (7, 'L-062', 'Cooperación internacional', TO_DATE('06/10/2026', 'DD/MM/YYYY'), TO_DATE('31/05/2027', 'DD/MM/YYYY'), 60, 60, 14, 202);
INSERT INTO INVENTARIO_LOTE (cod_lote, num_lote, origen, fecha_recepcion, fecha_vencimiento, cantidad_recibida, cantidad_disponible, cod_insumo, cod_centro)
     VALUES (8, 'L-063', 'Donación particular', TO_DATE('06/10/2026', 'DD/MM/YYYY'), NULL, 200, 200, 13, 202);
INSERT INTO INVENTARIO_LOTE (cod_lote, num_lote, origen, fecha_recepcion, fecha_vencimiento, cantidad_recibida, cantidad_disponible, cod_insumo, cod_centro)
     VALUES (9, 'L-070', 'Compra pública', TO_DATE('04/10/2026', 'DD/MM/YYYY'), TO_DATE('20/12/2026', 'DD/MM/YYYY'), 3000, 3000, 4, 203);
INSERT INTO INVENTARIO_LOTE (cod_lote, num_lote, origen, fecha_recepcion, fecha_vencimiento, cantidad_recibida, cantidad_disponible, cod_insumo, cod_centro)
     VALUES (10, 'L-071', 'Compra pública', TO_DATE('05/10/2026', 'DD/MM/YYYY'), TO_DATE('15/01/2027', 'DD/MM/YYYY'), 150, 150, 2, 203);
INSERT INTO INVENTARIO_LOTE (cod_lote, num_lote, origen, fecha_recepcion, fecha_vencimiento, cantidad_recibida, cantidad_disponible, cod_insumo, cod_centro)
     VALUES (11, 'L-072', 'Donación particular', TO_DATE('05/10/2026', 'DD/MM/YYYY'), NULL, 120, 120, 3, 203);
INSERT INTO INVENTARIO_LOTE (cod_lote, num_lote, origen, fecha_recepcion, fecha_vencimiento, cantidad_recibida, cantidad_disponible, cod_insumo, cod_centro)
     VALUES (12, 'L-073', 'Cooperación internacional', TO_DATE('05/10/2026', 'DD/MM/YYYY'), TO_DATE('30/09/2027', 'DD/MM/YYYY'), 80, 80, 7, 203);
INSERT INTO INVENTARIO_LOTE (cod_lote, num_lote, origen, fecha_recepcion, fecha_vencimiento, cantidad_recibida, cantidad_disponible, cod_insumo, cod_centro)
     VALUES (13, 'L-074', 'Compra pública', TO_DATE('06/10/2026', 'DD/MM/YYYY'), TO_DATE('15/12/2026', 'DD/MM/YYYY'), 300, 300, 8, 203);
INSERT INTO INVENTARIO_LOTE (cod_lote, num_lote, origen, fecha_recepcion, fecha_vencimiento, cantidad_recibida, cantidad_disponible, cod_insumo, cod_centro)
     VALUES (14, 'L-080', 'Cooperación internacional', TO_DATE('05/10/2026', 'DD/MM/YYYY'), NULL, 400, 400, 6, 204);
INSERT INTO INVENTARIO_LOTE (cod_lote, num_lote, origen, fecha_recepcion, fecha_vencimiento, cantidad_recibida, cantidad_disponible, cod_insumo, cod_centro)
     VALUES (15, 'L-081', 'Compra pública', TO_DATE('05/10/2026', 'DD/MM/YYYY'), NULL, 250, 250, 9, 204);
INSERT INTO INVENTARIO_LOTE (cod_lote, num_lote, origen, fecha_recepcion, fecha_vencimiento, cantidad_recibida, cantidad_disponible, cod_insumo, cod_centro)
     VALUES (16, 'L-082', 'Donación particular', TO_DATE('06/10/2026', 'DD/MM/YYYY'), NULL, 80, 80, 10, 204);
INSERT INTO INVENTARIO_LOTE (cod_lote, num_lote, origen, fecha_recepcion, fecha_vencimiento, cantidad_recibida, cantidad_disponible, cod_insumo, cod_centro)
     VALUES (17, 'L-083', 'Compra pública', TO_DATE('06/10/2026', 'DD/MM/YYYY'), TO_DATE('30/04/2027', 'DD/MM/YYYY'), 50, 50, 18, 204);
INSERT INTO INVENTARIO_LOTE (cod_lote, num_lote, origen, fecha_recepcion, fecha_vencimiento, cantidad_recibida, cantidad_disponible, cod_insumo, cod_centro)
     VALUES (18, 'L-090', 'Donación particular', TO_DATE('07/10/2026', 'DD/MM/YYYY'), TO_DATE('10/12/2026', 'DD/MM/YYYY'), 50, 50, 1, 205);
INSERT INTO INVENTARIO_LOTE (cod_lote, num_lote, origen, fecha_recepcion, fecha_vencimiento, cantidad_recibida, cantidad_disponible, cod_insumo, cod_centro)
     VALUES (19, 'L-091', 'Donación particular', TO_DATE('07/10/2026', 'DD/MM/YYYY'), NULL, 150, 150, 6, 205);
INSERT INTO INVENTARIO_LOTE (cod_lote, num_lote, origen, fecha_recepcion, fecha_vencimiento, cantidad_recibida, cantidad_disponible, cod_insumo, cod_centro)
     VALUES (20, 'L-092', 'Cooperación internacional', TO_DATE('07/10/2026', 'DD/MM/YYYY'), NULL, 60, 60, 19, 206);
INSERT INTO INVENTARIO_LOTE (cod_lote, num_lote, origen, fecha_recepcion, fecha_vencimiento, cantidad_recibida, cantidad_disponible, cod_insumo, cod_centro)
     VALUES (21, 'L-093', 'Compra pública', TO_DATE('07/10/2026', 'DD/MM/YYYY'), NULL, 15, 15, 15, 206);
INSERT INTO INVENTARIO_LOTE (cod_lote, num_lote, origen, fecha_recepcion, fecha_vencimiento, cantidad_recibida, cantidad_disponible, cod_insumo, cod_centro)
     VALUES (22, 'L-094', 'Donación particular', TO_DATE('06/10/2026', 'DD/MM/YYYY'), TO_DATE('30/08/2027', 'DD/MM/YYYY'), 200, 200, 5, 209);
INSERT INTO INVENTARIO_LOTE (cod_lote, num_lote, origen, fecha_recepcion, fecha_vencimiento, cantidad_recibida, cantidad_disponible, cod_insumo, cod_centro)
     VALUES (23, 'L-095', 'Compra pública', TO_DATE('04/10/2026', 'DD/MM/YYYY'), NULL, 100, 100, 12, 208);
INSERT INTO INVENTARIO_LOTE (cod_lote, num_lote, origen, fecha_recepcion, fecha_vencimiento, cantidad_recibida, cantidad_disponible, cod_insumo, cod_centro)
     VALUES (24, 'L-096', 'Cooperación internacional', TO_DATE('08/10/2026', 'DD/MM/YYYY'), NULL, 40, 40, 16, 207);
INSERT INTO INVENTARIO_LOTE (cod_lote, num_lote, origen, fecha_recepcion, fecha_vencimiento, cantidad_recibida, cantidad_disponible, cod_insumo, cod_centro)
     VALUES (25, 'L-097', 'Compra pública', TO_DATE('08/10/2026', 'DD/MM/YYYY'), NULL, 30, 30, 17, 210);
INSERT INTO INVENTARIO_LOTE (cod_lote, num_lote, origen, fecha_recepcion, fecha_vencimiento, cantidad_recibida, cantidad_disponible, cod_insumo, cod_centro)
     VALUES (26, 'L-098', 'Donación particular', TO_DATE('06/10/2026', 'DD/MM/YYYY'), NULL, 120, 120, 11, 207);
INSERT INTO INVENTARIO_LOTE (cod_lote, num_lote, origen, fecha_recepcion, fecha_vencimiento, cantidad_recibida, cantidad_disponible, cod_insumo, cod_centro)
     VALUES (27, 'L-099', 'Donación particular', TO_DATE('07/10/2026', 'DD/MM/YYYY'), TO_DATE('05/12/2026', 'DD/MM/YYYY'), 800, 800, 4, 209);
INSERT INTO INVENTARIO_LOTE (cod_lote, num_lote, origen, fecha_recepcion, fecha_vencimiento, cantidad_recibida, cantidad_disponible, cod_insumo, cod_centro)
     VALUES (28, 'L-100', 'Donación particular', TO_DATE('07/10/2026', 'DD/MM/YYYY'), NULL, 80, 80, 3, 209);
INSERT INTO INVENTARIO_LOTE (cod_lote, num_lote, origen, fecha_recepcion, fecha_vencimiento, cantidad_recibida, cantidad_disponible, cod_insumo, cod_centro)
     VALUES (29, 'L-101', 'Compra pública', TO_DATE('08/10/2026', 'DD/MM/YYYY'), TO_DATE('20/11/2026', 'DD/MM/YYYY'), 100, 100, 8, 205);


-- ============================================================================
-- Datos tabla SOLICITUD (16 registros)
-- ============================================================================

INSERT INTO SOLICITUD (cod_solicitud, fecha_solicitud, tipo_solicitud, descripcion, prioridad, estado, cod_solicitante, cod_zona)
     VALUES (1, TO_DATE('04/10/2026', 'DD/MM/YYYY'), 'Insumos', 'Agua, mercados y pañales para el Coliseo Cubierto de Quibdó y el punto Quibdó Norte.', 'Urgente', 'Atendida', 2010, 2);
INSERT INTO SOLICITUD (cod_solicitud, fecha_solicitud, tipo_solicitud, descripcion, prioridad, estado, cod_solicitante, cod_zona)
     VALUES (2, TO_DATE('05/10/2026', 'DD/MM/YYYY'), 'Insumos', 'Medicamentos de uso continuo, suplementos para gestantes, ropa de abrigo y mercado para el Coliseo Municipal.', 'Alta', 'Atendida', 2002, 1);
INSERT INTO SOLICITUD (cod_solicitud, fecha_solicitud, tipo_solicitud, descripcion, prioridad, estado, cod_solicitante, cod_zona)
     VALUES (3, TO_DATE('05/10/2026', 'DD/MM/YYYY'), 'Auxilio', 'Rescate de personas atrapadas en una vivienda colapsada del barrio El Carmen.', 'Urgente', 'Atendida', 2009, 4);
INSERT INTO SOLICITUD (cod_solicitud, fecha_solicitud, tipo_solicitud, descripcion, prioridad, estado, cod_solicitante, cod_zona)
     VALUES (4, TO_DATE('06/10/2026', 'DD/MM/YYYY'), 'Insumos', 'Frazadas, colchonetas, kits de cocina, agua, pañales y kits de aseo para el Polideportivo.', 'Alta', 'Atendida', 2020, 5);
INSERT INTO SOLICITUD (cod_solicitud, fecha_solicitud, tipo_solicitud, descripcion, prioridad, estado, cod_solicitante, cod_zona)
     VALUES (5, TO_DATE('06/10/2026', 'DD/MM/YYYY'), 'Insumos', 'Medicamentos de uso continuo, colchonetas y frazadas para el Coliseo de Siloé.', 'Media', 'Atendida', 2020, 6);
INSERT INTO SOLICITUD (cod_solicitud, fecha_solicitud, tipo_solicitud, descripcion, prioridad, estado, cod_solicitante, cod_zona)
     VALUES (6, TO_DATE('06/10/2026', 'DD/MM/YYYY'), 'Insumos', 'Agua, suero oral y mercados para la Institución Educativa de Istmina.', 'Alta', 'Asignada', 2010, 3);
INSERT INTO SOLICITUD (cod_solicitud, fecha_solicitud, tipo_solicitud, descripcion, prioridad, estado, cod_solicitante, cod_zona)
     VALUES (7, TO_DATE('07/10/2026', 'DD/MM/YYYY'), 'Insumos', 'Frazadas y suero oral para la Casa Comunal Río Otún.', 'Media', 'Atendida', 2012, 7);
INSERT INTO SOLICITUD (cod_solicitud, fecha_solicitud, tipo_solicitud, descripcion, prioridad, estado, cod_solicitante, cod_zona)
     VALUES (8, TO_DATE('07/10/2026', 'DD/MM/YYYY'), 'Insumos', 'Leche de fórmula, agua y kits de curación para el Coliseo Municipal.', 'Alta', 'Atendida', 2002, 1);
INSERT INTO SOLICITUD (cod_solicitud, fecha_solicitud, tipo_solicitud, descripcion, prioridad, estado, cod_solicitante, cod_zona)
     VALUES (9, TO_DATE('08/10/2026', 'DD/MM/YYYY'), 'Insumos', 'Kits lúdicos y sillas de ruedas para el Coliseo Mayor de Manizales.', 'Media', 'Atendida', 2012, 9);
INSERT INTO SOLICITUD (cod_solicitud, fecha_solicitud, tipo_solicitud, descripcion, prioridad, estado, cod_solicitante, cod_zona)
     VALUES (10, TO_DATE('08/10/2026', 'DD/MM/YYYY'), 'Auxilio', 'Apoyo de cuadrilla para remoción de escombros en el barrio Zona Minera.', 'Urgente', 'Atendida', 2011, 2);
INSERT INTO SOLICITUD (cod_solicitud, fecha_solicitud, tipo_solicitud, descripcion, prioridad, estado, cod_solicitante, cod_zona)
     VALUES (11, TO_DATE('09/10/2026', 'DD/MM/YYYY'), 'Insumos', 'Agua potable para familias de Calarcá con falla de acueducto.', 'Media', 'Registrada', 2012, 10);
INSERT INTO SOLICITUD (cod_solicitud, fecha_solicitud, tipo_solicitud, descripcion, prioridad, estado, cod_solicitante, cod_zona)
     VALUES (12, TO_DATE('10/10/2026', 'DD/MM/YYYY'), 'Insumos', 'Agua potable adicional para Istmina.', 'Alta', 'Registrada', 2010, 3);
INSERT INTO SOLICITUD (cod_solicitud, fecha_solicitud, tipo_solicitud, descripcion, prioridad, estado, cod_solicitante, cod_zona)
     VALUES (13, TO_DATE('09/10/2026', 'DD/MM/YYYY'), 'Insumos', 'Kits de aseo y agua para el Albergue Bahía Solano Centro.', 'Alta', 'Atendida', 1019, 4);
INSERT INTO SOLICITUD (cod_solicitud, fecha_solicitud, tipo_solicitud, descripcion, prioridad, estado, cod_solicitante, cod_zona)
     VALUES (14, TO_DATE('10/10/2026', 'DD/MM/YYYY'), 'Insumos', 'Agua potable para familias de Bahía Solano fuera del albergue.', 'Alta', 'Registrada', 1019, 4);
INSERT INTO SOLICITUD (cod_solicitud, fecha_solicitud, tipo_solicitud, descripcion, prioridad, estado, cod_solicitante, cod_zona)
     VALUES (15, TO_DATE('10/10/2026', 'DD/MM/YYYY'), 'Insumos', 'Colchonetas para Dosquebradas (solicitud duplicada).', 'Baja', 'Rechazada', 2012, 8);
INSERT INTO SOLICITUD (cod_solicitud, fecha_solicitud, tipo_solicitud, descripcion, prioridad, estado, cod_solicitante, cod_zona)
     VALUES (16, TO_DATE('11/10/2026', 'DD/MM/YYYY'), 'Insumos', 'Agua potable para la Escuela Alto Llano.', 'Media', 'Asignada', 2002, 1);


-- ============================================================================
-- Datos tabla SOLICITUD_INSUMO (34 registros)
-- ============================================================================

INSERT INTO SOLICITUD_INSUMO (cod_solicitud, cod_insumo, cantidad_solicitada, cantidad_asignada)
     VALUES (1, 4, 1000, 900);
INSERT INTO SOLICITUD_INSUMO (cod_solicitud, cod_insumo, cantidad_solicitada, cantidad_asignada)
     VALUES (1, 2, 40, 30);
INSERT INTO SOLICITUD_INSUMO (cod_solicitud, cod_insumo, cantidad_solicitada, cantidad_asignada)
     VALUES (1, 3, 30, 20);
INSERT INTO SOLICITUD_INSUMO (cod_solicitud, cod_insumo, cantidad_solicitada, cantidad_asignada)
     VALUES (1, 7, 10, 10);
INSERT INTO SOLICITUD_INSUMO (cod_solicitud, cod_insumo, cantidad_solicitada, cantidad_asignada)
     VALUES (2, 18, 15, 10);
INSERT INTO SOLICITUD_INSUMO (cod_solicitud, cod_insumo, cantidad_solicitada, cantidad_asignada)
     VALUES (2, 14, 15, 10);
INSERT INTO SOLICITUD_INSUMO (cod_solicitud, cod_insumo, cantidad_solicitada, cantidad_asignada)
     VALUES (2, 13, 40, 30);
INSERT INTO SOLICITUD_INSUMO (cod_solicitud, cod_insumo, cantidad_solicitada, cantidad_asignada)
     VALUES (2, 2, 5, 5);
INSERT INTO SOLICITUD_INSUMO (cod_solicitud, cod_insumo, cantidad_solicitada, cantidad_asignada)
     VALUES (4, 6, 60, 50);
INSERT INTO SOLICITUD_INSUMO (cod_solicitud, cod_insumo, cantidad_solicitada, cantidad_asignada)
     VALUES (4, 9, 40, 30);
INSERT INTO SOLICITUD_INSUMO (cod_solicitud, cod_insumo, cantidad_solicitada, cantidad_asignada)
     VALUES (4, 10, 10, 10);
INSERT INTO SOLICITUD_INSUMO (cod_solicitud, cod_insumo, cantidad_solicitada, cantidad_asignada)
     VALUES (4, 4, 300, 200);
INSERT INTO SOLICITUD_INSUMO (cod_solicitud, cod_insumo, cantidad_solicitada, cantidad_asignada)
     VALUES (4, 3, 20, 20);
INSERT INTO SOLICITUD_INSUMO (cod_solicitud, cod_insumo, cantidad_solicitada, cantidad_asignada)
     VALUES (4, 5, 30, 30);
INSERT INTO SOLICITUD_INSUMO (cod_solicitud, cod_insumo, cantidad_solicitada, cantidad_asignada)
     VALUES (5, 18, 10, 10);
INSERT INTO SOLICITUD_INSUMO (cod_solicitud, cod_insumo, cantidad_solicitada, cantidad_asignada)
     VALUES (5, 9, 20, 20);
INSERT INTO SOLICITUD_INSUMO (cod_solicitud, cod_insumo, cantidad_solicitada, cantidad_asignada)
     VALUES (5, 6, 30, 30);
INSERT INTO SOLICITUD_INSUMO (cod_solicitud, cod_insumo, cantidad_solicitada, cantidad_asignada)
     VALUES (6, 4, 500, 400);
INSERT INTO SOLICITUD_INSUMO (cod_solicitud, cod_insumo, cantidad_solicitada, cantidad_asignada)
     VALUES (6, 8, 40, 30);
INSERT INTO SOLICITUD_INSUMO (cod_solicitud, cod_insumo, cantidad_solicitada, cantidad_asignada)
     VALUES (6, 2, 20, 15);
INSERT INTO SOLICITUD_INSUMO (cod_solicitud, cod_insumo, cantidad_solicitada, cantidad_asignada)
     VALUES (7, 6, 20, 20);
INSERT INTO SOLICITUD_INSUMO (cod_solicitud, cod_insumo, cantidad_solicitada, cantidad_asignada)
     VALUES (7, 8, 10, 10);
INSERT INTO SOLICITUD_INSUMO (cod_solicitud, cod_insumo, cantidad_solicitada, cantidad_asignada)
     VALUES (8, 1, 30, 30);
INSERT INTO SOLICITUD_INSUMO (cod_solicitud, cod_insumo, cantidad_solicitada, cantidad_asignada)
     VALUES (8, 4, 150, 120);
INSERT INTO SOLICITUD_INSUMO (cod_solicitud, cod_insumo, cantidad_solicitada, cantidad_asignada)
     VALUES (8, 7, 10, 10);
INSERT INTO SOLICITUD_INSUMO (cod_solicitud, cod_insumo, cantidad_solicitada, cantidad_asignada)
     VALUES (9, 19, 10, 10);
INSERT INTO SOLICITUD_INSUMO (cod_solicitud, cod_insumo, cantidad_solicitada, cantidad_asignada)
     VALUES (9, 15, 3, 3);
INSERT INTO SOLICITUD_INSUMO (cod_solicitud, cod_insumo, cantidad_solicitada, cantidad_asignada)
     VALUES (11, 4, 1500, NULL);
INSERT INTO SOLICITUD_INSUMO (cod_solicitud, cod_insumo, cantidad_solicitada, cantidad_asignada)
     VALUES (12, 4, 2500, NULL);
INSERT INTO SOLICITUD_INSUMO (cod_solicitud, cod_insumo, cantidad_solicitada, cantidad_asignada)
     VALUES (13, 5, 20, 20);
INSERT INTO SOLICITUD_INSUMO (cod_solicitud, cod_insumo, cantidad_solicitada, cantidad_asignada)
     VALUES (13, 4, 100, 100);
INSERT INTO SOLICITUD_INSUMO (cod_solicitud, cod_insumo, cantidad_solicitada, cantidad_asignada)
     VALUES (14, 4, 2000, NULL);
INSERT INTO SOLICITUD_INSUMO (cod_solicitud, cod_insumo, cantidad_solicitada, cantidad_asignada)
     VALUES (15, 9, 30, 0);
INSERT INTO SOLICITUD_INSUMO (cod_solicitud, cod_insumo, cantidad_solicitada, cantidad_asignada)
     VALUES (16, 4, 60, 60);


-- ============================================================================
-- Datos tabla DESPACHO (12 registros)
-- ============================================================================

INSERT INTO DESPACHO (cod_despacho, fecha_emision, estado, placa_vehiculo, fecha_entrega, nombre_receptor, confirmacion_recibido, cod_centro, cod_solicitud, cod_destino, cod_conductor)
     VALUES (11, TO_DATE('05/10/2026', 'DD/MM/YYYY'), 'Entregado', 'TQB214', TO_DATE('05/10/2026', 'DD/MM/YYYY'), 'Yesenia Córdoba', 'S', 203, 1, 103, 2013);
INSERT INTO DESPACHO (cod_despacho, fecha_emision, estado, placa_vehiculo, fecha_entrega, nombre_receptor, confirmacion_recibido, cod_centro, cod_solicitud, cod_destino, cod_conductor)
     VALUES (12, TO_DATE('06/10/2026', 'DD/MM/YYYY'), 'Entregado', 'TQB214', TO_DATE('06/10/2026', 'DD/MM/YYYY'), 'Yesenia Córdoba', 'S', 203, 1, 302, 2013);
INSERT INTO DESPACHO (cod_despacho, fecha_emision, estado, placa_vehiculo, fecha_entrega, nombre_receptor, confirmacion_recibido, cod_centro, cod_solicitud, cod_destino, cod_conductor)
     VALUES (13, TO_DATE('06/10/2026', 'DD/MM/YYYY'), 'Entregado', 'STK482', TO_DATE('06/10/2026', 'DD/MM/YYYY'), 'María Torres', 'S', 202, 2, 101, 2001);
INSERT INTO DESPACHO (cod_despacho, fecha_emision, estado, placa_vehiculo, fecha_entrega, nombre_receptor, confirmacion_recibido, cod_centro, cod_solicitud, cod_destino, cod_conductor)
     VALUES (14, TO_DATE('07/10/2026', 'DD/MM/YYYY'), 'Entregado', 'CLI908', TO_DATE('08/10/2026', 'DD/MM/YYYY'), 'Hernán Arias', 'S', 204, 4, 106, 2018);
INSERT INTO DESPACHO (cod_despacho, fecha_emision, estado, placa_vehiculo, fecha_entrega, nombre_receptor, confirmacion_recibido, cod_centro, cod_solicitud, cod_destino, cod_conductor)
     VALUES (15, TO_DATE('07/10/2026', 'DD/MM/YYYY'), 'Entregado', 'STK482', TO_DATE('07/10/2026', 'DD/MM/YYYY'), 'María Torres', 'S', 201, 8, 101, 2001);
INSERT INTO DESPACHO (cod_despacho, fecha_emision, estado, placa_vehiculo, fecha_entrega, nombre_receptor, confirmacion_recibido, cod_centro, cod_solicitud, cod_destino, cod_conductor)
     VALUES (16, TO_DATE('08/10/2026', 'DD/MM/YYYY'), 'Entregado', 'CLI908', TO_DATE('08/10/2026', 'DD/MM/YYYY'), 'Hernán Arias', 'S', 204, 5, 107, 2018);
INSERT INTO DESPACHO (cod_despacho, fecha_emision, estado, placa_vehiculo, fecha_entrega, nombre_receptor, confirmacion_recibido, cod_centro, cod_solicitud, cod_destino, cod_conductor)
     VALUES (17, TO_DATE('08/10/2026', 'DD/MM/YYYY'), 'Entregado', 'PER311', TO_DATE('09/10/2026', 'DD/MM/YYYY'), 'Sandra Ocampo', 'S', 205, 7, 108, 2018);
INSERT INTO DESPACHO (cod_despacho, fecha_emision, estado, placa_vehiculo, fecha_entrega, nombre_receptor, confirmacion_recibido, cod_centro, cod_solicitud, cod_destino, cod_conductor)
     VALUES (18, TO_DATE('09/10/2026', 'DD/MM/YYYY'), 'Entregado', 'MZL450', TO_DATE('09/10/2026', 'DD/MM/YYYY'), 'Sandra Ocampo', 'S', 206, 9, 109, 2016);
INSERT INTO DESPACHO (cod_despacho, fecha_emision, estado, placa_vehiculo, fecha_entrega, nombre_receptor, confirmacion_recibido, cod_centro, cod_solicitud, cod_destino, cod_conductor)
     VALUES (19, TO_DATE('08/10/2026', 'DD/MM/YYYY'), 'Entregado', 'BUN772', TO_DATE('08/10/2026', 'DD/MM/YYYY'), 'Hernán Arias', 'S', 209, 4, 106, 2013);
INSERT INTO DESPACHO (cod_despacho, fecha_emision, estado, placa_vehiculo, fecha_entrega, nombre_receptor, confirmacion_recibido, cod_centro, cod_solicitud, cod_destino, cod_conductor)
     VALUES (20, TO_DATE('09/10/2026', 'DD/MM/YYYY'), 'En Tránsito', 'TQB214', NULL, NULL, 'N', 203, 6, 104, 2013);
INSERT INTO DESPACHO (cod_despacho, fecha_emision, estado, placa_vehiculo, fecha_entrega, nombre_receptor, confirmacion_recibido, cod_centro, cod_solicitud, cod_destino, cod_conductor)
     VALUES (21, TO_DATE('09/10/2026', 'DD/MM/YYYY'), 'En Tránsito', 'BUN772', NULL, NULL, 'N', 209, 13, 105, 2013);
INSERT INTO DESPACHO (cod_despacho, fecha_emision, estado, placa_vehiculo, fecha_entrega, nombre_receptor, confirmacion_recibido, cod_centro, cod_solicitud, cod_destino, cod_conductor)
     VALUES (22, TO_DATE('11/10/2026', 'DD/MM/YYYY'), 'Pendiente', 'STK482', NULL, NULL, 'N', 201, 16, 102, 2001);


-- ============================================================================
-- Datos tabla DESPACHO_LOTE (33 registros)
-- ============================================================================

-- Cada INSERT activa TRG_DLO_DESCUENTO, que valida y descuenta el inventario.
INSERT INTO DESPACHO_LOTE (cod_despacho, cod_lote, cantidad_despachada)
     VALUES (11, 9, 600);
INSERT INTO DESPACHO_LOTE (cod_despacho, cod_lote, cantidad_despachada)
     VALUES (11, 10, 20);
INSERT INTO DESPACHO_LOTE (cod_despacho, cod_lote, cantidad_despachada)
     VALUES (11, 11, 20);
INSERT INTO DESPACHO_LOTE (cod_despacho, cod_lote, cantidad_despachada)
     VALUES (12, 9, 300);
INSERT INTO DESPACHO_LOTE (cod_despacho, cod_lote, cantidad_despachada)
     VALUES (12, 10, 10);
INSERT INTO DESPACHO_LOTE (cod_despacho, cod_lote, cantidad_despachada)
     VALUES (12, 12, 10);
INSERT INTO DESPACHO_LOTE (cod_despacho, cod_lote, cantidad_despachada)
     VALUES (13, 6, 10);
INSERT INTO DESPACHO_LOTE (cod_despacho, cod_lote, cantidad_despachada)
     VALUES (13, 7, 10);
INSERT INTO DESPACHO_LOTE (cod_despacho, cod_lote, cantidad_despachada)
     VALUES (13, 8, 30);
INSERT INTO DESPACHO_LOTE (cod_despacho, cod_lote, cantidad_despachada)
     VALUES (13, 5, 5);
INSERT INTO DESPACHO_LOTE (cod_despacho, cod_lote, cantidad_despachada)
     VALUES (14, 14, 50);
INSERT INTO DESPACHO_LOTE (cod_despacho, cod_lote, cantidad_despachada)
     VALUES (14, 15, 30);
INSERT INTO DESPACHO_LOTE (cod_despacho, cod_lote, cantidad_despachada)
     VALUES (14, 16, 10);
INSERT INTO DESPACHO_LOTE (cod_despacho, cod_lote, cantidad_despachada)
     VALUES (15, 1, 20);
INSERT INTO DESPACHO_LOTE (cod_despacho, cod_lote, cantidad_despachada)
     VALUES (15, 2, 10);
INSERT INTO DESPACHO_LOTE (cod_despacho, cod_lote, cantidad_despachada)
     VALUES (15, 3, 120);
INSERT INTO DESPACHO_LOTE (cod_despacho, cod_lote, cantidad_despachada)
     VALUES (15, 4, 10);
INSERT INTO DESPACHO_LOTE (cod_despacho, cod_lote, cantidad_despachada)
     VALUES (16, 17, 10);
INSERT INTO DESPACHO_LOTE (cod_despacho, cod_lote, cantidad_despachada)
     VALUES (16, 15, 20);
INSERT INTO DESPACHO_LOTE (cod_despacho, cod_lote, cantidad_despachada)
     VALUES (16, 14, 30);
INSERT INTO DESPACHO_LOTE (cod_despacho, cod_lote, cantidad_despachada)
     VALUES (17, 19, 20);
INSERT INTO DESPACHO_LOTE (cod_despacho, cod_lote, cantidad_despachada)
     VALUES (17, 29, 10);
INSERT INTO DESPACHO_LOTE (cod_despacho, cod_lote, cantidad_despachada)
     VALUES (18, 20, 10);
INSERT INTO DESPACHO_LOTE (cod_despacho, cod_lote, cantidad_despachada)
     VALUES (18, 21, 3);
INSERT INTO DESPACHO_LOTE (cod_despacho, cod_lote, cantidad_despachada)
     VALUES (19, 27, 200);
INSERT INTO DESPACHO_LOTE (cod_despacho, cod_lote, cantidad_despachada)
     VALUES (19, 28, 20);
INSERT INTO DESPACHO_LOTE (cod_despacho, cod_lote, cantidad_despachada)
     VALUES (19, 22, 30);
INSERT INTO DESPACHO_LOTE (cod_despacho, cod_lote, cantidad_despachada)
     VALUES (20, 9, 400);
INSERT INTO DESPACHO_LOTE (cod_despacho, cod_lote, cantidad_despachada)
     VALUES (20, 13, 30);
INSERT INTO DESPACHO_LOTE (cod_despacho, cod_lote, cantidad_despachada)
     VALUES (20, 10, 15);
INSERT INTO DESPACHO_LOTE (cod_despacho, cod_lote, cantidad_despachada)
     VALUES (21, 22, 20);
INSERT INTO DESPACHO_LOTE (cod_despacho, cod_lote, cantidad_despachada)
     VALUES (21, 27, 100);
INSERT INTO DESPACHO_LOTE (cod_despacho, cod_lote, cantidad_despachada)
     VALUES (22, 3, 60);

-- ============================================================================
-- Actualización: El despacho 21 llega a Bahía Solano y se confirma el recibido
-- ============================================================================

UPDATE DESPACHO
SET estado = 'Entregado',
    fecha_entrega = TO_DATE('10/10/2026', 'DD/MM/YYYY'),
    nombre_receptor = 'Yesenia Córdoba',
    confirmacion_recibido = 'S'
WHERE cod_despacho = 21;


-- ============================================================================
-- Datos tabla ENTREGA (32 registros)
-- ============================================================================

-- Cada entrega queda a nombre del beneficiario (quien tiene la necesidad) y del receptor (quien recoge, por ejemplo la madre de un lactante).
INSERT INTO ENTREGA (cod_entrega, fecha_hora, cantidad, metodo_identificacion, cod_despacho, cod_insumo, cod_beneficiario, cod_receptor, cod_necesidad)
     VALUES (1, TO_DATE('07/10/2026 10:30', 'DD/MM/YYYY HH24:MI'), 2, 'Código de censo', 15, 1, 1005, 1004, NULL);
INSERT INTO ENTREGA (cod_entrega, fecha_hora, cantidad, metodo_identificacion, cod_despacho, cod_insumo, cod_beneficiario, cod_receptor, cod_necesidad)
     VALUES (2, TO_DATE('07/10/2026 10:35', 'DD/MM/YYYY HH24:MI'), 1, 'Documento', 15, 7, 1004, 1004, 5);
INSERT INTO ENTREGA (cod_entrega, fecha_hora, cantidad, metodo_identificacion, cod_despacho, cod_insumo, cod_beneficiario, cod_receptor, cod_necesidad)
     VALUES (3, TO_DATE('07/10/2026 10:40', 'DD/MM/YYYY HH24:MI'), 12, 'Código de censo', 15, 4, 1001, 1001, NULL);
INSERT INTO ENTREGA (cod_entrega, fecha_hora, cantidad, metodo_identificacion, cod_despacho, cod_insumo, cod_beneficiario, cod_receptor, cod_necesidad)
     VALUES (4, TO_DATE('07/10/2026 10:45', 'DD/MM/YYYY HH24:MI'), 12, 'Código de censo', 15, 4, 1003, 1003, NULL);
INSERT INTO ENTREGA (cod_entrega, fecha_hora, cantidad, metodo_identificacion, cod_despacho, cod_insumo, cod_beneficiario, cod_receptor, cod_necesidad)
     VALUES (5, TO_DATE('09/10/2026 09:00', 'DD/MM/YYYY HH24:MI'), 1, 'Documento', 13, 18, 1001, 1001, 1);
INSERT INTO ENTREGA (cod_entrega, fecha_hora, cantidad, metodo_identificacion, cod_despacho, cod_insumo, cod_beneficiario, cod_receptor, cod_necesidad)
     VALUES (6, TO_DATE('06/10/2026 15:00', 'DD/MM/YYYY HH24:MI'), 1, 'Código de censo', 13, 14, 1003, 1003, 4);
INSERT INTO ENTREGA (cod_entrega, fecha_hora, cantidad, metodo_identificacion, cod_despacho, cod_insumo, cod_beneficiario, cod_receptor, cod_necesidad)
     VALUES (7, TO_DATE('06/10/2026 15:10', 'DD/MM/YYYY HH24:MI'), 1, 'Código de censo', 13, 14, 1006, 1006, 6);
INSERT INTO ENTREGA (cod_entrega, fecha_hora, cantidad, metodo_identificacion, cod_despacho, cod_insumo, cod_beneficiario, cod_receptor, cod_necesidad)
     VALUES (8, TO_DATE('06/10/2026 15:20', 'DD/MM/YYYY HH24:MI'), 1, 'Código de censo', 13, 13, 1001, 1001, NULL);
INSERT INTO ENTREGA (cod_entrega, fecha_hora, cantidad, metodo_identificacion, cod_despacho, cod_insumo, cod_beneficiario, cod_receptor, cod_necesidad)
     VALUES (9, TO_DATE('06/10/2026 15:30', 'DD/MM/YYYY HH24:MI'), 1, 'Código de censo', 13, 2, 1001, 1003, NULL);
INSERT INTO ENTREGA (cod_entrega, fecha_hora, cantidad, metodo_identificacion, cod_despacho, cod_insumo, cod_beneficiario, cod_receptor, cod_necesidad)
     VALUES (10, TO_DATE('06/10/2026 15:35', 'DD/MM/YYYY HH24:MI'), 1, 'Documento', 13, 2, 1004, 1004, NULL);
INSERT INTO ENTREGA (cod_entrega, fecha_hora, cantidad, metodo_identificacion, cod_despacho, cod_insumo, cod_beneficiario, cod_receptor, cod_necesidad)
     VALUES (11, TO_DATE('06/10/2026 15:40', 'DD/MM/YYYY HH24:MI'), 1, 'Documento', 13, 13, 1004, 1004, NULL);
INSERT INTO ENTREGA (cod_entrega, fecha_hora, cantidad, metodo_identificacion, cod_despacho, cod_insumo, cod_beneficiario, cod_receptor, cod_necesidad)
     VALUES (12, TO_DATE('10/10/2026 11:00', 'DD/MM/YYYY HH24:MI'), 1, 'Documento', 13, 13, 1004, 1004, NULL);
INSERT INTO ENTREGA (cod_entrega, fecha_hora, cantidad, metodo_identificacion, cod_despacho, cod_insumo, cod_beneficiario, cod_receptor, cod_necesidad)
     VALUES (13, TO_DATE('05/10/2026 16:00', 'DD/MM/YYYY HH24:MI'), 1, 'Documento', 11, 2, 1010, 1010, NULL);
INSERT INTO ENTREGA (cod_entrega, fecha_hora, cantidad, metodo_identificacion, cod_despacho, cod_insumo, cod_beneficiario, cod_receptor, cod_necesidad)
     VALUES (14, TO_DATE('05/10/2026 16:10', 'DD/MM/YYYY HH24:MI'), 2, 'Código de censo', 11, 3, 1013, 1011, NULL);
INSERT INTO ENTREGA (cod_entrega, fecha_hora, cantidad, metodo_identificacion, cod_despacho, cod_insumo, cod_beneficiario, cod_receptor, cod_necesidad)
     VALUES (15, TO_DATE('05/10/2026 16:15', 'DD/MM/YYYY HH24:MI'), 12, 'Documento', 11, 4, 1011, 1011, NULL);
INSERT INTO ENTREGA (cod_entrega, fecha_hora, cantidad, metodo_identificacion, cod_despacho, cod_insumo, cod_beneficiario, cod_receptor, cod_necesidad)
     VALUES (16, TO_DATE('07/10/2026 16:00', 'DD/MM/YYYY HH24:MI'), 1, 'Documento', 12, 7, 1015, 1015, 7);
INSERT INTO ENTREGA (cod_entrega, fecha_hora, cantidad, metodo_identificacion, cod_despacho, cod_insumo, cod_beneficiario, cod_receptor, cod_necesidad)
     VALUES (17, TO_DATE('06/10/2026 14:00', 'DD/MM/YYYY HH24:MI'), 12, 'Código de censo', 12, 4, 1030, 1030, NULL);
INSERT INTO ENTREGA (cod_entrega, fecha_hora, cantidad, metodo_identificacion, cod_despacho, cod_insumo, cod_beneficiario, cod_receptor, cod_necesidad)
     VALUES (18, TO_DATE('06/10/2026 14:10', 'DD/MM/YYYY HH24:MI'), 1, 'Documento', 12, 2, 2015, 2015, NULL);
INSERT INTO ENTREGA (cod_entrega, fecha_hora, cantidad, metodo_identificacion, cod_despacho, cod_insumo, cod_beneficiario, cod_receptor, cod_necesidad)
     VALUES (19, TO_DATE('08/10/2026 17:00', 'DD/MM/YYYY HH24:MI'), 1, 'Código de censo', 14, 6, 1021, 1021, NULL);
INSERT INTO ENTREGA (cod_entrega, fecha_hora, cantidad, metodo_identificacion, cod_despacho, cod_insumo, cod_beneficiario, cod_receptor, cod_necesidad)
     VALUES (20, TO_DATE('08/10/2026 17:05', 'DD/MM/YYYY HH24:MI'), 1, 'Código de censo', 14, 6, 1023, 1022, NULL);
INSERT INTO ENTREGA (cod_entrega, fecha_hora, cantidad, metodo_identificacion, cod_despacho, cod_insumo, cod_beneficiario, cod_receptor, cod_necesidad)
     VALUES (21, TO_DATE('11/10/2026 10:00', 'DD/MM/YYYY HH24:MI'), 1, 'Código de censo', 14, 10, 1021, 1021, NULL);
INSERT INTO ENTREGA (cod_entrega, fecha_hora, cantidad, metodo_identificacion, cod_despacho, cod_insumo, cod_beneficiario, cod_receptor, cod_necesidad)
     VALUES (22, TO_DATE('08/10/2026 17:20', 'DD/MM/YYYY HH24:MI'), 2, 'Código de censo', 19, 3, 1023, 1022, NULL);
INSERT INTO ENTREGA (cod_entrega, fecha_hora, cantidad, metodo_identificacion, cod_despacho, cod_insumo, cod_beneficiario, cod_receptor, cod_necesidad)
     VALUES (23, TO_DATE('08/10/2026 17:25', 'DD/MM/YYYY HH24:MI'), 1, 'Documento', 19, 5, 1022, 1022, NULL);
INSERT INTO ENTREGA (cod_entrega, fecha_hora, cantidad, metodo_identificacion, cod_despacho, cod_insumo, cod_beneficiario, cod_receptor, cod_necesidad)
     VALUES (24, TO_DATE('09/10/2026 16:00', 'DD/MM/YYYY HH24:MI'), 1, 'Documento', 16, 18, 1024, 1024, 11);
INSERT INTO ENTREGA (cod_entrega, fecha_hora, cantidad, metodo_identificacion, cod_despacho, cod_insumo, cod_beneficiario, cod_receptor, cod_necesidad)
     VALUES (25, TO_DATE('08/10/2026 18:00', 'DD/MM/YYYY HH24:MI'), 1, 'Documento', 16, 9, 1024, 1024, NULL);
INSERT INTO ENTREGA (cod_entrega, fecha_hora, cantidad, metodo_identificacion, cod_despacho, cod_insumo, cod_beneficiario, cod_receptor, cod_necesidad)
     VALUES (26, TO_DATE('11/10/2026 09:30', 'DD/MM/YYYY HH24:MI'), 1, 'Documento', 16, 9, 1024, 1024, NULL);
INSERT INTO ENTREGA (cod_entrega, fecha_hora, cantidad, metodo_identificacion, cod_despacho, cod_insumo, cod_beneficiario, cod_receptor, cod_necesidad)
     VALUES (27, TO_DATE('09/10/2026 15:00', 'DD/MM/YYYY HH24:MI'), 1, 'Código de censo', 17, 6, 1028, 1028, NULL);
INSERT INTO ENTREGA (cod_entrega, fecha_hora, cantidad, metodo_identificacion, cod_despacho, cod_insumo, cod_beneficiario, cod_receptor, cod_necesidad)
     VALUES (28, TO_DATE('09/10/2026 15:05', 'DD/MM/YYYY HH24:MI'), 1, 'Código de censo', 17, 6, 1029, 1029, NULL);
INSERT INTO ENTREGA (cod_entrega, fecha_hora, cantidad, metodo_identificacion, cod_despacho, cod_insumo, cod_beneficiario, cod_receptor, cod_necesidad)
     VALUES (29, TO_DATE('09/10/2026 15:10', 'DD/MM/YYYY HH24:MI'), 2, 'Código de censo', 17, 8, 1032, 1029, NULL);
INSERT INTO ENTREGA (cod_entrega, fecha_hora, cantidad, metodo_identificacion, cod_despacho, cod_insumo, cod_beneficiario, cod_receptor, cod_necesidad)
     VALUES (30, TO_DATE('10/10/2026 10:00', 'DD/MM/YYYY HH24:MI'), 1, 'Código de censo', 18, 15, 1026, 1027, 12);
INSERT INTO ENTREGA (cod_entrega, fecha_hora, cantidad, metodo_identificacion, cod_despacho, cod_insumo, cod_beneficiario, cod_receptor, cod_necesidad)
     VALUES (31, TO_DATE('10/10/2026 14:00', 'DD/MM/YYYY HH24:MI'), 1, 'Documento', 21, 5, 1019, 1019, NULL);
INSERT INTO ENTREGA (cod_entrega, fecha_hora, cantidad, metodo_identificacion, cod_despacho, cod_insumo, cod_beneficiario, cod_receptor, cod_necesidad)
     VALUES (32, TO_DATE('10/10/2026 14:05', 'DD/MM/YYYY HH24:MI'), 12, 'Documento', 21, 4, 1020, 1020, NULL);

-- ============================================================================
-- Actualización: Psicología valida la necesidad que surgió de la manifestación 1
-- ============================================================================

UPDATE NECESIDAD_DAMNIFICADO
SET estado = 'Validada',
    fecha_validacion = TO_DATE('12/10/2026', 'DD/MM/YYYY'),
    fecha_inicio = TO_DATE('12/10/2026', 'DD/MM/YYYY'),
    fecha_fin = TO_DATE('31/12/2026', 'DD/MM/YYYY'),
    cod_validador = 2007
WHERE cod_necesidad = 14;


-- ============================================================================
-- Datos tabla CUADRILLA (10 registros)
-- ============================================================================

INSERT INTO CUADRILLA (cod_cuadrilla, nombre)
     VALUES (1, 'Cuadrilla de Rescate Quibdó');
INSERT INTO CUADRILLA (cod_cuadrilla, nombre)
     VALUES (2, 'Cuadrilla USAR Bomberos Chocó');
INSERT INTO CUADRILLA (cod_cuadrilla, nombre)
     VALUES (3, 'Brigada Médica Cruz Roja Santander');
INSERT INTO CUADRILLA (cod_cuadrilla, nombre)
     VALUES (4, 'Brigada Médica Pacífico');
INSERT INTO CUADRILLA (cod_cuadrilla, nombre)
     VALUES (5, 'Cuadrilla de Apoyo Psicosocial');
INSERT INTO CUADRILLA (cod_cuadrilla, nombre)
     VALUES (6, 'Cuadrilla de Atención Eje Cafetero');
INSERT INTO CUADRILLA (cod_cuadrilla, nombre)
     VALUES (7, 'Cuadrilla de Rescate Eje Cafetero');
INSERT INTO CUADRILLA (cod_cuadrilla, nombre)
     VALUES (8, 'Brigada de Salud Materno Infantil');
INSERT INTO CUADRILLA (cod_cuadrilla, nombre)
     VALUES (9, 'Cuadrilla de Protección a la Infancia');
INSERT INTO CUADRILLA (cod_cuadrilla, nombre)
     VALUES (10, 'Cuadrilla de Transporte Humanitario');


-- ============================================================================
-- Datos tabla PERSONAL_CUADRILLA (16 registros)
-- ============================================================================

INSERT INTO PERSONAL_CUADRILLA (cod_personal, cod_cuadrilla, fecha_ingreso, fecha_salida)
     VALUES (2009, 2, TO_DATE('04/10/2026', 'DD/MM/YYYY'), NULL);
INSERT INTO PERSONAL_CUADRILLA (cod_personal, cod_cuadrilla, fecha_ingreso, fecha_salida)
     VALUES (2011, 2, TO_DATE('04/10/2026', 'DD/MM/YYYY'), NULL);
INSERT INTO PERSONAL_CUADRILLA (cod_personal, cod_cuadrilla, fecha_ingreso, fecha_salida)
     VALUES (2015, 1, TO_DATE('05/10/2026', 'DD/MM/YYYY'), NULL);
INSERT INTO PERSONAL_CUADRILLA (cod_personal, cod_cuadrilla, fecha_ingreso, fecha_salida)
     VALUES (2019, 1, TO_DATE('05/10/2026', 'DD/MM/YYYY'), NULL);
INSERT INTO PERSONAL_CUADRILLA (cod_personal, cod_cuadrilla, fecha_ingreso, fecha_salida)
     VALUES (2004, 3, TO_DATE('05/10/2026', 'DD/MM/YYYY'), NULL);
INSERT INTO PERSONAL_CUADRILLA (cod_personal, cod_cuadrilla, fecha_ingreso, fecha_salida)
     VALUES (2005, 3, TO_DATE('05/10/2026', 'DD/MM/YYYY'), NULL);
INSERT INTO PERSONAL_CUADRILLA (cod_personal, cod_cuadrilla, fecha_ingreso, fecha_salida)
     VALUES (2008, 3, TO_DATE('05/10/2026', 'DD/MM/YYYY'), TO_DATE('07/10/2026', 'DD/MM/YYYY'));
INSERT INTO PERSONAL_CUADRILLA (cod_personal, cod_cuadrilla, fecha_ingreso, fecha_salida)
     VALUES (2008, 6, TO_DATE('08/10/2026', 'DD/MM/YYYY'), NULL);
INSERT INTO PERSONAL_CUADRILLA (cod_personal, cod_cuadrilla, fecha_ingreso, fecha_salida)
     VALUES (2014, 4, TO_DATE('05/10/2026', 'DD/MM/YYYY'), NULL);
INSERT INTO PERSONAL_CUADRILLA (cod_personal, cod_cuadrilla, fecha_ingreso, fecha_salida)
     VALUES (2007, 5, TO_DATE('06/10/2026', 'DD/MM/YYYY'), NULL);
INSERT INTO PERSONAL_CUADRILLA (cod_personal, cod_cuadrilla, fecha_ingreso, fecha_salida)
     VALUES (2016, 7, TO_DATE('06/10/2026', 'DD/MM/YYYY'), NULL);
INSERT INTO PERSONAL_CUADRILLA (cod_personal, cod_cuadrilla, fecha_ingreso, fecha_salida)
     VALUES (2006, 8, TO_DATE('06/10/2026', 'DD/MM/YYYY'), NULL);
INSERT INTO PERSONAL_CUADRILLA (cod_personal, cod_cuadrilla, fecha_ingreso, fecha_salida)
     VALUES (2017, 9, TO_DATE('06/10/2026', 'DD/MM/YYYY'), NULL);
INSERT INTO PERSONAL_CUADRILLA (cod_personal, cod_cuadrilla, fecha_ingreso, fecha_salida)
     VALUES (2001, 10, TO_DATE('04/10/2026', 'DD/MM/YYYY'), NULL);
INSERT INTO PERSONAL_CUADRILLA (cod_personal, cod_cuadrilla, fecha_ingreso, fecha_salida)
     VALUES (2013, 10, TO_DATE('04/10/2026', 'DD/MM/YYYY'), NULL);
INSERT INTO PERSONAL_CUADRILLA (cod_personal, cod_cuadrilla, fecha_ingreso, fecha_salida)
     VALUES (2018, 10, TO_DATE('05/10/2026', 'DD/MM/YYYY'), NULL);


-- ============================================================================
-- Datos tabla ORDEN_ASIGNACION (13 registros)
-- ============================================================================

INSERT INTO ORDEN_ASIGNACION (cod_orden, fecha_hora_inicio, fecha_hora_fin, estado, cod_cuadrilla, cod_zona, cod_albergue)
     VALUES (1, TO_DATE('04/10/2026 06:00', 'DD/MM/YYYY HH24:MI'), TO_DATE('08/10/2026 18:00', 'DD/MM/YYYY HH24:MI'), 'Finalizada', 2, 2, NULL);
INSERT INTO ORDEN_ASIGNACION (cod_orden, fecha_hora_inicio, fecha_hora_fin, estado, cod_cuadrilla, cod_zona, cod_albergue)
     VALUES (2, TO_DATE('09/10/2026 06:00', 'DD/MM/YYYY HH24:MI'), NULL, 'Activa', 2, 4, NULL);
INSERT INTO ORDEN_ASIGNACION (cod_orden, fecha_hora_inicio, fecha_hora_fin, estado, cod_cuadrilla, cod_zona, cod_albergue)
     VALUES (3, TO_DATE('05/10/2026 07:00', 'DD/MM/YYYY HH24:MI'), NULL, 'Activa', 1, 2, NULL);
INSERT INTO ORDEN_ASIGNACION (cod_orden, fecha_hora_inicio, fecha_hora_fin, estado, cod_cuadrilla, cod_zona, cod_albergue)
     VALUES (4, TO_DATE('05/10/2026 08:00', 'DD/MM/YYYY HH24:MI'), NULL, 'Activa', 3, NULL, 101);
INSERT INTO ORDEN_ASIGNACION (cod_orden, fecha_hora_inicio, fecha_hora_fin, estado, cod_cuadrilla, cod_zona, cod_albergue)
     VALUES (5, TO_DATE('06/10/2026 08:00', 'DD/MM/YYYY HH24:MI'), NULL, 'Activa', 4, NULL, 106);
INSERT INTO ORDEN_ASIGNACION (cod_orden, fecha_hora_inicio, fecha_hora_fin, estado, cod_cuadrilla, cod_zona, cod_albergue)
     VALUES (6, TO_DATE('06/10/2026 09:00', 'DD/MM/YYYY HH24:MI'), TO_DATE('10/10/2026 17:00', 'DD/MM/YYYY HH24:MI'), 'Finalizada', 5, NULL, 103);
INSERT INTO ORDEN_ASIGNACION (cod_orden, fecha_hora_inicio, fecha_hora_fin, estado, cod_cuadrilla, cod_zona, cod_albergue)
     VALUES (7, TO_DATE('11/10/2026 08:00', 'DD/MM/YYYY HH24:MI'), NULL, 'Activa', 5, NULL, 108);
INSERT INTO ORDEN_ASIGNACION (cod_orden, fecha_hora_inicio, fecha_hora_fin, estado, cod_cuadrilla, cod_zona, cod_albergue)
     VALUES (8, TO_DATE('06/10/2026 06:00', 'DD/MM/YYYY HH24:MI'), NULL, 'Activa', 7, 9, NULL);
INSERT INTO ORDEN_ASIGNACION (cod_orden, fecha_hora_inicio, fecha_hora_fin, estado, cod_cuadrilla, cod_zona, cod_albergue)
     VALUES (9, TO_DATE('08/10/2026 08:00', 'DD/MM/YYYY HH24:MI'), NULL, 'Activa', 6, NULL, 109);
INSERT INTO ORDEN_ASIGNACION (cod_orden, fecha_hora_inicio, fecha_hora_fin, estado, cod_cuadrilla, cod_zona, cod_albergue)
     VALUES (10, TO_DATE('06/10/2026 10:00', 'DD/MM/YYYY HH24:MI'), NULL, 'Activa', 8, NULL, 104);
INSERT INTO ORDEN_ASIGNACION (cod_orden, fecha_hora_inicio, fecha_hora_fin, estado, cod_cuadrilla, cod_zona, cod_albergue)
     VALUES (11, TO_DATE('06/10/2026 10:00', 'DD/MM/YYYY HH24:MI'), TO_DATE('12/10/2026 18:00', 'DD/MM/YYYY HH24:MI'), 'Finalizada', 9, NULL, 104);
INSERT INTO ORDEN_ASIGNACION (cod_orden, fecha_hora_inicio, fecha_hora_fin, estado, cod_cuadrilla, cod_zona, cod_albergue)
     VALUES (12, TO_DATE('04/10/2026 06:00', 'DD/MM/YYYY HH24:MI'), NULL, 'Activa', 10, 1, NULL);
INSERT INTO ORDEN_ASIGNACION (cod_orden, fecha_hora_inicio, fecha_hora_fin, estado, cod_cuadrilla, cod_zona, cod_albergue)
     VALUES (13, TO_DATE('12/10/2026 07:00', 'DD/MM/YYYY HH24:MI'), NULL, 'Cancelada', 7, 10, NULL);


-- ============================================================================
-- La tabla AUDITORIA se llena sola con los disparadores TRG_AUD_*
-- ============================================================================

COMMIT;