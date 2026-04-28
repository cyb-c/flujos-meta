# Decisiones de Implantación — Etapa 1: Slim + FTP

**Versión:** 1.0  
**Fecha:** 28 de abril de 2026  
**Estado:** Pendiente de aprobación

---

## Índice de Contenido

1. [Propósito de este documento](#1-propósito-de-este-documento)
2. [Ubicación del proyecto Slim](#2-ubicación-del-proyecto-slim)
3. [Rutas de despliegue: sin subdirectorios fijos](#3-rutas-de-despliegue-sin-subdirectorios-fijos)
4. [Despliegue directo en directorio WA](#4-despliegue-directo-en-directorio-wa)
5. [Configuración de rutas no acopladas](#5-configuración-de-rutas-no-acopladas)
6. [Relación con decisiones generales](#6-relación-con-decisiones-generales)
7. [Referencias](#7-referencias)

---

## 1. Propósito de este documento

Este documento recoge las **decisiones específicas de implantación para Etapa 1**, complementando las decisiones generales documentadas en `00-decisiones-generales-implantacion.md`.

### Decisiones contenidas

| Decisión | Impacto |
|----------|---------|
| Ubicación del proyecto Slim en raíz del repositorio | Estructura del repositorio |
| Despliegue directo sin subdirectorios fijos | Procedimiento de despliegue |
| Configuración de rutas no acopladas | Arquitectura de la aplicación |

---

## 2. Ubicación del proyecto Slim

### Decisión

**La aplicación Slim se integra en la raíz del repositorio, no dentro de `pre-proyecto/`.**

### Justificación

- `pre-proyecto/` es un directorio **exclusivo para documentación**
- El código de la aplicación debe estar en la raíz para facilitar el despliegue
- La estructura del repositorio debe reflejar la estructura de despliegue
- Evita confusiones sobre qué se despliega y dónde

### Estructura correcta del repositorio

```
raíz-del-repositorio/
├── app/
│   ├── Controllers/
│   ├── Services/
│   ├── Middleware/
│   └── Config/
├── public/
│   └── index.php          # Front controller de Slim
├── vendor/
├── composer.json
├── composer.lock
├── deploy.sh              # Script de despliegue
├── .env.example           # Ejemplo de variables de entorno
├── .gitignore
└── pre-proyecto/          # SOLO documentación
    └── implantacion/
        └── (documentos de implantación)
```

### Estructura INCORRECTA (no usar)

```
raíz-del-repositorio/
├── pre-proyecto/
│   └── wa-slim/           # ❌ NO: código dentro de pre-proyecto/
│       ├── public/
│       └── vendor/
└── (otros directorios)
```

### Implicaciones

| Aspecto | Implicación |
|---------|-------------|
| **Desarrollo** | El código de la aplicación está en la raíz |
| **Despliegue** | Se despliega el contenido de la raíz (excluyendo pre-proyecto/) |
| **Documentación** | `pre-proyecto/` contiene solo documentación, nunca código |
| **Composer** | `composer.json` en raíz del repositorio |

---

## 3. Rutas de despliegue: sin subdirectorios fijos

### Decisión

**El despliegue se realiza directamente en el directorio base del dominio WA, sin crear subdirectorios fijos como `wa-slim/`.**

### Justificación

- Los directorios pueden cambiar en cualquier momento según necesidades del hosting
- No acoplar el desarrollo a rutas absolutas o directorios fijos
- La configuración debe permitir cambiar rutas sin alterar la lógica del proyecto
- Mayor flexibilidad para futuros cambios de infraestructura

### Configuración confirmada

| Parámetro | Valor |
|-----------|-------|
| **Dominio WA** | `stg2.cofemlevante.es` |
| **Directorio base** | `/home/beevivac/stg2.cofemlevante.es/` |
| **Subdirectorio** | Ninguno (despliegue directo) |

### Implicaciones para el despliegue

| Aspecto | Implicación |
|---------|-------------|
| **FTP target** | `/home/beevivac/stg2.cofemlevante.es/` (no `/home/beevivac/stg2.cofemlevante.es/wa-slim/`) |
| **Archivos** | Se suben directamente al directorio base |
| **Rutas web** | `https://stg2.cofemlevante.es/` (no `https://stg2.cofemlevante.es/wa-slim/`) |

---

## 4. Despliegue directo en directorio WA

### Decisión

**El agente desplegador debe apuntar directamente al directorio configurado para la WA, sin subdirectorio adicional `wa-slim/`.**

### Justificación

- El directorio WA ya está confirmado: `/home/beevivac/stg2.cofemlevante.es/`
- No hay necesidad de un subdirectorio intermedio
- Simplifica la configuración y reduce puntos de fallo
- Alineado con la decisión de rutas no fijas

### Configuración del agente desplegador

El agente `@ftp-deployer` debe configurarse con:

| Parámetro | Valor |
|-----------|-------|
| **FTP_SERVER** | `ftp.bee-viva.es` |
| **FTP_USER** | `ftp-wa@levantecofem.es` |
| **FTP_TARGET_PATH** | `/home/beevivac/stg2.cofemlevante.es/` |
| **FTP_PORT** | `21` |

### Variables de entorno requeridas

```bash
# En .env o GitHub Secrets
FTP_SERVER=ftp.bee-viva.es
FTP_USER=ftp-wa@levantecofem.es
FTP_PASSWORD=${CONTRASENYA_FTP_WA}  # Desde GitHub Secrets
FTP_TARGET_PATH=/home/beevivac/stg2.cofemlevante.es/
```

---

## 5. Configuración de rutas no acopladas

### Decisión

**Las rutas deben definirse en archivos de configuración externos que puedan modificarse sin tocar el código.**

### Justificación

- Los directorios pueden cambiar en cualquier momento
- Facilita el despliegue en diferentes entornos (staging, producción)
- Permite clonar el repositorio para otros proyectos con diferentes rutas
- Sigue el principio de configuración externa

### Implementación recomendada

#### Archivo `.env.example`

```bash
# Rutas de la aplicación
APP_BASE_PATH=/var/www/app
APP_PUBLIC_PATH=/var/www/app/public

# FTP de despliegue
FTP_SERVER=ftp.bee-viva.es
FTP_USER=ftp-wa@levantecofem.es
FTP_TARGET_PATH=/home/beevivac/stg2.cofemlevante.es/
```

#### Archivo `config/app.php`

```php
<?php
return [
    'base_path' => getenv('APP_BASE_PATH') ?: dirname(__DIR__),
    'public_path' => getenv('APP_PUBLIC_PATH') ?: dirname(__DIR__) . '/public',
];
```

#### Uso en la aplicación

```php
<?php
$config = require __DIR__ . '/../config/app.php';

// Usar $config['base_path'] y $config['public_path']
// Nunca hardcodear rutas absolutas
```

### Implicaciones para el código

| Práctica | Correcto | Incorrecto |
|----------|----------|------------|
| **Rutas de archivos** | `getenv('APP_BASE_PATH') . '/vendor/autoload.php'` | `/var/www/app/vendor/autoload.php` |
| **Rutas web** | `$app->get('/hello', ...)` | `$app->get('/wa-slim/hello', ...)` |
| **Configuración** | Archivos `.env` o `config/*.php` | Constantes hardcodeadas |

---

## 6. Relación con decisiones generales

Este documento complementa las siguientes decisiones de `00-decisiones-generales-implantacion.md`:

| Decisión general | Especificación en este documento |
|------------------|----------------------------------|
| Despliegue por FTP | Sección 3: Rutas de despliegue |
| No uso de Composer en servidor | Implícito en estructura de despliegue |
| Directorios WA/WP confirmados | Sección 4: Despliegue directo en directorio WA |
| Rutas de despliegue: sin subdirectorios fijos | Sección 3: Rutas de despliegue |
| Slim como framework base | Sección 2: Ubicación del proyecto Slim |

### Jerarquía de documentos

```
00-decisiones-generales-implantacion.md
└── 10-Decisiones-Etapa01-Slim-FTP.md (este documento)
    ├── 20-Alcance-Etapa01-Slim-FTP.md
    ├── 30-Plan-Etapa01-Slim-FTP.md
    ├── 40-Despliegue-Etapa01-Slim-FTP.md
    ├── 50-Verificacion-Etapa01-Slim-FTP.md
    └── 60-Pendientes-Etapa01-Slim-FTP.md
```

---

## 7. Referencias

### Documentos de este proyecto

| Documento | Ruta |
|-----------|------|
| Decisiones generales de implantación | `00-decisiones-generales-implantacion.md` |
| Índice de implantación | `00-INDICE-Implantacion.md` |
| Información del servidor WA | `wa-server-info-2026-04-28-101933.json` |

### Documentos externos

| Documento | Ruta |
|-----------|------|
| Comparativa de Frameworks | `../Estudios/02-Comparativa-Frameworks-PHP.md` |
| Análisis Técnico de Decisiones | `../Estudios/08-Analisis-Tecnico-Decisiones-Framework.md` |

---

## Historial de cambios

| Versión | Fecha | Cambio | Autor |
|---------|-------|--------|-------|
| 1.0 | 28 abr 2026 | Creación del documento (descompuesto de Etapa01_Slim-Despliegue-FTP.md) | Equipo de desarrollo |

---

*Documento generado el 28 de abril de 2026*  
*Pre-proyecto — Web-App de Automatización WooCommerce*
