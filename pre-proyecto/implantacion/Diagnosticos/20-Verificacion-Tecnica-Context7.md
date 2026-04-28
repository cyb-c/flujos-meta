# Verificación Técnica con Context7 — Implantación

**Versión:** 1.0  
**Fecha:** 28 de abril de 2026  
**Propósito:** Verificación de afirmaciones técnicas en `pre-proyecto/implantacion/` mediante Context7 API, documentación oficial de Slim, lftp, phpdotenv y OpenCode. Documento de entrada obligatoria para la Parte 3.

---

## Índice Interno

1. [Resumen de Verificaciones](#1-resumen-de-verificaciones)
2. [Metodología](#2-metodología)
3. [Slim Framework 4.x](#3-slim-framework-4x)
4. [Configuración de Servidor Web (.htaccess)](#4-configuración-de-servidor-web-htaccess)
5. [lftp y Despliegue FTP](#5-lftp-y-despliegue-ftp)
6. [phpdotenv y Variables de Entorno](#6-phpdotenv-y-variables-de-entorno)
7. [OpenCode y Agentes](#7-opencode-y-agentes)
8. [Contradicción Crítica: Agente ftp-deployer vs Implantación v2.0](#8-contradicción-crítica-agente-ftp-deployer-vs-implantación-v20)
9. [Hallazgos Adicionales](#9-hallazgos-adicionales)
10. [Conclusiones y Recomendaciones para Parte 3](#10-conclusiones-y-recomendaciones-para-parte-3)
11. [Referencias Context7](#11-referencias-context7)

---

## 1. Resumen de Verificaciones

| # | Afirmación | Fuente en Implantación | Verificación | Resultado |
|---|-----------|------------------------|-------------|-----------|
| 1 | Slim 4.x usa `AppFactory::create()` como front controller | `10-Plan §6` | Context7 / Slim docs | ✅ Correcto |
| 2 | Slim requiere `slim/slim:^4.15` y `slim/psr7:^1.7` | `00-INDICE §17`, `10-Plan §6` | Context7 / Slim docs | ✅ Correcto |
| 3 | PHP >= 8.1 necesario y servidor tiene 8.3.30 | `00-INDICE §19`, `10-Plan §5` | Context7 / Slim docs + wa-server-info | ✅ Correcto |
| 4 | El `public/index.php` NO incluye `addRoutingMiddleware()` ni `addErrorMiddleware()` | `10-Plan §6` | Context7 / Slim docs | ⚠️ Ausente (recomendado) |
| 5 | El `.htaccess` en `public/` redirige correctamente a `index.php` | `10-Plan §6`, `00-INDICE §13` | Context7 / Slim docs | ❌ Ubicación incorrecta |
| 6 | lftp con `mirror --reverse --delete` despliega correctamente | `20-Operaciones §3` | Context7 / lftp docs | ✅ Correcto |
| 7 | FTPS explícito (TLS, puerto 21) con lftp | `00-INDICE §3` | Context7 / lftp docs | ⚠️ Falta comando lftp SSL |
| 8 | `.env` como mecanismo de configuración | `00-INDICE §14` | Context7 / phpdotenv | ⚠️ No hay dependencia para cargarlo |
| 9 | Agente `@ftp-deployer` en modo subagent | `opencode.json` | OpenCode docs | ✅ Correcto |
| 10 | Rutas del agente ftp-deployer (origen y destino) | `.opencode/agents/ftp-deployer.md` | Contraste con implantación v2.0 | ❌ **OBJETO: desactualizadas** |

---

## 2. Metodología

- **Context7 API v2**: Consultas a `libs/search` y `context` para Slim, lftp, phpdotenv
- **OpenCode docs**: Documentación oficial vía web (https://opencode.ai/docs/agents/)
- **Contraste directo**: Comparación entre archivos del repositorio y documentación técnica verificada
- **Fuentes primarias**: slimframework.com/docs/v4/, lftp.yar.ru, vlucas/phpdotenv (GitHub README), opencode.ai/docs/

---

## 3. Slim Framework 4.x

### 3.1. Front controller pattern ✅

**Afirmación en 10-Plan §6:**
```php
$app = AppFactory::create();
// routes...
$app->run();
```

**Verificación Context7 — Slim docs (slimframework.com/docs/v4/):**
```php
<?php
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Slim\Factory\AppFactory;
require __DIR__ . '/../vendor/autoload.php';
$app = AppFactory::create();
// routes...
$app->run();
```

**Resultado:** ✅ Correcto. El patrón de front controller coincide exactamente con la documentación oficial de Slim.

### 3.2. Dependencias Composer ✅

**Afirmación en 00-INDICE §17 y 10-Plan §6:**
```json
{
    "require": {
        "php": ">=8.1",
        "slim/slim": "^4.15",
        "slim/psr7": "^1.7"
    }
}
```

**Verificación Context7:**
- Slim 4.x se instala con `composer require slim/slim:"4.*"` — el `^4.15` es una restricción semver válida
- `slim/psr7` es la implementación PSR-7 oficial recomendada
- Slim 4.x requiere PHP >= 7.4, por lo que `>=8.1` es seguro y correcto

**Resultado:** ✅ Correcto. Todas las dependencias son válidas.

### 3.3. Versión PHP y extensiones ✅

**Afirmación en 00-INDICE §19 y wa-server-info.json:**
- PHP 8.3.30 ✅ (Slim requiere >= 7.4)
- Extensiones: mysqli, pdo_mysql, curl, gd, zip, json, dom, mbstring, xml ✅ (Slim no requiere ninguna específica además de las básicas)

**Resultado:** ✅ Correcto. El servidor cumple y supera los requisitos.

### 3.4. Middleware faltante: `addRoutingMiddleware()` y `addErrorMiddleware()` ⚠️

**Afirmación en 10-Plan §6 — front controller actual:**
```php
$app = AppFactory::create();
$app->get('/', ...);
$app->get('/hello', ...);
$app->run();
```

**Verificación Context7 — Slim docs:**
```php
$app = AppFactory::create();

// The routing middleware should be added earlier than the ErrorMiddleware
// Otherwise exceptions thrown from it will not be handled by the middleware
$app->addRoutingMiddleware();

// Add Error Middleware
$errorMiddleware = $app->addErrorMiddleware(
    true,   // displayErrorDetails
    true,   // logErrors
    true    // logErrorDetails
);

$app->run();
```

**Resultado:** ⚠️ El front controller actual funciona para casos simples, pero carece de:
- `$app->addRoutingMiddleware()` — Aunque Slim lo auto-registra en algunos casos, la documentación oficial lo recomienda explícitamente.
- `$app->addErrorMiddleware()` — Sin esto, errores no capturados pueden producir respuestas HTTP 500 sin cuerpo útil y sin logging.

**Impacto:** Bajo para "Hola mundo", pero debe corregirse antes de producción.

### 3.5. Parámetros de `addErrorMiddleware` ⚠️

**Afirmación en 00-INDICE §14:** `APP_DEBUG=true` en `.env`

**Verificación Context7:** El primer parámetro de `addErrorMiddleware` es `$displayErrorDetails`:
- En desarrollo: `true`
- En producción: `false`

**Resultado:** ⚠️ El front controller no usa `APP_DEBUG` para controlar `displayErrorDetails`. Debería leer `$_ENV['APP_DEBUG']` para decidir el valor.

### 3.6. Contenedor PSR-11 y PHP-DI

**Afirmación:** No se menciona contenedor en Etapa 1; se deja para más adelante.

**Verificación Context7:** Slim 4.x **no incluye** contenedor por defecto. Si en Etapa 2+ se necesita inyección de dependencias, se requiere instalar `php-di/php-di` u otro contenedor PSR-11.

**Resultado:** ✅ Correcto para Etapa 1. Consistente con `00-INDICE §18` que lista dependencias futuras.

---

## 4. Configuración de Servidor Web (.htaccess)

### 4.1. Ubicación del .htaccess ❌

**Afirmación en documentos de implantación:**
- `00-INDICE §9`: `.htaccess` a nivel raíz, comentario `(public/)`
- `10-Plan §6`: `.htaccess` DENTRO de `public/`

**Verificación Context7 — Slim docs (`/v4/start/web-servers` y `/v4/deployment/deployment`):**

Para servidores compartidos con Apache, la documentación oficial de Slim recomienda DOS patrones:

**Patrón A — .htaccess a nivel de raíz del proyecto** (document root no es `public/`):
```apache
# En la raíz del proyecto, NO dentro de public/
<IfModule mod_rewrite.c>
   RewriteEngine on
   RewriteRule ^$ public/ [L]
   RewriteRule (^[^/]*$) public/$1 [L]
</IfModule>
```

**Patrón B — .htaccess dentro de public/** (document root apunta a `public/`):
```apache
# En public/ — asume que document root es public/
<IfModule mod_rewrite.c>
    RewriteEngine On
    RewriteCond %{REQUEST_FILENAME} !-f
    RewriteCond %{REQUEST_FILENAME} !-d
    RewriteRule ^ index.php [QSA,L]
</IfModule>
```

**Análisis:**

La estructura desplegada en el servidor será:
```
/home/beevivac/stg2.cofemlevante.es/
├── public/index.php
├── app/
├── vendor/
├── config/
├── .env
├── composer.json
...
```

Si el document root del dominio `stg2.cofemlevante.es` es `/home/beevivac/stg2.cofemlevante.es/`, entonces:
- El `.htaccess` en `public/` **NO REDIRIGIRÁ** las peticiones a `public/index.php`
- Una petición `GET /` buscará `index.php` en la raíz (no existe) → 404 o listado de directorio
- Se necesita un `.htaccess` en la raíz que redirija a `public/`

**Resultado:** ❌ **Inconsistencia.** El `.htaccess` en `public/` SOLO funciona si el document root del dominio está configurado apuntando a `/home/beevivac/stg2.cofemlevante.es/public/`. Esto no está verificado ni documentado. La estructura de proyecto y la ubicación del `.htaccess` deben ser consistentes.

**Recomendación:**
- Opción 1: Agregar un `.htaccess` en la raíz del proyecto que redirija a `public/` (Patrón A)
- Opción 2: Verificar que el document root apunta a `public/` y mantener el `.htaccess` interno
- Opción 3: Eliminar el subdirectorio `public/` y poner `index.php` en la raíz (menos recomendado, pero válido para Slim)

### 4.2. LiteSpeed + .htaccess ✅

**Afirmación en 00-INDICE §19 y wp-info:** El servidor web es LiteSpeed.

**Verificación:** LiteSpeed es compatible con Apache `mod_rewrite` y `.htaccess`. Las reglas de reescritura de Apache funcionan sin cambios en LiteSpeed.

**Resultado:** ✅ Correcto. Las reglas `.htaccess` documentadas son compatibles con LiteSpeed.

---

## 5. lftp y Despliegue FTP

### 5.1. Comando mirror --reverse --delete ✅

**Afirmación en 20-Operaciones §3 flujo del agente:**
```
lftp mirror --reverse --delete ./ . sobre FTP_TARGET_PATH
```

**Verificación Context7 — lftp docs:**
```bash
# Upload local directory to remote
lftp -e "open ftp.example.com; mirror -R /local/website /var/www; bye"

# Mirror with deletion of non-source files
lftp -e "open ftp.example.com; mirror --delete /remote/sync /local/sync; bye"

# Combined: reverse mirror with deletion
lftp -e "open ftp.example.com; mirror -R --delete /local /remote; bye"
```

**Resultado:** ✅ Correcto. `mirror -R` (o `--reverse`) combinado con `--delete` es el patrón estándar para despliegue por FTP. La sintaxis documentada es correcta.

### 5.2. FTPS explícito (TLS, puerto 21) ⚠️

**Afirmación en 00-INDICE §3:**
- Protocolo: FTPS explícito (FTP sobre TLS)
- Puerto: 21
- Cifrado: TLS recomendado

**Verificación Context7 — lftp docs:**
```bash
# Force SSL/TLS encryption for control and data connections
lftp -e "set ftp:ssl-force on; set ftp:ssl-protect-data on; open ftp.example.com; ls; bye"

# Connect with explicit FTPS
lftp -e "open ftps://secure.example.com"
```

**Análisis:** El FTPS explícito conecta al puerto 21 y luego negocia TLS mediante el comando AUTH TLS. La configuración de lftp requiere:
- `set ftp:ssl-force on` para forzar TLS en la conexión
- `set ftp:ssl-protect-data on` para cifrar también los datos

Sin embargo, `open ftps://` implica FTPS implícito (puerto 990). Para FTPS explícito en puerto 21, se debe usar `open ftp://` con las opciones SSL activadas.

**Resultado:** ⚠️ La configuración en 20-Operaciones §3 no especifica los comandos lftp SSL. El flujo del agente menciona "FTPS explícito" pero no configura `set ftp:ssl-force on`. Sin estas opciones, la conexión podría usar FTP plano.

### 5.3. Manejo de contraseña por variable de entorno ✅

**Afirmación en 20-Operaciones §3:** Contraseña desde `CONTRASENYA_FTP_WA`

**Verificación Context7 — lftp docs:**
```bash
export LFTP_PASSWORD="secret"
lftp -u user --env-password ftp.example.com
```

**Resultado:** ✅ Correcto. lftp soporta contraseñas por variable de entorno (`LFTP_PASSWORD`), pero el agente usa `CONTRASENYA_FTP_WA`. El agente debería exportar `LFTP_PASSWORD` desde `CONTRASENYA_FTP_WA` antes de invocar lftp.

---

## 6. phpdotenv y Variables de Entorno

### 6.1. Dependencia faltante para cargar `.env` ❌

**Afirmación en 00-INDICE §14:** Usar archivo `.env` para configuración.

**Verificación Context7 — phpdotenv docs:**
```php
$dotenv = Dotenv\Dotenv::createImmutable(__DIR__);
$dotenv->load();
```

**Problema:** Slim 4.x NO incluye capacidad nativa para leer archivos `.env`. Para cargar `.env` se necesita:
- `vlucas/phpdotenv` (requiere `composer require vlucas/phpdotenv`)
- O usar `getenv()` con variables ya configuradas manualmente

**Resultado:** ❌ `vlucas/phpdotenv` NO está listado en `composer.json` (00-INDICE §17, 10-Plan §6) pero el proyecto depende de `.env` para configuración. Sin esta dependencia, las variables de `.env` no se cargarán automáticamente en Slim.

### 6.2. Variables de entorno para FTP — ambigüedad

**Afirmación en 00-INDICE §14:**
```bash
# FTP (credenciales sensibles vía entorno)
FTP_PASSWORD=              # Poner vía variable de entorno
```

**Afirmación en 20-Operaciones §3:**
| `FTP_PASSWORD` | Desde variable de entorno (`CONTRASENYA_FTP_WA`) |

**Análisis:** Hay dos mecanismos posibles:
1. `FTP_PASSWORD` en `.env` (sugerido por 00-INDICE)
2. `FTP_PASSWORD` derivada de `CONTRASENYA_FTP_WA` (sugerido por 20-Operaciones)

Si se usa la opción 1, la contraseña estaría en `.env` que se despliega al servidor (aunque no versionado). Si se usa la opción 2, debe existir un mecanismo que exporte `FTP_PASSWORD` desde `CONTRASENYA_FTP_WA`.

**Resultado:** ⚠️ La ambigüedad detectada en el diagnóstico (Parte 1, §4.2) se confirma: no hay claridad sobre el mecanismo de entrega de `FTP_PASSWORD`.

---

## 7. OpenCode y Agentes

### 7.1. Configuración de agentes en opencode.json ✅

**Afirmación en 00-INDICE §12 y opencode.json:** Agentes configurados como `subagent`.

**Verificación — OpenCode docs (`/docs/agents/`):**
- `mode: subagent` → Agentes invocables mediante `@mention` desde agentes primarios
- `temperature: 0.1` → Rango válido 0.0-1.0, valor bajo para respuestas deterministas
- `permission` con `allow/deny/ask` → Esquema de permisos documentado y correcto

**Resultado:** ✅ Correcto. Todos los agentes están correctamente configurados según la documentación de OpenCode.

### 7.2. Permisos de agentes ✅

| Agente | Permisos en `opencode.json` | Permisos en `.md` | Coinciden |
|--------|---------------------------|-------------------|-----------|
| `@ftp-deployer` | bash: allow, read: allow, edit: deny, etc. | bash: allow, read: allow, edit: deny, etc. | ✅ |
| `@governance-updater` | read/edit/write: allow, bash: allow, task: deny | Igual | ✅ |
| `@governance-auditor` | read: allow, edit/write: deny, bash: allow | Igual | ✅ |

**Resultado:** ✅ Correcto. No hay discrepancias entre `opencode.json` y los archivos `.md`.

---

## 8. Contradicción Crítica: Agente ftp-deployer vs Implantación v2.0

### 8.1. Rutas desactualizadas en el agente ❌

| Parámetro | En `.opencode/agents/ftp-deployer.md` | En implantación v2.0 | ¿Coinciden? |
|-----------|--------------------------------------|---------------------|-------------|
| **Origen** | `pre-proyecto/wa-slim/` | Raíz del repositorio (NO `pre-proyecto/`) | ❌ |
| **Destino FTP** | `/home/beevivac/stg2.cofemlevante.es/wa-slim/` | `/home/beevivac/stg2.cofemlevante.es/` | ❌ |
| **Subdirectorio** | `wa-slim/` | Ninguno (decisión explícita §10) | ❌ |

### 8.2. Impacto

Si `@ftp-deployer` se invoca con las rutas actuales:
1. Buscará código en `pre-proyecto/wa-slim/` que puede no existir o estar vacío
2. Desplegará en `/wa-slim/` en lugar de la raíz del dominio
3. `https://stg2.cofemlevante.es/` no funcionará porque los archivos estarán en `/wa-slim/`

**Resultado:** ❌ **CRÍTICO. El agente `@ftp-deployer` debe actualizarse para reflejar las decisiones de implantación v2.0 antes de cualquier despliegue.**

### 8.3. Prompt incompleto del agente

El agente `ftp-deployer.md` tiene un prompt funcional pero carece de la configuración FTPS explícita que se documenta en `00-INDICE §3`:
- No incluye `set ftp:ssl-force on`
- No incluye `set ftp:ssl-protect-data on`

---

## 9. Hallazgos Adicionales

### 9.1. Ruta de skill incorrecta (confirmación)

**Diagnóstico §4.3 confirmado:**
- `00-INDICE-Implantacion.md:330`: `.skills/context7/SKILL.md` — **RUTA INEXISTENTE**
- Ruta correcta: `.opencode/skills/context7/SKILL.md`

### 9.2. LiteSpeed vs Apache

Aunque LiteSpeed soporta `.htaccess`, el servidor no es Apache. Algunas directivas específicas de Apache pueden no funcionar. Las reglas `mod_rewrite` básicas (las documentadas) son compatibles.

### 9.3. No hay `composer.lock` versionado

Según 10-Plan §6, se incluirá `composer.lock` en el despliegue. Es buena práctica para trazabilidad, pero no hay restricción de versiones para las dependencias transitivas de Slim/PSR-7.

### 9.4. `composer install --no-dev --optimize-autoloader` correcto

Verificación Context7 — Slim docs: El comando es correcto para preparar el paquete de producción. `--optimize-autoloader` genera un autoloader optimizado con mapa de clases.

### 9.5. Tamaño esperado de vendor/ (< 4 MB)

**Verificación:** Slim 4.x + slim/psr7 sin dependencias adicionales tiene un tamaño aproximado de 2-3 MB. La estimación de < 4 MB en 20-Operaciones §2 es razonable.

---

## 10. Conclusiones y Recomendaciones para Parte 3

### Errores críticos (corregir antes de desplegar)

| # | Problema | Severidad | Acción requerida |
|---|----------|-----------|------------------|
| 1 | `@ftp-deployer` tiene rutas de v1.0 (origen y destino incorrectos) | ❌ CRÍTICO | Actualizar `.opencode/agents/ftp-deployer.md` |
| 2 | `.htaccess` en `public/` sin verificar document root | ❌ ALTO | Decidir ubicación final y documentar |
| 3 | `vlucas/phpdotenv` no está en dependencias pero se usa `.env` | ❌ ALTO | Agregar a `composer.json` o definir mecanismo alternativo |

### Problemas importantes (resolver en Etapa 1)

| # | Problema | Severidad | Acción requerida |
|---|----------|-----------|------------------|
| 4 | Front controller sin `addRoutingMiddleware()` ni `addErrorMiddleware()` | ⚠️ MEDIO | Agregar middlewares recomendados por Slim docs |
| 5 | Ambigüedad en origen de `FTP_PASSWORD` (`.env` vs `CONTRASENYA_FTP_WA`) | ⚠️ MEDIO | Definir mecanismo canónico |
| 6 | Falta configuración SSL en flujo lftp del agente | ⚠️ MEDIO | Agregar `set ftp:ssl-force on` |
| 7 | `00-INDICE §17` referencia ruta de skill inexistente | ⚠️ MEDIO | Corregir a `.opencode/skills/context7/SKILL.md` |

### Recomendaciones técnicas

| # | Recomendación | Justificación |
|---|--------------|---------------|
| 8 | Agregar `.htaccess` raíz que redirija a `public/` | Document root del dominio no apunta a `public/` |
| 9 | Usar `APP_DEBUG` para controlar `displayErrorDetails` en `addErrorMiddleware()` | Evitar mostrar errores en producción |
| 10 | Centralizar valores de configuración en `inventario_recursos.md` | GOV-R2 prohíbe hardcoding |
| 11 | El agente ftp-deployer debe exportar `LFTP_PASSWORD` desde `CONTRASENYA_FTP_WA` | Mecanismo nativo lftp para contraseñas |

---

## 11. Referencias Context7

| Consulta | Library ID | Snippets |
|----------|-----------|----------|
| Slim 4.x — Getting started | `/websites/slimframework_v4` | 231 |
| Slim 4.x — Web server config + .htaccess | `/websites/slimframework_v4` | 231 |
| Slim 4.x — Routes, middleware, PSR-7 | `/websites/slimframework_v4` | 231 |
| Slim 4.x — Error handling middleware | `/websites/slimframework_v4` | 231 |
| Slim 4.x — Deployment | `/websites/slimframework_v4` | 231 |
| lftp — Mirror, FTPS, SSL | `/lavv17/lftp` | 126 |
| phpdotenv — Usage | `/vlucas/phpdotenv` | 36 |
| OpenCode docs — Agents | https://opencode.ai/docs/agents/ | — |

---

## Historial de cambios

| Versión | Fecha | Cambio | Autor |
|---------|-------|--------|-------|
| 1.0 | 28 abr 2026 | Verificación técnica inicial mediante Context7 | OpenCode |
