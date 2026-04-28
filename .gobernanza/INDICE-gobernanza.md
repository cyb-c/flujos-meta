# Índice de Gobernanza — Agentes, Skills y Documentación

**Última actualización:** 28 de abril de 2026  
**Versión:** 1.0  
**Ubicación:** `.gobernanza/INDICE-gobernanza.md`

---

## 📁 Carpeta: `.gobernanza/`

Documentos de gobernanza del proyecto cargados automáticamente vía `opencode.json` → `instructions`.

| # | Documento | Ruta | Propósito | Versión | Estado |
|---|-----------|------|-----------|---------|--------|
| 1 | `reglas_universales.md` | `.gobernanza/reglas_universales.md` | Contrato de 11 reglas universales con REQUIREMENT_IDs | 1.1 | ✅ Activo |
| 2 | `inventario_recursos.md` | `.gobernanza/inventario_recursos.md` | Fuente de verdad para recursos, variables, endpoints | 1.1 | ✅ Activo |
| 3 | `politica_versionamiento.md` | `.gobernanza/politica_versionamiento.md` | Política de versionamiento de documentos | 1.0 | ✅ Activo |
| 4 | `notas_cambios.md` | `.gobernanza/notas_cambios.md` | Trazabilidad interna de cambios (Capa 1) | 1.1 | 📋 Referencia |

---

## 📁 Carpeta: `_registro_/`

Bitácora de cambios del inventario (fuera de `.gobernanza/` y `.opencode/`, listado en `.gitignore`).

| # | Documento | Ruta | Propósito | Estado |
|---|-----------|------|-----------|--------|
| 1 | `inventario_recursos_bitaacora.md` | `_registro_/inventario_recursos_bitaacora.md` | Registro de cambios del inventario | ✅ Activo |

---

## 📁 Carpeta: `.opencode/agents/`

Agentes OpenCode implementados según especificaciones de `pre-proyecto/agentica/`.

| # | Agente | Archivo | Especificación | Modo | Invocación | Propósito |
|---|--------|---------|----------------|------|------------|-----------|
| 1 | `@ftp-deployer` | `.opencode/agents/ftp-deployer.md` | `pre-proyecto/agentica/ftp-deployer-agent-spec.md` | `subagent` | `@ftp-deployer` | Despliega WA por FTP con verificación |
| 2 | `@governance-updater` | `.opencode/agents/governance-updater.md` | `_doc-legado/analisis-integracion-gobernanza-opencode.md` | `subagent` | `@governance-updater` | Actualiza inventario (único autorizado) |
| 3 | `@governance-auditor` | `.opencode/agents/governance-auditor.md` | `_doc-legado/analisis-integracion-gobernanza-opencode.md` | `subagent` | `@governance-auditor` | Auditoría de consistencia (solo lectura) |

---

## 📁 Carpeta: `.opencode/skills/`

Skills OpenCode cargados bajo demanda mediante herramienta `skill`.

| # | Skill | Ruta | Propósito | Invocación |
|---|-------|------|-----------|------------|
| 1 | `context7` | `.opencode/skills/context7/SKILL.md` | Documentación técnica de librerías vía API Context7 | `skill({ name: "context7" })` |
| 2 | `documentacion-tecnica-preventiva` | `.opencode/skills/documentacion-tecnica-preventiva/SKILL.md` | Conocimiento técnico para prevenir errores | `skill({ name: "documentacion-tecnica-preventiva" })` |

---

## 📊 Relación entre Componentes

```
.gobernanza/                          .opencode/agents/                   .opencode/skills/
│                                     │                                   │
├── reglas_universales.md ───────────►│ Todos los agentes leen reglas     │
├── inventario_recursos.md ──────────►│ @governance-updater actualiza     │
│                                     │ @governance-auditor audita        │
│                                     │                                   │
│                                     │──► @ftp-deployer ────────────────►│ (usa context7 si necesita)
│                                     │──► @governance-updater ──────────►│ (usa context7 si necesita)
│                                     │──► @governance-auditor ──────────►│ (usa context7 si necesita)
│                                     │                                   │
└── politica_versionamiento.md        │                                   └── context7/SKILL.md
                                        └── documentacion-tecnica-preventiva/SKILL.md

_registro_/
│
└── inventario_recursos_bitaacora.md ← @governance-updater registra cambios
```

---

## 🔑 Convenciones de Nomenclatura

| Elemento | Regla | Ejemplo |
|----------|-------|---------|
| **REQUIREMENT_ID** | `GOV-<ID>` (R1-R14, PRE) | `GOV-R1`, `GOV-PRE` |
| **Agente OpenCode** | Minúsculas con guiones, archivo `.md` | `governance-updater.md` → `@governance-updater` |
| **Skill** | Minúsculas con guiones, directorio + `SKILL.md` | `documentacion-tecnica-preventiva/SKILL.md` |
| **Documento gobernanza** | `snake_case.md` en `.gobernanza/` | `politica_versionamiento.md` |
| **Bitácora** | `snake_case.md` en `_registro_/` | `inventario_recursos_bitaacora.md` |

---

## 📋 Orden Recomendado de Lectura

| Prioridad | Ruta | Motivo |
|-----------|------|--------|
| 1 | `AGENTS.md` (raíz) | Reglas esenciales + referencias rápidas |
| 2 | `.gobernanza/reglas_universales.md` | Contrato completo de reglas |
| 3 | `.gobernanza/inventario_recursos.md` | Inventario de recursos (consultar antes de actuar) |
| 4 | `.opencode/agents/*.md` | Implementación de agentes |
| 5 | `.gobernanza/politica_versionamiento.md` | Política de versionamiento |
| 6 | `_doc-legado/analisis-integracion-gobernanza-opencode.md` | Análisis de integración (referencia histórica) |

---

## 🔗 Referencias Cruzadas

| Documento | Relación |
|-----------|----------|
| `AGENTS.md` (raíz) | Resumen de reglas + agentes + skills |
| `opencode.json` | Configuración OpenCode con instructions + agentes |
| `.gobernanza/reglas_universales.md` | Contrato de reglas (GOV-PRE, GOV-R1 a GOV-R14) |
| `.gobernanza/inventario_recursos.md` | Inventario de recursos |
| `.gobernanza/politica_versionamiento.md` | Versionamiento de documentos |
| `_registro_/inventario_recursos_bitaacora.md` | Bitácora de cambios |
| `pre-proyecto/agentica/ftp-deployer-agent-spec.md` | Especificación de `@ftp-deployer` |
| `_doc-legado/analisis-integracion-gobernanza-opencode.md` | Análisis de integración (referencia histórica) |
| Documentación oficial OpenCode (Rules) | https://opencode.ai/docs/rules/ |
| Documentación oficial OpenCode (Agents) | https://opencode.ai/docs/agents/ |
| Documentación oficial OpenCode (Skills) | https://opencode.ai/docs/skills/ |
| Documentación oficial OpenCode (Config) | https://opencode.ai/docs/config/ |

---

## 📝 Flujo de Gobernanza

```
1. Usuario solicita tarea
   ↓
2. OpenCode carga automáticamente:
   - AGENTS.md (reglas esenciales)
   - .gobernanza/reglas_universales.md (vía instructions)
   - .gobernanza/inventario_recursos.md (vía instructions)
   ↓
3. Agente ejecuta tarea siguiendo reglas
   ↓
4. Si hay cambios en recursos:
   → @governance-updater actualiza inventario + bitácora
   ↓
5. Antes de despliegue:
   → @governance-auditor audita consistencia
   ↓
6. Despliegue:
   → Solo @ftp-deployer (prohibido CI/CD, FTP manual, otros)
```

---

## 📝 Resumen de Agentes

### `@ftp-deployer`

| Campo | Valor |
|-------|-------|
| **Propósito** | Despliega archivos de la WA por FTP al servidor compartido con verificación posterior |
| **Modo** | `subagent` |
| **Invocación** | `@ftp-deployer despliega la WA` |
| **Permisos** | bash, read, glob, grep (allow); edit, webfetch, task (deny); skill (ask) |
| **Temperature** | 0.1 |
| **Especificación** | `pre-proyecto/agentica/ftp-deployer-agent-spec.md` |

### `@governance-updater`

| Campo | Valor |
|-------|-------|
| **Propósito** | Actualiza el inventario de recursos. Único agente autorizado para modificar `.gobernanza/inventario_recursos.md` |
| **Modo** | `subagent` |
| **Invocación** | `@governance-updater actualiza inventario` |
| **Permisos** | read, write, edit, glob, grep, bash, skill (allow); task, webfetch (deny) |
| **Temperature** | 0.1 |
| **Especificación** | `pre-proyecto/agentica/analisis-integracion-gobernanza-opencode.md` (sección 11) |

### `@governance-auditor`

| Campo | Valor |
|-------|-------|
| **Propósito** | Audita consistencia entre inventario y recursos reales. Solo lectura. |
| **Modo** | `subagent` |
| **Invocación** | `@governance-auditor audita inventario` |
| **Permisos** | read, glob, grep, bash, skill (allow); edit, write, task, webfetch (deny) |
| **Temperature** | 0.1 |
| **Especificación** | `pre-proyecto/agentica/analisis-integracion-gobernanza-opencode.md` (sección 11) |

---

## 📝 Resumen de Skills

### `context7`

| Campo | Valor |
|-------|-------|
| **Propósito** | Consultar documentación actualizada de librerías y frameworks vía API Context7 |
| **Ubicación** | `.opencode/skills/context7/SKILL.md` |
| **Invocación** | Automática o `skill({ name: "context7" })` |

### `documentacion-tecnica-preventiva`

| Campo | Valor |
|-------|-------|
| **Propósito** | Conocimiento técnico para prevenir errores en arquitectura, flujos críticos, seguridad |
| **Ubicación** | `.opencode/skills/documentacion-tecnica-preventiva/SKILL.md` |
| **Contenido completo** | `.gobernanza/documentacion_tecnica_preventiva.md` (eliminado, skill es la única fuente) |
| **Invocación** | Automática o `skill({ name: "documentacion-tecnica-preventiva" })` |

---

## 📄 Estructura de Archivos Completa

```
raíz del proyecto/
│
├── opencode.json                    ← instructions + 3 agentes
├── AGENTS.md                        ← Reglas esenciales + referencias
├── .gitignore                       ← Incluye _registro_/
│
├── .gobernanza/                     ← Gobernanza del proyecto
│   ├── INDICE-gobernanza.md         ← (este documento)
│   ├── reglas_universales.md        ← 11 reglas con REQUIREMENT_IDs
│   ├── inventario_recursos.md       ← Inventario de recursos
│   ├── politica_versionamiento.md   ← Política de versionamiento
│   └── notas_cambios.md             ← Trazabilidad interna
│
├── _registro_/                      ← Bitácora (.gitignore)
│   └── inventario_recursos_bitaacora.md
│
├── .opencode/
│   ├── agents/
│   │   ├── ftp-deployer.md
│   │   ├── governance-updater.md
│   │   └── governance-auditor.md
│   │
│   └── skills/
│       ├── context7/SKILL.md
│       └── documentacion-tecnica-preventiva/SKILL.md
│
└── pre-proyecto/
    └── agentica/
        └── ftp-deployer-agent-spec.md

└── _doc-legado/
    └── analisis-integracion-gobernanza-opencode.md
```

---

*Documento generado el 28 de abril de 2026.*  
*Gobernanza — Sistema de reglas, agentes y skills para OpenCode*
