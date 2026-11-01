# ARCA Web: demostrador de la base de datos

ARCA (SIGER-Emergencias) gestiona la ayuda humanitaria después de un terremoto. Esta aplicación muestra, en una exposición de 10 minutos, que:

1. las 5 consultas del proyecto funcionan sobre datos reales;
2. las reglas de negocio viven en Oracle (quien rechaza una operación es un disparador, un CHECK o un índice único);
3. cada ayuda queda a nombre de la persona que la recibe, y el damnificado tiene voz propia.

Equipo: Andrés Felipe Gómez Carrillo (Arquitecto de Base de Datos) y Rodolfo José Hernández Luna (Administrador de Proyectos).

## Arquitectura

```
Navegador (link de Vercel o localhost:3000)
   │  solo habla con el servidor Next.js
   ▼
Next.js 15 (App Router, TypeScript)
   ├─ Páginas: /, /coordinador, /quiosco, /quiosco/[codigo], /transparencia
   └─ Route handlers /api/*   (único lugar que conoce la URL y las credenciales de ORDS)
          ├─ token OAuth2 (client credentials), guardado en memoria
          ├─ lista blanca de rutas y normalización de la respuesta de ORDS
          ├─ traducción de errores ORA (src/lib/errores-oracle.ts)
          ├─ clave de demostración en todos los POST (encabezado x-demo-clave)
          └─ solo en local: caché en data/cache/ para el modo sin conexión
   ▼
ORDS en apex.oracle.com (módulo REST "arca")
   ▼
Oracle: tablas ARCA, disparadores, vistas, P_RESTABLECER_DEMO y PKG_ARCA_API
```

| Carpeta | Contenido |
|---|---|
| `db/` | Scripts del proyecto (0 a 2 y consultas) + `3_ARCA_RESTABLECER.sql` + `4_ARCA_API_REST.sql` |
| `scripts/` | `generar-restablecer.ts`, `generar-sql.ts`, `smoke.ts`, `precargar.ts` |
| `src/app/` | Páginas y route handlers (`src/app/api/`) |
| `src/components/` | Interfaz (coordinador, quiosco, transparencia) |
| `src/lib/` | Cliente ORDS, OAuth, caché, clave de demo, errores de Oracle, formatos |
| `src/generated/` | `consultas-sql.ts`, lo genera el prebuild (ignorado en git) |
| `tests/` | Pruebas de errores de Oracle, formatos, rutas y clave |

## 1. Requisitos

- Node 20 o superior (probado con Node 24).
- Acceso al workspace de APEX en apex.oracle.com con los objetos de ARCA.

## 2. Base de datos en APEX

En APEX: **SQL Workshop > SQL Scripts**, subir y ejecutar en este orden:

1. `db/0_ARCA_DROP.sql` (si los objetos ya existían)
2. `db/1_ARCA_OBJETOS.sql`
3. `db/2_ARCA_DATOS.sql`
4. `db/3_ARCA_RESTABLECER.sql`: crea el procedimiento `P_RESTABLECER_DEMO`.
5. `db/4_ARCA_API_REST.sql`: crea el paquete `PKG_ARCA_API`, el módulo REST `arca`, el privilegio `arca.api` (que protege todo el módulo) y el cliente OAuth2 `arca_web`.

Al terminar el paso 5, en los resultados del script (ver **View Results** del script), aparecen dos líneas:

```
ORDS_CLIENT_ID=...
ORDS_CLIENT_SECRET=...
```

Cópielas a `.env.local` (local) y a las variables de entorno de Vercel. **El secreto solo se muestra en ese momento.** Si se pierde, vuelva a ejecutar `4_ARCA_API_REST.sql`: borra el cliente y crea uno nuevo con credenciales nuevas.

### Dónde ver el alias del esquema

En APEX: **SQL Workshop > RESTful Services > Modules > arca**: la **Full URL** tiene la forma `https://apex.oracle.com/pls/apex/<alias>/arca/`. Si APEX pide **Register Schema with ORDS**, regístrelo primero (deje el alias que propone). No hace falta crear ninguna aplicación de APEX: el módulo REST vive en el esquema.

Use el dominio final, **`oracleapex.com/ords`**, no el que muestra APEX:

```
ORDS_BASE_URL=https://oracleapex.com/ords/<alias>/arca/
ORDS_OAUTH_TOKEN_URL=https://oracleapex.com/ords/<alias>/oauth/token
```

`apex.oracle.com/pls/apex/...` redirige (302) a `apex.oracle.com/ords/...` y de ahí a `oracleapex.com/ords/...`. Con una redirección 302 el POST del token se convierte en GET y ORDS responde **405 Method Not Allowed**. El cliente de la aplicación (`src/lib/ords/http.ts`) igual sigue esas redirecciones conservando el método, pero con la URL final se ahorran dos saltos en cada llamada.

Los valores de `ORDS_CLIENT_ID` y `ORDS_CLIENT_SECRET` suelen terminar en `..`: los puntos son parte del valor.

### Sintaxis de ORDS usada (verificar contra la versión en uso)

- Módulo, plantillas y manejadores: `ORDS.DEFINE_MODULE`, `ORDS.DEFINE_TEMPLATE`, `ORDS.DEFINE_HANDLER`.
- Rol y privilegio: `ORDS.CREATE_ROLE` y `ORDS.DEFINE_PRIVILEGE` con `p_modules => 'arca'`.
- Cliente OAuth2: `ORDS_SECURITY.REGISTER_CLIENT` con `p_client_secret => NULL` (ORDS genera el secreto) y `ORDS_SECURITY.GRANT_CLIENT_ROLE`. Se usa `ORDS_SECURITY` porque el paquete `OAUTH` quedó sin soporte desde ORDS 25.3. Para un ORDS anterior a 23.3, el final de `4_ARCA_API_REST.sql` trae comentado el bloque equivalente con `OAUTH.CREATE_CLIENT`.
- La versión de ORDS se ve en **SQL Workshop > RESTful Services** o con `SELECT ords.installed_version FROM dual;`.

Verificado el 29/10/2026 en apex.oracle.com (esquema `WKSP_ANDRESGOMMZ`): los scripts 3 y 4 funcionaron sin cambios; `npm run smoke` respondió 27 de 27 endpoints, y los pasos 5 a 9 del guion dieron los resultados esperados (incluido `P_RESTABLECER_DEMO`, que tardó unos 4 segundos).

Si las credenciales se pierden, en **SQL Workshop > SQL Commands** (que muestra la salida de `DBMS_OUTPUT` en **Results**) se puede ejecutar solo el último bloque de `4_ARCA_API_REST.sql`, el que empieza con `DECLARE l_credenciales`: borra el cliente `arca_web` y crea uno nuevo.

## 3. Instalación y arranque local

```bash
npm install
```

Cree `.env.local` a partir de `.env.example` y complete los valores:

```
ORDS_BASE_URL=https://oracleapex.com/ords/<alias>/arca/
ORDS_OAUTH_TOKEN_URL=https://oracleapex.com/ords/<alias>/oauth/token
ORDS_CLIENT_ID=<del paso 5>
ORDS_CLIENT_SECRET=<del paso 5>
DEMO_TIMEZONE=America/Bogota
DEMO_CLAVE=
CACHE_LOCAL=true
```

Compruebe la conexión, llene la caché del modo sin conexión y arranque:

```bash
npm run smoke
```

```bash
npm run precargar
```

```bash
npm run dev
```

La aplicación queda en http://localhost:3000.

Otros comandos:

| Comando | Qué hace |
|---|---|
| `npm test` | Pruebas unitarias (errores de Oracle, formatos, rutas, clave). |
| `npm run build` | Build de producción (antes corre `generar-sql`). |
| `npm run smoke` | Llama a cada GET de ORDS e informa cuál falla. |
| `npm run smoke -- --url https://<app>.vercel.app` | Lo mismo contra la versión publicada, y verifica que un POST sin clave responda 401. |
| `npm run precargar` | Guarda en `data/cache/` todas las respuestas GET (incluidas la trazabilidad y el quiosco de `4821`). |
| `npm run generar-restablecer` | Regenera `db/3_ARCA_RESTABLECER.sql` desde `0_ARCA_DROP.sql` y `2_ARCA_DATOS.sql`. |

## 4. Despliegue en Vercel (plan Hobby)

1. Suba el repositorio a GitHub como **privado**. `.env.local` y `data/cache/` están en `.gitignore`: no se suben.
2. En https://vercel.com, con una cuenta Hobby: **Add New > Project**, importe el repositorio. Vercel detecta Next.js; no cambie los comandos (`npm run build` ya ejecuta el prebuild que genera el SQL de "Ver SQL").
3. Antes de desplegar, en **Settings > Environment Variables** cargue:
   - `ORDS_BASE_URL`, `ORDS_OAUTH_TOKEN_URL`, `ORDS_CLIENT_ID`, `ORDS_CLIENT_SECRET`
   - `DEMO_TIMEZONE=America/Bogota`
   - `DEMO_CLAVE=<una clave para la clase>`
   - `CACHE_LOCAL=false`
4. **Deploy**. Al terminar, Vercel da el link (`https://<proyecto>.vercel.app`).
5. Pruebe el link:

```bash
npm run smoke -- --url https://<proyecto>.vercel.app
```

6. Recorra el guion de la sección 5 en el link. La primera operación pide la clave de demostración; sin ella, el servidor responde 401 y no llama a ORDS.

Si cambia una variable de entorno, haga **Redeploy** para que tome efecto.

### Vercel con Oracle Cloud (Autonomous Database), sin depender del portátil

oracleapex.com (el apex.oracle.com gratuito) rechaza las llamadas desde Vercel. Con una **Autonomous Database Always Free** en Oracle Cloud sí funciona: su ORDS queda en `https://<id>-<base>.adb.<región>.oraclecloudapps.com/ords/<alias>/`, sin ese cortafuegos.

Configuración usada (01/11/2026): base `ARCA` en Bogotá (`sa-bogota-1`), workspace de APEX `ARCA`, esquema `WKSP_ARCA`, alias REST `arca_siger`.

1. En Oracle Cloud: **Oracle Database › Autonomous Database › Create**, *Transaction Processing*, **Always Free**, acceso *Secure access from everywhere*.
2. **Tool configuration › Oracle APEX**: entrar como ADMIN y crear el workspace con un esquema nuevo.
3. En el workspace, **SQL Workshop › SQL Commands**: habilitar REST si `SELECT * FROM user_ords_schemas` no devuelve filas:

```sql
BEGIN
  ORDS.ENABLE_SCHEMA(p_enabled => TRUE, p_url_mapping_type => 'BASE_PATH',
                     p_url_mapping_pattern => 'arca_siger', p_auto_rest_auth => FALSE);
  COMMIT;
END;
```

4. **SQL Scripts**: ejecutar 1, 2, 3 y 4 (no el 0 en un esquema nuevo). Luego crear el cliente con el último bloque de `4_ARCA_API_REST.sql` en **SQL Commands**.
5. En Vercel, con la **Full URL** del módulo `arca` (RESTful Services › Modules):

```
ORDS_BASE_URL=https://<id>-<base>.adb.<región>.oraclecloudapps.com/ords/arca_siger/arca/
ORDS_OAUTH_TOKEN_URL=https://<id>-<base>.adb.<región>.oraclecloudapps.com/ords/arca_siger/oauth/token
```

más `ORDS_CLIENT_ID`, `ORDS_CLIENT_SECRET`, `DEMO_CLAVE`, `DEMO_TIMEZONE=America/Bogota` y `CACHE_LOCAL=false`; después **Redeploy**.

Verificado: `npm run smoke -- --url https://arca-siger.vercel.app` con 28 de 28 correctas. Las funciones de Vercel corren en São Paulo (`vercel.json`), la región de Vercel más cercana a la base.

**Antes de cada clase:** las bases Always Free se detienen solas después de 7 días sin uso. Entre a la consola de Oracle Cloud y confirme que la base esté *Available* (si no, **Start**); si queda detenida 90 días, Oracle la borra. Las bases de Oracle Cloud y de apex.oracle.com son independientes: restablecer una no cambia la otra.

### Link público desde el portátil (respaldo con apex.oracle.com)

oracleapex.com rechaza las llamadas que salen de los servidores de Vercel (HTTP 403), así que la versión de Vercel no se puede conectar a Oracle. Para tener un link que se abra desde otro computador o celular, la app corre en el portátil y un túnel de Cloudflare la publica: las llamadas a Oracle salen del portátil, que Oracle sí acepta.

1. Una sola vez, instale `cloudflared` (programa oficial de Cloudflare, gratis y sin cuenta):

```bash
winget install Cloudflare.cloudflared
```

2. Escriba una clave en `.env.local` (`DEMO_CLAVE=...`). Es obligatoria: con un link público, sin clave cualquiera podría modificar o restablecer la base. El comando no arranca si está vacía.
3. Antes de la clase:

```bash
npm run compartir
```

Compila la app, la arranca en modo producción y abre el túnel. En la consola aparece el link, del tipo `https://palabras-al-azar.trycloudflare.com`. Compruébelo con:

```bash
npm run smoke -- --url https://palabras-al-azar.trycloudflare.com
```

Tenga en cuenta:

- **El link cambia cada vez** que se ejecuta `npm run compartir`: compártalo el mismo día. Un link fijo requiere una cuenta de Cloudflare con dominio propio.
- **El portátil debe seguir encendido**, con la ventana abierta y conectado a internet; desactive la suspensión durante la clase. `Ctrl+C` cierra la app y el túnel.
- La primera operación desde el link pide la clave de demostración.

Probado el 31/10/2026: smoke con 28 de 28 correctas a través del link (incluido el 401 sin clave).

## 5. Guion de demostración

Antes de empezar: **Coordinador > Restablecer demo**.

1. **Inicio:** tres perfiles e indicador verde "Conectado con Oracle".
2. **Transparencia:** 12 zonas y 10 albergues; la Casa Comunal Río Otún al 100 % (barra roja). Ningún nombre de persona.
3. **Quiosco:** código `4821` en el teclado. Aparece Ana María Ruiz Peña con 4 entregas (ropa de abrigo, mercado recogido por Martha Lucía Ruiz Peña, agua y kit de medicamentos). "Quiero manifestar algo" > "No recibí" > descripción > Enviar. La manifestación aparece en su lista y en **Coordinador > Manifestaciones** (arriba). "Salir", luego "No recuerdo mi código" con el documento `63500111`: llega a la misma persona.
4. **Coordinador > Consultas:** las 5 subpestañas.
   - Prorrateo: Istmina 1.552,79 L; Bahía Solano 997,06 L; Calarcá 670,15 L.
   - Índice: Istmina, Comuna 12 Buenaventura y Comuna Río Otún en 0 %; Vereda Alto Llano en 66,7 %.
   - Ocupación: Casa Comunal Río Otún al 100 %.
   - "Ver SQL" muestra el SQL de cada archivo `ARCA_CONSULTAn.sql`.
5. **Operaciones > Alojar familia:** "Usar datos de demostración (rechazo RN-03)" > Alojar: rechazo RN-03 con el texto ORA-20003. "Caso que Oracle acepta" (familia 5 en el Coliseo Cubierto de Quibdó): éxito; en Ocupación ese albergue pasa de 4 a 7 personas.
6. **Ingresar lote:** "Usar datos de demostración (rechazo RN-05: vence a 20 días)": rechazo RN-05. "Caso que Oracle acepta (vence a 60 días)": éxito, y el lote aparece en Vencimientos.
7. **Despachar lote:** "Usar datos de demostración (rechazo RN-08: L-031)": rechazo RN-08 y no queda despacho creado. "Rechazo RN-12: L-070 de Quibdó": rechazo RN-12. "Caso que Oracle acepta: L-044, 60 L": éxito, y el disponible de L-044 baja de 1.020 a 960.
8. **Registrar entrega:** "Caso que Oracle acepta: 12 L de agua a Ana María" (despacho 15, Coliseo Municipal de Piedecuesta): éxito, y la Trazabilidad de `4821` muestra 5 entregas. (El enlace "Usar datos de demostración" de esta tarjeta envía cantidad 0 y Oracle la rechaza con C_ENT_CANT_CK.)
9. **Restablecer demo:** confirmar. Ana María vuelve a 4 entregas, L-044 a 1.020 y la familia 5 queda sin alojamiento.
10. **Sin conexión (solo local):** con la red desconectada, las pantallas muestran "Sin conexión: datos guardados del DD/MM/AAAA HH:MM" y los botones de operaciones y de restablecer quedan deshabilitados con su explicación. Requiere haber corrido `npm run precargar`.

## 6. Qué hacer si falla

| Síntoma | Qué revisar |
|---|---|
| Indicador ámbar "Sin conexión" en local | ¿Hay internet? ¿`.env.local` tiene las 4 variables de ORDS? Corra `npm run smoke`: la primera línea dice si falla el token o los endpoints. |
| En `npm run dev` la página se recarga sola y vuelve a la primera pestaña | El modo desarrollo estaba vigilando `data/cache/`. Ya está resuelto en `next.config.ts` y en `globals.css` (`@source not "../../data"`); si vuelve a pasar, reinicie `npm run dev` y revise que esas dos líneas sigan ahí. |
| `npm run smoke` falla en el token con HTTP 405 | La URL usa `apex.oracle.com/pls/apex`: cámbiela por `https://oracleapex.com/ords/<alias>/...` (ver sección 2). |
| `npm run smoke` falla en el token (HTTP 401) | `ORDS_CLIENT_ID` o `ORDS_CLIENT_SECRET` incorrectos, o el cliente se recreó. Vuelva a ejecutar `4_ARCA_API_REST.sql` y copie las credenciales nuevas. |
| Token correcto pero endpoints con 401 | El cliente no tiene el rol `arca_api_rol`. Revise el bloque `GRANT_CLIENT_ROLE` del script 4. |
| Un endpoint responde 404 | La URL base no termina en `/arca/` o el módulo no se creó. En **SQL Workshop > RESTful Services > Modules** debe aparecer `arca`. |
| Un endpoint responde 500 | Error en el SQL del manejador. Pruébelo en **RESTful Services > Modules > arca > plantilla > GET > Test**. |
| Operación con "Error de la base de datos" | Lea el texto ORA que se muestra debajo: es el error original de Oracle. |
| Restablecer demo falla | Ejecute `BEGIN P_RESTABLECER_DEMO; END;` en SQL Commands para ver el error. Si se modificó `2_ARCA_DATOS.sql`, corra `npm run generar-restablecer` y vuelva a ejecutar el script 3. |
| En Vercel el token falla con **HTTP 403 "Access Denied"** | El cortafuegos de oracleapex.com rechaza las llamadas que salen de los servidores de Vercel (probado el 29/10/2026 en las regiones `iad1` y `gru1`); desde un computador personal las mismas llamadas funcionan. No es un error de la app ni de las credenciales. Use una Autonomous Database de Oracle Cloud (sección "Vercel con Oracle Cloud"), la versión local, o un link desde el portátil con `npm run compartir`. |
| En Vercel todo dice "Sin conexión con Oracle" | Faltan variables de entorno o no se hizo Redeploy después de cargarlas. Corra `npm run smoke -- --url <link>`. |
| En Vercel las operaciones responden 401 | La clave escrita no coincide con `DEMO_CLAVE`. El diálogo la vuelve a pedir; la clave se guarda solo en esa pestaña. |
| El build de Vercel falla | Revise el log: el prebuild necesita que `db/ARCA_CONSULTA1.sql` a `ARCA_CONSULTA5.sql` estén en el repositorio. |

## Decisiones

Decisiones no cubiertas por el PRD, tomadas con el criterio de la opción más simple que cumple el guion:

- **Paquete `PKG_ARCA_API`.** Los manejadores POST comparten tres utilidades: convertir números del JSON sin depender de la configuración regional de la sesión, la fecha de hoy en hora de Bogotá (SYSDATE en apex.oracle.com no está en hora colombiana) y escribir la respuesta JSON. No modifica ninguna tabla. Las 5 consultas sí usan `SYSDATE`, igual que los archivos originales.
- **Endpoint extra `catalogos/lotes-todos`.** `catalogos/lotes?centro=` solo trae lotes del centro con disponible mayor que 0, así que L-031 (agotado) y L-070 (de Quibdó) no aparecerían. El formulario de despacho tiene la casilla "Ver todos los lotes (para probar las reglas)", que usa este endpoint, para poder enviar a Oracle los casos RN-08 y RN-12.
- **`quiosco/persona` es de tipo elemento** (`source_type_collection_item`) en lugar de colección, porque así ORDS responde 404 por sí mismo cuando la persona no existe o no tiene censo activo.
- **Consulta 5:** el parámetro se usa como `SYSDATE + TO_NUMBER(:dias)`; la lógica es la del archivo.
- **Varios casos de demostración por tarjeta.** Cada tarjeta tiene "Usar datos de demostración" (el caso que Oracle rechaza) y enlaces para los demás casos del guion (por ejemplo, el caso aceptado), para no improvisar.
- **Rechazo de demostración en "Registrar entrega":** cantidad 0 (C_ENT_CANT_CK), porque el método de identificación es una lista con los dos valores válidos.
- **Respuestas de éxito con datos útiles:** alojar devuelve las personas alojadas en el albergue y despachar devuelve el nuevo disponible del lote, para mostrar en vivo el efecto de los disparadores.
- **Caché del lado del cliente con SWR.** Después de cada operación se vuelven a consultar solo las rutas relacionadas; restablecer recarga todas.
- **Formato de números propio** (`src/lib/formatos.ts`) en lugar de `Intl`, para garantizar `1.020` y `1.552,79` en cualquier navegador.
- **Tipografía Inter empaquetada** (`@fontsource-variable/inter`), para que la versión local funcione sin internet.
- **Naranja de texto `#B85A14`.** El acento `#E8833A` se usa en rellenos y gráficos; para cifras y botones con texto se usa un tono más oscuro con contraste suficiente en el proyector.
- **Sesión del quiosco:** avisa en los últimos 20 segundos antes de cerrarse por inactividad (2 minutos).
- **Smoke con `--url`:** además de los GET, envía un POST con cuerpo vacío sin clave a `operaciones/alojar` y espera 401. Si no hay clave, Oracle lo rechaza por los valores nulos, así que no modifica datos.

### Diseño (revisión con las guías de interfaz de Apple)

Revisión del 29/10/2026 con la skill `apple-design`. Como es una aplicación web, se aplicaron los principios y los fundamentos (accesibilidad, color, tipografía, disposición y escritura), no las convenciones nativas de iOS o macOS.

- **Tamaño de letra relativo** (`html { font-size: 106.25% }`): da 17 px por defecto, pero respeta el tamaño de letra que la persona elija en el navegador (antes estaba fijo en 17 px).
- **Movimiento reducido y contraste aumentado:** con `prefers-reduced-motion` se apagan animaciones y transiciones (también las del gráfico); con `prefers-contrast: more` se oscurecen los grises de texto y bordes.
- **Contraste medido** (WCAG AA, 4,5:1 texto normal y 3:1 texto grande o gráficos): el marcador "Código" del quiosco y "Sin respuesta" pasaron de 2,60:1 a 4,84:1; la barra naranja del gráfico pasó de `#E8833A` (2,71:1) a `#B85A14` (4,66:1).
- **Gráfico de Transparencia:** cada barra lleva su número, encima hay una frase con lo que hay que leer ("7 de 13 necesidades validadas ya recibieron una entrega. Sin ninguna atendida todavía: …") y los mismos datos están en una tabla para lectores de pantalla.
- **Elemento propio: la ruta de la ayuda.** En la consulta de trazabilidad, cada entrega se dibuja como su recorrido real (centro de acopio, lote, despacho, destino) y termina en la persona, el único punto resaltado en naranja. Es la misma cadena de la consulta 1 y lo que distingue a ARCA. La tabla con el resultado exacto de Oracle sigue debajo.
- **Operaciones de a una:** las cuatro operaciones pasaron de una cuadrícula de dos columnas (que cortaba los textos de las listas entre 1280 y 1366 px) a subpestañas como las de Consultas, a todo el ancho. Los formularios siguen montados, así que el resultado no se pierde al cambiar de pestaña.
- **Restablecer demo** es un botón secundario: es una acción de administración destructiva, no la acción principal. El botón de confirmación dice "Restablecer" (no "Sí, restablecer").
- **Textos del quiosco** sin "nosotros" ("Ese código no aparece en el censo") y estados vacíos que indican el siguiente paso.
- **Solo apariencia clara**, a propósito: el PRD pide fondo blanco y la exposición es con proyector. Las guías piden también una apariencia oscura; queda como posible mejora, con tokens semánticos de color.
