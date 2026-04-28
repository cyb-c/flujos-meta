# Plan de Implantación — Etapa 1: Slim + FTP

**Versión:** 2.0  
**Fecha:** 28 de abril de 2026  
**Estado:** ✅ Aprobado

---

## Índice de Contenido

1. [Propósito y alcance del documento](#1-propósito-y-alcance-del-documento)
2. [Objetivo de la etapa](#2-objetivo-de-la-etapa)
3. [Alcance incluido](#3-alcance-incluido)
4. [Alcance excluido](#4-alcance-excluido)
5. [Requisitos técnicos](#5-requisitos-técnicos)
6. [Estructura del proyecto](#6-estructura-del-proyecto)
7. [Actividades y tareas](#7-actividades-y-tareas)
8. [Criterios de aceptación](#8-criterios-de-aceptación)
9. [Riesgos y mitigaciones](#9-riesgos-y-mitigaciones)
10. [Referencias](#10-referencias)

---

## 1. Propósito y alcance del documento

Plan detallado de trabajo para **Etapa 1**: integrar Slim como framework base del repositorio y preparar despliegue FTP mediante el agente desplegador.

Sustituye a: `20-Alcance-Etapa01-Slim-FTP.md` v1.0, `30-Plan-Etapa01-Slim-FTP.md` v1.0  
Depende de: `00-INDICE-Implantacion.md` (decisiones confirmadas)

---

## 2. Objetivo de la etapa

**Objetivo principal:** Integrar Slim como framework base en la raíz del repositorio y preparar despliegue FTP mediante el agente `@ftp-deployer`.

La prueba "Hola mundo" es una **validación mínima** de la integración y despliegue, no el objetivo final.

**Resultados esperados:**

| Resultado | Descripción |
|-----------|-------------|
| Slim integrado | Framework base en raíz del repositorio, con estructura `app/`, `config/`, `public/` |
| Agente operativo | `@ftp-deployer` configurado y funcional |
| Endpoint público | `https://stg2.cofemlevante.es/` responde 200 OK |
| Documentación | `00-INDICE-Implantacion.md`, `10-Plan-Etapa01-Slim-FTP.md`, `20-Operaciones-Etapa01-Slim-FTP.md` |

---

## 3. Alcance incluido

| Objetivo | Descripción | Criterio de aceptación |
|----------|-------------|------------------------|
| Integrar Slim | v4.x como framework base en raíz del repositorio | `composer.json` en raíz con Slim |
| Preparar despliegue FTP | Configurar agente `@ftp-deployer` para despliegue | Agente responde y conecta |
| Prueba "Hola mundo" | Endpoint `/` responde 200 OK como validación | `curl https://stg2.cofemlevante.es/` → "Hola mundo" |
| Verificación en servidor | Confirmar Slim se ejecuta en el hosting | Logs sin errores |
| Documentación | Decisiones, plan y operaciones documentados | Documentos activos creados y aprobados |

**Actividades incluidas:**

1. Instalación de Slim (`composer require slim/slim:^4.15 slim/psr7:^1.7`)
2. Creación de estructura (`app/`, `public/`, `config/`, `public/.htaccess`)
3. Configuración de rutas en `.env`
4. Preparación de despliegue (`composer install --no-dev --optimize-autoloader`)
5. Ejecución de despliegue mediante `@ftp-deployer` (sin `deploy.sh`)
6. Verificación HTTP y de logs
7. Documentación de decisiones y procedimientos

---

## 4. Alcance excluido

| Elemento | Etapa |
|----------|-------|
| Autenticación contra WordPress | 2+ |
| Logging estructurado (Monolog) | 2+ |
| Eloquent ORM (acceso a BD) | 2+ |
| Cliente HTTP (Guzzle) | 2+ |
| Protección CSRF | 2+ |
| Endpoint WP de validación | 2+ |
| Subida de PDFs | 3+ |
| Tabla personalizada en WP | 3+ |
| Proveedores de IA | 3+ |
| Formularios de revisión | 3+ |
| Mapeo WooCommerce | 4+ |

**Criterio:** No se incluye nada que no sea estrictamente necesario para integrar Slim y validar el despliegue.

---

## 5. Requisitos técnicos

### Servidor (verificado)

| Requisito | Estado |
|-----------|--------|
| PHP >= 8.1 | ✅ 8.3.30 |
| mysqli, pdo_mysql, curl, gd, zip, json, dom, mbstring, xml | ✅ Todos disponibles |

### Codespace (por verificar)

| Requisito | Acción |
|-----------|--------|
| PHP >= 8.1 | `php -v` |
| Composer | `composer --version` |
| lftp | `which lftp` (instalar si falta) |
| Variables de entorno FTP | Configurar en `.env` |

---

## 6. Estructura del proyecto

```
raíz-del-repositorio/
├── app/
│   ├── Controllers/
│   ├── Services/
│   ├── Middleware/
│   └── Config/
├── public/
│   ├── index.php          # Front controller Slim
│   └── .htaccess          # Reescritura URLs
├── vendor/                # Dependencias
├── config/
│   ├── app.php
│   ├── database.php
│   └── routes.php
├── composer.json
├── composer.lock
├── .env                   # NO versionado
├── .env.example           # Versionado
├── .gitignore
└── pre-proyecto/          # Solo documentación
```

### Front controller (`public/index.php`)

```php
<?php
declare(strict_types=1);
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Slim\Factory\AppFactory;
require __DIR__ . '/../vendor/autoload.php';

$app = AppFactory::create();

$app->get('/', function (Request $request, Response $response) {
    $response->getBody()->write('Hola mundo');
    return $response;
});

$app->get('/hello', function (Request $request, Response $response) {
    $response->getBody()->write('Hola mundo desde Slim');
    return $response;
});

$app->run();
```

### Composer (`composer.json`)

```json
{
    "name": "cofemlevante/web-app",
    "description": "Web-App de Automatización WooCommerce",
    "type": "project",
    "require": {
        "php": ">=8.1",
        "slim/slim": "^4.15",
        "slim/psr7": "^1.7"
    },
    "config": {
        "optimize-autoloader": true,
        "sort-packages": true
    },
    "scripts": {
        "start": "php -S localhost:8080 -t public"
    }
}
```

### .htaccess (`public/.htaccess`)

```
<IfModule mod_rewrite.c>
    RewriteEngine On
    RewriteCond %{REQUEST_FILENAME} !-f
    RewriteCond %{REQUEST_FILENAME} !-d
    RewriteRule ^ index.php [QSA,L]
</IfModule>
```

---

## 7. Actividades y tareas

### Fase 0: Pre-requisitos obligatorios (ejecutar antes de iniciar)

Las siguientes acciones **deben completarse antes** de comenzar la Fase 1. Son responsabilidad del equipo y bloquean el avance si no están resueltas.

| # | Acción | Responsable | Verificación |
|---|--------|-------------|--------------|
| 0.1 | **Verificar credenciales FTP** — Confirmar que el usuario `ftp-wa@levantecofem.es` tiene acceso y la contraseña está disponible como variable de entorno | Equipo | `echo $CONTRASENYA_FTP_WA` no vacío |
| 0.2 | **Confirmar acceso FTP desde Codespace** — Verificar que el Codespace puede conectar al servidor FTP sin bloqueos de firewall | Equipo | `nc -zv ftp.bee-viva.es 21` → éxito |
| 0.3 | **Obtener acceso a logs del servidor** — Solicitar acceso a los logs de error del servidor o ruta donde se almacenan | Equipo | Ruta de logs confirmada (ej. `/home/beevivac/logs/stg2.cofemlevante.es/error.log`) |

**Si estas acciones no pueden completarse, la Etapa 1 no debe iniciarse.** Documentar el bloqueo en `20-Operaciones-Etapa01-Slim-FTP.md` sección 7 (pendientes).

### Fase 1: Preparación del entorno

| Tarea | Acción |
|-------|--------|
| Verificar PHP | `php -v` |
| Verificar Composer | `composer --version` |
| Instalar lftp | `sudo apt-get install -y lftp` |
| Configurar `.env` | Copiar `.env.example` a `.env`, completar credenciales |

### Fase 2: Instalación de Slim

| Tarea | Acción |
|-------|--------|
| Inicializar proyecto | `composer init --name="cofemlevante/web-app" --no-interaction` |
| Instalar Slim | `composer require slim/slim:^4.15 slim/psr7:^1.7` |
| Crear estructura | `mkdir -p app/Controllers app/Services app/Middleware app/Config config public` |
| Crear front controller | `public/index.php` (ver sección 6) |
| Crear `.htaccess` | `public/.htaccess` (ver sección 6) |
| Crear `.env.example` | Con variables FTP_SERVER, FTP_USER, FTP_TARGET_PATH, APP_ENV |

### Fase 3: Prueba local

| Tarea | Acción |
|-------|--------|
| Iniciar servidor | `php -S localhost:8080 -t public` |
| Verificar `/` | `curl http://localhost:8080/` → "Hola mundo" |
| Verificar `/hello` | `curl http://localhost:8080/hello` → "Hola mundo desde Slim" |

### Fase 4: Preparación de despliegue

| Tarea | Acción |
|-------|--------|
| Instalar dependencias prod | `composer install --no-dev --optimize-autoloader` |
| Verificar tamaño | `du -sh vendor/` (esperado < 4 MB) |
| Verificar autoload | `vendor/autoload.php` existe |

### Fase 5: Despliegue

| Tarea | Acción |
|-------|--------|
| Invocar agente | `@ftp-deployer despliega la Web-App` |
| Confirmar transferencia | El agente informa archivos transferidos |

### Fase 6: Verificación

| Tarea | Acción |
|-------|--------|
| HTTP 200 | `curl -I https://stg2.cofemlevante.es/` |
| Contenido | `curl https://stg2.cofemlevante.es/` → "Hola mundo" |
| Logs | Revisar logs del servidor |

---

## 8. Criterios de aceptación

| # | Criterio | Verificación |
|---|----------|--------------|
| 1 | Slim en raíz del repositorio | `composer.json` en raíz con Slim |
| 2 | Agente `@ftp-deployer` operativo | Agente responde y conecta FTP |
| 3 | "Hola mundo" funciona en local | `http://localhost:8080/` → 200 OK |
| 4 | Paquete desplegable preparado | `composer install --no-dev` ejecutado |
| 5 | Despliegue FTP ejecutado | Agente confirma despliegue |
| 6 | Endpoint público accesible | `https://stg2.cofemlevante.es/` responde |
| 7 | HTTP 200 + "Hola mundo" | `curl` muestra contenido esperado |
| 8 | Sin errores en logs | Logs limpios |
| 9 | Documentación completa | 3 documentos activos creados |

---

## 9. Riesgos y mitigaciones

| Riesgo | Probabilidad | Impacto | Mitigación |
|--------|-------------|---------|------------|
| PHP < 8.1 en servidor | Baja | Alto | Ya verificado (8.3.30) |
| Composer no disponible local | Baja | Medio | `curl -sS https://getcomposer.org/installer \| php` |
| FTP bloqueado por firewall | Media | Alto | Usar FTPS, verificar puertos |
| Permisos incorrectos tras subir | Media | Medio | Verificar con `ls -la` |
| Credenciales FTP expuestas | Baja | Crítico | Variables de entorno, nunca en código |

---

## 10. Referencias

| Documento | Ruta |
|-----------|------|
| Decisiones + índice | `00-INDICE-Implantacion.md` |
| Operaciones | `20-Operaciones-Etapa01-Slim-FTP.md` |
| Info. servidor WA | `wa-server-info-2026-04-28-101933.json` |
| Agente ftp-deployer | `pre-proyecto/agentica/ftp-deployer-agent-spec.md` |
| Slim docs | https://www.slimframework.com/docs/v4/ |

---

## Historial de cambios

| Versión | Fecha | Cambio | Autor |
|---------|-------|--------|-------|
| 2.0 | 28 abr 2026 | Consolidación de alcance + plan. Sustituye a 20-Alcance v1.0 y 30-Plan v1.0 | Equipo de desarrollo |

---

*Documento generado el 28 de abril de 2026*  
*Pre-proyecto — Web-App de Automatización WooCommerce*
