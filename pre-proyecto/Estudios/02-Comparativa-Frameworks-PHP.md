# Comparativa Técnica de Frameworks PHP para el Proyecto de Automatización WooCommerce

## Índice de Contenidos

1. [Resumen Ejecutivo](#1-resumen-ejecutivo)
2. [Frameworks Analizados](#2-frameworks-analizados)
3. [Tabla Comparativa Principal](#3-tabla-comparativa-principal)
4. [Comparativa Frente a las Necesidades del Proyecto](#4-comparativa-frente-a-las-necesidades-del-proyecto)
5. [Riesgos y Limitaciones](#5-riesgos-y-limitaciones)
6. [Recomendación Final Justificada](#6-recomendación-final-justificada)
7. [Conclusión Operativa](#7-conclusión-operativa)
8. [Referencias y Documentación](#8-referencias-y-documentación)

---

## 1. Resumen Ejecutivo

### 1.1 Propósito del Análisis

Este documento compara cinco frameworks PHP como bases tecnológicas potenciales para la Web-App (WA) descrita en `02-Boceto_B09.md`. La comparación toma como referencia el análisis existente de `PHP-React-Framework` contenido en `01-PHP-React-Framework-Analisis.md`.

### 1.2 Frameworks Evaluados

| Framework | Repositorio | Enfoque Principal |
|-----------|-------------|-------------------|
| **PHP-React-Framework** | `mrbeandev/PHP-React-Framework` | Boilerplate PHP + React con arquitectura personalizada |
| **flightphp/core** | `flightphp/core` | Micro-framework rápido, cero dependencias |
| **clue/framework-x** | `clue/framework-x` | Micro-framework reactivo con soporte async |
| **slimphp/Slim** | `slimphp/Slim` | Micro-framework maduro, PSR-compliant |
| **leafsphp/leaf** | `leafsphp/leaf` | Framework ligero enfocado en experiencia de desarrollador |

### 1.3 Conclusión Anticipada

**Slim PHP es la recomendación principal** para este proyecto, seguido de cerca por Flight PHP como alternativa más ligera.

**Justificación resumida:**
- Slim ofrece el mejor equilibrio entre madurez, comunidad, documentación y funcionalidades necesarias
- Flight PHP es la opción más rápida y con cero dependencias, ideal si se prioriza minimalismo
- PHP-React-Framework requiere adaptación significativa (autenticación WordPress) y carece de tests
- Framework-X es excelente para casos async pero puede ser excesivo para este proyecto
- Leaf PHP tiene buena experiencia de desarrollador pero menor madurez que Slim

### 1.4 Hallazgos Clave por Categoría

| Categoría | Mejor Opción | Alternativa |
|-----------|--------------|-------------|
| **Madurez y comunidad** | Slim (12.3k stars, 4.5k commits) | Flight (2.9k stars, 794 commits) |
| **Rendimiento** | Flight (190k req/s benchmark) | Framework-X (async nativo) |
| **Documentación** | Slim (completa v4) | Flight (docs.flightphp.com) |
| **Tests automatizados** | Slim (cobertura verificada) | Framework-X (100% coverage) |
| **Facilidad integración WordPress** | Slim/Flight (middleware flexible) | PHP-React-Framework (requiere adaptación) |
| **Curva de aprendizaje** | Flight (más simple) | Leaf (enfoque developer-friendly) |

---

## 2. Frameworks Analizados

### 2.1 PHP-React-Framework (Referencia Base)

**Estado:** Proyecto muy nuevo, 5 commits totales, 1 autor, sin tests.

**Arquitectura:**
- Front controller en `public/index.php`
- Router personalizado con regex y middleware pipeline
- DI Container con resolución por reflexión
- Request/Response inmutables estilo PSR-7/15
- Validador propio (5 reglas: required, string, boolean, max, path)
- Eloquent ORM (Laravel ^10.0)
- Guzzle HTTP para APIs externas

**Stack:**
- Backend: PHP 8.1+
- Frontend: React 19 + TypeScript + Vite 7 + Tailwind 4

**Ventajas identificadas en análisis previo:**
- Arquitectura limpia y moderna
- Stack tecnológico actualizado
- Eloquent ORM potente para persistencia
- Configuración centralizada

**Desventajas críticas:**
- Sin tests automatizados
- Autenticación por API key (incompatible con WordPress cookies)
- Framework de un solo autor (riesgo de abandono)
- Validador limitado (5 reglas)
- Demo app entrelazada con core

**Fuente:** `pre-proyecto/Estudios/01-PHP-React-Framework-Analisis.md`

---

### 2.2 flightphp/core

**Estado:** Maduro, 2.9k stars, 794 commits, activo (v3.18.1 Abril 2026).

**Arquitectura:**
- Micro-framework sin dependencias externas
- Router basado en patrones
- Middleware pipeline configurable
- Response helpers (json, html, redirect)
- Sin ORM incluido (compatible con cualquiera)

**Stack:**
- PHP 7.4+ (soporta 8.x)
- Cero dependencias en core
- Opcional: cualquier PSR-7, ORM, template engine

**Características destacadas:**
- **Rendimiento:** 190,421 req/s (TechEmpower R18) - uno de los más rápidos
- **Cero dependencias:** Sin polyfills, sin paquetes externos, sin interfaces PSR obligatorias
- **Backwards compatible:** v3 es augmentación de v2, mínima ruptura
- **AI-focused:** Skeleton app incluye instrucciones para AI coding assistants
- **Documentación:** docs.flightphp.com completa

**Instalación:**
```bash
composer require flightphp/core
```

**Ejemplo básico:**
```php
<?php
require 'vendor/autoload.php';

Flight::route('/', function() {
  echo 'hello world!';
});

Flight::route('/json', function() {
  Flight::json(['hello' => 'world']);
});

Flight::start();
```

**Fuente:** GitHub `flightphp/core`, docs.flightphp.com

---

### 2.3 clue/framework-x

**Estado:** Beta pública, 935 stars, 512 commits, v0.17.0 (Diciembre 2024).

**Arquitectura:**
- Micro-framework reactivo basado en ReactPHP
- Soporte nativo para async/fiber (PHP 8.4+)
- PSR-7/PSR-15 compliant
- Built-in web server optimizado para async
- Streaming y Server-Sent Events nativos

**Stack:**
- PHP 7.1+ (recomendado 8.4+ para fibers)
- ReactPHP como base
- PSR-7 para mensajes HTTP

**Características destacadas:**
- **Async nativo:** Promises, fibers, coroutines soportados
- **Streaming:** Server-Sent Events, WebSockets, manejo de conexiones largas
- **Rendimiento:** Hasta millones de requests concurrentes con built-in server
- **Runs anywhere:** Funciona en shared hosting (Apache/Nginx) o standalone
- **Tests:** 100% code coverage, PHPStan max level

**Instalación:**
```bash
composer require clue/framework-x:^0.17
```

**Ejemplo básico:**
```php
<?php
require __DIR__ . '/../vendor/autoload.php';

$app = new FrameworkX\App();

$app->get('/', function () {
    return React\Http\Message\Response::plaintext("Hello wörld!\n");
});

$app->run();
```

**Fuente:** GitHub `clue/framework-x`, framework-x.org

---

### 2.4 slimphp/Slim

**Estado:** Muy maduro, 12.3k stars, 4.5k commits, v4.15.1 (Noviembre 2025).

**Arquitectura:**
- Micro-framework PSR-compliant (PSR-7, PSR-15)
- Router con grupos y middleware
- Dependency Injection container (PHP-DI opcional)
- Error handling middleware
- Body parsing middleware

**Stack:**
- PHP 7.4+
- Requiere implementación PSR-7 (Slim-Psr7, Nyholm, Guzzle, etc.)
- Compatible con cualquier ORM, template engine

**Características destacadas:**
- **Madurez:** 10+ años de desarrollo, comunidad establecida
- **Documentación:** www.slimframework.com/docs/v4/ muy completa
- **Ecosistema:** Slim-Csrf, Slim-HttpCache, Slim-Flash, Twig view
- **Tests:** Suite completa con Coveralls, PHPUnit, PHPStan, Psalm
- **Soporte profesional:** Tidelift subscription disponible
- **Comunidad:** Slack, forum, Twitter activos

**Instalación:**
```bash
composer require slim/slim
composer require slim/psr7  # Implementación PSR-7
```

**Ejemplo básico:**
```php
<?php
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Slim\Factory\AppFactory;

require __DIR__ . '/../vendor/autoload.php';

$app = AppFactory::create();
$app->addRoutingMiddleware();
$errorMiddleware = $app->addErrorMiddleware(true, true, true);

$app->get('/hello/{name}', function (Request $request, Response $response, $args) {
    $name = $args['name'];
    $response->getBody()->write("Hello, $name");
    return $response;
});

$app->run();
```

**Fuente:** GitHub `slimphp/Slim`, slimframework.com/docs/v4/

---

### 2.5 leafsphp/leaf

**Estado:** Moderadamente maduro, 1.3k stars, 697 commits, v4.4 (Septiembre 2025).

**Arquitectura:**
- Framework modular tipo "Laravel ligero"
- Global functions para operaciones comunes
- MVC opcional (leafmvc disponible)
- Router, middleware, auth, session incluidos
- CLI propia (leaf CLI)

**Stack:**
- PHP 7.4+
- Modular (instala solo lo necesario)
- Ecosistema propio de módulos

**Características destacadas:**
- **Developer experience:** Funciones globales simplifican código
- **Modular:** Instala solo features necesarios
- **Ecosistema:** leafmvc, leaf CLI, módulos oficiales
- **Documentación:** leafphp.dev con tutoriales y codelabs
- **Comunidad:** Discord, Twitter, forum activos

**Instalación:**
```bash
composer require leafs/leaf
# O con CLI
leaf create <project-name> --basic
```

**Ejemplo básico:**
```php
<?php
require __DIR__ . '/vendor/autoload.php';

app()->get('/', function () {
  response()->json([
    'message' => 'Hello World!'
  ]);
});

app()->run();
```

**Fuente:** GitHub `leafsphp/leaf`, leafphp.dev (no accesible al momento de consulta)

---

## 3. Tabla Comparativa Principal

### 3.1 Características Generales

| Característica | PHP-React-Framework | flightphp/core | clue/framework-x | slimphp/Slim | leafsphp/leaf |
|----------------|---------------------|----------------|------------------|--------------|---------------|
| **Stars GitHub** | 2 | 2.9k | 935 | 12.3k | 1.3k |
| **Commits** | 5 | 794 | 512 | 4.5k | 697 |
| **Última versión** | N/A | v3.18.1 (Abr 2026) | v0.17.0 (Dic 2024) | v4.15.1 (Nov 2025) | v4.4 (Sep 2025) |
| **PHP mínimo** | 8.1+ | 7.4+ | 7.1+ (8.4+ recomendado) | 7.4+ | 7.4+ |
| **Licencia** | MIT | MIT | MIT | MIT | MIT |
| **Dependencias core** | illuminate/database, guzzle | **Cero** | ReactPHP | PSR-7 impl. | Modular |
| **ORM incluido** | Eloquent | No | No | No | Opcional (leafmvc) |
| **Frontend incluido** | React + TS + Vite | No | No | No | Opcional |
| **Tests** | ❌ No | ✅ Sí | ✅ 100% coverage | ✅ Sí | ✅ Sí |
| **Documentación** | README | docs.flightphp.com | framework-x.org | slimframework.com/docs | leafphp.dev |

### 3.2 Arquitectura y Patrones

| Característica | PHP-React-Framework | flightphp/core | clue/framework-x | slimphp/Slim | leafsphp/leaf |
|----------------|---------------------|----------------|------------------|--------------|---------------|
| **Patrón entrada** | Front controller | Front controller | Front controller | Front controller | Front controller |
| **Enrutamiento** | Regex personalizado | Patrones simples | PSR-15 middleware | PSR-15 compliant | Propio + grupos |
| **Middleware** | ✅ Pipeline | ✅ Limitado | ✅ PSR-15 | ✅ PSR-15 completo | ✅ Completo |
| **DI Container** | ✅ Reflexión propia | ❌ No | ❌ No | ✅ PHP-DI opcional | ✅ Incluido |
| **Request/Response** | Inmutable propio | Helper functions | PSR-7 | PSR-7 | PSR-7 + helpers |
| **Validación** | 5 reglas propias | ❌ No incluida | ❌ No incluida | ❌ No incluida | ✅ Incluida |
| **Auth incluida** | API key | ❌ No | ❌ No | ❌ No | ✅ leaf auth |

### 3.3 Rendimiento y Escalabilidad

| Característica | PHP-React-Framework | flightphp/core | clue/framework-x | slimphp/Slim | leafsphp/leaf |
|----------------|---------------------|----------------|------------------|--------------|---------------|
| **Benchmark req/s** | No disponible | **190,421** | No disponible | 89,588 | No disponible |
| **Soporte async** | ❌ No | ❌ No | ✅ Nativo (fibers) | ⚠️ Vía middleware | ⚠️ Limitado |
| **Streaming** | ❌ No | ❌ No | ✅ SSE, WebSocket | ⚠️ Vía middleware | ⚠️ Limitado |
| **Built-in server** | PHP standard | PHP standard | ✅ Optimizado async | PHP standard | leaf CLI |
| **Escalabilidad** | Moderada | Alta (ligero) | **Muy alta** (async) | Alta (maduro) | Moderada |
| **Shared hosting** | ✅ Sí | ✅ Sí | ✅ Sí | ✅ Sí | ✅ Sí |

### 3.4 Comunidad y Soporte

| Característica | PHP-React-Framework | flightphp/core | clue/framework-x | slimphp/Slim | leafsphp/leaf |
|----------------|---------------------|----------------|------------------|--------------|---------------|
| **Contribuidores** | 1 | Múltiples | Múltiples | **Equipo establecido** | Múltiples |
| **Issues abiertos** | N/A | 3 | 1 | 10 | 10 |
| **Pull requests** | N/A | 2 | 2 | 4 | 0 |
| **Comunidad** | ❌ No existe | Matrix, Discord | Twitter, GitHub | **Slack, Forum** | Discord, Twitter |
| **Soporte profesional** | ❌ No | ❌ No | ✅ clue.engineering | ✅ Tidelift | ❌ No |
| **Paquetes ecosystema** | 0 | Limitados | ReactPHP ecosystem | **Muchos add-ons** | Módulos leaf |

### 3.5 Seguridad y Calidad de Código

| Característica | PHP-React-Framework | flightphp/core | clue/framework-x | slimphp/Slim | leafsphp/leaf |
|----------------|---------------------|----------------|------------------|--------------|---------------|
| **PHPStan** | ❌ No configurado | ✅ Level 6 | ✅ Max level | ✅ Configurado | ✅ Configurado |
| **Tests unitarios** | ❌ No | ✅ PHPUnit | ✅ PHPUnit 100% | ✅ PHPUnit + Coveralls | ✅ PHPUnit |
| **Security policy** | ❌ No | ✅ SECURITY.md | ✅ GitHub Security | ✅ security@slimframework.com | ✅ GitHub Security |
| **Code of Conduct** | ❌ No | ❌ No | ❌ No | ✅ CODE_OF_CONDUCT.md | ✅ CODE_OF_CONDUCT.md |
| **Contributing guide** | ❌ No | ✅ CONTRIBUTING.md | En README | ✅ CONTRIBUTING.md | ✅ Contributing guide |
| **Changelog** | ❌ No | ✅ Releases | ✅ CHANGELOG.md | ✅ CHANGELOG.md | ✅ Releases |

---

## 4. Comparativa Frente a las Necesidades del Proyecto

### 4.1 Requisitos del Proyecto (según Boceto_B09.md)

**Requisitos funcionales críticos:**
1. Autenticación validada contra WordPress (cookies, `credentials: "include"`)
2. Roles de usuario (Admin WP = Admin WA, Usuario > suscriptor = Usuario WA)
3. Proceso de PDF (subida, extracción, IA, revisión, aprobación)
4. Gestión de archivos (subcarpetas en `DIR_ALMACEN_PDF`)
5. Integración WordPress (guardar texto en tabla personalizada, imágenes en media library)
6. Integración WooCommerce (API para crear/publicar productos)
7. Configuración de IA (CRUD de proveedores, APIs, límites)
8. Trazabilidad (log completo del proceso)

**Requisitos técnicos:**
- PHP framework desde cero
- Mismo servidor que WordPress
- Validación de cookies contra WordPress
- Nonces/CSRF para acciones modificadoras
- Múltiples APIs externas (IA, WooCommerce)
- Gestión de archivos con conservación selectiva

### 4.2 Encaje por Requisito Crítico

#### 4.2.1 Autenticación WordPress (Cookies)

| Framework | Encaje | Adaptación necesaria | Complejidad |
|-----------|--------|---------------------|-------------|
| **PHP-React-Framework** | ⚠️ Requiere cambio mayor | Reemplazar ApiKeyAuthMiddleware con WordPressAuthMiddleware | Alta |
| **flightphp/core** | ✅ Flexible | Crear middleware personalizado para validación WP | Media |
| **clue/framework-x** | ✅ Flexible | Middleware PSR-15 para validación WP | Media |
| **slimphp/Slim** | ✅ **Óptimo** | Middleware PSR-15 bien documentado, ejemplos disponibles | Media-Baja |
| **leafsphp/leaf** | ✅ Flexible | leaf auth + middleware personalizado | Media |

**Recomendación:** Slim y Flight ofrecen la mejor flexibilidad para middleware personalizado. Slim tiene más documentación y ejemplos de autenticación custom.

---

#### 4.2.2 Gestión de Archivos (PDFs, Imágenes)

| Framework | Encaje | Características relevantes | Complejidad |
|-----------|--------|---------------------------|-------------|
| **PHP-React-Framework** | ⚠️ No implementado | Sin gestión de archivos en demo | Media-Alta |
| **flightphp/core** | ✅ Flexible | Sin restricción, implementar desde cero | Media |
| **clue/framework-x** | ✅ Flexible | Soporte streaming para uploads grandes | Media |
| **slimphp/Slim** | ✅ **Óptimo** | Cookbook: "Uploading Files using POST forms" | Baja |
| **leafsphp/leaf** | ✅ Flexible | Funciones helper para files | Media |

**Recomendación:** Slim tiene documentación específica para uploads. Framework-X ofrece ventaja si hay necesidad de streaming para PDFs grandes.

---

#### 4.2.3 Integración APIs Externas (IA, WooCommerce)

| Framework | Encaje | Cliente HTTP | Manejo de errores | Complejidad |
|-----------|--------|--------------|-------------------|-------------|
| **PHP-React-Framework** | ✅ Guzzle incluido | Guzzle ^7.0 | Excepciones HTTP | Baja |
| **flightphp/core** | ✅ Flexible | Implementar Guzzle | Manual | Media |
| **clue/framework-x** | ✅ **Óptimo async** | ReactHTTP async | Promises, async | Media (curva async) |
| **slimphp/Slim** | ✅ Flexible | Implementar Guzzle | Middleware error handling | Baja |
| **leafsphp/leaf** | ✅ Flexible | Implementar Guzzle | Manual | Media |

**Recomendación:** Si las llamadas a IA son largas o múltiples, Framework-X async ofrece ventaja real. Para llamadas secuenciales simples, Slim/Flight son suficientes.

---

#### 4.2.4 Persistencia de Datos (Tabla WordPress)

| Framework | Encaje | ORM | Migraciones | Complejidad |
|-----------|--------|-----|-------------|-------------|
| **PHP-React-Framework** | ✅ **Eloquent incluido** | Eloquent ^10.0 | Scripts PHP | Baja |
| **flightphp/core** | ⚠️ Implementar | Cualquier ORM | Manual | Media |
| **clue/framework-x** | ⚠️ Implementar | Cualquier ORM (async preferible) | Manual | Media |
| **slimphp/Slim** | ⚠️ Implementar | Cualquier ORM (Eloquent, Doctrine) | Manual | Media |
| **leafsphp/leaf** | ✅ leafmvc opcional | ORM incluido en leafmvc | leaf CLI | Baja-Media |

**Recomendación:** PHP-React-Framework tiene ventaja por Eloquent incluido, pero Slim + Eloquent es igual de efectivo con mejor soporte.

---

#### 4.2.5 Sistema de Log y Trazabilidad

| Framework | Encaje | Logging incluido | Rotación | Personalización |
|-----------|--------|-----------------|----------|-----------------|
| **PHP-React-Framework** | ⚠️ Básico | error_log vía RequestLoggingMiddleware | ❌ No | Media |
| **flightphp/core** | ⚠️ Implementar | ❌ No | Manual | Alta |
| **clue/framework-x** | ⚚️ Implementar | ❌ No | Manual | Alta |
| **slimphp/Slim** | ✅ **Óptimo** | Error middleware configurable, Monolog compatible | Vía Monolog | Alta |
| **leafsphp/leaf** | ⚠️ Implementar | Básico | Manual | Media |

**Recomendación:** Slim tiene error middleware robusto y documentación para Monolog. Mejor opción para logging estructurado.

---

#### 4.2.6 Frontend React (si se requiere)

| Framework | Encaje | Frontend incluido | Build tool | Complejidad |
|-----------|--------|-------------------|------------|-------------|
| **PHP-React-Framework** | ✅ **Incluido** | React 19 + TS + Vite 7 + Tailwind 4 | Vite | Baja |
| **flightphp/core** | ⚠️ Implementar | ❌ No | Elegir | Media |
| **clue/framework-x** | ⚠️ Implementar | ❌ No | Elegir | Media |
| **slimphp/Slim** | ⚠️ Implementar | ❌ No (Twig view disponible) | Elegir | Media |
| **leafsphp/leaf** | ⚠️ Implementar | ❌ No | Elegir | Media |

**Nota:** El proyecto B09.md no especifica frontend React como requisito. PHP-React-Framework lo incluye pero añade complejidad innecesaria si no se requiere.

---

### 4.3 Puntuación por Categoría (Escala 1-5)

| Categoría | PHP-React | Flight | Framework-X | Slim | Leaf |
|-----------|-----------|--------|-------------|------|------|
| **Autenticación WordPress** | 2 | 4 | 4 | **5** | 4 |
| **Gestión de archivos** | 2 | 4 | 4 | **5** | 4 |
| **APIs externas** | 4 | 4 | **5** | 4 | 4 |
| **Persistencia (ORM)** | **5** | 3 | 3 | 4 | 4 |
| **Logging/Trazabilidad** | 2 | 3 | 3 | **5** | 3 |
| **Frontend React** | **5** | 2 | 2 | 3 | 2 |
| **Documentación** | 2 | 4 | 3 | **5** | 3 |
| **Tests/Calidad** | 1 | 4 | **5** | **5** | 4 |
| **Comunidad/Soporte** | 1 | 3 | 3 | **5** | 3 |
| **Madurez** | 1 | 4 | 3 | **5** | 3 |
| **TOTAL** | **25/50** | **36/50** | **37/50** | **46/50** | **34/50** |

---

## 5. Riesgos y Limitaciones

### 5.1 Riesgos por Framework

#### PHP-React-Framework

| Riesgo | Probabilidad | Impacto | Mitigación |
|--------|--------------|---------|------------|
| **Sin tests automatizados** | Alta | Crítico | Implementar PHPUnit/Pest antes de desarrollo |
| **Auth incompatible (API key vs WP cookies)** | Media | Crítico | Desarrollar WordPressAuthMiddleware personalizado |
| **Framework de 1 autor, sin comunidad** | Media | Crítico | Asumir mantenimiento interno, hacer fork |
| **Validador limitado (5 reglas)** | Alta | Alto | Extender o usar biblioteca externa (Respect/Validation) |
| **Demo mezclada con core** | Media | Bajo | Seguir guía de customización, separar código |
| **Sin documentación interna** | Alta | Medio | Documentar durante implementación |
| **Eloquent puede ser excesivo** | Baja | Bajo | Evaluar ORM más ligero si es necesario |

**Riesgo total:** **ALTO** - Requiere adaptación significativa y asunción de mantenimiento.

---

#### flightphp/core

| Riesgo | Probabilidad | Impacto | Mitigación |
|--------|--------------|---------|------------|
| **Sin ORM incluido** | Alta | Medio | Integrar Eloquent o Doctrine según necesidad |
| **Sin validación incluida** | Alta | Medio | Usar Respect/Validation o similar |
| **Middleware limitado vs Slim** | Media | Bajo | Evaluar si es suficiente para el proyecto |
| **Comunidad más pequeña que Slim** | Media | Bajo | Documentación es completa, menos ejemplos |
| **Sin frontend incluido** | Alta | Bajo | No es requisito del proyecto |

**Riesgo total:** **BAJO-MEDIO** - Framework estable, requiere integración de componentes adicionales.

---

#### clue/framework-x

| Riesgo | Probabilidad | Impacto | Mitigación |
|--------|--------------|---------|------------|
| **Versión beta (v0.17.0)** | Media | Medio | Monitorear changelog, congelar versión |
| **Curva de aprendizaje async** | Alta | Medio | Capacitación en async PHP, promises, fibers |
| **PHP 8.4+ recomendado para fibers** | Media | Bajo | Funciona en 7.1+, async opcional |
| **Comunidad más pequeña** | Media | Bajo | Soporte profesional disponible (clue.engineering) |
| **Ecosistema ReactPHP menos conocido** | Media | Bajo | Documentación buena, ejemplos disponibles |
| **Posible over-engineering** | Media | Bajo | Evaluar si async es realmente necesario |

**Riesgo total:** **MEDIO** - Tecnología excelente pero puede ser excesiva para el proyecto.

---

#### slimphp/Slim

| Riesgo | Probabilidad | Impacto | Mitigación |
|--------|--------------|---------|------------|
| **Requiere PSR-7 implementation** | Baja | Mínimo | Documentado, múltiples opciones disponibles |
| **Más dependencias que Flight** | Media | Mínimo | Composer gestiona automáticamente |
| **Posible overhead vs micro-frameworks** | Baja | Mínimo | Benchmark muestra rendimiento adecuado |
| **Configuración inicial más compleja** | Media | Mínimo | Skeleton app disponible, documentación clara |

**Riesgo total:** **BAJO** - Framework maduro, bien mantenido, comunidad establecida.

---

#### leafsphp/leaf

| Riesgo | Probabilidad | Impacto | Mitigación |
|--------|--------------|---------|------------|
| **Documentación no accesible** | Alta | Medio | leafphp.dev no accesible al momento de consulta |
| **Ecosistema propio (lock-in potencial)** | Media | Medio | Evaluar compatibilidad con estándares PSR |
| **Comunidad más pequeña que Slim** | Media | Bajo | Discord y Twitter activos |
| **Menos maduro que Slim** | Media | Bajo | 697 commits vs 4.5k de Slim |
| **Funciones globales (testing más difícil)** | Media | Bajo | Patrones de testing disponibles |

**Riesgo total:** **MEDIO** - Buen framework pero menos verificado que Slim.

---

### 5.2 Limitaciones Identificadas vs Requisitos del Proyecto

| Requisito | PHP-React | Flight | Framework-X | Slim | Leaf |
|-----------|-----------|--------|-------------|------|------|
| Auth WordPress cookies | ⚠️ Requiere cambio mayor | ✅ Implementable | ✅ Implementable | ✅ **Mejor soporte** | ✅ Implementable |
| Gestión de subcarpetas PDF | ⚠️ Desde cero | ✅ Desde cero | ✅ Desde cero | ✅ **Cookbook disponible** | ✅ Desde cero |
| Múltiples APIs IA | ✅ Guzzle incluido | ✅ Implementar | ✅ **Async nativo** | ✅ Implementar | ✅ Implementar |
| Tabla personalizada WP | ✅ **Eloquent incluido** | ⚠️ ORM externo | ⚠️ ORM externo | ⚠️ ORM externo | ✅ leafmvc |
| Log completo trazabilidad | ⚠️ Básico | ⚠️ Implementar | ⚠️ Implementar | ✅ **Error middleware** | ⚠️ Implementar |
| CSRF/Nonces | ⚠️ Implementar | ⚠️ Implementar | ⚠️ Implementar | ✅ **Slim-Csrf disponible** | ⚠️ Implementar |
| React frontend | ✅ **Incluido** | ⚠️ Implementar | ⚠️ Implementar | ⚠️ Implementar | ⚠️ Implementar |

---

### 5.3 Consideración de Plazo (18 mayo 2026)

| Framework | Tiempo setup | Curva aprendizaje | Desarrollo funcional | Total estimado | ¿Compatible con plazo? |
|-----------|--------------|-------------------|---------------------|----------------|----------------------|
| **PHP-React-Framework** | 1 semana (adaptar auth) | 1 semana | 8-10 semanas | **10-12 semanas** | ✅ Sí (con reservas) |
| **flightphp/core** | 3 días | 3-5 días | 8-10 semanas | **9-11 semanas** | ✅ Sí |
| **clue/framework-x** | 1 semana (async) | 2-3 semanas (async) | 8-10 semanas | **11-14 semanas** | ⚠️ Ajustado |
| **slimphp/Slim** | 3-5 días | 1 semana | 8-10 semanas | **9-11 semanas** | ✅ Sí |
| **leafsphp/leaf** | 3-5 días | 1 semana | 8-10 semanas | **9-11 semanas** | ✅ Sí |

**Nota:** Todos los frameworks son compatibles con el plazo, pero Framework-X requiere curva de aprendizaje async que puede extender el timeline.

---

## 6. Recomendación Final Justificada

### 6.1 Evaluación Consolidada

| Criterio | Peso | PHP-React | Flight | Framework-X | Slim | Leaf |
|----------|------|-----------|--------|-------------|------|------|
| **Madurez y comunidad** | 15% | 1/5 | 4/5 | 3/5 | **5/5** | 3/5 |
| **Documentación** | 15% | 2/5 | 4/5 | 3/5 | **5/5** | 3/5 |
| **Encaje requisitos** | 25% | 3/5 | 4/5 | 4/5 | **5/5** | 4/5 |
| **Rendimiento** | 10% | 3/5 | **5/5** | 4/5 | 4/5 | 3/5 |
| **Facilidad desarrollo** | 15% | 3/5 | 4/5 | 3/5 | **5/5** | 4/5 |
| **Riesgo total** | 20% | 2/5 | 4/5 | 3/5 | **5/5** | 3/5 |
| **Ponderado** | 100% | **2.2/5** | **4.1/5** | **3.4/5** | **4.9/5** | **3.5/5** |

### 6.2 Recomendación Principal: **Slim PHP**

**Puntuación: 4.9/5**

**Razones para adoptar Slim:**

1. **Madurez comprobada:** 12.3k stars, 4.5k commits, 10+ años de desarrollo
2. **Documentación excepcional:** slimframework.com/docs/v4/ completa y actualizada
3. **Comunidad establecida:** Slack, forum, Twitter activos, soporte profesional Tidelift
4. **PSR-compliant:** PSR-7, PSR-15 facilitan integración con cualquier componente
5. **Ecosistema rico:** Slim-Csrf, Slim-HttpCache, Slim-Flash, Twig view
6. **Tests y calidad:** PHPUnit, Coveralls, PHPStan, Psalm configurados
7. **Flexibilidad para WordPress:** Middleware personalizado bien documentado
8. **Cookbook específico:** "Uploading Files", "Enabling CORS", etc.
9. **Riesgo bajo:** Framework estable, mantenimiento activo, roadmap claro
10. **Plazo compatible:** 9-11 semanas estimadas, compatible con 18 mayo 2026

**Componentes recomendados para el proyecto:**
```bash
composer require slim/slim
composer require slim/psr7
composer require slim/csrf  # Para nonces/CSRF
composer require slim/http  # Decoradores HTTP
composer require illuminate/database  # Eloquent ORM
composer require guzzlehttp/guzzle  # Cliente HTTP para IA/WooCommerce
composer require monolog/monolog  # Logging estructurado
```

**Estructura de middleware recomendada:**
```php
$app = AppFactory::create();
$app->addRoutingMiddleware();
$app->add(new WordPressAuthMiddleware());  // Personalizado para WP cookies
$app->add(new CsrfMiddleware());  # Slim-Csrf para nonces
$errorMiddleware = $app->addErrorMiddleware(true, true, true);
```

---

### 6.3 Alternativa Recomendada: **Flight PHP**

**Puntuación: 4.1/5**

**Razones para considerar Flight:**

1. **Rendimiento superior:** 190k req/s en benchmarks TechEmpower
2. **Cero dependencias:** Core sin dependencias externas, menor attack surface
3. **Simplicidad:** Curva de aprendizaje más baja que Slim
4. **Backwards compatible:** v3 es augmentación de v2, mínima ruptura
5. **Documentación completa:** docs.flightphp.com bien estructurada
6. **AI-focused:** Skeleton app incluye instrucciones para AI coding assistants
7. **PHP 7.4+:** Compatible con versiones antiguas si es necesario

**Cuándo elegir Flight sobre Slim:**
- Si se prioriza **máximo rendimiento** y **mínimo footprint**
- Si se prefiere **cero dependencias** en core
- Si el equipo valora **simplicidad sobre features**
- Si no se necesita el ecosistema de add-ons de Slim

**Componentes recomendados:**
```bash
composer require flightphp/core
composer require illuminate/database  # Eloquent ORM
composer require guzzlehttp/guzzle  # Cliente HTTP
composer require monolog/monolog  # Logging
composer require respect/validation  # Validación
```

---

### 6.4 Cuándo Considerar Framework-X

**Puntuación: 3.4/5**

**Framework-X es recomendable si:**

1. Las llamadas a APIs de IA son **múltiples y concurrentes**
2. Se requiere **streaming en tiempo real** (SSE, WebSockets)
3. El proceso de PDF/IA puede beneficiarse de **async nativo**
4. El equipo tiene experiencia con **programación reactiva/async**
5. Se busca **máxima escalabilidad** de conexiones concurrentes

**No recomendado si:**
- El equipo no tiene experiencia con async PHP
- El plazo es ajustado (curva de aprendizaje de 2-3 semanas)
- Las llamadas a IA son secuenciales y no bloqueantes
- Se prioriza simplicidad sobre features avanzadas

---

### 6.5 Cuándo Considerar PHP-React-Framework

**Puntuación: 2.2/5**

**PHP-React-Framework solo es recomendable si:**

1. Se **requiere React + TypeScript + Vite** frontend incluido
2. Se valora tener **Eloquent ORM preconfigurado**
3. El equipo está dispuesto a **asumir mantenimiento del framework**
4. Se acepta implementar **tests desde cero**
5. Se tiene capacidad para **adaptar autenticación WordPress**

**No recomendado si:**
- Se prioriza **estabilidad y madurez**
- Se necesita **comunidad y soporte**
- El plazo es ajustado
- No se quiere asumir mantenimiento de framework custom

---

### 6.6 Cuándo Considerar Leaf PHP

**Puntuación: 3.5/5**

**Leaf es recomendable si:**

1. Se valora **developer experience** con funciones globales
2. Se prefiere enfoque **modular** (instalar solo lo necesario)
3. Se quiere **leafmvc** para estructura MVC completa
4. La documentación leafphp.dev es accesible y completa

**No recomendado si:**
- Se prioriza **madurez sobre features**
- Se necesita **comunidad grande y establecida**
- Se prefieren **estándares PSR estrictos**

---

## 7. Conclusión Operativa

### 7.1 Decisión Recomendada

**Adoptar Slim PHP como framework base para la Web-App del proyecto.**

**Justificación operativa:**

| Factor | Slim PHP |
|--------|----------|
| **Riesgo técnico** | Bajo - Framework maduro y probado |
| **Riesgo de mantenimiento** | Bajo - Comunidad activa, 10+ años |
| **Curva de aprendizaje** | Media - Documentación completa facilita onboarding |
| **Tiempo de desarrollo** | 9-11 semanas - Compatible con plazo 18 mayo 2026 |
| **Flexibilidad WordPress** | Alta - Middleware PSR-15 bien documentado |
| **Escalabilidad futura** | Alta - Ecosistema permite crecimiento |
| **Coste de mantenimiento** | Bajo - Sin necesidad de mantener framework propio |

### 7.2 Plan de Implementación Recomendado

#### Fase 0: Setup del Framework (1 semana)

| Día | Tarea |
|-----|-------|
| 1-2 | Instalar Slim + dependencias, configurar estructura de proyecto |
| 3-4 | Implementar WordPressAuthMiddleware (validación de cookies) |
| 5 | Configurar Eloquent ORM para conexión a BD de WordPress |
| 6-7 | Implementar sistema de logging con Monolog |

#### Fase 1: Funcionalidades Core (8-10 semanas)

| Iteración | Funcionalidades |
|-----------|-----------------|
| 1-2 | Autenticación, gestión de usuarios, configuración WA |
| 3-4 | Subida de PDFs, creación de subcarpetas, gestión de archivos |
| 5-6 | Integración con proveedores de IA (CRUD + ejecución de prompts) |
| 7-8 | Formulario de revisión, edición, subida de imágenes |
| 9-10 | Integración WordPress (texto, media) + API WooCommerce |

#### Fase 2: Pruebas y Ajustes (2-3 semanas)

| Tarea | Duración |
|-------|----------|
| Pruebas de integración | 1 semana |
| Pruebas de rendimiento | 1 semana |
| Ajustes y optimizaciones | 1 semana |

**Total estimado: 11-14 semanas** (compatible con plazo 18 mayo 2026)

### 7.3 Archivos a Crear (Estructura Recomendada)

```
wa-woocommerce/
├── public/
│   └── index.php              # Front controller
├── src/
│   ├── Middleware/
│   │   ├── WordPressAuthMiddleware.php  # Validación cookies WP
│   │   └── CsrfMiddleware.php           # Nonces/CSRF
│   ├── Controllers/
│   │   ├── AuthController.php
│   │   ├── ProcesoController.php
│   │   ├── RevisionController.php
│   │   ├── ConfigController.php
│   │   └── AdminController.php
│   ├── Services/
│   │   ├── WordPressService.php         # Integración con WP
│   │   ├── WooCommerceService.php       # API WooCommerce
│   │   ├── IAService.php                # Ejecución de prompts IA
│   │   ├── PDFService.php               # Gestión de PDFs
│   │   └── LogService.php               # Trazabilidad
│   ├── Models/
│   │   └── TextoPDF.php                 # Modelo Eloquent para tabla WP
│   └── Support/
│       ├── Config.php
│       └── Helpers.php
├── config/
│   ├── app.php
│   ├── database.php
│   ├── wordpress.php
│   └── woocommerce.php
├── routes/
│   ├── api.php
│   └── web.php
├── logs/
├── storage/
│   └── pdfs/                # DIR_ALMACEN_PDF
├── composer.json
└── .env.example
```

### 7.4 Dependencias Críticas a Resolver

| Dependencia | Estado | Acción necesaria |
|-------------|--------|------------------|
| **Endpoint WordPress para validación** | Por crear | Crear endpoint en WP que responda 200/401 según `is_user_logged_in()` |
| **Tabla personalizada en WordPress** | Por definir | Definir schema en R04-ACLARATIVO.md |
| **Campos personalizados WooCommerce** | Pendientes | Definir mapeo IA → campos WooC |
| **Proveedor de IA** | No seleccionado | Admin debe configurar CRUD de proveedores |
| **PHP 8.1+ en servidor** | Por verificar | Confirmar versión PHP en servidor de producción |
| **Node.js en servidor** | Por verificar | Necesario solo si hay frontend React |

### 7.5 Criterios de Reevaluación

Reconsiderar la decisión si durante el desarrollo se identifica:

| Situación | Acción recomendada |
|-----------|-------------------|
| **Llamadas a IA son múltiples y concurrentes** | Evaluar migración parcial a Framework-X para servicios async |
| **Rendimiento insuficiente** | Evaluar Flight PHP como alternativa más ligera |
| **Complejidad de autenticación WordPress mayor a la esperada** | Considerar Laravel como alternativa más robusta |
| **El equipo tiene fuerte experiencia con React** | Reevaluar PHP-React-Framework si se prioriza frontend unificado |

---

## 8. Referencias y Documentación

### 8.1 Fuentes Consultadas

| Framework | Fuente | URL |
|-----------|--------|-----|
| **PHP-React-Framework** | Análisis previo | `pre-proyecto/Estudios/01-PHP-React-Framework-Analisis.md` |
| **PHP-React-Framework** | GitHub | https://github.com/mrbeandev/PHP-React-Framework |
| **flightphp/core** | GitHub | https://github.com/flightphp/core |
| **flightphp/core** | Documentación | https://docs.flightphp.com |
| **clue/framework-x** | GitHub | https://github.com/clue/framework-x |
| **clue/framework-x** | Website | https://framework-x.org |
| **slimphp/Slim** | GitHub | https://github.com/slimphp/Slim |
| **slimphp/Slim** | Documentación | https://www.slimframework.com/docs/v4/ |
| **leafsphp/leaf** | GitHub | https://github.com/leafsphp/leaf |
| **leafsphp/leaf** | Website | https://leafphp.dev (no accesible al momento de consulta) |

### 8.2 Documentación del Proyecto

| Documento | Ubicación |
|-----------|-----------|
| Boceto del proyecto (B09) | `pre-proyecto/02-Boceto_B09.md` |
| Análisis PHP-React-Framework | `pre-proyecto/Estudios/01-PHP-React-Framework-Analisis.md` |
| Workflow comparativa | `pre-proyecto/Estudios/03-Workflow-Comparativa.md` |
| Login externo WordPress | `pre-proyecto/Estudios/04-Autenticacion-WordPress-Investigacion.md` |

| Log errores tracking | `pre-proyecto/Estudios/06-Log-Errores-Investigacion.md` |
### 8.3 Context7 API

La API de Context7 se utilizó para intentar obtener documentación actualizada de los frameworks. Los resultados fueron limitados debido a que los frameworks PHP no están indexados en Context7 (orientado principalmente a JavaScript/TypeScript).

**Skill utilizado:** `.skills/context7/SKILL.md`

**Comandos ejecutados:**
```bash
curl -s -H "Authorization: Bearer $CONTEXT7_API_KEY" \
  "https://context7.com/api/v2/libs/search?libraryName=flightphp&query=PHP"
curl -s -H "Authorization: Bearer $CONTEXT7_API_KEY" \
  "https://context7.com/api/v2/libs/search?libraryName=slim&query=PHP"
curl -s -H "Authorization: Bearer $CONTEXT7_API_KEY" \
  "https://context7.com/api/v2/libs/search?libraryName=clue&query=framework-x"
curl -s -H "Authorization: Bearer $CONTEXT7_API_KEY" \
  "https://context7.com/api/v2/libs/search?libraryName=leafsphp&query=PHP"
```

**Resultado:** Sin resultados en Context7 para frameworks PHP. La información se obtuvo directamente de GitHub y documentación oficial.

---

### 8.4 Notas sobre la Información

- **Fecha de consulta:** Abril 2026
- **Versiones verificadas:** Las versiones indicadas son las más recientes al momento de la consulta
- **Documentación leafphp.dev:** No fue accesible durante la consulta; información obtenida de GitHub README
- **Benchmarks:** Los benchmarks de TechEmpower son de la ronda R18 (más reciente disponible)
- **Context7:** No indexa frameworks PHP; información verificada vía fuentes oficiales

---

*Documento generado para el proyecto flujos-meta - Abril 2026*

*Comparativa técnica basada en análisis de `01-PHP-React-Framework-Analisis.md` y documentación oficial de frameworks*
