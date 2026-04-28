# Política de Versionamiento de Documentos

> **Versión:** 1.0
> **Aplicación:** Todos los documentos de gobernanza del proyecto

---

## Índice

1. [Reglas de Versionamiento](#reglas-de-versionamiento)
2. [Proceso de Actualización](#proceso-de-actualización)
3. [Documentos Cubiertos](#documentos-cubiertos)

---

## Reglas de Versionamiento

### 1. Versiones Independientes

- Cada documento de gobernanza tiene su propio número de versión
- Los cambios en un documento **NO** requieren actualizar la versión de otros
- La versión se incrementa cuando hay cambios significativos en el contenido

### 2. Incremento de Versión

| Tipo | Versión | Descripción |
|------|---------|-------------|
| **Versión mayor** | X.0 | Cambios estructurales importantes, adición de nuevas secciones, reorganización significativa |
| **Versión menor** | 0.X | Cambios moderados, adición de nuevas reglas, modificaciones existentes |
| **Versión de parche** | 0.0.X | Correcciones menores, typos, formato (opcional) |

### 3. Historial de Cambios

| Documento | Ubicación del Historial |
|-----------|------------------------|
| `inventario_recursos.md` | `_registro_/inventario_recursos_bitaacora.md` |
| `reglas_universales.md` | Commits del repositorio |
| `politica_versionamiento.md` | Commits del repositorio |
| Documentación de agentes | Commits del repositorio |
| Skills | Commits del repositorio |

### 4. Sincronización entre Documentos

- Los documentos pueden tener versiones diferentes
- No es necesario mantener sincronización de versiones entre documentos
- Para cambios que afectan múltiples documentos, actualizar cada uno independientemente

### 5. Notificación de Cambios

| Documento | Notificar a |
|-----------|-------------|
| `reglas_universales.md` | Todos los involucrados |
| `inventario_recursos.md` | Responsables de gestión y auditoría (`@governance-updater`, `@governance-auditor`) |
| `politica_versionamiento.md` | Todos los involucrados |
| Agentes (`@*`) | Agentes afectados |

---

## Proceso de Actualización

### Paso 1: Identificar Necesidad de Cambio

- Revisión periódica de consistencia
- Detección de problemas o ambigüedades
- Solicitud de mejoras por parte de colaboradores

### Paso 2: Evaluar Impacto

- Determinar qué documentos se ven afectados
- Evaluar si el cambio es mayor o menor
- Identificar quiénes deben ser notificados

### Paso 3: Implementar Cambio

- Actualizar el documento correspondiente
- Incrementar la versión según el tipo de cambio
- Documentar el cambio en `_registro_/inventario_recursos_bitaacora.md` (si aplica al inventario)

### Paso 4: Notificar a Interesados

- Comunicar el cambio a los afectados
- Actualizar referencias cruzadas si es necesario
- Solicitar confirmación de comprensión

---

## Documentos Cubiertos

| Documento | Ruta | Versión Actual |
|-----------|------|----------------|
| Reglas Universales | `.gobernanza/reglas_universales.md` | 1.1 |
| Inventario de Recursos | `.gobernanza/inventario_recursos.md` | 1.1 |
| Política de Versionamiento | `.gobernanza/politica_versionamiento.md` | 1.0 |
| Documentación Técnica Preventiva | `.gobernanza/documentacion_tecnica_preventiva.md` | 1.0 |
| Bitácora de Cambios | `_registro_/inventario_recursos_bitaacora.md` | 1.0 |
| Agentes OpenCode | `.opencode/agents/*.md` | — |
| Skills | `.opencode/skills/*/SKILL.md` | — |

---

*Documento extraído de `.gobernanza/reglas_universales.md` el 28 de abril de 2026.*
