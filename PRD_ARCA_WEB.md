# PRD: ARCA Web, demostrador de la base de datos

**Producto:** ARCA, Sistema de Gestión y Distribución Equitativa de Recursos para Emergencias y Desastres (SIGER-Emergencias)
**Equipo:** Andrés Felipe Gómez Carrillo (Arquitecto de Base de Datos) y Rodolfo José Hernández Luna (Administrador de Proyectos)
**Destinatario de este documento:** Claude Code, que construirá la aplicación.
**Versión:** 1.1, 29/10/2026 (agrega despliegue en Vercel)

---

## 1. Contexto

ARCA es una base de datos relacional en Oracle (Oracle APEX, apex.oracle.com) para gestionar la ayuda humanitaria después de un terremoto: zonas afectadas, albergues, centros de acopio, censo de damnificados, necesidades por persona, inventario por lotes, solicitudes, despachos, entregas a la persona, personal de socorro y auditoría.

La base ya existe y está probada. Tiene 34 tablas, 598 registros de prueba, 8 disparadores, 2 índices únicos condicionados y 2 vistas públicas. Se crea con estos scripts, que el equipo pondrá en la carpeta `db/` del repositorio y que son la **fuente de verdad del esquema**:

| Archivo | Qué hace |
|---|---|
| `0_ARCA_DROP.sql` | Borra los objetos en orden inverso, sin CASCADE CONSTRAINTS. |
| `1_ARCA_OBJETOS.sql` | Crea tablas, llaves, CHECK, índices, secuencia, disparadores y vistas. |
| `2_ARCA_DATOS.sql` | Carga los datos de prueba (terremoto del 03/10/2026). |
| `ARCA_CONSULTA1.sql` a `ARCA_CONSULTA5.sql` | Las 5 consultas del proyecto. |
| `ARCA_PRUEBAS_REGLAS.sql` | Sentencias que violan cada regla y que Oracle rechaza. |

Lee esos archivos antes de escribir cualquier SQL. **No modifiques la estructura de ninguna tabla existente ni esos scripts.** Todo lo nuevo en la base va en scripts nuevos (sección 7).

## 2. Objetivo

Construir una aplicación web sencilla que muestre cómo funciona la base de datos en una operación real. La aplicación es para una exposición de 10 minutos en clase. Se publicará en internet con un link (Vercel, plan gratuito Hobby) y también se podrá ejecutar localmente en el portátil como respaldo.

Debe demostrar tres cosas:

1. **Las consultas funcionan sobre datos reales**: las 5 consultas del proyecto, con sus resultados en vivo.
2. **Las reglas de negocio viven en la base de datos**: cuando una operación viola una regla, quien la rechaza es Oracle (disparador, CHECK o índice único), y la aplicación muestra ese rechazo de forma clara.
3. **El diferenciador de ARCA**: cada ayuda queda registrada a nombre de la persona que la recibe y se puede rastrear, y el damnificado tiene voz propia.

## 3. Alcance

### Incluido
- Pantalla inicial con selector de perfil, sin login.
- Perfil **Coordinador**: panel de las 5 consultas, cuatro operaciones que activan reglas de Oracle, lista de manifestaciones recibidas y botón "Restablecer demo".
- Perfil **Quiosco del damnificado**: ingreso con código de censo o documento, consulta de entregas y necesidades propias, y registro de una manifestación.
- Perfil **Transparencia pública**: cifras agregadas por zona y cupos de albergues, sin datos personales.
- API REST en Oracle (ORDS) y servidor Next.js que la consume.
- Despliegue en Vercel (plan Hobby) y ejecución local con el mismo código.
- Clave de demostración para las operaciones de escritura en la versión publicada.
- Modo sin conexión de solo lectura en la versión local.

### Fuera de alcance
- Login real, roles y gestión de usuarios.
- CRUD general de tablas.
- Dominio propio: se usa la URL que asigna Vercel.
- Pantalla de auditoría (la tabla AUDITORIA se sigue llenando por disparadores, pero no se muestra).
- Cambiar el estado de un despacho, validar necesidades o asignar cuadrillas.

## 4. Usuarios y perfiles

| Perfil | Quién es en la historia | Qué hace en la app |
|---|---|---|
| Coordinador | Coordinador de la emergencia u operador de centro de acopio | Ve las 5 consultas, ejecuta las 4 operaciones, lee las manifestaciones y restablece la demo. |
| Quiosco | Persona damnificada en un albergue | Se identifica con su código de censo (o documento), ve lo que ha recibido y lo que necesita, y manifiesta algo. |
| Transparencia | Ciudadanía y donantes | Ve cifras agregadas por zona y cupos de albergues. Nunca ve nombres, documentos ni necesidades individuales. |

## 5. Arquitectura

```
Navegador (link de Vercel o localhost:3000)
   │  solo habla con el servidor Next.js
   ▼
Next.js (App Router, TypeScript)
   ├─ Páginas y componentes (React, Tailwind)
   ├─ Route handlers /api/*  ── capa servidor: único lugar que conoce la URL y las credenciales de ORDS
   │      ├─ obtiene y cachea el token OAuth2 (client credentials)
   │      ├─ llama a ORDS y normaliza la respuesta
   │      ├─ traduce errores ORA a mensajes de regla de negocio
   │      ├─ valida la clave de demostración en las operaciones de escritura
   │      └─ solo en local: guarda en data/cache/ la última respuesta exitosa de cada GET
   ▼
ORDS en apex.oracle.com (módulo REST "arca")
   ▼
Oracle Database: esquema del workspace, tablas ARCA, disparadores, vistas
```

Decisiones:
- **El navegador nunca llama a ORDS directamente.** Así se evitan problemas de CORS y las credenciales no llegan al cliente.
- **Las reglas no se reimplementan en la app.** La app hace validaciones de interfaz para guiar al usuario (listas filtradas, campos obligatorios), pero nunca decide si una operación viola RN-03, RN-05, RN-08 o RN-12: eso lo decide Oracle. Para la demo debe ser posible enviar una operación que viole la regla y ver el rechazo de Oracle.
- Stack: Next.js 15 o superior con App Router, TypeScript estricto, Tailwind CSS, Recharts para gráficos y Node 20 o superior. Sin base de datos local.

## 6. Configuración

Las mismas variables se usan en local (archivo `.env.local`, no versionado, con su plantilla `.env.example`) y en Vercel (Settings > Environment Variables):

```
ORDS_BASE_URL=https://apex.oracle.com/pls/apex/<alias_del_esquema>/arca/
ORDS_OAUTH_TOKEN_URL=https://apex.oracle.com/pls/apex/<alias_del_esquema>/oauth/token
ORDS_CLIENT_ID=
ORDS_CLIENT_SECRET=
DEMO_TIMEZONE=America/Bogota
DEMO_CLAVE=            # clave para operaciones de escritura; vacía = sin clave
CACHE_LOCAL=true       # true en local; false en Vercel
```

**Clave de demostración.** Si `DEMO_CLAVE` tiene valor, todo POST (operaciones, manifestaciones del quiosco y restablecer) exige el encabezado `x-demo-clave` con esa clave; si no coincide, el servidor responde 401 sin llamar a ORDS. En la interfaz, la primera vez que alguien intenta una operación aparece un diálogo que pide la clave y la guarda en `sessionStorage` para el resto de la sesión. Las consultas (GET) nunca piden clave. En local se puede dejar vacía.

El alias del esquema se ve en APEX, en SQL Workshop > RESTful Services. El README debe explicar cómo encontrarlo.

## 7. Base de datos: objetos nuevos

Genera dos scripts nuevos en `db/`, para ejecutar en APEX (SQL Workshop > SQL Scripts) después de `2_ARCA_DATOS.sql`:

### 7.1 `3_ARCA_RESTABLECER.sql`

Crea el procedimiento `P_RESTABLECER_DEMO`, que deja la base exactamente como la deja `2_ARCA_DATOS.sql`:

1. `DELETE` de todas las tablas en el mismo orden de `0_ARCA_DROP.sql` (de hijas a padres), sin `DROP` ni DDL.
2. `DELETE FROM AUDITORIA` al final, porque los disparadores de auditoría registran las eliminaciones.
3. Los mismos `INSERT` y los 2 `UPDATE` de `2_ARCA_DATOS.sql`, en el mismo orden. Así los disparadores vuelven a descontar el inventario y a generar los 124 registros de auditoría.
4. `COMMIT` al final. Si algo falla: `ROLLBACK` y `RAISE`.

Requisitos:
- **Genera el cuerpo del procedimiento a partir de `2_ARCA_DATOS.sql` con un script del repositorio** (`scripts/generar-restablecer.ts`), no a mano, para que los datos no se desincronicen. El script quita el `COMMIT` del archivo original y envuelve las sentencias en el procedimiento.
- La secuencia `SEQ_AUDITORIA` no se reinicia: los códigos de auditoría siguen creciendo, y es aceptable.
- Incluye comentarios en el estilo de los scripts existentes.

### 7.2 `4_ARCA_API_REST.sql`

Define el módulo ORDS `arca` (ruta base `/arca/`) con la API PL/SQL de ORDS disponible en apex.oracle.com (`ORDS.DEFINE_MODULE`, `DEFINE_TEMPLATE`, `DEFINE_HANDLER`). Protege el módulo con un privilegio y crea un cliente OAuth2 de tipo *client credentials*. El script imprime con `DBMS_OUTPUT` el `client_id` y el `client_secret` para copiarlos a `.env.local` y a las variables de Vercel. Verifica la sintaxis contra la versión de ORDS en uso y, si algo difiere, documenta el cambio en el README.

Convenciones de los handlers:
- **Consultas (GET):** tipo colección (`source_type_collection_feed`), sin paginación (`p_items_per_page => 0`) para que los catálogos lleguen completos, con alias de columnas en `snake_case` y sin comillas, porque ORDS usa el alias como nombre del campo JSON. Las fechas se devuelven ya formateadas con `TO_CHAR(..., 'DD/MM/YYYY')` o `'DD/MM/YYYY HH24:MI'`, para evitar corrimientos de zona horaria.
- **Mismo estilo SQL del proyecto:** sin `JOIN` (las tablas se relacionan en el `WHERE`) y sin `SELECT *`.
- **Las 5 consultas** usan exactamente la lógica de `ARCA_CONSULTA1.sql` a `ARCA_CONSULTA5.sql`. Solo cambian los alias y los parámetros indicados.
- **Operaciones (POST):** tipo PL/SQL. Leen los campos del cuerpo JSON como binds (`:campo`), calculan el código nuevo con `NVL(MAX(cod), 0) + 1` y hacen `COMMIT`. Ante cualquier error: `ROLLBACK`, `:status_code := 422` y una respuesta JSON `{"ok": false, "sqlcode": SQLCODE, "mensaje": SQLERRM}`. En éxito: `{"ok": true, ...}` con el código creado.

### 7.3 Endpoints

**Catálogos para formularios (GET)**

| Ruta | Devuelve |
|---|---|
| `catalogos/centros` | Centros de acopio: código y nombre. |
| `catalogos/albergues` | Albergues: código, nombre y municipio. |
| `catalogos/destinos` | Albergues y puntos de entrega. |
| `catalogos/insumos` | Insumos con perecedero, unidad y modalidad. |
| `catalogos/solicitudes` | Solicitudes con estado distinto de Rechazada: código, zona y descripción. |
| `catalogos/conductores` | Personal de socorro de tipo Conductor. |
| `catalogos/lotes?centro=` | Lotes de un centro con disponible mayor que 0: insumo, número de lote, vencimiento y disponible. |
| `catalogos/familias` | Familias con sus integrantes y su alojamiento activo (si tienen). |
| `catalogos/despachos-entregados` | Despachos en estado Entregado, con destino. |
| `catalogos/despachos/:id/insumos` | Insumos de un despacho, con cantidad despachada y cantidad ya entregada. |
| `catalogos/beneficiarios` | Damnificados con registro Activo en el censo. |
| `catalogos/personas` | Todas las personas (para elegir el receptor). |
| `catalogos/necesidades?beneficiario=&insumo=` | Necesidades validadas y vigentes del beneficiario cuya categoría cubre el insumo. |

**Consultas del panel (GET)**

| Ruta | Basada en | Parámetro |
|---|---|---|
| `consultas/trazabilidad?codigo_censo=` | ARCA_CONSULTA1 | Código de censo; en la interfaz, valor por defecto `4821`. |
| `consultas/ocupacion` | ARCA_CONSULTA2 | Ninguno. |
| `consultas/prorrateo?insumo=` | ARCA_CONSULTA3 | Nombre del insumo; por defecto `Agua potable bolsa 6 L`. |
| `consultas/indice-necesidades` | ARCA_CONSULTA4 | Ninguno. |
| `consultas/vencimientos?dias=` | ARCA_CONSULTA5 | Días hacia adelante; por defecto 90. |
| `manifestaciones` | MANIFESTACION + PERSONA | Ninguno. Lista para el Coordinador, de la más reciente a la más antigua. |

**Quiosco (GET y POST)**

| Ruta | Qué hace |
|---|---|
| `GET quiosco/persona?codigo_censo=` o `?documento=` | Datos básicos: nombres, código de censo, familia, albergue actual y zona. Si no existe o no tiene censo activo, responde 404. |
| `GET quiosco/:codigo_censo/entregas` | Sus entregas: insumo, cantidad, fecha, quién recogió y despacho. |
| `GET quiosco/:codigo_censo/necesidades` | Sus necesidades: categoría, estado y vigencia. |
| `GET quiosco/:codigo_censo/manifestaciones` | Sus manifestaciones con estado y respuesta. |
| `POST quiosco/manifestaciones` | Body: `codigo_censo`, `tipo`, `descripcion`. Inserta con `canal = 'Quiosco'`, `estado = 'Abierta'`, `cod_registrador = NULL` y fecha de hoy. |

**Transparencia (GET)**

| Ruta | Fuente |
|---|---|
| `publico/zonas` | Vista `V_TRANSPARENCIA_ZONA`. |
| `publico/albergues` | Vista `V_CUPOS_ALBERGUE`. |

**Operaciones (POST)**

| Ruta | Body | Qué hace en Oracle | Reglas que pueden rechazarla |
|---|---|---|---|
| `operaciones/alojar` | `cod_familia`, `cod_albergue` | INSERT en FAMILIA_ALBERGUE con fecha de hoy y sin salida. | RN-03 (TRG_FAL_CAPACIDAD), RN-13 (UX_FAL_ACTIVA) |
| `operaciones/ingresar-lote` | `cod_centro`, `cod_insumo`, `num_lote`, `origen`, `fecha_recepcion`, `fecha_vencimiento` (opcional), `cantidad` | INSERT en INVENTARIO_LOTE con `cantidad_disponible = cantidad_recibida`. | RN-05 (C_ILO_VENC_CK), C_ILO_ORIG_CK, C_ILO_CREC_CK |
| `operaciones/despachar` | `cod_centro`, `cod_solicitud`, `cod_destino`, `placa`, `cod_conductor`, `cod_lote`, `cantidad` | En **una sola transacción**: INSERT en DESPACHO (estado Pendiente, confirmación N, fecha de hoy) e INSERT en DESPACHO_LOTE. Si el disparador rechaza el lote, se deshace también el despacho. | RN-08 y RN-12 (TRG_DLO_DESCUENTO) |
| `operaciones/entregar` | `cod_despacho`, `cod_insumo`, `cod_beneficiario`, `cod_receptor`, `metodo_identificacion`, `cantidad`, `cod_necesidad` (opcional) | INSERT en ENTREGA con fecha y hora actuales. | C_ENT_MET_CK, C_ENT_CANT_CK, llaves foráneas |

**Administración (POST)**

| Ruta | Qué hace |
|---|---|
| `admin/restablecer` | Ejecuta `P_RESTABLECER_DEMO`. |

## 8. Traducción de errores de Oracle

La capa servidor convierte el error de Oracle en un mensaje entendible, **sin ocultar el original**. La interfaz muestra los dos: el mensaje de negocio y, debajo, el texto de Oracle (`ORA-20003: ...`), porque en la exposición el punto es mostrar que fue Oracle quien rechazó.

| Error | Regla | Mensaje en pantalla |
|---|---|---|
| ORA-20003 | RN-03 | El albergue ya alcanzó su capacidad máxima. |
| ORA-20008 | RN-08 | La cantidad supera la disponibilidad real del lote. |
| ORA-20012 | RN-12 | El lote no pertenece al centro de acopio que emite el despacho. |
| ORA-02290 con `C_ILO_VENC_CK` | RN-05 | Los perecederos deben vencer al menos 30 días después de su recepción. |
| ORA-00001 con `UX_FAL_ACTIVA` | RN-13 | La familia ya tiene un alojamiento activo. |
| ORA-02290 (otra) | Dominio | Un valor no está permitido (indica la restricción). |
| ORA-02291 | Integridad | Un dato referenciado no existe. |
| ORA-00001 (otro) | Unicidad | Ya existe un registro con ese valor. |
| Otro | | Error de la base de datos (mostrar el texto original). |

Implementa la traducción en `lib/errores-oracle.ts`, con pruebas unitarias para cada fila de la tabla.

## 9. Pantallas

Interfaz en español. Fechas en formato DD/MM/AAAA y zona horaria America/Bogota. Debe funcionar bien en un portátil (desde 1280 px de ancho) y verse correctamente en un proyector.

### 9.1 Inicio (`/`)
- Logo o nombre ARCA y el eslogan "Cada ayuda, a quien la necesita."
- Tres tarjetas grandes: Coordinador, Quiosco del damnificado y Transparencia pública, cada una con una línea que explica qué ve ese perfil.
- Indicador de estado de la conexión con Oracle (verde: conectado; ámbar: sin conexión, con datos guardados, solo en local).

### 9.2 Coordinador (`/coordinador`)
Encabezado con el nombre del perfil, el botón "Restablecer demo" y un enlace para volver al inicio.

**Pestaña "Consultas"**: cinco subpestañas, una por consulta, cada una con:
- Título y una frase que explica qué responde, con el mismo objetivo del documento del proyecto.
- El parámetro editable cuando aplica (código de censo, insumo, días).
- La tabla de resultados.
- Un panel plegable **"Ver SQL"** que muestra el SQL de la consulta tal como está en `ARCA_CONSULTAn.sql`, tomado de los archivos de `db/`. Como en Vercel no se garantiza leer archivos del repositorio en tiempo de ejecución, un script `prebuild` (`scripts/generar-sql.ts`) copia el texto de `ARCA_CONSULTA1.sql` a `ARCA_CONSULTA5.sql` a `src/generated/consultas-sql.ts` antes de cada build. Así se puede mostrar en clase que la app ejecuta la misma consulta del documento.
- Elementos visuales simples donde ayudan: barra de ocupación por albergue (roja al 100%), índice de atención como porcentaje con color (rojo 0%, ámbar menor de 100%, verde 100%) y días restantes resaltados cuando faltan menos de 30.

**Pestaña "Operaciones"**: cuatro tarjetas con formulario (Alojar familia, Ingresar lote, Despachar lote y Registrar entrega). Cada formulario:
- Usa listas desplegables alimentadas por los catálogos, no campos de texto para códigos.
- Para Registrar entrega, filtra: despacho Entregado, luego insumos de ese despacho con su saldo (despachado menos entregado), luego beneficiario con censo activo y las necesidades que ese insumo cubre. La app advierte si la cantidad supera el saldo (RN-25 aún no está en la base), pero permite enviar.
- Al enviar muestra un panel de resultado: verde con lo que se creó, o rojo con la regla violada y el texto de Oracle (sección 8).
- Después de un éxito, invalida la caché de las consultas relacionadas: alojar actualiza ocupación; ingresar y despachar actualizan vencimientos y prorrateo; entregar actualiza trazabilidad e índice.
- Tiene un enlace **"Usar datos de demostración"** que llena el formulario con un caso que Oracle rechaza (sección 11), para no improvisar en la exposición.

**Pestaña "Manifestaciones"**: tabla de solo lectura con fecha, damnificado, tipo, canal, estado y respuesta. Las que llegan del quiosco aparecen arriba.

**Restablecer demo**: abre un diálogo de confirmación ("Se borrarán todos los cambios hechos en la demostración y se recargarán los datos originales."). Muestra un indicador de progreso mientras corre y, al terminar, recarga todas las consultas.

### 9.3 Quiosco (`/quiosco` y `/quiosco/[codigo]`)
- Pantalla de entrada tipo quiosco: teclado numérico grande en pantalla para el código de censo, y un enlace "No recuerdo mi código" que cambia a ingreso por documento.
- Ficha de la persona con nombre, código, albergue o zona, y tres secciones: **Lo que he recibido** (entregas), **Mis necesidades** (categoría, estado, vigencia) y **Mis manifestaciones** (estado y respuesta).
- Botón **"Quiero manifestar algo"**: tres opciones grandes (Necesidad nueva, No recibí, No me sirve), un campo de descripción y el botón Enviar. Muestra una confirmación y la manifestación aparece en su lista y en la del Coordinador.
- Botón "Salir" que vuelve a la pantalla de entrada. La sesión del quiosco se cierra sola después de 2 minutos sin actividad.
- Tipografía grande y alto contraste: lo usan personas con poca experiencia digital, incluidos adultos mayores.

### 9.4 Transparencia (`/transparencia`)
- Encabezado: "Así se distribuye la ayuda".
- Tarjetas de totales: personas censadas, entregas registradas y necesidades atendidas sobre validadas.
- Gráfico de barras por zona con necesidades validadas y atendidas, ordenado por nivel de daño.
- Tabla de cupos por albergue con barra de ocupación.
- Nota fija: "Información agregada. No se muestran datos personales (Ley 1581 de 2012)."
- Esta pantalla **solo** usa los endpoints `publico/*`.

## 10. Diseño visual

- Marca ARCA. Color principal azul `#153D63`, acento naranja (por ejemplo `#E8833A`) para cifras y llamados a la acción, fondo blanco y grises neutros.
- Rojo, ámbar y verde solo para estados (rechazo o alerta, advertencia, éxito), nunca como decoración.
- Tipografía sin serifa (Inter o Montserrat), con títulos grandes legibles en proyector.
- Íconos simples (lucide-react).
- Nada de rayas largas (el carácter U+2014) en los textos de la interfaz; usar comas, dos puntos o paréntesis.

## 11. Guion de demostración y criterios de aceptación

La app está terminada cuando este guion funciona de principio a fin con la base recién restablecida:

1. **Inicio:** se ven los tres perfiles y el indicador verde de conexión.
2. **Transparencia:** aparecen las 12 zonas y los 10 albergues; la Casa Comunal Río Otún sale al 100%. No aparece ningún nombre de persona.
3. **Quiosco:** con el código `4821` aparece Ana María Ruiz Peña con 4 entregas (ropa de abrigo, mercado recogido por Martha Lucía Ruiz Peña, agua y kit de medicamentos). Registra una manifestación "No recibido", que aparece en su lista y en la pestaña Manifestaciones del Coordinador. Con el documento `63500111` se llega a la misma persona.
4. **Coordinador, consultas:** las 5 subpestañas muestran los mismos resultados que las consultas en APEX:
   - Prorrateo: Istmina 1.552,79 L; Bahía Solano 997,06 L; Calarcá 670,15 L.
   - Índice: Istmina, Comuna 12 Buenaventura y Comuna Río Otún en 0%; Vereda Alto Llano en 66,7%.
   - Ocupación: Casa Comunal Río Otún al 100%.
   - "Ver SQL" muestra el SQL de cada archivo.
5. **Alojar familia:**
   - Familia 5 en la Casa Comunal Río Otún: **rechazo RN-03** con el texto ORA-20003.
   - Familia 5 en el Coliseo Cubierto de Quibdó: éxito, y la ocupación de ese albergue pasa de 4 a 7 personas.
6. **Ingresar lote:**
   - Leche de fórmula en el Centro de Acopio Floridablanca, recibida hoy y con vencimiento a 20 días: **rechazo RN-05**.
   - El mismo lote con vencimiento a 60 días: éxito, y aparece en Vencimientos.
7. **Despachar lote:**
   - Desde Floridablanca con el lote L-031 (disponible 0): **rechazo RN-08**, y no queda ningún despacho nuevo creado.
   - Desde Floridablanca con el lote L-070 (que es de Quibdó): **rechazo RN-12**.
   - Desde Floridablanca con el lote L-044 y 60 litros: éxito, y el disponible de L-044 baja de 1.020 a 960.
8. **Registrar entrega:** del despacho 15 (Coliseo Municipal de Piedecuesta, entregado), 12 litros de agua a Ana María (código 4821), recogidos por ella misma con código de censo. Éxito, y la trazabilidad de `4821` muestra 5 entregas.
9. **Restablecer demo:** después de confirmar, todo vuelve al estado del paso 1: Ana María tiene 4 entregas, L-044 vuelve a 1.020 y la familia 5 queda sin alojamiento.
10. **Sin conexión (solo local):** con la red desconectada, las pantallas muestran los últimos datos guardados con el aviso "Sin conexión: datos guardados del DD/MM/AAAA HH:MM", y los botones de operaciones y de restablecer quedan deshabilitados con su explicación.

Además:
- `npm run build` termina sin errores ni advertencias de TypeScript.
- `npm test` pasa, con pruebas de la traducción de errores y de los formateadores de fecha y número.
- `npm run smoke` llama a cada endpoint GET de ORDS e informa cuál falla.
- Ninguna credencial aparece en el código del cliente ni en el repositorio.
- **El guion completo (pasos 1 a 9) funciona igual en el link de Vercel y en local.** En el link, la primera operación pide la clave de demostración y sin ella devuelve 401.
- `npm run smoke` acepta `--url` para probar también la versión publicada.

## 12. Modo sin conexión (solo local)

En Vercel el sistema de archivos es de solo lectura y la app siempre está en línea, así que la caché en archivos solo se activa cuando `CACHE_LOCAL=true`. En Vercel, si ORDS no responde, la pantalla muestra un error claro con el botón Reintentar.

- Cada respuesta exitosa de un GET se guarda en `data/cache/<ruta>.json` con su fecha y hora.
- Si ORDS no responde en 8 segundos o la red falla, el servidor devuelve la copia guardada con la marca `desde_cache: true` y su fecha.
- Incluye un comando `npm run precargar` que recorre todos los GET (incluidas la trazabilidad de `4821` y el quiosco de `4821`) para llenar la caché antes de la exposición.
- Las operaciones, el quiosco (POST) y el restablecer nunca usan caché: si no hay conexión, se deshabilitan.

## 13. Estructura del repositorio

```
arca-web/
├─ db/                      scripts existentes + 3_ARCA_RESTABLECER.sql + 4_ARCA_API_REST.sql
├─ scripts/                 generar-restablecer.ts, generar-sql.ts, smoke.ts, precargar.ts
├─ data/cache/              (ignorado en git)
├─ src/app/                 páginas: /, /coordinador, /quiosco, /quiosco/[codigo], /transparencia
├─ src/app/api/             route handlers que llaman a ORDS
├─ src/components/          componentes de interfaz
├─ src/lib/                 cliente ORDS, OAuth, caché, clave de demo, errores-oracle, formatos
├─ src/generated/           consultas-sql.ts (lo genera el prebuild; ignorado en git)
├─ tests/
├─ .env.example
└─ README.md
```

El README debe estar en español y explicar:
1. Requisitos: Node 20 o superior y acceso al workspace de APEX.
2. Orden de ejecución en APEX: `0_ARCA_DROP`, `1_ARCA_OBJETOS`, `2_ARCA_DATOS`, `3_ARCA_RESTABLECER`, `4_ARCA_API_REST`, y dónde copiar el `client_id` y el `client_secret`.
3. Instalación y arranque local: `npm install`, `npm run precargar` y `npm run dev`.
4. Despliegue en Vercel paso a paso: subir el repositorio a GitHub (privado), importarlo en vercel.com con una cuenta Hobby, cargar las variables de entorno con `CACHE_LOCAL=false` y una `DEMO_CLAVE`, desplegar y probar el guion en el link.
5. El guion de demostración de la sección 11.
6. Qué hacer si falla: la conexión, el token, un endpoint o el despliegue.

## 14. Plan de trabajo sugerido

1. Generar `3_ARCA_RESTABLECER.sql` y `4_ARCA_API_REST.sql`. Pausa: el equipo los ejecuta en APEX y entrega las credenciales.
2. Cliente ORDS, OAuth, caché, traducción de errores, `npm run smoke` y pruebas.
3. Pantalla de inicio y Transparencia (solo lectura, para validar la conexión de punta a punta).
4. Coordinador: panel de consultas con "Ver SQL".
5. Quiosco.
6. Coordinador: operaciones, manifestaciones y restablecer demo.
7. Modo sin conexión, precarga, clave de demostración y README.
8. Despliegue en Vercel y prueba del guion en el link.
9. Recorrer completo el guion de la sección 11 en local y en el link, y corregir.

Al terminar cada paso, muestra al equipo qué se puede probar. Si una decisión no está cubierta por este documento, elige la opción más simple que cumpla el guion de la sección 11 y anótala en el README, en una sección "Decisiones".

## 15. Riesgos

| Riesgo | Mitigación |
|---|---|
| No hay internet el día de la exposición | Usar la versión local con caché precargada (sección 12). |
| Alguien con el link modifica o restablece los datos | Clave de demostración en todos los POST (sección 6); el repositorio es privado. |
| Se exceden los límites del plan gratuito de Vercel | Muy improbable con el tráfico de una clase; si pasa, se usa la versión local. |
| La sintaxis de ORDS u OAuth difiere en la versión de apex.oracle.com | Verificar contra la versión en uso; si OAuth no se puede configurar, documentarlo y pedir decisión al equipo antes de dejar el módulo sin protección. |
| Los datos de la demo quedan alterados entre ensayos | Botón Restablecer demo y paso 9 del guion. |
| `P_RESTABLECER_DEMO` se desincroniza de `2_ARCA_DATOS.sql` | Se genera con un script, nunca a mano. |
| Fechas corridas por zona horaria | Formatear fechas en Oracle con `TO_CHAR`. |
| La docente pregunta cómo funciona la app | "Ver SQL" en cada consulta, errores de Oracle visibles y README con la arquitectura. |
