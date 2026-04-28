# Guía de Inicio Rápido: OpenCode para Desarrolladores Nuevos

## Índice de Contenidos

1. [Introducción a OpenCode](#1-introducción-a-opencode)
2. [Agentes](#2-agentes)
3. [Agente Orquestador](#3-agente-orquestador)
4. [Skills](#4-skills)
5. [Relación entre Agentes, Orquestador y Skills](#5-relación-entre-agentes-orquestador-y-skills)
6. [Modelos Disponibles en OpenCode Go](#6-modelos-disponibles-en-opencode-go)
7. [Parte 1: Esquema Simple para Comprensión General](#7-parte-1-esquema-simple-para-comprensión-general)
8. [Parte 2: Esquema Ampliado y Operativo](#8-parte-2-esquema-ampliado-y-operativo)
9. [Comandos Útiles y Referencia](#9-comandos-útiles-y-referencia)
10. [Recursos y Documentación Oficial](#10-recursos-y-documentación-oficial)

---

## 1. Introducción a OpenCode

### ¿Qué es OpenCode?

OpenCode (OC) es un **agente de codificación de código abierto** que funciona en tu terminal, IDE o como aplicación de escritorio. Permite interactuar con modelos de lenguaje (LLM) para:

- Explicar código existente
- Añadir nuevas funcionalidades
- Refactorizar código
- Revisar código
- Generar documentación
- Ejecutar tareas repetitivas

**Características principales:**

- **Código abierto**: Más de 140.000 estrellas en GitHub, 850+ contribuidores
- **Multi-sesión**: Puedes iniciar múltiples agentes en paralelo sobre el mismo proyecto
- **LSP integrado**: Carga automáticamente los servidores de lenguaje (LSP) adecuados para el LLM
- **Compartir sesiones**: Genera enlaces para compartir conversaciones con tu equipo
- **Cualquier modelo**: Soporta 75+ proveedores de LLM a través de Models.dev
- **Multi-plataforma**: Disponible como interfaz de terminal, aplicación de escritorio y extensión para IDE

### Instalación

```bash
# Método recomendado (script de instalación)
curl -fsSL https://opencode.ai/install | bash

# Alternativa con npm
npm install -g opencode-ai

# Alternativa con Homebrew (macOS/Linux)
brew install anomalyco/tap/opencode
```

### Configuración Inicial

1. **Ejecutar OpenCode** en tu proyecto:
   ```bash
   cd /ruta/a/tu/proyecto
   opencode
   ```

2. **Conectar un proveedor** de modelos:
   ```
   /connect
   ```
   - Selecciona `opencode` para usar OpenCode Go
   - O selecciona otro proveedor (Anthropic, OpenAI, etc.)

3. **Inicializar el proyecto**:
   ```
   /init
   ```
   Esto crea un archivo `AGENTS.md` en la raíz del proyecto que ayuda a OC a entender la estructura del código.

---

## 2. Agentes

### ¿Qué son los Agentes?

Los agentes son **asistentes de IA especializados** configurados para tareas y flujos de trabajo específicos. Cada agente puede tener:

- Prompts personalizados
- Modelos diferentes
- Acceso a herramientas específicas
- Permisos configurados

### Tipos de Agentes

#### 2.1 Agentes Primarios

Son los asistentes principales con los que interactúas directamente. Puedes alternar entre ellos usando la tecla **Tab** durante una sesión.

**Agentes primarios integrados:**

| Agente | Modo | Descripción | Permisos |
|--------|------|-------------|----------|
| **Build** | Primario (por defecto) | Agente de desarrollo con todas las herramientas habilitadas | Todas permitidas |
| **Plan** | Primario | Análisis y planificación sin hacer cambios | Edición y bash en modo `ask` |

**Uso del agente Plan:**
- Útil para analizar código
- Sugerir cambios
- Crear planes de implementación
- Previene modificaciones no intencionadas

#### 2.2 Subagentes

Son asistentes especializados que los agentes primarios pueden invocar para tareas específicas. También puedes invocarlos manualmente mencionándolos con `@`.

**Subagentes integrados:**

| Subagente | Descripción | Cuándo usar |
|-----------|-------------|-------------|
| **General** | Propósito general para tareas complejas | Ejecutar múltiples unidades de trabajo en paralelo |
| **Explore** | Exploración rápida de código (solo lectura) | Buscar archivos, buscar código, responder preguntas sobre el codebase |

**Ejemplo de invocación manual:**
```
@general ayúdame a buscar esta función
@explorer ¿dónde se maneja la autenticación?
```

### Agentes Personalizados

Puedes crear agentes personalizados para necesidades específicas del proyecto.

**Ejemplo: Agente de revisión de código**

Archivo: `.opencode/agents/review.md`

```markdown
---
description: Revisa código en busca de mejores prácticas y problemas potenciales
mode: subagent
model: anthropic/claude-sonnet-4-20250514
temperature: 0.1
permission:
  edit: deny
  bash: deny
---
Eres un revisor de código. Enfócate en:
- Calidad del código y mejores prácticas
- Bugs potenciales y casos borde
- Implicaciones de rendimiento
- Consideraciones de seguridad

Proporciona feedback constructivo sin hacer cambios directos.
```

**Configuración en JSON** (`opencode.json`):

```json
{
  "$schema": "https://opencode.ai/config.json",
  "agent": {
    "code-reviewer": {
      "description": "Revisa código en busca de mejores prácticas",
      "mode": "subagent",
      "model": "anthropic/claude-sonnet-4-20250514",
      "prompt": "Eres un revisor de código. Enfócate en seguridad, rendimiento y mantenibilidad.",
      "permission": {
        "edit": "deny"
      }
    }
  }
}
```

### Opciones de Configuración de Agentes

| Opción | Descripción | Ejemplo |
|--------|-------------|---------|
| `description` | Descripción breve del agente (requerido) | `"Revisa código"` |
| `mode` | Tipo: `primary`, `subagent`, o `all` | `"subagent"` |
| `model` | Modelo específico para este agente | `"anthropic/claude-sonnet-4"` |
| `temperature` | Creatividad (0.0-1.0) | `0.1` para análisis, `0.7` para brainstorming |
| `steps` | Máximo de iteraciones agénticas | `5` |
| `prompt` | Archivo de prompt personalizado | `"{file:./prompts/review.txt}"` |
| `permission` | Permisos de herramientas | `{"edit": "deny", "bash": "ask"}` |
| `hidden` | Ocultar de autocompletado `@` | `true` |
| `color` | Color en la UI | `"#ff6b6b"` o `"accent"` |

---

## 3. Agente Orquestador

### ¿Qué es un Agente Orquestador?

Un **agente orquestador** es un agente primario configurado para coordinar y delegar trabajo a múltiples subagentes. Utiliza la herramienta `Task` para invocar subagentes especializados.

**Nota importante:** OpenCode no tiene un "agente orquestador" predefinido como tal. Debes crearlo configurando un agente primario con permisos específicos para invocar subagentes.

### Configuración de un Orquestador

**Ejemplo en `opencode.json`:**

```json
{
  "agent": {
    "orchestrator": {
      "description": "Coordina tareas complejas delegando a subagentes especializados",
      "mode": "primary",
      "model": "opencode-go/qwen3.5-plus",
      "permission": {
        "task": {
          "*": "deny",
          "orchestrator-*": "allow",
          "code-reviewer": "ask",
          "documentation": "allow"
        }
      }
    }
  }
}
```

### Permisos de Tarea (`permission.task`)

Controla qué subagentes puede invocar el orquestador:

- `"*": "deny"` - Deniega todos por defecto
- `"orchestrator-*": "allow"` - Permite subagentes que coincidan con el patrón
- `"code-reviewer": "ask"` - Requiere aprobación para este subagente

**Nota:** Los usuarios siempre pueden invocar cualquier subagente directamente vía el menú de autocompletado `@`, incluso si los permisos de tarea lo deniegan.

### Flujo de Trabajo del Orquestador

1. El usuario describe una tarea compleja al orquestador
2. El orquestador analiza y descompone la tarea
3. Invoca subagentes especializados para cada subtarea
4. Coordina y consolida los resultados
5. Presenta el resultado final al usuario

---

## 4. Skills

### ¿Qué son los Skills?

Los **skills** son instrucciones reutilizables que OpenCode puede descubrir y cargar bajo demanda. Permiten definir comportamientos estandarizados para tareas específicas del proyecto.

### Estructura de un Skill

Cada skill se define en un archivo `SKILL.md` dentro de una carpeta con el nombre del skill.

**Ubicaciones soportadas:**

| Tipo | Ruta |
|------|------|
| Proyecto | `.opencode/skills/<nombre>/SKILL.md` |
| Global | `~/.config/opencode/skills/<nombre>/SKILL.md` |
| Compatible con Claude | `.claude/skills/<nombre>/SKILL.md` |
| Compatible con Agents | `.agents/skills/<nombre>/SKILL.md` |

### Frontmatter Requerido

Cada `SKILL.md` debe comenzar con YAML frontmatter:

```yaml
---
name: nombre-del-skill
description: Descripción clara de 1-1024 caracteres
license: MIT  # Opcional
compatibility: opencode  # Opcional
metadata:  # Opcional
  audience: desarrolladores
  workflow: github
---
```

### Reglas de Nomenclatura

El `name` debe:

- Tener 1-64 caracteres
- Ser alfanumérico en minúsculas con guiones separadores
- No empezar ni terminar con `-`
- No contener `--` consecutivo
- Coincidir con el nombre del directorio

**Regex válido:** `^[a-z0-9]+(-[a-z0-9]+)*$`

### Ejemplo de Skill

Archivo: `.opencode/skills/git-release/SKILL.md`

```markdown
---
name: git-release
description: Crea releases consistentes y changelogs
license: MIT
compatibility: opencode
metadata:
  audience: maintainers
  workflow: github
---

## Qué hago
- Redacto notas de release desde PRs mergeados
- Propongo un bump de versión
- Proporciono un comando `gh release create` para copiar y pegar

## Cuándo usarme
Usa este skill cuando estés preparando un release etiquetado.
Haz preguntas de clarificación si el esquema de versionado no está claro.
```

### Uso de Skills por los Agentes

Los agentes ven los skills disponibles en la descripción de la herramienta `skill`:

```xml
<available_skills>
  <skill>
    <name>git-release</name>
    <description>Crea releases consistentes y changelogs</description>
  </skill>
</available_skills>
```

**Invocación:**
```
skill({ name: "git-release" })
```

### Permisos de Skills

Controla qué skills pueden acceder los agentes en `opencode.json`:

```json
{
  "permission": {
    "skill": {
      "*": "allow",
      "pr-review": "allow",
      "internal-*": "deny",
      "experimental-*": "ask"
    }
  }
}
```

| Permiso | Comportamiento |
|---------|----------------|
| `allow` | El skill se carga inmediatamente |
| `deny` | El skill está oculto para el agente, acceso rechazado |
| `ask` | Se solicita aprobación al usuario antes de cargar |

### Deshabilitar la Herramienta Skill

Para agentes que no deben usar skills:

**En frontmatter de agente personalizado:**
```yaml
---
tools:
  skill: false
---
```

**En `opencode.json` para agentes integrados:**
```json
{
  "agent": {
    "plan": {
      "tools": {
        "skill": false
      }
    }
  }
}
```

---

## 5. Relación entre Agentes, Orquestador y Skills

### Diagrama Conceptual

```
┌─────────────────────────────────────────────────────────────┐
│                      USUARIO                                │
│         (interactúa vía terminal/IDE con OC)                │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                   AGENTE PRIMARIO                           │
│              (Build, Plan, o personalizado)                 │
│                                                             │
│  ┌──────────────────────────────────────────────────────┐  │
│  │              AGENTE ORQUESTADOR                      │  │
│  │         (si está configurado como tal)               │  │
│  │                                                      │  │
│  │  ┌────────────┐  ┌────────────┐  ┌────────────┐    │  │
│  │  │ Subagente 1│  │ Subagente 2│  │ Subagente N│    │  │
│  │  │ (General)  │  │ (Explore)  │  │ (Custom)   │    │  │
│  │  └────────────┘  └────────────┘  └────────────┘    │  │
│  └──────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼ (puede invocar)
┌─────────────────────────────────────────────────────────────┐
│                      SKILLS                                 │
│  (instrucciones reutilizables cargadas bajo demanda)        │
│                                                             │
│  • git-release    • pr-review    • documentation           │
│  • security-audit • deploy       • testing                 │
└─────────────────────────────────────────────────────────────┘
```

### Flujo de Interacción

1. **Usuario → Agente Primario**: El usuario describe una tarea
2. **Agente Primario → Subagentes**: Si la tarea es compleja, puede delegar a subagentes
3. **Agente → Skills**: El agente carga skills relevantes para la tarea
4. **Ejecución**: Se ejecutan las acciones con los permisos configurados
5. **Resultado**: Se presenta el resultado al usuario

### Cuándo Usar Cada Elemento

| Elemento | Cuándo usar | Ejemplo |
|----------|-------------|---------|
| **Agente Primario** | Tarea principal de desarrollo | "Añade autenticación a /settings" |
| **Agente Plan** | Análisis sin cambios | "¿Cómo está estructurada la API?" |
| **Subagente General** | Tareas complejas paralelas | "Busca todos los usos de esta función" |
| **Subagente Explore** | Exploración rápida | "¿Dónde se define el modelo User?" |
| **Skill** | Comportamiento estandarizado | "Prepara un release con changelog" |
| **Orquestador** | Tarea que requiere coordinación | "Implementa el feature completo con tests y docs" |

---

## 6. Modelos Disponibles en OpenCode Go

### ¿Qué es OpenCode Go?

OpenCode Go es una suscripción de bajo coste (**5$ primer mes, luego 10$/mes**) que proporciona acceso fiable a modelos open-source optimizados para codificación.

**Nota:** El uso de Go es **opcional**. Puedes usar cualquier otro proveedor (Anthropic, OpenAI, etc.) con OpenCode.

### Modelos Incluidos en Go

| Modelo | Solicitudes / 5h | Solicitudes / semana | Solicitudes / mes |
|--------|------------------|---------------------|-------------------|
| GLM-5.1 | 880 | 2.150 | 4.300 |
| GLM-5 | 1.150 | 2.880 | 5.750 |
| Kimi K2.5 | 1.850 | 4.630 | 9.250 |
| Kimi K2.6 | 1.150 | 2.880 | 5.750 |
| MiMo-V2-Pro | 1.290 | 3.225 | 6.450 |
| MiniMax M2.7 | 3.400 | 8.500 | 17.000 |
| **Qwen3.5 Plus** | **10.200** | **25.200** | **50.500** |
| **Qwen3.6 Plus** | **3.300** | **8.200** | **16.300** |
| DeepSeek V4 Pro | 3.450 | 8.550 | 17.150 |
| DeepSeek V4 Flash | 31.650 | 79.050 | 158.150 |

### Límites de Uso

| Periodo | Límite en dólares |
|---------|-------------------|
| 5 horas | 12$ |
| Semanal | 30$ |
| Mensual | 60$ |

**Nota:** Los límites se definen en valor monetario. El número real de solicitudes depende del modelo utilizado.

### Recomendación de Modelos para este Proyecto

**Modelo principal recomendado:** `opencode-go/qwen3.5-plus`

**Razones:**
- Alto límite de solicitudes (50.500/mes)
- Buen equilibrio entre capacidad y coste
- Optimizado para tareas de codificación

**Modelo secundario (tareas ligeras):** `opencode-go/deepseek-v4-flash`

**Razones:**
- Límite muy alto (158.150/mes)
- Ideal para tareas simples, exploración, resúmenes

**Configuración recomendada en `opencode.json`:**

```json
{
  "$schema": "https://opencode.ai/config.json",
  "model": "opencode-go/qwen3.5-plus",
  "small_model": "opencode-go/deepseek-v4-flash",
  "agent": {
    "build": {
      "model": "opencode-go/qwen3.5-plus"
    },
    "plan": {
      "model": "opencode-go/deepseek-v4-flash",
      "temperature": 0.1
    }
  }
}
```

### Consideraciones sobre los Modelos

**Importante:** La selección de modelos puede cambiar en el futuro si:

- El proyecto requiere capacidades específicas no cubiertas por los modelos actuales
- OpenCode añade nuevos modelos más adecuados
- Los límites de uso o costes cambian
- Se identifican mejores opciones para casos de uso específicos

**Recomendación:** Revisa periódicamente los modelos disponibles con:
```
/models
```

---

## 7. Parte 1: Esquema Simple para Comprensión General

### ¿Qué se Necesita?

| Elemento | Descripción | Estado inicial |
|----------|-------------|----------------|
| **OpenCode instalado** | CLI de OpenCode | ✓ Disponible en el entorno |
| **Proveedor configurado** | API key de modelos | Por configurar (Go u otro) |
| **Proyecto inicializado** | Archivo `AGENTS.md` | Por crear con `/init` |
| **Configuración básica** | `opencode.json` | Por crear |

### Piezas a Crear o Revisar

1. **Configuración del proyecto**
   - `opencode.json` en la raíz del proyecto
   - `.opencode/` directorio para configuraciones locales

2. **Agentes personalizados** (si son necesarios)
   - `.opencode/agents/<nombre>.md`

3. **Skills personalizados** (si son necesarios)
   - `.opencode/skills/<nombre>/SKILL.md`

4. **Documentación del proyecto**
   - `AGENTS.md` (generado con `/init`)
   - Instrucciones específicas en `.opencode/instructions/`

### Relación entre Componentes

```
┌──────────────┐     delega     ┌──────────────┐
│  Agente      │ ─────────────▶ │  Subagentes  │
│  Primario    │                │  (General,   │
│  (Build/Plan)│                │   Explore)   │
└──────────────┘                └──────────────┘
       │                               │
       │ invoca                        │ puede usar
       ▼                               ▼
┌──────────────┐               ┌──────────────┐
│  Agente      │               │    Skills    │
│ Orquestador  │               │ (instruccs.  │
│  (opcional)  │               │ reutilizables)│
└──────────────┘               └──────────────┘
```

### Flujo General del Proyecto

1. **Inicialización**
   - Ejecutar `opencode` en el directorio del proyecto
   - Ejecutar `/init` para generar `AGENTS.md`

2. **Configuración**
   - Crear/editar `opencode.json` con modelos y agentes
   - Configurar permisos según necesidades

3. **Desarrollo**
   - Usar agente **Build** para implementación
   - Usar agente **Plan** para análisis previo
   - Invocar subagentes con `@nombre` para tareas específicas

4. **Estandarización** (opcional)
   - Crear skills para tareas repetitivas
   - Crear agentes personalizados para flujos específicos

---

## 8. Parte 2: Esquema Ampliado y Operativo

### 8.1 Configuración Inicial del Entorno

#### Qué debe preparar el usuario

1. **Verificar instalación de OpenCode:**
   ```bash
   opencode --version
   ```

2. **Configurar proveedor de modelos:**
   ```bash
   opencode
   # Dentro del TUI:
   /connect
   # Seleccionar proveedor y pegar API key
   ```

3. **Inicializar proyecto:**
   ```bash
   cd /workspaces/flujos-meta
   opencode
   # Dentro del TUI:
   /init
   ```

#### Tareas que puedes automatizar o acelerar

- **Búsqueda de documentación**: Usar `.skills/context7/SKILL.md` para consultar docs actualizadas
- **Generación de configs**: Crear plantillas de `opencode.json` y agentes
- **Validación de estructura**: Verificar que skills y agentes siguen las reglas de nomenclatura

#### Archivos a crear o revisar

| Archivo | Propósito | Acción |
|---------|-----------|--------|
| `opencode.json` | Configuración principal | Crear en raíz |
| `tui.json` | Configuración de UI | Opcional en raíz |
| `.opencode/agents/*.md` | Agentes personalizados | Crear según necesidad |
| `.opencode/skills/*/SKILL.md` | Skills personalizados | Crear según necesidad |
| `AGENTS.md` | Contexto del proyecto | Generar con `/init` |

### 8.2 Instalación y Configuración

#### Paso 1: Configurar `opencode.json`

```json
{
  "$schema": "https://opencode.ai/config.json",
  "model": "opencode-go/qwen3.5-plus",
  "small_model": "opencode-go/deepseek-v4-flash",
  "permission": {
    "edit": "ask",
    "bash": "ask"
  },
  "agent": {
    "plan": {
      "permission": {
        "edit": "deny",
        "bash": "deny"
      }
    }
  },
  "watcher": {
    "ignore": ["node_modules/**", "dist/**", ".git/**"]
  }
}
```

#### Paso 2: Crear agentes personalizados (si es necesario)

**Ejemplo: Agente documentador**

Archivo: `.opencode/agents/documentacion.md`

```markdown
---
description: Genera y mantiene documentación del proyecto
mode: subagent
model: opencode-go/qwen3.5-plus
temperature: 0.3
permission:
  edit: allow
  bash: deny
---
Eres un escritor técnico. Crea documentación clara y completa.

Enfócate en:
- Explicaciones claras
- Estructura apropiada
- Ejemplos de código
- Lenguaje accesible

Usa español de España para la documentación de este proyecto.
```

#### Paso 3: Crear skills personalizados (si es necesario)

**Ejemplo: Skill para análisis de workflow**

Archivo: `.opencode/skills/analizar-workflow/SKILL.md`

```markdown
---
name: analizar-workflow
description: Analiza workflows y pipelines existentes en el proyecto
license: MIT
compatibility: opencode
metadata:
  audience: desarrolladores
  workflow: pipeflow
---

## Qué hago
- Identifico archivos de workflow en el proyecto
- Analizo la estructura de pipelines definidos
- Resumo el flujo de ejecución
- Sugiero mejoras o puntos de atención

## Cuándo usarme
Usa este skill cuando necesites entender cómo funciona un workflow existente.
Proporciona la ruta del workflow o déjame explorarlo.
```

### 8.3 Cómo Seguir las Reglas de OpenCode

#### Reglas de Nomenclatura

**Agentes:**
- Nombre del archivo: `.opencode/agents/<nombre>.md`
- El nombre del agente es el nombre del archivo sin extensión
- Ejemplo: `code-reviewer.md` → agente `code-reviewer`

**Skills:**
- Directorio: `.opencode/skills/<nombre>/SKILL.md`
- El nombre debe estar en el frontmatter y coincidir con el directorio
- Ejemplo: `.opencode/skills/git-release/SKILL.md` con `name: git-release`

#### Reglas de Permisos

1. **Principio de mínimo privilegio**: Concede solo los permisos necesarios
2. **Patrones glob**: Usa patrones como `"git *": "ask"` para control granular
3. **Orden de evaluación**: La última regla coincidente gana

```json
{
  "permission": {
    "bash": {
      "*": "ask",
      "git status *": "allow",
      "git diff *": "allow",
      "rm -rf *": "deny"
    }
  }
}
```

### 8.4 Cómo Usar `.skills/context7/SKILL.md`

El skill `context7` permite consultar documentación actualizada de librerías y frameworks.

#### Verificar API Key

```bash
echo $CONTEXT7_API_KEY
# Debe mostrar un valor (inyectado desde GitHub Secrets)
```

#### Flujo de Uso

**Paso 1: Buscar la librería**

```bash
curl -s -H "Authorization: Bearer $CONTEXT7_API_KEY" \
  "https://context7.com/api/v2/libs/search?libraryName=react&query=hooks" | \
  jq '.results[0]'
```

**Paso 2: Obtener documentación**

```bash
curl -s -H "Authorization: Bearer $CONTEXT7_API_KEY" \
  "https://context7.com/api/v2/context?libraryId=/websites/react_dev_reference&query=useState&type=txt"
```

#### Integración con OpenCode

Puedes pedirle a OpenCode que use context7 para:

1. **Verificar uso de APIs:**
   ```
   @general Busca en context7 la documentación actualizada de FastAPI dependencies
   ```

2. **Validar implementación:**
   ```
   Usa context7 para verificar si esta implementación de React hooks es correcta
   ```

3. **Obtener ejemplos:**
   ```
   Obtén ejemplos de código de Next.js app router desde context7
   ```

### 8.5 Flujo de Trabajo Recomendado

#### Para Tareas Simples

1. Ejecutar `opencode`
2. Describir tarea directamente al agente **Build**
3. Revisar y aprobar cambios (si permisos en `ask`)

#### Para Tareas Complejas

1. Ejecutar `opencode`
2. Cambiar a agente **Plan** (tecla Tab)
3. Describir tarea y solicitar plan
4. Iterar sobre el plan hasta estar satisfecho
5. Cambiar a agente **Build**
6. Solicitar implementación del plan

#### Para Análisis de Código

1. Ejecutar `opencode`
2. Invocar subagente **Explore**:
   ```
   @explorer ¿Cómo está implementada la autenticación en este proyecto?
   ```
3. Revisar resultados y hacer preguntas de seguimiento

#### Para Tareas Estandarizadas

1. Crear skill para la tarea repetitiva
2. Invocar skill desde el agente:
   ```
   Usa el skill git-release para preparar el próximo release
   ```

### 8.6 Comandos Útiles del TUI

| Comando | Tecla | Descripción |
|---------|-------|-------------|
| `/help` | `Ctrl+x h` | Mostrar ayuda |
| `/new` | `Ctrl+x n` | Nueva sesión |
| `/undo` | `Ctrl+x u` | Deshacer último mensaje |
| `/redo` | `Ctrl+x r` | Rehacer mensaje deshecho |
| `/compact` | `Ctrl+x c` | Compactar contexto |
| `/share` | `Ctrl+x s` | Compartir sesión |
| `/models` | `Ctrl+x m` | Listar modelos disponibles |
| `/themes` | `Ctrl+x t` | Listar temas de UI |
| `/init` | `Ctrl+x i` | Inicializar proyecto |
| `/connect` | - | Conectar proveedor |
| `/exit` | `Ctrl+x q` | Salir de OpenCode |

### 8.7 Validación y Verificación

#### Verificar configuración

```bash
# Ver configuración resuelta
opencode debug config
```

#### Verificar agentes disponibles

Dentro del TUI:
- Presionar `Tab` para ciclar entre agentes primarios
- Usar `@` para ver lista de subagentes disponibles

#### Verificar skills disponibles

Dentro del TUI, preguntar:
```
¿Qué skills están disponibles?
```

O revisar manualmente:
```bash
ls -la .opencode/skills/
ls -la ~/.config/opencode/skills/
```

---

## 9. Comandos Útiles y Referencia

### Comandos de Terminal

```bash
# Iniciar OpenCode en directorio actual
opencode

# Iniciar en directorio específico
opencode /ruta/proyecto

# Ejecutar comando único
opencode run "describe el proyecto"

# Listar modelos disponibles
opencode models

# Ver configuración
opencode debug config

# Crear agente interactivo
opencode agent create
```

### Atajos de Teclado (TUI)

| Tecla | Acción |
|-------|--------|
| `Tab` | Cambiar entre agentes primarios |
| `@` | Mencionar subagente o archivo |
| `!` | Ejecutar comando bash |
| `Ctrl+x h` | Ayuda |
| `Ctrl+x n` | Nueva sesión |
| `Ctrl+x u` | Deshacer |
| `Ctrl+x r` | Rehacer |
| `Ctrl+x s` | Compartir |
| `Ctrl+x q` | Salir |

### Estructura de Directorios Recomendada

```
proyecto/
├── opencode.json           # Configuración principal
├── tui.json                # Configuración de UI (opcional)
├── AGENTS.md               # Contexto del proyecto (generado)
├── .opencode/
│   ├── agents/             # Agentes personalizados
│   │   ├── documentacion.md
│   │   └── code-reviewer.md
│   ├── skills/             # Skills personalizados
│   │   ├── git-release/
│   │   │   └── SKILL.md
│   │   └── analizar-workflow/
│   │       └── SKILL.md
│   └── instructions/       # Instrucciones adicionales
│       └── guidelines.md
└── .skills/
    └── context7/
        └── SKILL.md        # Skill para Context7 API
```

---

## 10. Recursos y Documentación Oficial

### Documentación Principal

| Recurso | URL |
|---------|-----|
| Documentación principal | https://opencode.ai/docs |
| Agentes | https://opencode.ai/docs/agents |
| Skills | https://opencode.ai/docs/skills |
| Configuración | https://opencode.ai/docs/config |
| OpenCode Go | https://opencode.ai/docs/go |
| TUI | https://opencode.ai/docs/tui |
| Permisos | https://opencode.ai/docs/permissions |
| Comandos | https://opencode.ai/docs/commands |

### Context7

| Recurso | Descripción |
|---------|-------------|
| Skill local | `.skills/context7/SKILL.md` |
| API | https://context7.com/api/v2 |

### Comunidad y Soporte

| Recurso | URL |
|---------|-----|
| GitHub | https://github.com/anomalyco/opencode |
| Discord | https://opencode.ai/discord |
| Descargas | https://opencode.ai/download |

---

## Notas Importantes

### Sobre la Información de este Documento

- Este documento se basa en la documentación oficial de OpenCode consultada en abril de 2026
- La información sobre modelos de OpenCode Go puede cambiar; verifica con `/models` en el TUI
- Las URLs de documentación pueden actualizarse; consulta siempre la documentación oficial

### Puntos que Requieren Confirmación

- **Agente orquestador**: OpenCode no define un "orquestador" como agente preconfigurado. La implementación descrita es un patrón recomendado basado en la configuración de permisos `task`.
- **Modelos específicos**: La lista de modelos en Go puede variar; consulta la documentación actual en https://opencode.ai/docs/go

### Convenciones de Este Documento

- **Español de España**: Se ha utilizado la variante europea del español
- **Viñetas y secciones**: Estructura diseñada para escaneo visual rápido
- **Enfoque práctico**: Orientado a la implementación inmediata en el proyecto

---

*Documento generado para el proyecto flujos-meta - Abril 2026*
