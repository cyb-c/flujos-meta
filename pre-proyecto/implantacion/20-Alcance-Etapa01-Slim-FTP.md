# Alcance de Implantación — Etapa 1: Slim + FTP

**Versión:** 1.0  
**Fecha:** 28 de abril de 2026  
**Estado:** Pendiente de aprobación

---

## Índice de Contenido

1. [Propósito de este documento](#1-propósito-de-este-documento)
2. [Alcance incluido](#2-alcance-incluido)
3. [Alcance excluido](#3-alcance-excluido)
4. [Criterios de exclusión](#4-criterios-de-exclusión)
5. [Relación con otros documentos](#5-relación-con-otros-documentos)
6. [Referencias](#6-referencias)

---

## 1. Propósito de este documento

Este documento delimita el **alcance incluido y excluido de Etapa 1** de implantación, proporcionando criterios claros sobre qué se incluye en esta etapa y qué se pospone para etapas futuras.

### Contexto

Este documento se deriva de las decisiones documentadas en:
- `00-decisiones-generales-implantacion.md` — Decisiones generales
- `10-Decisiones-Etapa01-Slim-FTP.md` — Decisiones específicas de Etapa 1

---

## 2. Alcance incluido

### 2.1 Objetivos de Etapa 1

| Objetivo | Descripción | Criterio de aceptación |
|----------|-------------|------------------------|
| **Integrar Slim PHP** | Versión 4.x como framework base del repositorio | Slim instalado en raíz del repositorio |
| **Preparar despliegue FTP** | Configuración de conexión y método de subida mediante agente | Agente `@ftp-deployer` operativo |
| **Prueba "Hola mundo"** | Endpoint mínimo que responde 200 OK como validación | URL pública responde 200 con "Hola mundo" |
| **Verificación en servidor** | Confirmar que Slim se ejecuta en el hosting compartido | Logs sin errores, PHP 8.3.30 confirmado |
| **Documentación de decisiones** | Registrar decisiones técnicas de implantación | Documentos 10-60 creados y aprobados |

### 2.2 Entregables

| Entregable | Descripción | Ubicación |
|------------|-------------|-----------|
| Slim integrado | Framework base en raíz del repositorio | `/` (raíz) |
| Front controller | `public/index.php` con ruta "Hola mundo" | `/public/index.php` |
| Composer configurado | `composer.json` y `composer.lock` | `/composer.json`, `/composer.lock` |
| Agente desplegador | `@ftp-deployer` configurado | `.opencode/agents/ftp-deployer.md` |
| Script de despliegue | `deploy.sh` (opcional) | `/deploy.sh` |
| Documentación | Documentos 10-60 de implantación | `/pre-proyecto/implantacion/` |

### 2.3 Actividades incluidas

| Actividad | Descripción |
|-----------|-------------|
| Instalación de Slim | `composer require slim/slim:^4.15 slim/psr7:^1.7` |
| Creación de estructura | Directorios `app/`, `public/`, `config/` |
| Configuración de rutas | Variables de entorno para rutas |
| Preparación de despliegue | `composer install --no-dev --optimize-autoloader` |
| Ejecución de despliegue | Mediante `@ftp-deployer` o `deploy.sh` |
| Verificación | Tests HTTP y revisión de logs |
| Documentación | Creación de documentos 10-60 |

---

## 3. Alcance excluido

### 3.1 Explícitamente fuera de Etapa 1

| Elemento | Estado | Etapa estimada | Justificación |
|----------|--------|----------------|---------------|
| Autenticación contra WordPress | ❌ Fuera de alcance | Etapa 2 | Requiere endpoint WP y middleware |
| Logging estructurado (Monolog) | ❌ Fuera de alcance | Etapa 2 | Requiere configuración adicional |
| Eloquent ORM (acceso a BD) | ❌ Fuera de alcance | Etapa 2 | Requiere `illuminate/database` |
| Cliente HTTP (Guzzle) | ❌ Fuera de alcance | Etapa 2 | Requiere `guzzlehttp/guzzle` |
| Protección CSRF | ❌ Fuera de alcance | Etapa 2 | Requiere `slim/csrf` |
| Subida de PDFs | ❌ Fuera de alcance | Etapa 3 | Requiere formularios y gestión de archivos |
| Endpoint WordPress de validación | ❌ Fuera de alcance | Etapa 2 | Requiere plugin en WordPress |
| Tabla personalizada en WordPress | ❌ Fuera de alcance | Etapa 3 | Requiere definición de schema |
| Mapeo de campos WooCommerce | ❌ Fuera de alcance | Etapa 4 | Requiere análisis de campos existentes |
| Selección de proveedor de IA | ❌ Fuera de alcance | Etapa 3 | Requiere CRUD de proveedores |
| Definición de `DIR_ALMACEN_PDF` | ❌ Fuera de alcance | Etapa 3 | Requiere decisión de ubicación |
| CRUD de proveedores de IA | ❌ Fuera de alcance | Etapa 3 | Requiere frontend y backend |
| Formulario de revisión | ❌ Fuera de alcance | Etapa 3 | Requiere lógica de negocio |
| Integración con API WooCommerce | ❌ Fuera de alcance | Etapa 4 | Requiere autenticación y mapeo |

### 3.2 Dependencias de Etapa 2

Las siguientes dependencias se incluirán en Etapa 2, no en Etapa 1:

| Dependencia | Propósito | Razón de exclusión en Etapa 1 |
|-------------|-----------|-------------------------------|
| `monolog/monolog` | Logging estructurado | No necesario para validación mínima |
| `illuminate/database` | Eloquent ORM (acceso a BD WordPress) | Sin integración con BD en Etapa 1 |
| `guzzlehttp/guzzle` | Cliente HTTP (llamadas a APIs) | Sin llamadas a APIs en Etapa 1 |
| `slim/csrf` | Protección CSRF/Nonces | Sin formularios en Etapa 1 |

---

## 4. Criterios de exclusión

Cualquier funcionalidad que cumpla **al menos uno** de los siguientes criterios queda **excluida de Etapa 1**:

### Criterio 1: No necesario para validación mínima

Si la funcionalidad no es estrictamente necesaria para validar "Slim integrado + despliegue funcionando", se pospone.

**Ejemplos:**
- Logging estructurado → Se puede validar sin logs
- CSRF → No hay formularios en prueba "Hola mundo"

### Criterio 2: Requiere integración con WordPress

Si la funcionalidad requiere integración activa con WordPress o WooCommerce, se pospone a Etapa 2+.

**Ejemplos:**
- Autenticación → Requiere endpoint en WordPress
- Acceso a BD → Requiere conexión a BD de WordPress

### Criterio 3: Añade complejidad desproporcionada

Si la funcionalidad añade complejidad significativa sin beneficio inmediato para la validación, se pospone.

**Ejemplos:**
- Múltiples entornos → Etapa 1 solo necesita un entorno
- Sistema de plantillas → "Hola mundo" no requiere templates

### Criterio 4: Requiere definición de arquitectura no resuelta

Si la funcionalidad requiere decisiones de arquitectura aún no tomadas, se pospone.

**Ejemplos:**
- `DIR_ALMACEN_PDF` → Requiere decisión de ubicación
- Schema de tablas → Requiere diseño de BD

---

## 5. Relación con otros documentos

### Documentos de los que depende

| Documento | Relación |
|-----------|----------|
| `00-decisiones-generales-implantacion.md` | Decisiones generales que definen límites |
| `10-Decisiones-Etapa01-Slim-FTP.md` | Decisiones específicas que justifican exclusiones |

### Documentos que dependen de este

| Documento | Relación |
|-----------|----------|
| `30-Plan-Etapa01-Slim-FTP.md` | El plan se basa en el alcance definido |
| `60-Pendientes-Etapa01-Slim-FTP.md` | Los pendientes son lo excluido + acciones |

### Jerarquía de documentos de Etapa 1

```
10-Decisiones-Etapa01-Slim-FTP.md
└── 20-Alcance-Etapa01-Slim-FTP.md (este documento)
    ├── 30-Plan-Etapa01-Slim-FTP.md
    ├── 40-Despliegue-Etapa01-Slim-FTP.md
    ├── 50-Verificacion-Etapa01-Slim-FTP.md
    └── 60-Pendientes-Etapa01-Slim-FTP.md
```

---

## 6. Referencias

### Documentos de este proyecto

| Documento | Ruta |
|-----------|------|
| Decisiones generales de implantación | `00-decisiones-generales-implantacion.md` |
| Decisiones específicas Etapa 1 | `10-Decisiones-Etapa01-Slim-FTP.md` |
| Índice de implantación | `00-INDICE-Implantacion.md` |

### Documentos externos

| Documento | Ruta |
|-----------|------|
| Boceto del proyecto | `../02-Boceto_B09.md` |

---

## Historial de cambios

| Versión | Fecha | Cambio | Autor |
|---------|-------|--------|-------|
| 1.0 | 28 abr 2026 | Creación del documento (descompuesto de Etapa01_Slim-Despliegue-FTP.md) | Equipo de desarrollo |

---

*Documento generado el 28 de abril de 2026*  
*Pre-proyecto — Web-App de Automatización WooCommerce*
