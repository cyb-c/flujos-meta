# Diagnóstico de Revisión — Implantación

**Versión:** 1.0  
**Fecha:** 28 de abril de 2026  
**Propósito:** Documento de diagnóstico obligatorio para la Parte 3. Identifica redundancias, contradicciones, datos duplicados respecto al inventario, y candidatos a consolidación en `pre-proyecto/implantacion/`.

---

## Índice Interno

1. [Resumen Ejecutivo](#1-resumen-ejecutivo)
2. [Archivos Analizados](#2-archivos-analizados)
3. [Redundancias entre Documentos de Implantación](#3-redundancias-entre-documentos-de-implantación)
4. [Contradicciones e Inconsistencias Internas](#4-contradicciones-e-inconsistencias-internas)
5. [Datos Duplicados respecto a `inventario_recursos.md`](#5-datos-duplicados-respecto-a-inventario_recursosmd)
6. [Datos de Configuración que Deberían Estar en el Inventario](#6-datos-de-configuración-que-deberían-estar-en-el-inventario)
7. [Archivos Solapados, Obsoletos o Candidatos a Consolidación](#7-archivos-solapados-obsoletos-o-candidatos-a-consolidación)
8. [Información que Debería Referenciar al Inventario](#8-información-que-debería-referenciar-al-inventario)
9. [Errores de Referencias Cruzadas](#9-errores-de-referencias-cruzadas)
10. [Recomendaciones para la Parte 3](#10-recomendaciones-para-la-parte-3)

---

## 1. Resumen Ejecutivo

El directorio `pre-proyecto/implantacion/` contiene **6 elementos activos** (3 documentos v2.0, 2 archivos informativos, 1 subdirectorio `legado/` con 8 documentos v1.0 obsoletos). Los documentos activos son consolidaciones correctas pero presentan:

- **10+ redundancias** entre los 3 documentos activos
- **3 contradicciones** en configuración de `.env`, variables de entorno y rutas de skill
- **El inventario de recursos (`inventario_recursos.md`) está completamente vacío** (todos los campos en 🔲), mientras que los documentos de implantación contienen todos los valores de configuración reales del proyecto
- **8 documentos legacy** en `legado/` que deberían archivarse o eliminarse
- **1 referencia a ruta inexistente** (`.skills/context7/SKILL.md`)

**Conclusión:** La documentación de implantación está bien estructurada pero contiene mucha información operativa duplicada que infringe GOV-R2 (cero hardcoding) y GOV-R14 (inventario actualizado).

---

## 2. Archivos Analizados

### Activos

| # | Archivo | Versión | Estado | Tipo |
|---|---------|---------|--------|------|
| 1 | `00-INDICE-Implantacion.md` | 2.0 | ✅ Activo | Decisiones + índice |
| 2 | `10-Plan-Etapa01-Slim-FTP.md` | 2.0 | ✅ Activo | Plan de trabajo |
| 3 | `20-Operaciones-Etapa01-Slim-FTP.md` | 2.0 | ✅ Activo | Procedimientos operativos |
| 4 | `wa-server-info-2026-04-28-101933.json` | — | ℹ️ Referencia | Datos técnicos servidor |
| 5 | `wp-Información de salud del sitio.txt` | — | ℹ️ Referencia | Salud WordPress |

### Legado (obsoletos, en `legado/`)

| # | Archivo | Versión | Estado |
|---|---------|---------|--------|
| 6 | `legado/Etapa01_Slim-Despliegue-FTP.md` | — | 🔄 Sustituido |
| 7 | `legado/00-decisiones-generales-implantacion.md` | 1.0 | 🔄 Sustituido |
| 8 | `legado/10-Decisiones-Etapa01-Slim-FTP.md` | 1.0 | 🔄 Sustituido |
| 9 | `legado/20-Alcance-Etapa01-Slim-FTP.md` | 1.0 | 🔄 Sustituido |
| 10 | `legado/30-Plan-Etapa01-Slim-FTP.md` | 1.0 | 🔄 Sustituido |
| 11 | `legado/40-Despliegue-Etapa01-Slim-FTP.md` | 1.0 | 🔄 Sustituido |
| 12 | `legado/50-Verificacion-Etapa01-Slim-FTP.md` | 1.0 | 🔄 Sustituido |
| 13 | `legado/60-Pendientes-Etapa01-Slim-FTP.md` | 1.0 | 🔄 Sustituido |

---

## 3. Redundancias entre Documentos de Implantación

### 3.1. Datos del servidor FTP (triplicado)

El bloque `ftp.bee-viva.es:21 / usuario ftp-wa@levantecofem.es` aparece en:

| Documento | Sección |
|-----------|---------|
| `00-INDICE-Implantacion.md` | §3 — Despliegue confirmado por FTP |
| `10-Plan-Etapa01-Slim-FTP.md` | §7 Fase 0 (tarea 0.2), §7 Fase 1 |
| `20-Operaciones-Etapa01-Slim-FTP.md` | §2 (pre-requisitos), §3 (configuración del agente), §5 (diagnóstico) |

**Impacto:** 5+ ocurrencias del mismo valor hardcodeado. Si cambia el servidor FTP, hay que actualizarlo en 3 documentos × múltiples secciones.

### 3.2. Lista de archivos a desplegar (duplicado)

| Documento | Sección |
|-----------|---------|
| `00-INDICE-Implantacion.md` | §15 — Primer despliegue (include/exclude) |
| `10-Plan-Etapa01-Slim-FTP.md` | §6 — Estructura del proyecto |
| `20-Operaciones-Etapa01-Slim-FTP.md` | §2 — Archivos a desplegar |

### 3.3. Contenido de `.htaccess` (duplicado)

| Documento | Sección |
|-----------|---------|
| `00-INDICE-Implantacion.md` | §13 — Reescritura de URLs |
| `10-Plan-Etapa01-Slim-FTP.md` | §6 — .htaccess |

### 3.4. Elementos fuera de alcance (duplicado)

| Documento | Sección |
|-----------|---------|
| `00-INDICE-Implantacion.md` | §20 — Elementos fuera de alcance |
| `10-Plan-Etapa01-Slim-FTP.md` | §4 — Alcance excluido |

(Idénticos en contenido con diferencias menores de formato)

### 3.5. Pre-requisitos obligatorios (duplicado)

| Documento | Sección |
|-----------|---------|
| `10-Plan-Etapa01-Slim-FTP.md` | §7 Fase 0 — Pre-requisitos obligatorios |
| `20-Operaciones-Etapa01-Slim-FTP.md` | §2 — Pre-requisitos obligatorios |

(Checklist de 3 ítems: credenciales FTP, acceso FTP, logs del servidor — idéntico)

### 3.6. Versiones de dependencias Slim (duplicado)

| Documento | Sección |
|-----------|---------|
| `00-INDICE-Implantacion.md` | §17 — Dependencias mínimas (slim/slim ^4.15, slim/psr7 ^1.7) |
| `10-Plan-Etapa01-Slim-FTP.md` | §6 — composer.json (slim/slim ^4.15, slim/psr7 ^1.7) |

### 3.7. Contenido del front controller `public/index.php`

Aparece solo en `10-Plan-Etapa01-Slim-FTP.md` §6, pero en `00-INDICE-Implantacion.md` no se repite (correcto).

### 3.8. Ruta de logs del servidor (duplicado)

La ruta `/home/beevivac/logs/stg2.cofemlevante.es/error.log` aparece en:

| Documento | Sección |
|-----------|---------|
| `10-Plan-Etapa01-Slim-FTP.md` | §7 Fase 0 (tarea 0.3) |
| `20-Operaciones-Etapa01-Slim-FTP.md` | §2 (pre-requisitos, #0.3) |

### 3.9. Variable `CONTRASENYA_FTP_WA` (triplicado)

| Documento | Sección |
|-----------|---------|
| `00-INDICE-Implantacion.md` | §14 — Nota sobre contraseñas |
| `10-Plan-Etapa01-Slim-FTP.md` | §7 Fase 0 (tarea 0.1) |
| `20-Operaciones-Etapa01-Slim-FTP.md` | §2 (pre-requisito #0.1), §3, §5 |

### 3.10. Contenido del `.env` (duplicado)

| Documento | Sección |
|-----------|---------|
| `00-INDICE-Implantacion.md` | §14 — Variables de entorno con .env |
| `10-Plan-Etapa01-Slim-FTP.md` | §7 Fase 1 — Configurar `.env` |

---

## 4. Contradicciones e Inconsistencias Internas

### 4.1. Variables listadas en `.env` — discrepancia

| Documento | Variables listadas en `.env` |
|-----------|------------------------------|
| `00-INDICE-Implantacion.md` §14 | `FTP_SERVER`, `FTP_USER`, `FTP_PASSWORD`, `APP_ENV`, `APP_DEBUG` |
| `10-Plan-Etapa01-Slim-FTP.md` §7 Fase 1 | `FTP_SERVER`, `FTP_USER`, `FTP_TARGET_PATH`, `APP_ENV` |
| `20-Operaciones-Etapa01-Slim-FTP.md` §2 | `FTP_SERVER`, `FTP_USER`, `FTP_TARGET_PATH` |

**Problemas:**
- `FTP_TARGET_PATH` aparece en 10-Plan y 20-Operaciones pero NO en 00-INDICE
- `APP_DEBUG` solo aparece en 00-INDICE
- `FTP_PASSWORD` solo aparece en 00-INDICE como variable de `.env`; en 20-Operaciones §3 se trata como variable de entorno externa (`CONTRASENYA_FTP_WA`)

### 4.2. Origen de `FTP_PASSWORD` — ambigüedad

`00-INDICE-Implantacion.md` §14 dice:

> "Nota: Las contraseñas sensibles (`FTP_PASSWORD`, `CONTRASENYA_FTP_WA`) se pueden pasar como variables de entorno además del `.env`, pero la configuración base (rutas, servidores, usuarios) va en `.env`."

Esto sugiere que tanto `FTP_PASSWORD` como `CONTRASENYA_FTP_WA` pueden coexistir. Sin embargo, `20-Operaciones-Etapa01-Slim-FTP.md` §3 establece:

| `FTP_PASSWORD` | Contraseña FTP | Desde variable de entorno (`CONTRASENYA_FTP_WA`) |

Lo que implica que `FTP_PASSWORD` se lee desde `CONTRASENYA_FTP_WA`, no desde el `.env`. Hay conflicto entre "va en `.env`" y "desde variable de entorno".

### 4.3. Ruta de skill `context7` incorrecta

`00-INDICE-Implantacion.md` §17 referencia:

> "La skill `context7` (`.skills/context7/SKILL.md`) ya permite consultar documentación actualizada de Slim"

La ruta correcta es `.opencode/skills/context7/SKILL.md`. El directorio `.skills/` no existe.

### 4.4. Menor: `FTP_TARGET_PATH` vs ruta directa

En `00-INDICE-Implantacion.md` §10, la tabla dice:

| **FTP target** | `/home/beevivac/stg2.cofemlevante.es/` |

Pero en `20-Operaciones-Etapa01-Slim-FTP.md` §3 se usa la variable `FTP_TARGET_PATH` con el mismo valor. No hay contradicción de valor, pero sí una repetición que debería unificarse en una única fuente.

---

## 5. Datos Duplicados respecto a `inventario_recursos.md`

El inventario de recursos (`.gobernanza/inventario_recursos.md` versión 1.1) está **completamente vacío**: todas las secciones (2 a 10) tienen valores 🔲 sin ningún dato registrado.

Los documentos de implantación contienen **todos los valores reales** que deberían estar en el inventario, creando una duplicación sistémica:

| Sección del Inventario | Estado actual | Datos en implantación que deberían poblarlo |
|------------------------|---------------|---------------------------------------------|
| §1 Resumen del Proyecto | 🔲 Vacío | Nombre, stack, entornos (disperso en 00-INDICE) |
| §2 Secrets para Despliegue | 🔲 Vacío | `CONTRASENYA_FTP_WA` (referenciado en 20-Operaciones) |
| §3 Secrets Desarrollo Local | 🔲 Vacío | `FTP_SERVER`, `FTP_USER`, `FTP_PASSWORD`, `APP_ENV`, `APP_DEBUG` (00-INDICE §14) |
| §4.1 Base de Datos | 🔲 Vacío | MariaDB 11.4.10, mysqli, pdo_mysql (wa-server-info.json, wp-info) |
| §4.2 Plataforma Despliegue | 🔲 Vacío | Servidor compartido, LiteSpeed, dominio `stg2.cofemlevante.es` |
| §5 Configuración Despliegue | 🔲 Vacío | FTP/FTPS, `@ftp-deployer`, puerto 21, `lftp mirror` |
| §6 Variables de Entorno | 🔲 Vacío | `FTP_SERVER`, `FTP_USER`, `FTP_PASSWORD`, `FTP_TARGET_PATH`, `FTP_PORT`, `APP_ENV`, `APP_DEBUG` |
| §7 Integraciones Externas | 🔲 Vacío | WordPress REST API (previsto etapa 2+) |
| §8 Contratos entre Servicios | 🔲 Vacío | WA ↔ WP (endpoint REST, etapa 2+) |
| §9 Stack Tecnológico | 🔲 Vacío | PHP 8.3.30, Slim 4.x, MariaDB 11.4.10, LiteSpeed, WooCommerce 10.4.4 |
| §10 Archivos de Configuración | 🔲 Vacío | `composer.json`, `.env`, `.env.example`, `.htaccess`, `.gitignore` |

---

## 6. Datos de Configuración que Deberían Estar en el Inventario

Lista completa de valores hardcodeados en implantación que deben migrarse al inventario:

### Configuración de servidor

| Dato | Valor | Aparece en |
|------|-------|------------|
| Servidor FTP | `ftp.bee-viva.es` | 00-INDICE §3, 10-Plan §7, 20-Operaciones §2/3/5 |
| Puerto FTP | `21` | 00-INDICE §3, 20-Operaciones §3 |
| Usuario FTP WA | `ftp-wa@levantecofem.es` | 00-INDICE §7/14, 10-Plan §7, 20-Operaciones §2/3/5 |
| Directorio target WA | `/home/beevivac/stg2.cofemlevante.es/` | 00-INDICE §7/10, 20-Operaciones §2/3 |
| Directorio WP | `/home/beevivac/levantecofem_es` | 00-INDICE §7, wp-info |
| Variable secreta FTP | `CONTRASENYA_FTP_WA` | 00-INDICE §14, 10-Plan §7, 20-Operaciones §2/3/5 |
| Ruta logs | `/home/beevivac/logs/stg2.cofemlevante.es/error.log` | 10-Plan §7, 20-Operaciones §2 |
| Dominio público WA | `https://stg2.cofemlevante.es/` | 00-INDICE §11, 10-Plan §2/7/8, 20-Operaciones §3/4 |

### Configuración de framework

| Dato | Valor | Aparece en |
|------|-------|------------|
| Versión PHP | 8.3.30 | 00-INDICE §19, wa-server-info.json |
| Framework | Slim 4.x (`^4.15`) | 00-INDICE §17, 10-Plan §6 |
| PSR-7 | slim/psr7 `^1.7` | 00-INDICE §17, 10-Plan §6 |
| Nombre paquete | `cofemlevante/web-app` | 10-Plan §6 |
| Servidor web | LiteSpeed | 00-INDICE §19, wa-server-info.json |
| MariaDB | 11.4.10 | wp-info |
| WooCommerce | 10.4.4 | wp-info |

### Configuración de agente

| Dato | Valor | Aparece en |
|------|-------|------------|
| Agente despliegue | `@ftp-deployer` | 00-INDICE §12, 10-Plan §2/7, 20-Operaciones §3 |
| Archivo agente | `.opencode/agents/ftp-deployer.md` | 20-Operaciones §3 |
| Especificación agente | `pre-proyecto/agentica/ftp-deployer-agent-spec.md` | 10-Plan §10, 20-Operaciones §3 |

---

## 7. Archivos Solapados, Obsoletos o Candidatos a Consolidación

### 7.1. Directorio `legado/` (8 archivos obsoletos)

| Archivo | Reemplazado por | Volumen |
|---------|-----------------|---------|
| `legado/Etapa01_Slim-Despliegue-FTP.md` | 00-INDICE + 10-Plan + 20-Operaciones | ~30 KB |
| `legado/00-decisiones-generales-implantacion.md` | 00-INDICE-Implantacion.md v2.0 | ~5 KB |
| `legado/10-Decisiones-Etapa01-Slim-FTP.md` | 00-INDICE-Implantacion.md v2.0 | ~5 KB |
| `legado/20-Alcance-Etapa01-Slim-FTP.md` | 10-Plan-Etapa01-Slim-FTP.md v2.0 | ~5 KB |
| `legado/30-Plan-Etapa01-Slim-FTP.md` | 10-Plan-Etapa01-Slim-FTP.md v2.0 | ~5 KB |
| `legado/40-Despliegue-Etapa01-Slim-FTP.md` | 20-Operaciones-Etapa01-Slim-FTP.md v2.0 | ~5 KB |
| `legado/50-Verificacion-Etapa01-Slim-FTP.md` | 20-Operaciones-Etapa01-Slim-FTP.md v2.0 | ~5 KB |
| `legado/60-Pendientes-Etapa01-Slim-FTP.md` | 20-Operaciones-Etapa01-Slim-FTP.md v2.0 | ~5 KB |

**Recomendación:** Mover `legado/` a un archivo fuera del árbol principal (ej. `_archivo/` o eliminar, pues ya están versionados en git).

### 7.2. Solapamiento entre 00-INDICE y 10-Plan

- §20 de 00-INDICE (Elementos fuera de alcance) solapa completamente con §4 de 10-Plan (Alcance excluido)
- Las dependencias futuras (Etapa 2) aparecen en 00-INDICE §18 y también referenciadas en 20-Operaciones §7

### 7.3. Candidatos a consolidación

| Contenido | Propietario lógico | Repetido en |
|-----------|--------------------|-------------|
| Datos de conexión FTP | Inventario | 00-INDICE §3, 10-Plan §7, 20-Operaciones §2/3/5 |
| Versiones de PHP/extensiones | Inventario | 00-INDICE §19 + wa-server-info.json |
| Estructura de directorios | 10-Plan §6 | 00-INDICE §9 (parcial) |
| Pre-requisitos de equipo | 20-Operaciones §2 | 10-Plan §7 Fase 0 |

---

## 8. Información que Debería Referenciar al Inventario en Lugar de Repetirse

Según GOV-PRE y GOV-R2, el inventario es la fuente única de verdad para valores específicos. Los siguientes contenidos deberían referenciar `inventario_recursos.md` en lugar de hardcodear los valores:

1. **Configuración FTP** (servidor, puerto, usuario, ruta target) — aparece en 3 documentos → debería ser una referencia a `inventario_recursos.md` §2 o §5
2. **Variable secreta `CONTRASENYA_FTP_WA`** — aparece en 3 documentos → debería referenciar `inventario_recursos.md` §2
3. **Variables de entorno** (`FTP_SERVER`, `FTP_USER`, `FTP_PASSWORD`, `FTP_TARGET_PATH`, `FTP_PORT`, `APP_ENV`, `APP_DEBUG`) → deberían estar en `inventario_recursos.md` §5.1/§6
4. **Versiones de PHP, Slim, MariaDB, WooCommerce** → deberían estar en `inventario_recursos.md` §9 (Stack Tecnológico)
5. **Ruta de logs** → debería estar en `inventario_recursos.md` §4
6. **Dominio público** → debería estar en `inventario_recursos.md` §4.2
7. **Estructura del proyecto** (rutas de directorios) → debería referenciar `inventario_recursos.md` §10

---

## 9. Errores de Referencias Cruzadas

### 9.1. Ruta de skill incorrecta en 00-INDICE §17

```diff
- La skill `context7` (`.skills/context7/SKILL.md`)
+ La skill `context7` (`.opencode/skills/context7/SKILL.md`)
```

La ruta correcta según el INDICE de gobernanza es `.opencode/skills/context7/SKILL.md`.

### 9.2. Falta de referencia cruzada al inventario

Ninguno de los 3 documentos activos referencia `inventario_recursos.md`. Según GOV-PRE:

> "Todo agente o colaborador debe consultar `inventario_recursos.md` antes de iniciar cualquier acción relevante"

Los documentos de implantación deberían incluir una sección de referencias a `inventario_recursos.md`.

### 9.3. Falta de referencia a `reglas_universales.md`

Ningún documento de implantación referencia las reglas de gobernanza del proyecto.

---

## 10. Recomendaciones para la Parte 3

### Prioridad Alta — resolver contradicciones

1. **Unificar fuente de `FTP_PASSWORD`**: Decidir si va en `.env` o solo como variable de entorno externa, y reflejarlo consistentemente
2. **Unificar lista de variables de `.env`**: Decidir conjunto canónico e incluirlo en inventario
3. **Corregir ruta de skill**: `.skills/context7/SKILL.md` → `.opencode/skills/context7/SKILL.md`

### Prioridad Alta — poblar inventario

4. **Migrar todos los valores hardcodeados** (sección 6 de este diagnóstico) a `inventario_recursos.md` mediante `@governance-updater`
5. **Referenciar el inventario** desde los 3 documentos de implantación en lugar de repetir valores

### Prioridad Media — consolidar y limpiar

6. **Archivar `legado/`** fuera del árbol principal (a `_archivo/` o eliminarlo)
7. **Eliminar redundancias** entre 00-INDICE y 10-Plan (especialmente §20 vs §4, §17 vs §6)
8. **Unificar pre-requisitos**: mantenerlos solo en 20-Operaciones y referenciarlos desde 10-Plan

### Prioridad Baja — referencias

9. **Agregar referencias** a `inventario_recursos.md` y `reglas_universales.md` en los 3 documentos activos

---

## Historial de cambios

| Versión | Fecha | Cambio | Autor |
|---------|-------|--------|-------|
| 1.0 | 28 abr 2026 | Diagnóstico inicial de revisión de implantación | OpenCode |
