# Plan de Implantación — Etapa 1: Slim + FTP

**Versión:** 1.0  
**Fecha:** 28 de abril de 2026  
**Estado:** Pendiente de aprobación

---

## Índice de Contenido

1. [Propósito de este documento](#1-propósito-de-este-documento)
2. [Objetivo de la etapa](#2-objetivo-de-la-etapa)
3. [Requisitos técnicos](#3-requisitos-técnicos)
4. [Estructura del proyecto](#4-estructura-del-proyecto)
5. [Actividades y tareas](#5-actividades-y-tareas)
6. [Criterios de aceptación](#6-criterios-de-aceptación)
7. [Riesgos y mitigaciones](#7-riesgos-y-mitigaciones)
8. [Relación con otros documentos](#8-relación-con-otros-documentos)
9. [Referencias](#9-referencias)

---

## 1. Propósito de este documento

Este documento describe el **plan detallado de trabajo para Etapa 1** de implantación, incluyendo actividades, tareas, requisitos y criterios de aceptación.

### Contexto

Este documento se deriva de:
- `00-decisiones-generales-implantacion.md` — Decisiones generales
- `10-Decisiones-Etapa01-Slim-FTP.md` — Decisiones específicas
- `20-Alcance-Etapa01-Slim-FTP.md` — Alcance definido

---

## 2. Objetivo de la etapa

### Objetivo principal

**Integrar Slim como framework base del repositorio y preparar despliegue FTP mediante el agente desplegador.**

### La prueba "Hola mundo" como validación

La prueba "Hola mundo" **no es el objetivo final** de la etapa, sino una **validación mínima** de que:
- Slim está correctamente integrado
- El despliegue FTP funciona
- La aplicación se ejecuta en el servidor

### Resultados esperados

| Resultado | Descripción |
|-----------|-------------|
| Slim integrado | Framework base en raíz del repositorio |
| Agente operativo | `@ftp-deployer` configurado y funcional |
| Endpoint público | URL accesible respondiendo 200 OK con "Hola mundo" |
| Documentación | Documentos 10-60 creados y aprobados |

---

## 3. Requisitos técnicos

### 3.1 Verificados en el servidor

| Requisito | Estado | Detalle |
|-----------|--------|---------|
| **PHP >= 8.1** | ✅ Cumple | PHP 8.3.30 instalado |
| **Extensión mysqli** | ✅ Cumple | Disponible |
| **Extensión pdo_mysql** | ✅ Cumple | Disponible |
| **Extensión mbstring** | ✅ Cumple | Disponible |
| **Extensión xml** | ✅ Cumple | Disponible |
| **Extensión curl** | ✅ Cumple | Disponible |
| **Extensión gd** | ✅ Cumple | Disponible |
| **Extensión zip** | ✅ Cumple | Disponible |
| **Extensión json** | ✅ Cumple | Disponible |
| **Extensión dom** | ✅ Cumple | Disponible |
| **Extensión fileinfo** | ✅ Cumple | Disponible |

**Fuente:** `wa-server-info-2026-04-28-101933.json`

### 3.2 Entorno de desarrollo (Codespace)

| Requisito | Estado | Acción requerida |
|-----------|--------|------------------|
| **PHP >= 8.1** | Por verificar | Ejecutar `php -v` en Codespace |
| **Composer** | Por verificar | Ejecutar `composer --version` |
| **Acceso FTP** | Por configurar | Credenciales en GitHub Secrets |
| **Cliente FTP (lftp)** | Por verificar | Instalar si no disponible |

### 3.3 Datos del servidor confirmados

| Entorno | Directorio base | Usuario FTP | Servidor FTP | Puerto |
|---------|-----------------|-------------|--------------|--------|
| **WA (Web-App)** | `/home/beevivac/stg2.cofemlevante.es` | `ftp-wa@levantecofem.es` | `ftp.bee-viva.es` | 21 |
| **WP (WordPress)** | `/home/beevivac/levantecofem_es` | `ftp-cfle-wp@levantecofem.es` | `ftp.bee-viva.es` | 21 |

---

## 4. Estructura del proyecto

### 4.1 Estructura de directorios (raíz del repositorio)

```
raíz-del-repositorio/
├── app/
│   ├── Controllers/       # Controladores de la aplicación
│   ├── Services/          # Servicios de negocio
│   ├── Middleware/        # Middleware de Slim
│   └── Config/            # Configuración de la aplicación
├── public/
│   └── index.php          # Front controller de Slim
├── vendor/                # Dependencias (generado por Composer)
├── config/
│   ├── app.php            # Configuración de la aplicación
│   ├── database.php       # Configuración de base de datos
│   └── routes.php         # Definición de rutas
├── composer.json          # Dependencias de PHP
├── composer.lock          # Bloqueo de versiones
├── deploy.sh              # Script de despliegue (opcional)
├── .env.example           # Ejemplo de variables de entorno
├── .gitignore             # Archivos ignorados por Git
└── pre-proyecto/          # SOLO documentación
    └── implantacion/
        └── (documentos)
```

### 4.2 Front controller mínimo (`public/index.php`)

```php
<?php
declare(strict_types=1);

use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Slim\Factory\AppFactory;

require __DIR__ . '/../vendor/autoload.php';

$app = AppFactory::create();

// Ruta de prueba "Hola mundo"
$app->get('/', function (Request $request, Response $response) {
    $response->getBody()->write('Hola mundo');
    return $response;
});

// Ruta alternativa /hello
$app->get('/hello', function (Request $request, Response $response) {
    $response->getBody()->write('Hola mundo desde Slim');
    return $response;
});

$app->run();
```

### 4.3 Configuración de Composer (`composer.json`)

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

---

## 5. Actividades y tareas

### 5.1 Fase 1: Preparación del entorno

| Tarea | Descripción | Comando/Acción |
|-------|-------------|----------------|
| 1.1 Verificar PHP | Confirmar versión de PHP en Codespace | `php -v` |
| 1.2 Verificar Composer | Confirmar instalación de Composer | `composer --version` |
| 1.3 Instalar lftp | Instalar cliente FTP si no disponible | `sudo apt-get install -y lftp` |
| 1.4 Configurar Secrets | Añadir credenciales FTP en GitHub Secrets | `CONTRASENYA_FTP_WA` |

### 5.2 Fase 2: Instalación de Slim

| Tarea | Descripción | Comando/Acción |
|-------|-------------|----------------|
| 2.1 Inicializar proyecto | Crear `composer.json` base | `composer init --name="cofemlevante/web-app" --no-interaction` |
| 2.2 Instalar Slim | Instalar Slim y dependencias | `composer require slim/slim:^4.15 slim/psr7:^1.7` |
| 2.3 Crear estructura | Crear directorios base | `mkdir -p app/Controllers app/Services app/Middleware app/Config config public` |
| 2.4 Crear front controller | Crear `public/index.php` | Ver sección 4.2 |

### 5.3 Fase 3: Prueba local

| Tarea | Descripción | Comando/Acción |
|-------|-------------|----------------|
| 3.1 Iniciar servidor local | Probar en localhost | `composer start` |
| 3.2 Verificar endpoint | Acceder a `http://localhost:8080/` | Navegador o `curl http://localhost:8080/` |
| 3.3 Verificar logs | Confirmar sin errores | Revisar output del servidor |

### 5.4 Fase 4: Preparación de despliegue

| Tarea | Descripción | Comando/Acción |
|-------|-------------|----------------|
| 4.1 Instalar dependencias | Preparar para producción | `composer install --no-dev --optimize-autoloader` |
| 4.2 Verificar tamaño | Confirmar tamaño razonable | `du -sh vendor/` |
| 4.3 Crear script deploy | Opcional: `deploy.sh` | Ver sección 9 de `40-Despliegue-Etapa01-Slim-FTP.md` |

### 5.5 Fase 5: Despliegue

| Tarea | Descripción | Comando/Acción |
|-------|-------------|----------------|
| 5.1 Invocar agente | Desplegar mediante agente | `@ftp-deployer despliega la WA` |
| 5.2 O ejecutar script | Alternativa: script manual | `./deploy.sh` |
| 5.3 Confirmar despliegue | Verificar archivos en servidor | `lftp -e "ls -la /home/beevivac/stg2.cofemlevante.es/; bye"` |

### 5.6 Fase 6: Verificación

| Tarea | Descripción | Comando/Acción |
|-------|-------------|----------------|
| 6.1 Verificar HTTP 200 | Confirmar respuesta correcta | `curl -I https://stg2.cofemlevante.es/` |
| 6.2 Verificar contenido | Confirmar "Hola mundo" | `curl https://stg2.cofemlevante.es/` |
| 6.3 Verificar logs | Confirmar sin errores | Revisar logs del servidor |
| 6.4 Documentar resultado | Registrar en `60-Pendientes-Etapa01-Slim-FTP.md` | Actualizar documento |

---

## 6. Criterios de aceptación

Esta etapa se considera **completada** cuando se cumplen **todos** los siguientes criterios:

| # | Criterio | Verificación |
|---|----------|--------------|
| 1 | Slim integrado como framework base en raíz del repositorio | `composer.json` en raíz con Slim como dependencia |
| 2 | Agente desplegador FTP configurado y operativo | `@ftp-deployer` responde correctamente |
| 3 | Endpoint "Hola mundo" funciona en local | `http://localhost:8080/` responde 200 OK |
| 4 | Paquete desplegable preparado (con `vendor/`) | `composer install --no-dev` ejecutado |
| 5 | Despliegue por FTP ejecutado correctamente | Agente confirma despliegue |
| 6 | Endpoint accesible públicamente | `https://stg2.cofemlevante.es/` accesible |
| 7 | Respuesta HTTP 200 OK con "Hola mundo" | `curl https://stg2.cofemlevante.es/` muestra contenido |
| 8 | Sin errores en logs del servidor | Logs revisados y limpios |
| 9 | Decisiones de implantación documentadas | Documentos 10-60 creados |

---

## 7. Riesgos y mitigaciones

| Riesgo | Probabilidad | Impacto | Mitigación |
|--------|-------------|---------|------------|
| **PHP < 8.1 en servidor** | Baja (verificado 8.3.30) | Alto | N/A - ya verificado |
| **Composer no disponible localmente** | Baja | Medio | Instalar: `curl -sS https://getcomposer.org/installer \| php` |
| **FTP bloqueado por firewall** | Media | Alto | Usar FTPS explícito, verificar puertos |
| **Permisos incorrectos tras subir** | Media | Medio | Script de despliegue con chmod explícito |
| **vendor/ demasiado grande** | Baja | Bajo | Usar `--no-dev`, optimizar autoload |
| **Ruta pública incorrecta** | Media | Medio | Probar múltiples rutas, verificar .htaccess |
| **Errores de autoload en servidor** | Media | Alto | Regenerar autoload con `dump-autoload --optimize` |
| **Credenciales FTP expuestas** | Baja | Crítico | Usar GitHub Secrets, nunca en código |

---

## 8. Relación con otros documentos

### Documentos de los que depende

| Documento | Relación |
|-----------|----------|
| `00-decisiones-generales-implantacion.md` | Decisiones generales |
| `10-Decisiones-Etapa01-Slim-FTP.md` | Decisiones específicas |
| `20-Alcance-Etapa01-Slim-FTP.md` | Alcance definido |

### Documentos que dependen de este

| Documento | Relación |
|-----------|----------|
| `40-Despliegue-Etapa01-Slim-FTP.md` | Procedimiento detallado de despliegue |
| `50-Verificacion-Etapa01-Slim-FTP.md` | Procedimiento de verificación |
| `60-Pendientes-Etapa01-Slim-FTP.md` | Seguimiento de pendientes |

### Jerarquía de documentos de Etapa 1

```
10-Decisiones-Etapa01-Slim-FTP.md
└── 20-Alcance-Etapa01-Slim-FTP.md
    └── 30-Plan-Etapa01-Slim-FTP.md (este documento)
        ├── 40-Despliegue-Etapa01-Slim-FTP.md
        ├── 50-Verificacion-Etapa01-Slim-FTP.md
        └── 60-Pendientes-Etapa01-Slim-FTP.md
```

---

## 9. Referencias

### Documentos de este proyecto

| Documento | Ruta |
|-----------|------|
| Decisiones generales de implantación | `00-decisiones-generales-implantacion.md` |
| Decisiones específicas Etapa 1 | `10-Decisiones-Etapa01-Slim-FTP.md` |
| Alcance Etapa 1 | `20-Alcance-Etapa01-Slim-FTP.md` |
| Índice de implantación | `00-INDICE-Implantacion.md` |
| Información del servidor WA | `wa-server-info-2026-04-28-101933.json` |

### Documentos externos

| Documento | Ruta |
|-----------|------|
| Comparativa de Frameworks | `../Estudios/02-Comparativa-Frameworks-PHP.md` |
| Slim Framework Documentation | https://www.slimframework.com/docs/v4/ |

---

## Historial de cambios

| Versión | Fecha | Cambio | Autor |
|---------|-------|--------|-------|
| 1.0 | 28 abr 2026 | Creación del documento (descompuesto de Etapa01_Slim-Despliegue-FTP.md) | Equipo de desarrollo |

---

*Documento generado el 28 de abril de 2026*  
*Pre-proyecto — Web-App de Automatización WooCommerce*
