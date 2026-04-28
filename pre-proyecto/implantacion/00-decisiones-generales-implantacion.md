# Decisiones Generales de Implantación

**Versión:** 1.0  
**Fecha:** 28 de abril de 2026  
**Estado:** Aprobado

---

## Índice de Contenido

1. [Despliegue confirmado por FTP](#1-despliegue-confirmado-por-ftp)
2. [No uso de Composer en servidor](#2-no-uso-de-composer-en-servidor)
3. [Desarrollo completo en Codespace](#3-desarrollo-completo-en-codespace)
4. [Despliegue directo de archivos por FTP](#4-despliegue-directo-de-archivos-por-ftp)
5. [No ejecución de comandos en servidor](#5-no-ejecución-de-comandos-en-servidor)
6. [Directorios WA/WP confirmados](#6-directorios-wawp-confirmados)
7. [Separación entre aplicación WA y WordPress](#7-separación-entre-aplicación-wa-y-wordpress)
8. [Rutas de despliegue: sin subdirectorios fijos](#8-rutas-de-despliegue-sin-subdirectorios-fijos)
9. [Slim como framework base del repositorio](#9-slim-como-framework-base-del-repositorio)
10. [Etapa 1: integración de Slim y despliegue FTP](#10-etapa-1-integración-de-slim-y-despliegue-ftp)
11. [Repositorio como base clonable para proyectos futuros](#11-repositorio-como-base-clonable-para-proyectos-futuros)
12. [Elementos explícitamente fuera de alcance](#12-elementos-explícitamente-fuera-de-alcance)
13. [Decisiones técnicas de framework](#13-decisiones-técnicas-de-framework)
14. [Dependencias futuras: Etapa 2](#14-dependencias-futuras-etapa-2)

---

## 1. Despliegue confirmado por FTP

### Decisión

**El método de despliegue al servidor compartido será FTP/FTPS.**

### Justificación

- El hosting compartido no proporciona acceso SSH/SFTP
- FTP es el método estándar soportado por el proveedor
- Las credenciales FTP están disponibles y configuradas
- Compatible con el flujo de trabajo en GitHub Codespaces

### Configuración confirmada

| Parámetro | Valor |
|-----------|-------|
| **Protocolo** | FTPS explícito (FTP sobre TLS) |
| **Servidor** | `ftp.bee-viva.es` |
| **Puerto** | 21 |
| **Cifrado** | TLS recomendado |

### Referencia

- `pre-proyecto/implantacion/wa-server-info-2026-04-28-101933.json`

---

## 2. No uso de Composer en servidor

### Decisión

**No se ejecutará Composer en el servidor de producción.**

### Justificación

- El hosting compartido puede no tener Composer instalado
- Evita dependencias del entorno del servidor
- Mayor control sobre versiones de dependencias
- Despliegue más predecible y reproducible

### Implicaciones

| Aspecto | Implicación |
|---------|-------------|
| **vendor/** | Se genera localmente y se sube completo |
| **composer install** | Se ejecuta solo en entorno local/Codespace |
| **composer.lock** | Se incluye en el despliegue para trazabilidad |
| **Tamaño del despliegue** | ~2-4 MB incluyendo vendor/ |

### Comando de preparación

```bash
composer install --no-dev --optimize-autoloader
```

---

## 3. Desarrollo completo en Codespace

### Decisión

**Todo el desarrollo se realizará en este GitHub Codespace/workspace.**

### Justificación

- Entorno consistente y reproducible
- Acceso a herramientas preconfiguradas
- Integración nativa con GitHub Secrets
- Facilita colaboración futura

### Configuración del entorno

| Herramienta | Versión mínima | Propósito |
|-------------|----------------|-----------|
| PHP | 8.1+ | Ejecución de Slim |
| Composer | 2.0+ | Gestión de dependencias |
| Git | 2.0+ | Control de versiones |
| Cliente FTP | Cualquiera | Despliegue al servidor |

---

## 4. Despliegue directo de archivos por FTP

### Decisión

**El despliegue se realizará copiando archivos por FTP directamente.**

### Justificación

- Método más simple para esta etapa inicial
- No requiere herramientas de CI/CD complejas
- Control total sobre qué archivos se suben
- Fácil de depurar y verificar

### Archivos a subir

| Ruta | Incluir | Justificación |
|------|---------|---------------|
| `public/index.php` | ✅ | Front controller |
| `vendor/` | ✅ | Dependencias de Slim |
| `composer.json` | ✅ | Referencia de versiones |
| `composer.lock` | ✅ | Bloqueo de versiones exactas |
| `.git/` | ❌ | No necesario en producción |
| `.env` | ❌ | No usar en esta etapa |
| `README.md` | ❌ | Documentación interna |

### Método de subida

- **Herramienta recomendada:** `lftp` con comando `mirror --reverse`
- **Alternativa:** Cliente FTP gráfico (FileZilla) o `curl`
- **Automatización:** Script `deploy.sh` en raíz del proyecto

---

## 5. No ejecución de comandos en servidor

### Decisión

**No se ejecutará ningún comando en el servidor remoto.**

### Justificación

- El hosting compartido no proporciona acceso SSH
- FTP solo permite transferencia de archivos, no ejecución
- Mantiene la seguridad del entorno compartido
- Alineado con las restricciones del proveedor

### Implicaciones

| Tarea | Enfoque alternativo |
|-------|---------------------|
| **Instalar dependencias** | Ejecutar localmente, subir vendor/ |
| **Generar autoload** | Ejecutar localmente (`composer dump-autoload`) |
| **Verificar PHP** | Crear archivo phpinfo() temporal |
| **Ver logs** | Solicitar acceso por panel de control o al equipo |

---

## 6. Directorios WA/WP confirmados

### Decisión

**Los directorios del servidor hosting compartido están confirmados.**

### Configuración confirmada

| Entorno | Directorio | Propósito |
|---------|------------|-----------|
| **WA (Web-App)** | `/home/beevivac/stg2.cofemlevante.es` | Aplicación Slim |
| **WP (WordPress)** | `/home/beevivac/levantecofem_es` | WordPress + WooCommerce |

### Cuentas FTP asociadas

| Entorno | Usuario FTP | Contraseña |
|---------|-------------|------------|
| **WA** | `ftp-wa@levantecofem.es` | `CONTRASENYA_FTP_WA` (GitHub Secret) |
| **WP** | `ftp-cfle-wp@levantecofem.es` | `CONTRASENYA_FTP_WP` (GitHub Secret) |

### Nota importante

La Web-App (WA) y WordPress están en **directorios separados** dentro del mismo hosting compartido, lo que confirma la arquitectura de **aplicación externa a WordPress** descrita en `02-Boceto_B09.md`.

---

## 7. Separación entre aplicación WA y WordPress

### Decisión

**La Web-App (WA) será una aplicación PHP independiente de WordPress.**

### Justificación

- Alineado con el Boceto B09 (sección 9: "Web-App externa a WordPress")
- Permite usar Slim PHP sin interferir con WordPress
- Facilita el despliegue independiente
- Mejor separación de responsabilidades

### Arquitectura

```
/home/beevivac/
├── stg2.cofemlevante.es/     # WA: Aplicación Slim (despliegue directo)
│   ├── public/
│   └── vendor/
│
└── levantecofem_es/          # WP: WordPress + WooCommerce
    ├── wp-content/
    ├── wp-admin/
    └── wp-includes/
```

### Comunicación WA ↔ WordPress

- **Autenticación:** Endpoint REST personalizado en WordPress (etapa 2+)
- **Base de datos:** Acceso directo a BD de WordPress cuando sea necesario
- **Archivos:** Directorios separados, sin compartición directa

---

## 8. Rutas de despliegue: sin subdirectorios fijos

### Decisión

**El despliegue se realiza directamente en `stg2.cofemlevante.es/` sin crear subdirectorios fijos como `wa-slim/`.**

### Justificación

- Los directorios pueden cambiar en cualquier momento según necesidades del hosting
- No acoplar el desarrollo a rutas absolutas o directorios fijos
- La configuración debe permitir cambiar rutas sin alterar la lógica del proyecto
- Mayor flexibilidad para futuros cambios de infraestructura

### Implicaciones

| Aspecto | Implicación |
|---------|-------------|
| **Rutas en código** | Usar rutas relativas y configurables, nunca absolutas |
| **Configuración** | Centralizar rutas en archivos de configuración editables |
| **Despliegue** | El agente desplegador debe leer rutas de configuración, no hardcodeadas |
| **Documentación** | Las rutas en documentación son orientativas, pueden variar |

### Configuración de rutas

Las rutas deben definirse en archivos de configuración externos (ej. `.env`, `config.php`) que puedan modificarse sin tocar el código:

```php
// Ejemplo: config/app.php
return [
    'base_path' => getenv('APP_BASE_PATH') ?: __DIR__ . '/..',
    'public_path' => getenv('APP_PUBLIC_PATH') ?: __DIR__ . '/../public',
];
```

---

## 9. Slim como framework base del repositorio

### Decisión

**Slim se integra como framework base real del desarrollo, no como prueba temporal.**

### Justificación

- Slim no se instala solo para una prueba "Hola mundo"
- Todo el desarrollo debe girar alrededor de Slim como framework principal
- La estructura inicial del proyecto debe prepararse ya para que Slim sea la base del repositorio
- Permite construir una arquitectura sólida y escalable desde el inicio

### Implicaciones

| Aspecto | Implicación |
|---------|-------------|
| **Estructura** | El repositorio se organiza alrededor de Slim desde Etapa 1 |
| **Dependencias** | Slim y sus componentes son dependencias core, no temporales |
| **Desarrollo** | Controllers, Services, Middleware se construyen sobre Slim |
| **Configuración** | La configuración del proyecto es configuración de Slim |

### Estructura base del repositorio

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
└── config/
    ├── app.php
    ├── database.php
    └── routes.php
```

---

## 10. Etapa 1: integración de Slim y despliegue FTP

### Decisión

**Esta etapa se define como la Etapa 1 del desarrollo general del proyecto.**

### Objetivo principal

Integrar Slim como framework base del repositorio y preparar despliegue FTP mediante el agente desplegador.

### Objetivos específicos

| Objetivo | Descripción |
|----------|-------------|
| ✅ **Integrar Slim** | Slim como framework base del repositorio, no como prueba |
| ✅ **Validar despliegue FTP** | Confirmar que el método de despliegue mediante agente funciona |
| ✅ **Prueba funcional mínima** | Endpoint que responde 200 OK con "Hola mundo" como validación de integración |
| ✅ **Documentar decisiones** | Registrar decisiones técnicas de implantación |

### La prueba "Hola mundo" como validación

La prueba "Hola mundo" **no es el objetivo final** de la etapa, sino una **validación mínima** de que:
- Slim está correctamente integrado
- El despliegue FTP funciona
- La aplicación se ejecuta en el servidor

### Entregables

1. Slim integrado como framework base en el repositorio
2. Agente desplegador FTP configurado y operativo
3. Endpoint público accesible respondiendo "Hola mundo" (validación)
4. Documentación de decisiones de implantación

---

## 11. Repositorio como base clonable para proyectos futuros

### Decisión

**El repositorio debe servir como base o andamio clonable para otros proyectos futuros.**

### Justificación

- Objetivo secundario del proyecto: crear plantilla reutilizable
- Otros proyectos podrán clonar y adaptar esta estructura
- Reduce tiempo de arranque de futuros desarrollos
- Establece estándares de arquitectura para el equipo

### Implicaciones de diseño

| Principio | Aplicación |
|-----------|------------|
| **Reutilizable** | Componentes diseñados para ser genéricos, no específicos de este proyecto |
| **Configurable** | Rutas, credenciales, opciones en archivos de configuración externos |
| **No acoplado** | Sin dependencias a rutas concretas del hosting actual |
| **Documentado** | Instrucciones claras para clonar y adaptar a nuevos proyectos |

### Consideraciones para futuros proyectos

- La integración de Slim debe diseñarse de forma reutilizable
- Las configuraciones deben poder adaptarse a otros entornos
- El agente desplegador debe poder configurarse para otros servidores
- La estructura debe ser lo suficientemente genérica para distintos casos de uso

---

## 12. Elementos explícitamente fuera de alcance

### Esta etapa NO incluye:

| Elemento | Etapa estimada | Justificación |
|----------|----------------|---------------|
| ❌ Autenticación contra WordPress | Etapa 2 | Requiere endpoint WP y middleware |
| ❌ Logging estructurado (Monolog) | Etapa 2 | Requiere configuración adicional |
| ❌ Eloquent ORM (acceso a BD) | Etapa 2 | Requiere illuminate/database |
| ❌ Cliente HTTP (Guzzle) | Etapa 2 | Requiere guzzlehttp/guzzle |
| ❌ Protección CSRF | Etapa 2 | Requiere slim/csrf |
| ❌ Subida de PDFs | Etapa 3 | Requiere formularios y gestión de archivos |
| ❌ Endpoint WordPress de validación | Etapa 2 | Requiere plugin en WordPress |
| ❌ Tabla personalizada en WordPress | Etapa 3 | Requiere definición de schema |
| ❌ Mapeo de campos WooCommerce | Etapa 4 | Requiere análisis de campos existentes |
| ❌ Selección de proveedor de IA | Etapa 3 | Requiere CRUD de proveedores |
| ❌ Definición de `DIR_ALMACEN_PDF` | Etapa 3 | Requiere decisión de ubicación |
| ❌ Integración con API WooCommerce | Etapa 4 | Requiere autenticación y mapeo |
| ❌ Formulario de revisión | Etapa 3 | Requiere frontend y lógica de negocio |
| ❌ Extracción de texto de PDF | Etapa 3 | Requiere librería o servicio de IA |

### Criterio de exclusión

Cualquier funcionalidad que no sea estrictamente necesaria para integrar Slim como framework base y validar el despliegue queda fuera de esta etapa y se pospone para etapas siguientes.

---

## 13. Decisiones técnicas de framework

### 13.1 Framework seleccionado

**Slim PHP 4.x**

### Justificación (de `02-Comparativa-Frameworks-PHP.md`)

| Criterio | Puntuación |
|----------|------------|
| Madurez y comunidad | 5/5 (12.3k stars, 4.5k commits) |
| Documentación | 5/5 (slimframework.com/docs/v4/) |
| Encaje requisitos | 5/5 (middleware PSR-15 flexible) |
| Tests/Calidad | 5/5 (PHPUnit, Coveralls, PHPStan) |
| **Total ponderado** | **4.9/5** |

### Dependencias mínimas

```json
{
    "require": {
        "php": ">=8.1",
        "slim/slim": "^4.15",
        "slim/psr7": "^1.7"
    }
}
```

### Dependencias futuras (etapas siguientes)

| Dependencia | Propósito | Etapa |
|-------------|-----------|-------|
| `monolog/monolog` | Logging estructurado | 2 |
| `illuminate/database` | Eloquent ORM (acceso a BD WP) | 2 |
| `guzzlehttp/guzzle` | Cliente HTTP (llamadas a APIs) | 2 |
| `slim/csrf` | Protección CSRF/Nonces | 2 |

---

## 14. Dependencias futuras: Etapa 2

### Dependencias explícitas para Etapa 2

La Etapa 2 incluirá las siguientes dependencias como parte de la consolidación del framework:

| Dependencia | Propósito | Justificación |
|-------------|-----------|---------------|
| `monolog/monolog` | Logging estructurado | Permite trazabilidad de errores y eventos del sistema |
| `illuminate/database` | Eloquent ORM para acceso a BD WordPress | Facilita consultas a base de datos WordPress de forma segura y mantenible |
| `guzzlehttp/guzzle` | Cliente HTTP para llamadas a APIs | Necesario para comunicación con APIs externas y endpoints de WordPress |
| `slim/csrf` | Protección CSRF/Nonces | Seguridad en formularios y peticiones POST/PUT/DELETE |

### Criterios de inclusión

Estas dependencias se incluirán en Etapa 2 cuando:
- Slim esté completamente integrado y operativo
- El despliegue FTP esté validado
- Exista necesidad real de logging, acceso a BD o llamadas HTTP

### Nota sobre dependencias

Las dependencias de Etapa 2 están **explícitamente excluidas de Etapa 1** para mantener el alcance mínimo de validación inicial. Su inclusión prematura añadiría complejidad innecesaria.

---

## 15. Datos del servidor

### 15.1 Información verificada (wa-server-info-2026-04-28-101933.json)

| Parámetro | Valor |
|-----------|-------|
| **PHP versión** | 8.3.30 |
| **PHP SAPI** | litespeed |
| **Sistema operativo** | Linux 5.14.0-611.45.1.el9_7.x86_64 |
| **Servidor web** | LiteSpeed |
| **Memoria límite** | 256M |
| **Tiempo máximo ejecución** | 30 segundos |
| **Upload max filesize** | 32M |
| **Post max size** | 128M |

### 15.2 Extensiones PHP disponibles (relevantes)

✅ mysqli, pdo_mysql, curl, gd, zip, json, dom, fileinfo, mbstring, xml

### 15.3 WordPress instalado (wp-Información de salud del sitio.txt)

| Parámetro | Valor |
|-----------|-------|
| **Versión WP** | 6.9.4 |
| **Versión WooCommerce** | 10.4.4 |
| **Ruta WordPress** | `/home/beevivac/levantecofem_es` |
| **Base de datos** | MariaDB 11.4.10 |
| **PHP versión** | 8.3.30 |

---

## 16. Referencias

### Documentos de este proyecto

| Documento | Ruta |
|-----------|------|
| Plan de Implantación (Etapa 1) | `pre-proyecto/implantacion/Etapa01_Slim-Despliegue-FTP.md` |
| Comparativa de Frameworks | `pre-proyecto/Estudios/02-Comparativa-Frameworks-PHP.md` |
| Análisis Técnico de Decisiones | `pre-proyecto/Estudios/08-Analisis-Tecnico-Decisiones-Framework.md` |
| Información del servidor WA | `pre-proyecto/implantacion/wa-server-info-2026-04-28-101933.json` |
| Información de salud WP | `pre-proyecto/implantacion/wp-Información de salud del sitio.txt` |
| Boceto del proyecto | `pre-proyecto/02-Boceto_B09.md` |

### Documentación externa

| Recurso | URL |
|---------|-----|
| Slim Framework Documentation | https://www.slimframework.com/docs/v4/ |
| Slim GitHub Repository | https://github.com/slimphp/Slim |
| Composer Documentation | https://getcomposer.org/doc/ |

---

## 17. Historial de cambios

| Versión | Fecha | Cambio | Autor |
|---------|-------|--------|-------|
| 1.0 | 28 abr 2026 | Creación del documento | Equipo de desarrollo |

---

*Documento generado el 28 de abril de 2026*  
*Pre-proyecto — Web-App de Automatización WooCommerce*
