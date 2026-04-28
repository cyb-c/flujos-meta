# Índice y Decisiones de Implantación

**Versión:** 2.0  
**Fecha:** 28 de abril de 2026  
**Estado:** ✅ Aprobado

---

## Índice de Contenido

1. [Propósito de este documento](#1-propósito-de-este-documento)
2. [Estructura documental](#2-estructura-documental)
3. [Despliegue confirmado por FTP](#3-despliegue-confirmado-por-ftp)
4. [No uso de Composer en servidor](#4-no-uso-de-composer-en-servidor)
5. [Desarrollo completo en Codespace](#5-desarrollo-completo-en-codespace)
6. [No ejecución de comandos en servidor](#6-no-ejecución-de-comandos-en-servidor)
7. [Directorios WA/WP confirmados](#7-directorios-wawp-confirmados)
8. [Separación entre aplicación WA y WordPress](#8-separación-entre-aplicación-wa-y-wordpress)
9. [Slim como framework base en raíz del repositorio](#9-slim-como-framework-base-en-raíz-del-repositorio)
10. [Rutas de despliegue sin subdirectorios fijos](#10-rutas-de-despliegue-sin-subdirectorios-fijos)
11. [URL pública confirmada](#11-url-pública-confirmada)
12. [Despliegue mediante agente desplegador](#12-despliegue-mediante-agente-desplegador)
13. [Reescritura de URLs con .htaccess](#13-reescritura-de-urls-con-htaccess)
14. [Variables de entorno con .env](#14-variables-de-entorno-con-env)
15. [Primer despliegue: estructura completa base](#15-primer-despliegue-estructura-completa-base)
16. [Repositorio como base clonable](#16-repositorio-como-base-clonable)
17. [Decisiones técnicas de framework](#17-decisiones-técnicas-de-framework)
18. [Dependencias futuras: Etapa 2](#18-dependencias-futuras-etapa-2)
19. [Datos del servidor](#19-datos-del-servidor)
20. [Elementos fuera de alcance de Etapa 1](#20-elementos-fuera-de-alcance-de-etapa-1)

---

## 1. Propósito de este documento

Documento único que consolida:
- **Índice** de toda la documentación de implantación
- **Todas las decisiones confirmadas** (generales + Etapa 1)
- **Datos del servidor** y dependencias futuras

Sustituye a: `00-decisiones-generales-implantacion.md` v1.0, `10-Decisiones-Etapa01-Slim-FTP.md` v1.0

---

## 2. Estructura documental

| Documento | Finalidad | Dependencias | Estado |
|-----------|-----------|--------------|--------|
| **`00-INDICE-Implantacion.md`** | Índice + decisiones confirmadas (este documento) | — | ✅ Activo |
| **`10-Plan-Etapa01-Slim-FTP.md`** | Plan de trabajo: objetivo, alcance, actividades, criterios | `00-INDICE-Implantacion.md` | ✅ Activo |
| **`20-Operaciones-Etapa01-Slim-FTP.md`** | Despliegue, verificación, pendientes | `10-Plan-Etapa01-Slim-FTP.md` | ✅ Activo |
| `wa-server-info-2026-04-28-101933.json` | Datos técnicos del servidor (informativo) | — | ℹ️ Referencia |
| `wp-Información de salud del sitio.txt` | Datos de WordPress (informativo) | — | ℹ️ Referencia |
| `Etapa01_Slim-Despliegue-FTP.md` | **Transición**: documento original descompuesto | — | 🔄 Sustituido |
| `00-decisiones-generales-implantacion.md` v1.0 | **Transición**: contenido consolidado aquí | — | 🔄 Sustituido |
| `10-Decisiones-Etapa01-Slim-FTP.md` v1.0 | **Transición**: contenido consolidado aquí | — | 🔄 Sustituido |
| `20-Alcance-Etapa01-Slim-FTP.md` v1.0 | **Transición**: contenido en 10-Plan | — | 🔄 Sustituido |
| `30-Plan-Etapa01-Slim-FTP.md` v1.0 | **Transición**: contenido en 10-Plan | — | 🔄 Sustituido |
| `40-Despliegue-Etapa01-Slim-FTP.md` v1.0 | **Transición**: contenido en 20-Operaciones | — | 🔄 Sustituido |
| `50-Verificacion-Etapa01-Slim-FTP.md` v1.0 | **Transición**: contenido en 20-Operaciones | — | 🔄 Sustituido |
| `60-Pendientes-Etapa01-Slim-FTP.md` v1.0 | **Transición**: contenido en 20-Operaciones | — | 🔄 Sustituido |

### Jerarquía de lectura

```
00-INDICE-Implantacion.md (decisiones confirmadas)
│
└── 10-Plan-Etapa01-Slim-FTP.md (qué hacer y cómo)
    │
    └── 20-Operaciones-Etapa01-Slim-FTP.md (ejecución)
```

### Orden de lectura recomendado

1. `00-INDICE-Implantacion.md` — Decisiones (este documento)
2. `10-Plan-Etapa01-Slim-FTP.md` — Plan
3. `20-Operaciones-Etapa01-Slim-FTP.md` — Operaciones

---

## 3. Despliegue confirmado por FTP

**Decisión:** El método de despliegue al servidor compartido será FTP/FTPS.

**Justificación:** El hosting compartido no proporciona acceso SSH/SFTP. FTP es el método estándar soportado. Las credenciales están disponibles y configuradas en variables de entorno.

| Parámetro | Valor |
|-----------|-------|
| **Protocolo** | FTPS explícito (FTP sobre TLS) |
| **Servidor** | `ftp.bee-viva.es` |
| **Puerto** | 21 |
| **Cifrado** | TLS recomendado |

**Referencia:** `wa-server-info-2026-04-28-101933.json`

---

## 4. No uso de Composer en servidor

**Decisión:** No se ejecutará Composer en el servidor de producción.

**Implicaciones:**
- `vendor/` se genera localmente y se sube completo
- `composer install` se ejecuta solo en Codespace
- `composer.lock` se incluye en el despliegue para trazabilidad

---

## 5. Desarrollo completo en Codespace

**Decisión:** Todo el desarrollo se realizará en el GitHub Codespace/workspace.

| Herramienta | Versión mínima | Propósito |
|-------------|----------------|-----------|
| PHP | 8.1+ | Ejecución de Slim |
| Composer | 2.0+ | Gestión de dependencias |
| Git | 2.0+ | Control de versiones |
| lftp | Cualquiera | Despliegue por FTP |

---

## 6. No ejecución de comandos en servidor

**Decisión:** No se ejecutará ningún comando en el servidor remoto. El hosting compartido no proporciona SSH, solo transferencia de archivos.

---

## 7. Directorios WA/WP confirmados

| Entorno | Directorio | Usuario FTP |
|---------|------------|-------------|
| **WA** | `/home/beevivac/stg2.cofemlevante.es` | `ftp-wa@levantecofem.es` |
| **WP** | `/home/beevivac/levantecofem_es` | `ftp-cfle-wp@levantecofem.es` |

WA y WordPress están en directorios separados del mismo hosting, confirmando la arquitectura de aplicación externa a WordPress.

---

## 8. Separación entre aplicación WA y WordPress

**Decisión:** La Web-App será una aplicación PHP independiente de WordPress, usando Slim sin interferir con WP.

```
/home/beevivac/
├── stg2.cofemlevante.es/     # WA (despliegue directo)
└── levantecofem_es/          # WP + WooCommerce
```

La comunicación WA↔WP será vía endpoint REST personalizado (etapa 2+) y acceso directo a BD de WP.

---

## 9. Slim como framework base en raíz del repositorio

**Decisión:** Slim se integra como framework base real del desarrollo en la **raíz del repositorio**. `pre-proyecto/` es solo para documentación.

**Justificación:**
- `pre-proyecto/` es exclusivo para documentación
- El código va en la raíz para facilitar el despliegue
- La estructura del repositorio refleja la estructura de despliegue

**Estructura correcta:**
```
raíz/
├── app/Controllers/           # Controladores
├── app/Services/              # Servicios
├── app/Middleware/            # Middleware
├── app/Config/                # Configuración
├── public/index.php           # Front controller
├── vendor/                    # Dependencias
├── config/app.php             # Config. app
├── config/database.php        # Config. BD
├── config/routes.php          # Rutas
├── composer.json
├── composer.lock
├── .env                       # Variables de entorno (NO versionado)
├── .env.example               # Ejemplo (versionado)
├── .htaccess                  # Reescritura URLs (public/)
└── pre-proyecto/              # SOLO documentación
```

**Estructura INCORRECTA (no usar):**
```
raíz/
├── pre-proyecto/wa-slim/      # ❌ NO: código dentro de pre-proyecto/
```

---

## 10. Rutas de despliegue sin subdirectorios fijos

**Decisión:** El despliegue se realiza directamente en el directorio base del dominio WA, sin crear subdirectorios `wa-slim/` ni ningún otro subdirectorio fijo.

**Justificación:** Los directorios pueden cambiar. La configuración debe permitir cambiar rutas sin alterar la lógica del proyecto. No acoplar el desarrollo a rutas absolutas.

| Parámetro | Valor |
|-----------|-------|
| **Dominio WA** | `stg2.cofemlevante.es` |
| **Directorio base** | `/home/beevivac/stg2.cofemlevante.es/` |
| **Subdirectorio** | Ninguno (despliegue directo) |
| **FTP target** | `/home/beevivac/stg2.cofemlevante.es/` |

---

## 11. URL pública confirmada

**Decisión:** `https://stg2.cofemlevante.es/`

Esta es la URL pública definitiva para la Web-App en el entorno de staging. No se usará `https://stg2.cofemlevante.es/wa-slim/` ni ninguna otra variante.

---

## 12. Despliegue mediante agente desplegador

**Decisión:** El despliegue se realiza **exclusivamente mediante el agente `@ftp-deployer`**. No se crea ni usa el script `deploy.sh`.

**Justificación:** El agente `@ftp-deployer` (`.opencode/agents/ftp-deployer.md`) automatiza todo el flujo: pre-validación, preparación del paquete, conexión FTP, transferencia, verificación e informe. Eliminar el script reduce puntos de fallo y mantiene un único punto de ejecución.

**Invocación:**
```
@ftp-deployer despliega la Web-App
```

---

## 13. Reescritura de URLs con .htaccess

**Decisión:** Sí usar `.htaccess` para reescritura de URLs en el directorio `public/`.

**Archivo `public/.htaccess`:**
```
<IfModule mod_rewrite.c>
    RewriteEngine On
    RewriteCond %{REQUEST_FILENAME} !-f
    RewriteCond %{REQUEST_FILENAME} !-d
    RewriteRule ^ index.php [QSA,L]
</IfModule>
```

**Justificación:** Permite que Slim maneje rutas como `/hello` sin necesidad de `/public/index.php/hello`.

---

## 14. Variables de entorno con .env

**Decisión:** Usar archivo `.env` (no versionado) para configuración de variables de entorno, con `.env.example` (versionado) como plantilla. No se usan GitHub Secrets para configuración.

**Justificación:** `.env` permite cambiar configuración sin depender del proveedor de secrets, facilita el desarrollo local y la clonación del repositorio para otros proyectos.

**Contenido de `.env`:**
```bash
# FTP (credenciales sensibles vía entorno)
FTP_SERVER=ftp.bee-viva.es
FTP_USER=ftp-wa@levantecofem.es
FTP_PASSWORD=              # Poner vía variable de entorno

# Aplicación (configurables)
APP_ENV=development
APP_DEBUG=true
```

**Nota:** Las contraseñas sensibles (`FTP_PASSWORD`, `CONTRASENYA_FTP_WA`) se pueden pasar como variables de entorno además del `.env`, pero la configuración base (rutas, servidores, usuarios) va en `.env`.

---

## 15. Primer despliegue: estructura completa base

**Decisión:** El primer despliegue incluirá todo lo necesario: `app/`, `config/`, bootstrap y estructura completa base. No solo los archivos mínimos.

**Incluir en despliegue:**
- `public/index.php` — Front controller
- `public/.htaccess` — Reescritura de URLs
- `vendor/` — Dependencias
- `composer.json` y `composer.lock`
- `app/` — Estructura base (Controllers, Services, Middleware, Config)
- `config/` — Configuración (app.php, database.php, routes.php)
- `.env` — Variables de entorno

**Excluir:**
- `.git/` — No necesario en producción
- `.gitignore`
- `pre-proyecto/` — Solo documentación

---

## 16. Repositorio como base clonable

**Decisión:** El repositorio debe servir como base o andamio clonable para otros proyectos futuros.

**Principios:**
- **Reutilizable:** Componentes genéricos, no específicos de este proyecto
- **Configurable:** Rutas, credenciales, opciones en `.env` y `config/*.php`
- **No acoplado:** Sin dependencias a rutas concretas del hosting actual
- **Documentado:** Instrucciones claras para clonar y adaptar

---

## 17. Decisiones técnicas de framework

### Framework seleccionado: Slim PHP 4.x

**Justificación** (de `pre-proyecto/Estudios/02-Comparativa-Frameworks-PHP.md`):

| Criterio | Puntuación |
|----------|------------|
| Madurez y comunidad | 5/5 (12.3k stars) |
| Documentación | 5/5 (slimframework.com/docs/v4/) |
| Encaje requisitos | 5/5 (middleware PSR-15) |
| Tests/Calidad | 5/5 (PHPUnit, Coveralls, PHPStan) |
| **Total ponderado** | **4.9/5** |

### Dependencias mínimas (Etapa 1)

```json
{
    "require": {
        "php": ">=8.1",
        "slim/slim": "^4.15",
        "slim/psr7": "^1.7"
    }
}
```

### Evaluación: agente o skill para interactuar con Slim

**Conclusión: No se recomienda crear agente o skill específico en esta etapa.**

**Justificación:**
1. El alcance actual no justifica la complejidad adicional
2. La skill `context7` (`.skills/context7/SKILL.md`) ya permite consultar documentación actualizada de Slim
3. El agente general es suficiente con ayuda de context7
4. Principio de mínima complejidad

**Reconsiderar en Etapa 2+** si el uso de Slim es intensivo o hay patrones repetitivos que automatizar.

---

## 18. Dependencias futuras: Etapa 2

| Dependencia | Propósito | Incluir en Etapa |
|-------------|-----------|------------------|
| `monolog/monolog` | Logging estructurado | 2 |
| `illuminate/database` | Eloquent ORM (acceso BD WordPress) | 2 |
| `guzzlehttp/guzzle` | Cliente HTTP (llamadas a APIs) | 2 |
| `slim/csrf` | Protección CSRF/Nonces | 2 |

Se incluirán en Etapa 2 cuando Slim esté integrado, el despliegue validado y exista necesidad real.

---

## 19. Datos del servidor

Fuente: `wa-server-info-2026-04-28-101933.json`

| Parámetro | Valor |
|-----------|-------|
| **PHP versión** | 8.3.30 |
| **PHP SAPI** | litespeed |
| **Sistema operativo** | Linux 5.14.0 |
| **Servidor web** | LiteSpeed |
| **Memoria límite** | 256M |
| **Tiempo máximo ejecución** | 30s |
| **Upload max filesize** | 32M |
| **Post max size** | 128M |

**Extensiones:** mysqli, pdo_mysql, curl, gd, zip, json, dom, fileinfo, mbstring, xml

**WordPress:** v6.9.4, WooCommerce 10.4.4, MariaDB 11.4.10

---

## 20. Elementos fuera de alcance de Etapa 1

| Elemento | Etapa |
|----------|-------|
| Autenticación contra WordPress | 2+ |
| Logging estructurado (Monolog) | 2+ |
| Eloquent ORM (acceso a BD) | 2+ |
| Cliente HTTP (Guzzle) | 2+ |
| Protección CSRF | 2+ |
| Endpoint WordPress de validación | 2+ |
| Subida de PDFs | 3+ |
| Tabla personalizada en WordPress | 3+ |
| Selección de proveedor de IA | 3+ |
| Definición de `DIR_ALMACEN_PDF` | 3+ |
| CRUD de proveedores de IA | 3+ |
| Formulario de revisión | 3+ |
| Mapeo de campos WooCommerce | 4+ |
| Integración con API WooCommerce | 4+ |

**Criterio:** Cualquier funcionalidad no necesaria para integrar Slim y validar el despliegue queda excluida.

---

## Historial de cambios

| Versión | Fecha | Cambio | Autor |
|---------|-------|--------|-------|
| 2.0 | 28 abr 2026 | Consolidación: índice + todas las decisiones en un documento. Sustituye a 00-decisiones-generales v1.0 y 10-Decisiones v1.0 | Equipo de desarrollo |

---

*Documento generado el 28 de abril de 2026*  
*Pre-proyecto — Web-App de Automatización WooCommerce*
