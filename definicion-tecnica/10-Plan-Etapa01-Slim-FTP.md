# Plan de Implantación — Etapa 1: Slim + FTP

**Versión:** 3.0  
**Fecha:** 28 de abril de 2026  
**Estado:** ✅ Aprobado

---

## Índice Interno

1. [Propósito](#1-propósito)
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

## 1. Propósito

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
| Endpoint público | Responde 200 OK (URL según `inventario_recursos.md`) |
| Documentación | 3 documentos activos creados |

---

## 3. Alcance incluido

| Objetivo | Descripción | Criterio de aceptación |
|----------|-------------|------------------------|
| Integrar Slim | v4.x como framework base en raíz del repositorio | `composer.json` en raíz con Slim |
| Preparar despliegue FTP | Configurar agente `@ftp-deployer` para despliegue | Agente responde y conecta |
| Prueba "Hola mundo" | Endpoint `/` responde 200 OK como validación | `curl` → "Hola mundo" |
| Verificación en servidor | Confirmar Slim se ejecuta en el hosting | Logs sin errores |
| Documentación | Decisiones, plan y operaciones documentados | Documentos activos creados y aprobados |

**Actividades incluidas:**

1. Instalación de Slim (`composer require slim/slim:^4.15 slim/psr7:^1.7 vlucas/phpdotenv:^5.6`)
2. Creación de estructura (`app/`, `public/`, `config/`, `.htaccess`)
3. Configuración de rutas y variables de entorno
4. Preparación de despliegue (`composer install --no-dev --optimize-autoloader`)
5. Ejecución de despliegue mediante `@ftp-deployer` (sin `deploy.sh`)
6. Verificación HTTP y de logs
7. Documentación de decisiones y procedimientos

---

## 4. Alcance excluido

Ver listado completo en `00-INDICE-Implantacion.md` §17. En Etapa 1 no se incluye nada que no sea estrictamente necesario para integrar Slim y validar el despliegue.

---

## 5. Requisitos técnicos

### Servidor (verificado)

| Requisito | Estado |
|-----------|--------|
| PHP >= 8.1 | ✅ Según `inventario_recursos.md` (Stack Tecnológico) |
| Extensiones | mysqli, pdo_mysql, curl, gd, zip, json, dom, mbstring, xml — todas disponibles |

### Codespace (por verificar)

| Requisito | Acción |
|-----------|--------|
| PHP >= 8.1 | `php -v` |
| Composer | `composer --version` |
| lftp | `which lftp` (instalar si falta) |
| Variables de entorno FTP | Configurar según `inventario_recursos.md` y `.env.example` |

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
│   ├── index.php              # Front controller Slim
│   └── .htaccess              # Reescritura a index.php
├── vendor/                    # Dependencias
├── config/
│   ├── app.php
│   ├── database.php
│   └── routes.php
├── composer.json
├── composer.lock
├── .htaccess                  # Redirección raíz → public/
├── .env                       # NO versionado
├── .env.example               # Versionado
├── .gitignore
└── pre-proyecto/              # Solo documentación
```

### Front controller (`public/index.php`)

Incluye middlewares recomendados por Slim docs:

```php
<?php
declare(strict_types=1);

use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Slim\Factory\AppFactory;

require __DIR__ . '/../vendor/autoload.php';

// Cargar variables de entorno desde .env
$dotenv = Dotenv\Dotenv::createImmutable(__DIR__ . '/..');
$dotenv->safeLoad();

$app = AppFactory::create();

// Middlewares (orden recomendado por Slim docs)
$app->addRoutingMiddleware();

$errorMiddleware = $app->addErrorMiddleware(
    (bool)($_ENV['APP_DEBUG'] ?? false),
    true,
    true
);

// Rutas
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
        "slim/psr7": "^1.7",
        "vlucas/phpdotenv": "^5.6"
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

### .htaccess raíz

Redirige todo el tráfico al directorio `public/`:

```
<IfModule mod_rewrite.c>
    RewriteEngine On
    RewriteRule ^$ public/ [L]
    RewriteRule (.*) public/$1 [L]
</IfModule>
```

### .htaccess (`public/.htaccess`)

Reescritura interna de Slim dentro de `public/`:

```
<IfModule mod_rewrite.c>
    RewriteEngine On
    RewriteCond %{REQUEST_FILENAME} !-f
    RewriteCond %{REQUEST_FILENAME} !-d
    RewriteRule ^ index.php [QSA,L]
</IfModule>
```

### Variables de entorno (`.env.example`)

Ver `inventario_recursos.md` para la lista completa de variables. Ver `.env.example` en la raíz del repositorio como plantilla.

---

## 7. Actividades y tareas

### Fase 1: Preparación del entorno

| Tarea | Acción |
|-------|--------|
| Verificar PHP | `php -v` |
| Verificar Composer | `composer --version` |
| Instalar lftp | `sudo apt-get install -y lftp` |
| Configurar `.env` | Copiar `.env.example` a `.env`, completar según `inventario_recursos.md` |

### Fase 2: Instalación de Slim

| Tarea | Acción |
|-------|--------|
| Instalar Slim y dependencias | `composer require slim/slim:^4.15 slim/psr7:^1.7 vlucas/phpdotenv:^5.6` |
| Crear estructura | `mkdir -p app/Controllers app/Services app/Middleware app/Config config public` |
| Crear front controller | `public/index.php` (ver sección 6) |
| Crear `.htaccess` raíz | Ver sección 6 |
| Crear `public/.htaccess` | Ver sección 6 |

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
| HTTP 200 | `curl -I` según URL de `inventario_recursos.md` |
| Contenido | `curl` según URL → "Hola mundo" |
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
| 6 | Endpoint público accesible | URL de `inventario_recursos.md` responde |
| 7 | HTTP 200 + "Hola mundo" | `curl` muestra contenido esperado |
| 8 | Sin errores en logs | Logs limpios |
| 9 | Documentación completa | 3 documentos activos creados |

---

## 9. Riesgos y mitigaciones

| Riesgo | Probabilidad | Impacto | Mitigación |
|--------|-------------|---------|------------|
| PHP < 8.1 en servidor | Baja | Alto | Ya verificado (ver `inventario_recursos.md`) |
| Composer no disponible local | Baja | Medio | `curl -sS https://getcomposer.org/installer \| php` |
| FTP bloqueado por firewall | Media | Alto | Usar FTPS, verificar puertos |
| Permisos incorrectos tras subir | Media | Medio | Verificar con `ls -la` |
| Credenciales FTP expuestas | Baja | Crítico | Variables de entorno, nunca en código |

---

## 10. Referencias

| Documento | Ruta |
|-----------|------|
| Decisiones e índice | `00-INDICE-Implantacion.md` |
| Operaciones | `20-Operaciones-Etapa01-Slim-FTP.md` |
| Inventario de recursos | `.gobernanza/inventario_recursos.md` |
| Info. servidor WA | `wa-server-info-2026-04-28-101933.json` |
| Agente ftp-deployer | `.opencode/agents/ftp-deployer.md` |
| Especificación agente | `pre-proyecto/agentica/ftp-deployer-agent-spec.md` |
| Slim docs | https://www.slimframework.com/docs/v4/ |
| phpdotenv docs | https://github.com/vlucas/phpdotenv |
| lftp docs | https://lftp.yar.ru/ |

---

## Historial de cambios

| Versión | Fecha | Cambio | Autor |
|---------|-------|--------|-------|
| 3.0 | 28 abr 2026 | Corrección front controller con middlewares. Adición de `vlucas/phpdotenv` a dependencias. Corrección .htaccess (raíz + public/). Eliminación de pre-requisitos (duplicados en 20-Operaciones). Referencias a inventario. | OpenCode |
| 2.0 | 28 abr 2026 | Consolidación de alcance + plan | Equipo de desarrollo |

---

*Documento generado el 28 de abril de 2026*  
*Pre-proyecto — Web-App de Automatización WooCommerce*
