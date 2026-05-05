# Evaluación de Integración: anomalyco/opencode en flujos-meta

**Fecha de análisis:** 5 de mayo de 2026  
**Proyecto base:** flujos-meta (Web-App de Automatización WooCommerce)  
**Componente evaluado:** anomalyco/opencode v1.14.37  
**Propósito:** Evaluar integración técnica del core de OpenCode en la base de código actual

---

## Índice de Contenido

1. [Resumen Ejecutivo](#resumen-ejecutivo)
2. [Estado Actual del Proyecto](#estado-actual-del-proyecto)
3. [Configuración OpenCode Existente](#configuración-opencode-existente)
4. [Comparación de Funcionalidades](#comparación-de-funcionalidades)
5. [Agentes Existentes vs Agentes Nativos](#agentes-existentes-vs-agentes-nativos)
6. [Sistema de Permisos](#sistema-de-permisos)
7. [Recomendaciones de Integración](#recomendaciones-de-integración)
8. [Brechas Identificadas](#brechas-identificadas)
9. [Plan de Implementación](#plan-de-implementación)

---

## Resumen Ejecutivo

El proyecto `flujos-meta` ya tiene una configuración de OpenCode funcional con **3 agentes personalizados** definidos en `opencode.json`. Sin embargo, esta configuración depende implícitamente del runtime de `anomalyco/opencode` que debe estar instalado globalmente.

**Hallazgos principales:**
- ✅ Configuración `opencode.json` válida y completa
- ✅ 3 agentes personalizados definidos (ftp-deployer, governance-updater, governance-auditor)
- ✅ Sistema de gobernanza documentado (.gobernanza/)
- ⚠️ No hay plugins externos instalados
- ⚠️ No hay herramientas personalizadas registradas
- ⚠️ No hay skills personalizados en el proyecto

---

## Estado Actual del Proyecto

### Estructura del Proyecto

```
flujos-meta/
├── .gobernanza/
│   ├── reglas_universales.md      # Reglas de gobernanza (Nivel 1)
│   ├── inventario_recursos.md     # Inventario de recursos
│   └── ... (otros documentos)
├── .opencode/
│   ├── agents/                    # Definiciones de agentes personalizados
│   ├── skills/                    # Skills personalizados
│   ├── node_modules/              # Dependencias locales
│   └── package.json               # Paquete npm local
├── opencode.json                  # Configuración principal
├── AGENTS.md                      # Reglas para agentes
└── temp/                          # Archivos temporales
```

**Verificado mediante:** `ls -la /workspaces/flujos-meta/`

### Configuración OpenCode Existente

El archivo `opencode.json` (56 líneas) contiene:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "instructions": [
    ".gobernanza/reglas_universales.md",
    ".gobernanza/inventario_recursos.md"
  ],
  "agent": {
    "ftp-deployer": {
      "description": "Despliega archivos por FTP con verificación posterior",
      "mode": "subagent",
      "temperature": 0.1,
      "permission": {
        "bash": "allow",
        "read": "allow",
        "glob": "allow",
        "grep": "allow",
        "edit": "deny",
        "webfetch": "deny",
        "task": "deny",
        "skill": "ask"
      }
    },
    "governance-updater": {
      "description": "Actualiza el inventario de recursos del proyecto",
      "mode": "subagent",
      "temperature": 0.1,
      "permission": { /* ... */ }
    },
    "governance-auditor": {
      "description": "Audita la consistencia entre inventario y recursos reales",
      "mode": "subagent",
      "temperature": 0.1,
      "permission": { /* ... */ }
    }
  }
}
```

**Archivo verificado:** `/workspaces/flujos-meta/opencode.json`

---

## Comparación de Funcionalidades

### Funcionalidades del Core (anomalyco/opencode)

| Funcionalidad | Implementada en Core | Disponible en flujos-meta |
|--------------|---------------------|--------------------------|
| Agentes nativos (build, plan) | ✅ Sí | ✅ Implícito (requiere core instalado) |
| Herramientas nativas (18+) | ✅ Sí | ✅ Implícito |
| CLI (24 comandos) | ✅ Sí | ⚠️ Requiere instalación global |
| TUI | ✅ Sí | ⚠️ Requiere instalación global |
| Sistema de configuración | ✅ Sí | ✅ Usa opencode.json |
| Sistema de sesiones | ✅ Sí | ⚠️ Requiere core instalado |
| Sistema de plugins | ✅ Sí | ❌ No hay plugins instalados |
| Sistema de skills | ✅ Sí | ⚠️ Skills en .opencode/skills/ (no verificado si funcionales) |
| MCP support | ✅ Sí | ❌ No configurado |
| LSP support | ✅ Sí | ❌ No configurado |
| Git integration | ✅ Sí | ✅ Implícito |
| Worktree support | ✅ Sí | ❌ No configurado |

### Funcionalidades Específicas de flujos-meta

| Funcionalidad | Implementada | Notas |
|--------------|--------------|-------|
| Agentes de gobernanza | ✅ Sí | 3 agentes personalizados |
| Instructions de gobernanza | ✅ Sí | 2 documentos referenciados |
| Permisos granulares | ✅ Sí | Por agente |
| FTP deployer | ⚠️ Parcial | Agente definido, implementación no verificada |
| Governance updater | ⚠️ Parcial | Agente definido, implementación no verificada |
| Governance auditor | ⚠️ Parcial | Agente definido, implementación no verificada |

---

## Agentes Existentes vs Agentes Nativos

### Agentes Configurados en flujos-meta

| Agente | Modo | Temperatura | Permisos Clave |
|--------|------|-------------|----------------|
| `ftp-deployer` | subagent | 0.1 | bash:allow, edit:deny, webfetch:deny |
| `governance-updater` | subagent | 0.1 | read:allow, edit:allow, write:allow |
| `governance-auditor` | subagent | 0.1 | read:allow, edit:deny, write:deny |

### Agentes Nativos del Core

| Agente | Modo | Permisos por Defecto |
|--------|------|---------------------|
| `build` | primary | Todos allow excepto doom_loop:ask |
| `plan` | primary | edit:denny, question:allow, plan_exit:allow |
| `general` | subagent | Hereda de configuración |
| `explore` | subagent | Read-only por defecto |

### Comparación de Permisos

**Agente ftp-deployer (flujos-meta):**
```json
{
  "bash": "allow",      // ✅ Puede ejecutar comandos FTP
  "read": "allow",      // ✅ Puede leer archivos
  "glob": "allow",      // ✅ Puede buscar archivos
  "grep": "allow",      // ✅ Puede buscar contenido
  "edit": "deny",       // ✅ No puede editar directamente
  "webfetch": "deny",   // ✅ No puede acceder a web
  "task": "deny",       // ✅ No puede delegar
  "skill": "ask"        // ⚠️ Pregunta antes de usar skills
}
```

**Agente build (nativo del core):**
```typescript
permission: Permission.merge(
  defaults,  // {"*": "allow", doom_loop: "ask", ...}
  {
    question: "allow",
    plan_enter: "allow",
  },
  user,  // Permisos del usuario
)
```

**Diferencia clave:** El agente `ftp-deployer` tiene permisos más restrictivos que el agente `build` nativo, lo cual es apropiado para su rol específico.

---

## Sistema de Permisos

### Permisos por Defecto del Core

Según `packages/opencode/src/agent/agent.ts` (líneas 89-99):

```typescript
const defaults = Permission.fromConfig({
  "*": "allow",
  doom_loop: "ask",
  external_directory: {
    "*": "ask",
    ...Object.fromEntries(whitelistedDirs.map((dir) => [dir, "allow"])),
  },
  question: "deny",
  plan_enter: "deny",
  plan_exit: "deny",
  read: {
    "*": "allow",
    "*.env": "ask",
    "*.env.*": "ask",
    "*.env.example": "allow",
  },
})
```

### Permisos Configurados en flujos-meta

El proyecto sobrescribe los permisos por defecto para cada agente personalizado:

| Herramienta | ftp-deployer | governance-updater | governance-auditor |
|-------------|--------------|-------------------|-------------------|
| bash | allow | allow | allow |
| read | allow | allow | allow |
| glob | allow | allow | allow |
| grep | allow | allow | allow |
| edit | **deny** | **allow** | **deny** |
| write | (no especificado) | **allow** | **deny** |
| webfetch | **deny** | **deny** | **deny** |
| task | **deny** | **deny** | **deny** |
| skill | ask | allow | allow |

**Análisis:**
- ✅ `governance-updater` es el único agente con permisos de escritura (necesario para actualizar inventario)
- ✅ `governance-auditor` es solo lectura (apropiado para auditoría)
- ✅ `ftp-deployer` no puede editar (seguro, solo ejecuta comandos FTP)
- ✅ Todos los agentes tienen webfetch:deny (seguridad)

---

## Recomendaciones de Integración

### 1. Verificar Instalación del Core

**Acción requerida:** Confirmar que `anomalyco/opencode` está instalado globalmente.

```bash
# Verificar instalación
opencode --version

# Si no está instalado:
curl -fsSL https://opencode.ai/install | bash
```

**Justificación:** La configuración `opencode.json` requiere el runtime del core para funcionar.

### 2. Configurar Proveedores de IA

**Estado actual:** No hay configuración de proveedores en `opencode.json`.

**Recomendación:** Agregar configuración de proveedor:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "model": "anthropic/claude-sonnet-4-5",
  "provider": {
    "anthropic": {
      "apiKey": "${ANTHROPIC_API_KEY}"
    }
  },
  // ... resto de configuración
}
```

**Justificación:** El core requiere al menos un proveedor configurado para funcionar.

### 3. Habilitar Agentes Nativos

**Estado actual:** Solo hay agentes personalizados definidos.

**Recomendación:** Agregar configuración explícita para agentes nativos:

```json
{
  "agent": {
    "build": {
      "description": "Agente por defecto para desarrollo",
      "mode": "primary",
      "model": "anthropic/claude-sonnet-4-5"
    },
    "plan": {
      "description": "Modo planificación (solo lectura)",
      "mode": "primary",
      "model": "anthropic/claude-sonnet-4-5"
    },
    "ftp-deployer": { /* ... */ },
    "governance-updater": { /* ... */ },
    "governance-auditor": { /* ... */ }
  }
}
```

**Justificación:** Permite usar agentes nativos junto con personalizados.

### 4. Configurar Skills Personalizados

**Estado actual:** Directorio `.opencode/skills/` existe pero no hay referencia en configuración.

**Recomendación:** Agregar configuración de skills:

```json
{
  "skills": {
    "directories": [
      ".opencode/skills"
    ]
  }
}
```

**Justificación:** Permite cargar skills personalizados desde el directorio del proyecto.

### 5. Configurar MCP Servers (Opcional)

**Estado actual:** No hay configuración MCP.

**Recomendación (si se requiere):**

```json
{
  "mcp": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/workspaces/flujos-meta"]
    }
  }
}
```

**Justificación:** Permite acceso estructurado al sistema de archivos.

---

## Brechas Identificadas

### Brechas Críticas

| Brecha | Impacto | Prioridad |
|--------|---------|-----------|
| Core no verificado instalado | El sistema no funciona sin el runtime | **Crítica** |
| Sin proveedores configurados | No puede conectar con modelos de IA | **Crítica** |
| Sin autenticación configurada | Los proveedores requieren API keys | **Crítica** |

### Brechas Menores

| Brecha | Impacto | Prioridad |
|--------|---------|-----------|
| Sin skills personalizados | Limita capacidades especializadas | Media |
| Sin MCP servers | Sin integración con herramientas externas | Media |
| Sin LSP configurado | Sin autocompletado inteligente | Baja |
| Sin worktrees | Sin aislamiento de sesiones | Baja |

### Brechas de Funcionalidad

| Funcionalidad | Estado en Core | Estado en flujos-meta |
|--------------|----------------|----------------------|
| Compaction de contexto | ✅ Implementado | ⚠️ No configurado |
| Snapshots de sesión | ✅ Implementado | ⚠️ No configurado |
| Export/Import sesiones | ✅ 2 comandos CLI | ❌ No usado |
| Telemetría (OpenTelemetry) | ✅ Implementado | ❌ No configurado |
| Server mode | ✅ Comando `serve` | ❌ No usado |
| Web UI | ✅ Comando `web` | ❌ No usado |
| GitHub integration | ✅ Comando `github` | ❌ No configurado |

---

## Plan de Implementación

### Fase 1: Verificación de Instalación (Día 1)

**Tareas:**
1. Verificar instalación del core: `opencode --version`
2. Si no está instalado: `curl -fsSL https://opencode.ai/install | bash`
3. Verificar configuración: `opencode providers`
4. Configurar proveedor de IA

**Criterio de aceptación:**
- ✅ Comando `opencode --version` devuelve número de versión
- ✅ Comando `opencode providers` lista proveedores disponibles
- ✅ Al menos un proveedor configurado con API key válida

### Fase 2: Configuración de Proveedores (Día 1-2)

**Tareas:**
1. Agregar configuración de proveedor a `opencode.json`
2. Configurar variables de entorno para API keys
3. Verificar conexión con proveedor: `opencode models`

**Configuración recomendada:**
```json
{
  "$schema": "https://opencode.ai/config.json",
  "model": "anthropic/claude-sonnet-4-5",
  "provider": {
    "anthropic": {
      "apiKey": "${ANTHROPIC_API_KEY}"
    },
    "openai": {
      "apiKey": "${OPENAI_API_KEY}"
    }
  }
}
```

**Criterio de aceptación:**
- ✅ Comando `opencode models` lista modelos disponibles
- ✅ Sesión de prueba funciona: `opencode "Hello"`

### Fase 3: Habilitación de Agentes Nativos (Día 2-3)

**Tareas:**
1. Agregar configuración explícita para agentes `build` y `plan`
2. Configurar modelo por defecto para agentes nativos
3. Verificar que agentes nativos funcionan junto con personalizados

**Criterio de aceptación:**
- ✅ Agente `build` seleccionable: `opencode @build "task"`
- ✅ Agente `plan` seleccionable: `opencode @plan "task"`
- ✅ Agentes personalizados siguen funcionando

### Fase 4: Configuración de Skills (Día 3-4)

**Tareas:**
1. Verificar contenido de `.opencode/skills/`
2. Agregar configuración de directorios de skills
3. Crear skill de prueba
4. Verificar carga de skills

**Criterio de aceptación:**
- ✅ Skill personalizado cargado y usable
- ✅ Comando `opencode` reconoce skills disponibles

### Fase 5: Configuración Avanzada (Opcional, Día 4-5)

**Tareas:**
1. Configurar MCP servers (si se requiere)
2. Configurar LSP (si se requiere)
3. Configurar worktrees (si se requiere)
4. Configurar server mode (si se requiere)

**Criterio de aceptación:**
- ✅ MCP servers configurados y funcionales (si aplica)
- ✅ LSP proporcionando autocompletado (si aplica)

---

## Comparación Directa: Funcionalidades Core vs Configuración Actual

### Herramientas Disponibles

| Herramienta | Core (nativa) | flujos-meta (configurada) |
|-------------|---------------|--------------------------|
| read | ✅ Sí | ✅ Heredada del core |
| write | ✅ Sí | ✅ Heredada del core |
| edit | ✅ Sí | ✅ Heredada del core |
| shell/bash | ✅ Sí | ✅ Heredada del core |
| glob | ✅ Sí | ✅ Heredada del core |
| grep | ✅ Sí | ✅ Heredada del core |
| lsp | ✅ Sí | ⚠️ Disponible, no configurada |
| task | ✅ Sí | ✅ Heredada (deny para personalizados) |
| question | ✅ Sí | ✅ Heredada del core |
| webfetch | ✅ Sí | ✅ Heredada (deny para personalizados) |
| websearch | ✅ Sí | ✅ Heredada del core |
| skill | ✅ Sí | ✅ Heredada (ask/allow para personalizados) |
| todo/todowrite | ✅ Sí | ✅ Heredada del core |
| plan_enter/plan_exit | ✅ Sí | ✅ Heredada del core |

### Comandos CLI Disponibles

| Comando | Core | flujos-meta |
|---------|------|-------------|
| `opencode` (TUI) | ✅ Sí | ⚠️ Requiere core instalado |
| `opencode run` | ✅ Sí | ⚠️ Requiere core instalado |
| `opencode agent` | ✅ Sí | ⚠️ Requiere core instalado |
| `opencode models` | ✅ Sí | ⚠️ Requiere core instalado |
| `opencode providers` | ✅ Sí | ⚠️ Requiere core instalado |
| `opencode plugin` | ✅ Sí | ⚠️ Requiere core instalado |
| `opencode session` | ✅ Sí | ⚠️ Requiere core instalado |
| `opencode export` | ✅ Sí | ❌ No usado |
| `opencode import` | ✅ Sí | ❌ No usado |
| `opencode github` | ✅ Sí | ❌ No configurado |
| `opencode mcp` | ✅ Sí | ❌ No configurado |

---

## Conclusión de la Evaluación

### Estado General

El proyecto `flujos-meta` tiene una **configuración de OpenCode válida pero incompleta**. La configuración de agentes personalizados es correcta y sigue las mejores prácticas de permisos granulares. Sin embargo:

1. **Dependencia implícita:** La configuración asume que `anomalyco/opencode` está instalado globalmente, pero esto no está verificado en el proyecto.

2. **Sin proveedores configurados:** No hay configuración de proveedores de IA, lo cual es crítico para el funcionamiento.

3. **Funcionalidades sin usar:** Varias funcionalidades del core (export/import, github, mcp, server mode) no están configuradas ni usadas.

### Recomendación Principal

**Instalar y configurar el core de OpenCode antes de cualquier otra acción:**

```bash
# 1. Instalar core
curl -fsSL https://opencode.ai/install | bash

# 2. Verificar instalación
opencode --version

# 3. Configurar proveedores
# Editar opencode.json agregando configuración de proveedor

# 4. Configurar variables de entorno
export ANTHROPIC_API_KEY="sk-ant-..."

# 5. Verificar funcionamiento
opencode "Hello world"
```

### Valor de la Integración Completa

Una vez integrado completamente, el proyecto tendrá:

- ✅ 5 agentes funcionales (3 personalizados + 2 nativos)
- ✅ 18+ herramientas nativas disponibles
- ✅ 24 comandos CLI funcionales
- ✅ TUI para interacción interactiva
- ✅ Sesiones persistentes con SQLite
- ✅ Sistema de gobernanza automatizado
- ✅ Skills personalizables
- ✅ MCP servers extensibles

---

**Documento generado para:** Evaluación de integración de anomalyco/opencode en flujos-meta  
**Ubicación de salida:** `temp/evaluacion-integracion-opencode-flujos-meta.md`  
**Configuración analizada:** `/workspaces/flujos-meta/opencode.json` (56 líneas)  
**Agentes configurados:** 3 (ftp-deployer, governance-updater, governance-auditor)  
**Documentación de gobernanza referenciada:** 2 archivos (.gobernanza/reglas_universales.md, .gobernanza/inventario_recursos.md)
