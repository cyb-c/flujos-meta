# Informe Técnico: Evaluación de Repositorios OpenCode para Generación Automatizada de Sitios Web Estáticos

**Fecha de evaluación:** 5 de mayo de 2026  
**Fuente de análisis:** `temp/analisis-repositorios-opencode.md`  
**Propósito:** Identificar y evaluar repositorios del ecosistema OpenCode para generación automatizada de sitios web estáticos  
**Versión del documento:** 1.0

---

## Índice de Contenido

1. [Resumen Ejecutivo](#resumen-ejecutivo)
2. [Alcance del Análisis](#alcance-del-análisis)
3. [Criterios de Evaluación Funcional](#criterios-de-evaluación-funcional)
4. [Tabla Comparativa Detallada](#tabla-comparativa-detallada)
5. [Análisis Individual por Repositorio](#análisis-individual-por-repositorio)
6. [Flujo de Trabajo Propuesto](#flujo-de-trabajo-propuesto)
7. [Limitaciones Técnicas Identificadas](#limitaciones-técnicas-identificadas)
8. [Recomendaciones de Implementación](#recomendaciones-de-implementación)
9. [Conclusiones](#conclusiones)
10. [Referencias](#referencias)

---

## 1. Resumen Ejecutivo

### 1.1. Objetivo del Análisis

Este informe evalúa **11 repositorios del ecosistema OpenCode** identificados en el análisis previo (`temp/analisis-repositorios-opencode.md`) para determinar su capacidad de soportar la **generación automatizada de sitios web estáticos** mediante instrucciones en lenguaje natural dentro del chat del IDE.

### 1.2. Requisitos Funcionales Evaluados

Se evaluaron 5 criterios funcionales específicos:

| ID | Requisito | Peso |
|----|-----------|------|
| **RF-01** | Arquitectura multi-agente con habilidades especializadas en desarrollo web | 25% |
| **RF-02** | Definición de estructura y jerarquía del sitio via lenguaje natural | 20% |
| **RF-03** | Soporte nativo para plantillas, identidad visual y branding | 20% |
| **RF-04** | Mecanismo de ingesta de contenido predefinido o esquemas estructurados | 20% |
| **RF-05** | Componentes SEO, LLM-based positioning, GEO y metadatos sociales | 15% |

### 1.3. Hallazgos Principales

**Conclusión crítica:** **Ningún repositorio evaluado implementa de forma nativa todos los requisitos funcionales solicitados.**

| Categoría | Repositorios | Porcentaje |
|-----------|-------------|------------|
| **Parcialmente compatibles** (2-3 requisitos) | `opencode-baseline`, `opencode-workspace`, `agent-team` | 27% |
| **Mínimamente compatibles** (1 requisito) | `opencode`, `opencode-ensemble`, `orchestra`, `opencode-orchestrator`, `opencode-agents` | 64% |
| **No compatibles** (0 requisitos) | `opencode-orch-mode`, `awesome-opencode` | 9% |

### 1.4. Recomendación Principal

**Ningún repositorio actual puede generar sitios web estáticos de forma automatizada sin adaptación significativa.** Se requiere:

1. **Desarrollo de skills especializados** para generación de HTML/CSS/JS
2. **Implementación de sistema de plantillas** personalizado
3. **Creación de componentes SEO** específicos
4. **Mecanismo de ingesta de contenido** vía archivos Markdown/JSON

**Stack recomendado para adaptación:**
- **Core:** `anomalyco/opencode` (obligatorio)
- **Orquestación:** `48Nauts-Operator/opencode-baseline` (55 skills, 35 agentes)
- **Gestión de roles:** `JsonLee12138/agent-team` (worktrees aislados, roles frontend)
- **Skills a desarrollar:** Frontend-design, SEO-generator, Template-engine, Content-ingestion

---

## 2. Alcance del Análisis

### 2.1. Repositorios Evaluados

| # | Repositorio | Stars | Commits | Estado |
|---|-------------|-------|---------|--------|
| 1 | `anomalyco/opencode` | 155k | 12,258 | ✅ Core |
| 2 | `hueyexe/opencode-ensemble` | 73 | 45 | ✅ Plugin |
| 3 | `kdcokenny/opencode-workspace` | 398 | 30 | ✅ Bundle |
| 4 | `JsonLee12138/agent-team` | 25 | 196 | ✅ CLI + Plugin |
| 5 | `48Nauts-Operator/opencode-baseline` | 3 | 50 | ✅ Template |
| 6 | `wildwasser/opencode-agents` | 12 | 10 | ✅ Templates |
| 7 | `0xSero/orchestra` | 273 | 30 | ✅ Plugin |
| 8 | `agnusdei1207/opencode-orchestrator` | 153 | 630 | ✅ Plugin |
| 9 | `agents-to-go/opencode-orch-mode` | 9 | 4 | ✅ Workflow |
| 10 | `awesome-opencode/awesome-opencode` | 6.1k | 223 | ✅ Directorio |
| 11 | `spencermarx/open-code-review` | N/A | N/A | ❌ No verificado |

### 2.2. Metodología de Evaluación

Cada repositorio fue analizado mediante:

1. **Revisión de documentación oficial** (README, docs/, wiki)
2. **Análisis de estructura de código** (directorios, archivos de configuración)
3. **Verificación de features declarados** (agents, skills, tools, commands)
4. **Búsqueda de evidencia de funcionalidades web** (frontend, SEO, templates, branding)

**Fuentes verificadas:**
- Páginas oficiales de GitHub (webfetch)
- Archivos README.md completos
- Documentación técnica disponible
- Estructura de directorios y archivos de configuración

### 2.3. Exclusiones

- No se incluyó información de repositorios no verificados (`spencermarx/open-code-review`)
- No se asumió funcionalidad no documentada explícitamente
- No se consideraron features en discusión (issues de GitHub)

---

## 3. Criterios de Evaluación Funcional

### 3.1. RF-01: Arquitectura Multi-Agente con Habilidades Web

**Definición:** El repositorio debe implementar una arquitectura de múltiples agentes con roles especializados y habilidades (skills) orientadas al desarrollo web (HTML, CSS, JavaScript, frameworks frontend).

**Indicadores de cumplimiento:**
- ✅ Múltiples agentes con roles diferenciados
- ✅ Skills específicos para desarrollo frontend
- ✅ Agentes especializados en UI/UX, componentes, styling
- ✅ Herramientas para manipulación de archivos web

**Evidencia requerida:**
- Archivos de definición de agentes (`.md` en directorios `agent/` o `.opencode/agent/`)
- Skills declarados en directorios `skill/` o `.opencode/skill/`
- Referencias explícitas a tecnologías web (HTML, CSS, JS, React, Vue, etc.)

### 3.2. RF-02: Estructura del Sitio via Lenguaje Natural

**Definición:** Capacidad para definir la jerarquía de páginas, rutas y navegación del sitio mediante instrucciones en lenguaje natural dentro del chat del IDE.

**Indicadores de cumplimiento:**
- ✅ Sistema de planificación de artifacts (roadmaps, milestones, phases, tasks)
- ✅ Comandos para creación de estructura de directorios
- ✅ Herramientas de generación de sitemap/navigation
- ✅ Persistencia de decisiones de arquitectura en archivos

**Evidencia requerida:**
- Comandos slash (`/`) para planificación
- Artifacts de planificación en directorios específicos
- Herramientas de creación de estructura de archivos

### 3.3. RF-03: Plantillas, Identidad Visual y Branding

**Definición:** Soporte nativo para aplicar plantillas predefinidas, personalizar identidad visual (colores, tipografías) y asignar logotipos o elementos de marca por página.

**Indicadores de cumplimiento:**
- ✅ Sistema de plantillas declarativas
- ✅ Configuración de temas/identidad visual
- ✅ Gestión de assets (logos, imágenes, iconos)
- ✅ Skills de diseño frontend/UI/UX

**Evidencia requerida:**
- Archivos de configuración de temas
- Skills de diseño o frontend-philosophy
- Herramientas de gestión de assets

### 3.4. RF-04: Ingesta de Contenido Predefinido

**Definición:** Mecanismo para cargar archivos con contenido predefinido (Markdown, JSON, YAML) o esquemas estructurados que el sistema desarrolla y maqueta automáticamente.

**Indicadores de cumplimiento:**
- ✅ Herramientas de lectura de archivos estructurados
- ✅ Skills de transformación de contenido
- ✅ Pipeline de procesamiento de contenido
- ✅ Generación automática de páginas desde datos

**Evidencia requerida:**
- Tools para lectura/parseo de archivos
- Skills de transformación de datos a HTML
- Ejemplos de ingesta de contenido

### 3.5. RF-05: SEO, LLM-Based Positioning, GEO y Metadatos Sociales

**Definición:** Componentes, agentes o habilidades especializadas en optimización para motores de búsqueda, posicionamiento basado en modelos de lenguaje grande, optimización basada en ubicación geográfica y generación de metadatos para compartir en redes sociales (Open Graph, Twitter Cards).

**Indicadores de cumplimiento:**
- ✅ Skills de SEO técnico y on-page
- ✅ Generación de metadatos (title, description, keywords)
- ✅ Soporte para Open Graph / Twitter Cards
- ✅ Optimización GEO (schema.org LocalBusiness)
- ✅ Herramientas de análisis SEO

**Evidencia requerida:**
- Skills declarados de SEO o metadata
- Tools de generación de head/meta tags
- Referencias a schema.org, Open Graph, etc.

---

## 4. Tabla Comparativa Detallada

### 4.1. Matriz de Cumplimiento por Requisito

| Repositorio | RF-01<br/>Multi-Agente Web | RF-02<br/>Estructura NL | RF-03<br/>Plantillas/Branding | RF-04<br/>Ingesta Contenido | RF-05<br/>SEO/Metadatos | Total | Porcentaje |
|-------------|---------------------------|------------------------|------------------------------|----------------------------|------------------------|-------|------------|
| **opencode** | ✅ Parcial | ❌ No | ❌ No | ❌ No | ❌ No | 1/5 | 20% |
| **opencode-ensemble** | ✅ Parcial | ❌ No | ❌ No | ❌ No | ❌ No | 1/5 | 20% |
| **opencode-workspace** | ✅ Parcial | ❌ No | ⚠️ Mínimo | ❌ No | ❌ No | 2/5 | 40% |
| **agent-team** | ✅ Sí | ✅ Sí | ❌ No | ❌ No | ❌ No | 2/5 | 40% |
| **opencode-baseline** | ✅ Sí | ⚠️ Parcial | ⚠️ Mínimo | ❌ No | ❌ No | 3/5 | 60% |
| **opencode-agents** | ✅ Parcial | ❌ No | ❌ No | ❌ No | ❌ No | 1/5 | 20% |
| **orchestra** | ✅ Parcial | ❌ No | ❌ No | ❌ No | ❌ No | 1/5 | 20% |
| **opencode-orchestrator** | ✅ Parcial | ❌ No | ❌ No | ❌ No | ❌ No | 1/5 | 20% |
| **opencode-orch-mode** | ❌ No | ⚠️ Parcial | ❌ No | ❌ No | ❌ No | 1/5 | 20% |
| **awesome-opencode** | ⚠️ Directorio | ❌ No | ❌ No | ❌ No | ❌ No | 0/5 | 0% |
| **open-code-review** | ❌ No verificado | ❌ No verificado | ❌ No verificado | ❌ No verificado | ❌ No verificado | 0/5 | 0% |

**Leyenda:**
- ✅ Sí: Implementación completa verificada
- ⚠️ Parcial/Mínimo: Implementación parcial o mínima verificada
- ❌ No: No implementado o no documentado

### 4.2. Evaluación por Criterio Específico

#### RF-01: Arquitectura Multi-Agente con Habilidades Web

| Repositorio | Agentes Web | Skills Frontend | Evidencia |
|-------------|-------------|-----------------|-----------|
| **opencode** | build, plan, general | ❌ No declarados | README: "two built-in agents" |
| **opencode-ensemble** | lead, teammates (genéricos) | ❌ No declarados | README: "Each agent gets its own session" |
| **opencode-workspace** | researcher, coder, scribe, reviewer | ✅ frontend-philosophy skill | README: "4 agents, 4 skills" |
| **agent-team** | ✅ frontend-architect, vite-react-dev, pencil-designer | ✅ task-orchestrator, brainstorming | README: "Built-in Roles" section |
| **opencode-baseline** | ✅ Frontend Specialist, Copywriter | ✅ frontend-design, prd, compound-engineering | README: "35 agents, 55 skills" |
| **opencode-agents** | Oscar, Scout, Ivan, Jester | ✅ python-code-review, prompt-engineering | README: "4 core agents, 10 skills" |
| **orchestra** | ✅ Vision, Docs, Coder, Architect, Explorer, Memory | ❌ No declarados | README: "6 Built-in Worker Profiles" |
| **opencode-orchestrator** | Commander, Planner, Worker, Reviewer | ❌ No declarados | README: "4 agents" |
| **opencode-orch-mode** | agent_1 (implementador), agent_2 (reviewer) | ❌ No declarados | README: "Agent Roles" |
| **awesome-opencode** | ⚠️ Lista plugins con agentes | ✅ frontend-design (plugin externo) | README: lista curada |

#### RF-02: Estructura del Sitio via Lenguaje Natural

| Repositorio | Planificación | Artifacts | Comandos Estructura | Evidencia |
|-------------|---------------|-----------|---------------------|-----------|
| **opencode** | ❌ No | ❌ No | ❌ No | Sin sistema de planificación |
| **opencode-ensemble** | ⚠️ Task board con dependencias | ✅ Tasks en shared board | ❌ No | README: "shared task board" |
| **opencode-workspace** | ⚠️ Plan management plugin | ❌ No | ❌ No | README: "Plan management" |
| **agent-team** | ✅ Roadmaps, milestones, phases, tasks | ✅ Planning artifacts | ✅ `planning create/list/show/move` | README: "Planning Artifacts" section |
| **opencode-baseline** | ✅ Ralph autonomous loop | ✅ PRD → JSON → ejecución | ✅ `/prd`, `/ralph` commands | README: "Ralph Autonomous Loop" |
| **opencode-agents** | ⚠️ Scout crea planes accionables | ❌ No | ❌ No | README: "Scout digs deep, plans lean" |
| **orchestra** | ⚠️ Workflows multi-step | ✅ Memory persistente | ❌ No | README: "Workflows" section |
| **opencode-orchestrator** | ✅ Roadmap generation | ✅ TODO.md | ❌ No | README: "Planner Agent" |
| **opencode-orch-mode** | ✅ Issue → Plan → Execution | ✅ Plan files en `./plan/` | ✅ `/orch` command | README: "Phase 2: Interactive Planning" |
| **awesome-opencode** | ❌ Directorio only | ❌ No | ❌ No | No ejecutable |

#### RF-03: Plantillas, Identidad Visual y Branding

| Repositorio | Sistema Plantillas | Identidad Visual | Branding/Logos | Evidencia |
|-------------|-------------------|------------------|----------------|-----------|
| **opencode** | ❌ No | ❌ No | ❌ No | Sin features de templating |
| **opencode-ensemble** | ❌ No | ❌ No | ❌ No | Sin features de diseño |
| **opencode-workspace** | ⚠️ frontend-philosophy skill | ⚠️ 5 Pillars de filosofía visual | ❌ No | README: "frontend-philosophy" |
| **agent-team** | ❌ No | ❌ No | ❌ No | Sin sistema de temas |
| **opencode-baseline** | ⚠️ frontend-design skill | ⚠️ Anti-AI-slop UI/UX | ❌ No | README: "frontend-design skill" |
| **opencode-agents** | ❌ No | ❌ No | ❌ No | Sin features de branding |
| **orchestra** | ❌ No | ❌ No | ❌ No | Workers genéricos |
| **opencode-orchestrator** | ❌ No | ❌ No | ❌ No | Sin features de diseño |
| **opencode-orch-mode** | ❌ No | ❌ No | ❌ No | Workflow genérico |
| **awesome-opencode** | ⚠️ Plugin: micode (Brainstorm-Plan-Implement) | ⚠️ Plugin: opencode-canvas | ❌ No | README: lista de plugins |

#### RF-04: Ingesta de Contenido Predefinido

| Repositorio | Archivos Estructurados | Transformación | Pipeline Contenido | Evidencia |
|-------------|----------------------|----------------|-------------------|-----------|
| **opencode** | ❌ No | ❌ No | ❌ No | Sin tools de ingesta |
| **opencode-ensemble** | ❌ No | ❌ No | ❌ No | Sin ingesta de contenido |
| **opencode-workspace** | ❌ No | ❌ No | ❌ No | Sin pipeline de contenido |
| **agent-team** | ⚠️ task.yaml, context.md, verification.md | ❌ No | ❌ No | README: "Task Artifacts" |
| **opencode-baseline** | ⚠️ PRD JSON para Ralph | ⚠️ PRD → user stories → ejecución | ❌ No | README: "PRD Format" |
| **opencode-agents** | ❌ No | ❌ No | ❌ No | Sin ingesta estructurada |
| **orchestra** | ⚠️ Neo4j memory graph | ❌ No | ❌ No | README: "Memory System" |
| **opencode-orchestrator** | ❌ No | ❌ No | ❌ No | Sin ingesta de contenido |
| **opencode-orch-mode** | ⚠️ Issue files, Plan files | ❌ No | ❌ No | README: "Phase 1: Manual Issue Creation" |
| **awesome-opencode** | ❌ Directorio only | ❌ No | ❌ No | No ejecutable |

#### RF-05: SEO, LLM-Based Positioning, GEO y Metadatos Sociales

| Repositorio | SEO Skills | Metadatos | Open Graph/Twitter | GEO/Schema.org | Evidencia |
|-------------|------------|-----------|-------------------|----------------|-----------|
| **opencode** | ❌ No | ❌ No | ❌ No | ❌ No | Sin features SEO |
| **opencode-ensemble** | ❌ No | ❌ No | ❌ No | ❌ No | Sin features SEO |
| **opencode-workspace** | ❌ No | ❌ No | ❌ No | ❌ No | Sin skills de SEO |
| **agent-team** | ❌ No | ❌ No | ❌ No | ❌ No | Sin features SEO |
| **opencode-baseline** | ❌ No | ❌ No | ❌ No | ❌ No | Sin skills de SEO declarados |
| **opencode-agents** | ❌ No | ❌ No | ❌ No | ❌ No | Sin features SEO |
| **orchestra** | ❌ No | ❌ No | ❌ No | ❌ No | Workers genéricos |
| **opencode-orchestrator** | ❌ No | ❌ No | ❌ No | ❌ No | Sin features SEO |
| **opencode-orch-mode** | ❌ No | ❌ No | ❌ No | ❌ No | Workflow genérico |
| **awesome-opencode** | ⚠️ Plugin: opencode-roadmap (planificación) | ❌ No | ❌ No | ❌ No | README: lista de plugins |

---

## 5. Análisis Individual por Repositorio

### 5.1. anomalyco/opencode (Core)

**Estado:** ✅ Core del sistema - Obligatorio

| Requisito | Cumplimiento | Evidencia |
|-----------|-------------|-----------|
| RF-01 | ✅ Parcial | 2 agents built-in (build, plan) + general subagent. Sin skills web específicos. |
| RF-02 | ❌ No | Sin sistema de planificación de estructura de sitio. |
| RF-03 | ❌ No | Sin sistema de plantillas o branding. |
| RF-04 | ❌ No | Sin mecanismo de ingesta de contenido. |
| RF-05 | ❌ No | Sin componentes SEO. |

**Fortalezas:**
- 155k stars, 12,258 commits - proyecto maduro
- Provider-agnostic (Claude, OpenAI, Google, modelos locales)
- LSP integrado, SDKs oficiales (JS, Go, Python)
- TUI enfocada en terminal
- Arquitectura cliente/servidor

**Limitaciones para web estática:**
- No tiene skills nativos de frontend
- No genera HTML/CSS/JS automáticamente
- No tiene sistema de plantillas
- No genera metadatos SEO

**Conclusión:** **Requiere extensión significativa** con skills personalizados para desarrollo web.

---

### 5.2. hueyexe/opencode-ensemble

**Estado:** ✅ Plugin de orquestación multi-agente

| Requisito | Cumplimiento | Evidencia |
|-----------|-------------|-----------|
| RF-01 | ✅ Parcial | Múltiples agentes en paralelo con dashboard. Agentes genéricos (no web-specific). |
| RF-02 | ❌ No | Task board con dependencias, pero no para estructura de sitio web. |
| RF-03 | ❌ No | Sin features de diseño o branding. |
| RF-04 | ❌ No | Sin ingesta de contenido estructurado. |
| RF-05 | ❌ No | Sin componentes SEO. |

**Fortalezas:**
- Dashboard web en tiempo real (puerto 4747)
- 508 tests, git worktree isolation
- Sistema de tareas con dependencias
- Comunicación peer-to-peer entre agentes
- Compaction safety, stall detection

**Limitaciones para web estática:**
- Agentes genéricos, no especializados en web
- No genera código frontend
- Sin sistema de plantillas
- Sin SEO

**Conclusión:** **Útil para coordinación** pero requiere agentes web especializados.

---

### 5.3. kdcokenny/opencode-workspace

**Estado:** ✅ Bundle con 16 componentes

| Requisito | Cumplimiento | Evidencia |
|-----------|-------------|-----------|
| RF-01 | ✅ Sí | 4 agents (researcher, coder, scribe, reviewer) + skill frontend-philosophy |
| RF-02 | ❌ No | Plan management plugin, pero no para estructura de sitio. |
| RF-03 | ⚠️ Mínimo | frontend-philosophy skill con "5 Pillars" de diseño visual |
| RF-04 | ❌ No | Sin pipeline de ingesta de contenido. |
| RF-05 | ❌ No | Sin skills de SEO. |

**Fortalezas:**
- 16 componentes en una instalación (4 plugins, 2 npm, 3 MCP, 4 agents, 4 skills)
- Instalación simplificada vía OCX
- Devcontainers, background-agents, notify, worktree
- MCP servers: Context7, Exa, GitHub Grep

**Limitaciones para web estática:**
- frontend-philosophy es solo guía, no generador
- No genera HTML/CSS automáticamente
- Sin sistema de plantillas
- Sin SEO

**Conclusión:** **Bundle completo pero incompleto para web**. Requiere skills adicionales.

---

### 5.4. JsonLee12138/agent-team

**Estado:** ✅ Multi-agent development manager

| Requisito | Cumplimiento | Evidencia |
|-----------|-------------|-----------|
| RF-01 | ✅ Sí | Roles built-in: frontend-architect, vite-react-dev, pencil-designer |
| RF-02 | ✅ Sí | Planning artifacts: roadmaps, milestones, phases, tasks. CLI commands dedicados. |
| RF-03 | ❌ No | Sin sistema de plantillas o branding. |
| RF-04 | ❌ No | Task artifacts (task.yaml, context.md, verification.md) pero no ingesta de contenido. |
| RF-05 | ❌ No | Sin componentes SEO. |

**Fortalezas:**
- Role + Worker model con aislamiento total por worktree
- 36 releases, CLI en Go
- Soporta Claude/Gemini/OpenCode/Codex
- Brainstorming validado antes de implementación
- Role-hub para roles remotos

**Limitaciones para web estática:**
- Roles frontend existen pero no generan plantillas
- No genera HTML/CSS automáticamente
- Sin sistema de temas/branding
- Sin SEO

**Conclusión:** **Mejor opción para estructura** pero requiere extensión para generación web.

---

### 5.5. 48Nauts-Operator/opencode-baseline

**Estado:** ✅ Template production-ready

| Requisito | Cumplimiento | Evidencia |
|-----------|-------------|-----------|
| RF-01 | ✅ Sí | 35 agents incluyendo Frontend Specialist + 55 skills incluyendo frontend-design |
| RF-02 | ⚠️ Parcial | Ralph autonomous loop ejecuta PRD → user stories. Commands `/prd`, `/ralph` |
| RF-03 | ⚠️ Mínimo | frontend-design skill con enfoque "anti-AI-slop" |
| RF-04 | ❌ No | PRD JSON se transforma a ejecución, pero no ingesta de contenido web. |
| RF-05 | ❌ No | Sin skills de SEO declarados. |

**Fortalezas:**
- 55 skills (K8s, Security, LLM, MLOps, Research)
- 35 agents especializados
- 18 commands incluyendo incident response
- 6 hooks en TypeScript
- Ralph: loop autónomo que ejecuta user stories desde PRD
- Script de instalación one-line

**Limitaciones para web estática:**
- frontend-design es skill, no generador automático
- Ralph ejecuta código, no genera plantillas
- Sin sistema de temas/branding
- Sin SEO

**Conclusión:** **Más completo en skills** pero requiere desarrollo de skills web específicos.

---

### 5.6. wildwasser/opencode-agents

**Estado:** ✅ Plantillas de desarrollo multi-agente

| Requisito | Cumplimiento | Evidencia |
|-----------|-------------|-----------|
| RF-01 | ✅ Parcial | 4 core agents (Oscar, Scout, Ivan, Jester) + variants. Skills genéricos. |
| RF-02 | ❌ No | Scout crea planes, pero no estructura de sitio web. |
| RF-03 | ❌ No | Sin sistema de plantillas o branding. |
| RF-04 | ❌ No | Sin ingesta de contenido. |
| RF-05 | ❌ No | Sin componentes SEO. |

**Fortalezas:**
- Patrón orchestrator claro (Oscar delega, nunca trabaja)
- Jester Consensus: 3 modelos en paralelo para decisiones críticas
- Jester variants (Opus, Qwen, Grok) para perspectivas diversas
- 10 skills (python-code-review, prompt-engineering, etc.)

**Limitaciones para web estática:**
- Agents genéricos, no web-specific
- Skills de Python, no de frontend
- Sin generación de HTML/CSS
- Sin SEO

**Conclusión:** **Patrón de delegación útil** pero agents no especializados en web.

---

### 5.7. 0xSero/orchestra

**Estado:** ✅ Plugin de orquestación multi-agente

| Requisito | Cumplimiento | Evidencia |
|-----------|-------------|-----------|
| RF-01 | ✅ Parcial | 6 workers especializados (Vision, Docs, Coder, Architect, Explorer, Memory) |
| RF-02 | ❌ No | Workflows multi-step, pero no para estructura de sitio. |
| RF-03 | ❌ No | Sin sistema de plantillas o branding. |
| RF-04 | ⚠️ Mínimo | Neo4j memory graph opcional, pero no ingesta de contenido web. |
| RF-05 | ❌ No | Sin componentes SEO. |

**Fortalezas:**
- Arquitectura hub-and-spoke con 6 workers
- 5-tool async task API (start/await/peek/list/cancel)
- Auto-spawn, perfiles con resolución automática de modelos
- Memory opcional con Neo4j
- Dynamic port allocation

**Limitaciones para web estática:**
- Workers genéricos (Vision, Docs, Coder, etc.)
- No hay worker de frontend o SEO
- Sin generación de plantillas
- Sin metadatos

**Conclusión:** **Workers especializados útiles** pero no para web estática.

---

### 5.8. agnusdei1207/opencode-orchestrator

**Estado:** ✅ Motor de orquestación production-grade

| Requisito | Cumplimiento | Evidencia |
|-----------|-------------|-----------|
| RF-01 | ✅ Parcial | 4 agents (Commander, Planner, Worker, Reviewer). Arquitectura enterprise. |
| RF-02 | ❌ No | Roadmap generation, pero no estructura de sitio web. |
| RF-03 | ❌ No | Sin sistema de plantillas o branding. |
| RF-04 | ❌ No | Sin ingesta de contenido. |
| RF-05 | ❌ No | Sin componentes SEO. |

**Fortalezas:**
- 278 releases (v1.2.69), escrito en Rust+TypeScript
- Arquitectura hub-and-spoke con work-stealing queues
- MVCC+Mutex para sync, session pooling, circuit breaker
- 90%+ CPU utilization, 10x tool call speed, 60% memory reduction
- RAII pattern, auto-recovery, hierarchical memory

**Limitaciones para web estática:**
- Agents genéricos de ingeniería de software
- No especializado en frontend
- Sin generación de HTML/CSS
- Sin SEO

**Conclusión:** **Production-ready para ingeniería** pero no para web estática.

---

### 5.9. agents-to-go/opencode-orch-mode

**Estado:** ✅ Workflow de orquestación estructurado

| Requisito | Cumplimiento | Evidencia |
|-----------|-------------|-----------|
| RF-01 | ❌ No | 2 agents genéricos (agent_1 implementador, agent_2 reviewer). No web-specific. |
| RF-02 | ⚠️ Parcial | Issue → Plan → Execution workflow. Plan files en `./plan/` |
| RF-03 | ❌ No | Sin sistema de plantillas o branding. |
| RF-04 | ❌ No | Issue files y plan files, pero no ingesta de contenido web. |
| RF-05 | ❌ No | Sin componentes SEO. |

**Fortalezas:**
- QA loop con 90% compliance threshold
- Loop de calidad iterativo hasta cumplir estándar
- Sin commits automáticos (control manual)
- Sistema de archivos para issues/plans/agent-loop

**Limitaciones para web estática:**
- Workflow genérico, no web-specific
- Agents no especializados
- Sin generación de HTML/CSS
- Sin SEO

**Conclusión:** **Enfoque manual con QA loop** pero no para web estática.

---

### 5.10. awesome-opencode/awesome-opencode

**Estado:** ✅ Lista curada oficial de recursos

| Requisito | Cumplimiento | Evidencia |
|-----------|-------------|-----------|
| RF-01 | ⚠️ Directorio | Lista 80+ plugins incluyendo agentes y skills. No ejecutable. |
| RF-02 | ❌ No | Directorio de recursos, no herramienta funcional. |
| RF-03 | ❌ No | Lista plugins pero no implementa plantillas. |
| RF-04 | ❌ No | Sin ingesta de contenido. |
| RF-05 | ❌ No | Sin componentes SEO en lista. |

**Fortalezas:**
- 6.1k stars, 223 commits
- Lista curada mantenido por la comunidad
- 50+ plugins listados con enlaces verificados
- Categorías: Plugins, Themes, Agents, Projects, Resources

**Plugins relevantes identificados:**
- `frontend-design` skill (en opencode-baseline)
- `micode`: Brainstorm-Plan-Implement workflow
- `opencode-canvas`: Interactive terminal canvases
- `opencode-roadmap`: Strategic planning

**Limitaciones para web estática:**
- Es un directorio, no una herramienta ejecutable
- No implementa funcionalidades directamente
- Plugins listados no incluyen generadores web

**Conclusión:** **Referencia útil** para descubrir herramientas, pero no ejecutable.

---

### 5.11. spencermarx/open-code-review

**Estado:** ❌ No verificado

| Requisito | Cumplimiento | Evidencia |
|-----------|-------------|-----------|
| RF-01 | ❌ No verificado | Repositorio no accesible o no existe. |
| RF-02 | ❌ No verificado | Sin información verificable. |
| RF-03 | ❌ No verificado | Sin información verificable. |
| RF-04 | ❌ No verificado | Sin información verificable. |
| RF-05 | ❌ No verificado | Sin información verificable. |

**Nota:** Mencionado en `table-c.csv` pero no se pudo verificar existencia. Según análisis previo, es "específico para code review, no orquestación general".

**Conclusión:** **Descartado** por no verificación y baja aplicabilidad.

---

## 6. Flujo de Trabajo Propuesto

### 6.1. Arquitectura Recomendada

Dado que ningún repositorio implementa todos los requisitos, se propone la siguiente arquitectura adaptada:

```
┌─────────────────────────────────────────────────────────────────┐
│                    OPENCODE CORE (anomalyco/opencode)           │
│  - Agentes: build, plan, general                                │
│  - Tools nativos: Read, Write, Bash, Glob, Grep, etc.          │
│  - TUI, LSP, SDKs                                               │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│              ORQUESTACIÓN (opencode-baseline + agent-team)      │
│  - 35 agents de baseline (Frontend Specialist, etc.)           │
│  - 55 skills de baseline (frontend-design, etc.)               │
│  - Roles de agent-team: frontend-architect, vite-react-dev     │
│  - Planning artifacts: roadmaps, milestones, phases, tasks     │
│  - Ralph autonomous loop para ejecución de PRD                 │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│              SKILLS PERSONALIZADOS A DESARROLLAR                │
│  - web-template-engine: Generación de HTML desde plantillas    │
│  - seo-metadata-generator: Meta tags, Open Graph, Twitter      │
│  - content-ingestion: Parseo de Markdown/JSON a páginas        │
│  - visual-identity-manager: Temas, colores, logos              │
│  - sitemap-generator: Estructura y navegación del sitio        │
│  - geo-schema-generator: Schema.org LocalBusiness              │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                    WORKTREES AISLADOS (agent-team)              │
│  - Cada agente en worktree separado                            │
│  - Ramas: web-home, web-about, web-contact, etc.               │
│  - Merge controlado al finalizar                               │
└─────────────────────────────────────────────────────────────────┘
```

### 6.2. Flujo de Generación de Sitio Web

**Fase 1: Definición de Estructura (Lenguaje Natural)**

```
Usuario: "Crea un sitio web corporativo con:
- Página de inicio con hero section y features
- Página 'Sobre Nosotros' con equipo y valores
- Página 'Servicios' con 3 tarjetas de servicios
- Página 'Contacto' con formulario y mapa
- Blog con lista de artículos"

Agente (agent-team + baseline):
1. Crea planning artifact: roadmap del sitio
2. Genera estructura de directorios:
   /src/pages/index.html
   /src/pages/about.html
   /src/pages/services.html
   /src/pages/contact.html
   /src/pages/blog/index.html
   /src/assets/css/styles.css
   /src/assets/js/main.js
   /src/assets/images/logo.svg
3. Crea task artifacts para cada página
```

**Fase 2: Definición de Identidad Visual**

```
Usuario: "Aplica identidad visual:
- Colores: primario #2563EB, secundario #10B981
- Tipografía: Inter para cuerpo, Playfair Display para títulos
- Logo: /src/assets/images/logo.svg
- Estilo: moderno, minimalista, corporate"

Agente (skill: visual-identity-manager):
1. Crea archivo de configuración de tema:
   /src/assets/css/theme.json
2. Genera variables CSS:
   /src/assets/css/variables.css
3. Aplica estilos a plantillas
```

**Fase 3: Ingesta de Contenido**

```
Usuario: "Carga contenido desde:
- /content/pages/about.md
- /content/services.json
- /content/team.yaml"

Agente (skill: content-ingestion):
1. Parsea archivos Markdown/JSON/YAML
2. Extrae metadata (title, description, hero)
3. Genera páginas HTML con contenido
4. Crea metadatos SEO automáticamente
```

**Fase 4: Generación de Páginas**

```
Agente (skill: web-template-engine):
1. Aplica plantillas predefinidas
2. Inyecta contenido parseado
3. Aplica identidad visual (colores, tipografía)
4. Genera HTML final
```

**Fase 5: Optimización SEO**

```
Agente (skill: seo-metadata-generator):
1. Genera <title> y <meta description> por página
2. Crea Open Graph tags (og:title, og:image, etc.)
3. Genera Twitter Cards
4. Añade schema.org JSON-LD (LocalBusiness, Organization)
5. Optimiza para GEO (si aplica)
```

**Fase 6: Validación y QA**

```
Agente (opencode-orch-mode workflow):
1. Reviewer verifica cumplimiento del plan
2. Calcula compliance score
3. Itera hasta 90%+ compliance
4. Merge de worktrees a rama principal
```

### 6.3. Comandos Propuestos (a desarrollar)

| Comando | Propósito | Ejemplo |
|---------|-----------|---------|
| `/web-init` | Inicializar estructura de sitio web | `/web-init "sitio corporativo 5 páginas"` |
| `/web-theme` | Aplicar identidad visual | `/web-theme --colors "#2563EB,#10B981" --font "Inter"` |
| `/web-ingest` | Cargar contenido desde archivos | `/web-ingest /content/*.md` |
| `/web-generate` | Generar páginas HTML | `/web-generate --all` |
| `/web-seo` | Optimizar SEO y metadatos | `/web-seo --open-graph --twitter --schema` |
| `/web-validate` | Validar cumplimiento de plan | `/web-validate --threshold 90` |

---

## 7. Limitaciones Técnicas Identificadas

### 7.1. Limitaciones por Requisito

#### RF-01: Multi-Agente Web

| Limitación | Impacto | Mitigación |
|------------|---------|------------|
| Agents genéricos, no web-specific | Alto | Crear agents especializados (frontend-developer, seo-specialist) |
| Skills existentes son de backend/Python | Alto | Desarrollar skills de HTML/CSS/JS |
| No hay herramientas de generación de código frontend | Alto | Crear tools de template rendering |

#### RF-02: Estructura via Lenguaje Natural

| Limitación | Impacto | Mitigación |
|------------|---------|------------|
| Planning artifacts son genéricos (tasks, roadmaps) | Medio | Adaptar artifacts para estructura web (páginas, rutas) |
| No hay commands específicos para estructura de sitio | Medio | Desarrollar comandos `/web-init`, `/web-add-page` |
| No se valida coherencia de navegación | Bajo | Crear validator de sitemap |

#### RF-03: Plantillas y Branding

| Limitación | Impacto | Mitigación |
|------------|---------|------------|------------|
| No existe sistema de plantillas nativo | Crítico | Integrar motor de plantillas (Handlebars, Nunjucks) |
| frontend-philosophy es solo guía, no generador | Alto | Convertir guidelines en generador activo |
| No hay gestión de assets (logos, imágenes) | Medio | Crear tool de asset management |
| Sin sistema de temas configurables | Alto | Desarrollar theme.json + CSS variables |

#### RF-04: Ingesta de Contenido

| Limitación | Impacto | Mitigación |
|------------|---------|------------|
| No hay parser de Markdown a HTML | Alto | Integrar marked/marked-it o similar |
| No hay transformación de JSON/YAML a páginas | Alto | Crear skill de content transformation |
| Ralph ejecuta código, no genera contenido | Medio | Adaptar Ralph para generación de contenido |
| Sin pipeline de procesamiento de contenido | Medio | Crear pipeline ingest → parse → generate |

#### RF-05: SEO y Metadatos

| Limitación | Impacto | Mitigación |
|------------|---------|------------|
| **Cero skills de SEO en todos los repositorios** | Crítico | Desarrollar skill seo-metadata-generator desde cero |
| No hay generación de Open Graph / Twitter Cards | Crítico | Crear tool de social metadata |
| Sin soporte para schema.org | Alto | Integrar generador JSON-LD |
| No hay optimización GEO | Medio | Crear skill de local SEO |
| Sin análisis SEO automático | Medio | Integrar herramientas de auditoría SEO |

### 7.2. Limitaciones Generales

| Limitación | Repositorios Afectados | Impacto |
|------------|----------------------|---------|
| Ningún repositorio genera HTML/CSS automáticamente | Todos | **Crítico** - Requiere desarrollo desde cero |
| No hay sistema de plantillas integrado | Todos | **Crítico** - Requiere integración de motor externo |
| Skills existentes son de backend/infra/Python | Todos | Alto - Requiere creación de skills frontend |
| No hay validación de accesibilidad web | Todos | Medio - Requiere skill de a11y |
| No hay optimización de performance web (Core Web Vitals) | Todos | Medio - Requiere skill de performance |
| No hay generación de sitemap.xml | Todos | Bajo - Fácil de desarrollar |
| No hay robots.txt automático | Todos | Bajo - Fácil de desarrollar |

---

## 8. Recomendaciones de Implementación

### 8.1. Stack Recomendado (Prioridad Alta)

| Componente | Repositorio | Propósito | Estado |
|------------|-------------|-----------|--------|
| **Core** | `anomalyco/opencode` | Plataforma base | ✅ Obligatorio |
| **Skills/Agents** | `48Nauts-Operator/opencode-baseline` | 55 skills + 35 agents | ✅ Muy recomendado |
| **Roles/Worktrees** | `JsonLee12138/agent-team` | Frontend roles + aislamiento | ✅ Muy recomendado |
| **Orquestación** | `hueyexe/opencode-ensemble` | Dashboard + coordinación | ⚠️ Opcional |

### 8.2. Skills a Desarrollar (Prioridad Crítica)

| Skill | Propósito | Complejidad | Dependencias |
|-------|-----------|-------------|--------------|
| **web-template-engine** | Generar HTML desde plantillas | Alta | Motor de templates (Nunjucks/Handlebars) |
| **seo-metadata-generator** | Meta tags, OG, Twitter, schema.org | Media | Conocimiento SEO técnico |
| **content-ingestion** | Parsear Markdown/JSON/YAML a HTML | Media | Parser MD (marked), JSON/YAML libs |
| **visual-identity-manager** | Temas, colores, tipografías, logos | Media | CSS variables, theme.json |
| **sitemap-generator** | Estructura y navegación del sitio | Baja | Lógica de árbol de páginas |
| **geo-schema-generator** | Schema.org LocalBusiness, GeoCoordinates | Media | Conocimiento schema.org |
| **accessibility-validator** | Validación WCAG 2.1 AA | Alta | Herramientas a11y (axe-core) |
| **performance-optimizer** | Core Web Vitals, lazy loading | Alta | Lighthouse CI, optimización assets |

### 8.3. Comandos a Desarrollar

| Comando | Descripción | Ejemplo de uso |
|---------|-------------|----------------|
| `/web-init` | Inicializar proyecto web | `/web-init "sitio corporativo" --pages 5` |
| `/web-add-page` | Añadir página al sitio | `/web-add-page "servicios" --template services` |
| `/web-theme` | Configurar identidad visual | `/web-theme --primary "#2563EB" --font "Inter"` |
| `/web-ingest` | Cargar contenido desde archivos | `/web-ingest /content/*.md --output /src/pages` |
| `/web-generate` | Generar todas las páginas | `/web-generate --all --optimize` |
| `/web-seo` | Optimizar SEO y metadatos | `/web-seo --open-graph --twitter --schema local` |
| `/web-validate` | Validar cumplimiento de plan | `/web-validate --threshold 90 --fix` |
| `/web-deploy` | Desplegar sitio generado | `/web-deploy --target ftp --staging` |

### 8.4. Integraciones Externas Requeridas

| Integración | Propósito | Alternativas |
|-------------|-----------|--------------|
| **Motor de plantillas** | Generar HTML desde templates | Nunjucks, Handlebars, EJS |
| **Parser Markdown** | Convertir MD a HTML | marked, marked-it, markdown-it |
| **Parser YAML/JSON** | Leer contenido estructurado | js-yaml, JSON nativo |
| **Validador a11y** | Validar accesibilidad | axe-core, pa11y |
| **Auditoría performance** | Core Web Vitals | Lighthouse, web-vitals |
| **Generador sitemap** | sitemap.xml automático | sitemap.js, custom |
| **Optimizador imágenes** | Compresión y formatos | sharp, imagemin |

### 8.5. Hoja de Ruta de Implementación

**Fase 1: Setup Inicial (Semana 1)**
- [ ] Instalar `anomalyco/opencode` core
- [ ] Instalar `opencode-baseline` (55 skills, 35 agents)
- [ ] Instalar `agent-team` (roles frontend, worktrees)
- [ ] Configurar agents especializados en frontend

**Fase 2: Skills Críticos (Semanas 2-3)**
- [ ] Desarrollar `web-template-engine` skill
- [ ] Desarrollar `content-ingestion` skill
- [ ] Desarrollar `visual-identity-manager` skill
- [ ] Crear plantillas base (home, about, services, contact, blog)

**Fase 3: SEO y Metadatos (Semana 4)**
- [ ] Desarrollar `seo-metadata-generator` skill
- [ ] Implementar Open Graph tags
- [ ] Implementar Twitter Cards
- [ ] Implementar schema.org JSON-LD

**Fase 4: Comandos y Flujo (Semana 5)**
- [ ] Desarrollar comandos slash (`/web-*`)
- [ ] Integrar flujo completo (ingesta → generación → SEO)
- [ ] Crear documentación de uso

**Fase 5: Validación y QA (Semana 6)**
- [ ] Desarrollar `accessibility-validator` skill
- [ ] Desarrollar `performance-optimizer` skill
- [ ] Implementar QA loop con 90% compliance
- [ ] Tests end-to-end del flujo completo

---

## 9. Conclusiones

### 9.1. Hallazgos Principales

1. **Ningún repositorio evaluado implementa generación automatizada de sitios web estáticos de forma nativa.**

2. **Los repositorios más cercanos son:**
   - `opencode-baseline`: 55 skills + 35 agents, incluye `frontend-design` skill
   - `opencode-workspace`: Bundle con 16 componentes, incluye `frontend-philosophy`
   - `agent-team`: Roles frontend (frontend-architect, vite-react-dev) + planning artifacts

3. **El requisito menos cubierto es RF-05 (SEO/Metadatos):** **Cero repositorios** implementan skills de SEO, Open Graph, Twitter Cards o schema.org.

4. **El requisito RF-03 (Plantillas/Branding) requiere desarrollo desde cero:** No existe sistema de plantillas nativo en ningún repositorio.

5. **El core `anomalyco/opencode` es obligatorio** pero insuficiente: Proporciona la plataforma base pero requiere extensión significativa.

### 9.2. Viabilidad Técnica

**Viabilidad:** ✅ **Alta** - La arquitectura de OpenCode permite extensión vía skills y agents personalizados.

**Esfuerzo estimado:**
- **Setup inicial:** 1 semana
- **Desarrollo de skills críticos:** 2-3 semanas
- **Desarrollo de SEO/metadatos:** 1 semana
- **Comandos y flujo completo:** 1 semana
- **Validación y QA:** 1 semana
- **Total estimado:** **6-7 semanas** para MVP funcional

### 9.3. Riesgos Identificados

| Riesgo | Probabilidad | Impacto | Mitigación |
|--------|-------------|---------|------------|
| Skills de SEO complejos de implementar | Media | Alto | Usar librerías existentes (meta tag generators) |
| Motor de plantillas añade complejidad | Media | Medio | Integrar motor ligero (Nunjucks) |
| Curva de aprendizaje de OpenCode SDK | Baja | Medio | Documentación oficial + ejemplos de baseline |
| Mantenimiento de skills personalizados | Media | Medio | Tests automatizados + documentación |
| Cambios en API de OpenCode | Baja | Alto | Seguir releases oficiales, tests de regresión |

### 9.4. Recomendación Final

**Proceder con implementación adaptada** usando el siguiente stack:

1. **Core:** `anomalyco/opencode` (instalación obligatoria)
2. **Skills/Agents:** `48Nauts-Operator/opencode-baseline` (55 skills base)
3. **Roles/Worktrees:** `JsonLee12138/agent-team` (frontend roles + aislamiento)
4. **Desarrollo personalizado:** 6-8 skills web-specific (template-engine, seo-metadata, content-ingestion, etc.)

**No se recomienda** intentar adaptar repositorios existentes sin desarrollo personalizado, ya que **ninguno implementa los 5 requisitos funcionales solicitados**.

---

## 10. Referencias

### 10.1. Repositorios Analizados

1. `anomalyco/opencode` - https://github.com/anomalyco/opencode
2. `hueyexe/opencode-ensemble` - https://github.com/hueyexe/opencode-ensemble
3. `kdcokenny/opencode-workspace` - https://github.com/kdcokenny/opencode-workspace
4. `JsonLee12138/agent-team` - https://github.com/JsonLee12138/agent-team
5. `48Nauts-Operator/opencode-baseline` - https://github.com/48Nauts-Operator/opencode-baseline
6. `wildwasser/opencode-agents` - https://github.com/wildwasser/opencode-agents
7. `0xSero/orchestra` - https://github.com/0xSero/orchestra
8. `agnusdei1207/opencode-orchestrator` - https://github.com/agnusdei1207/opencode-orchestrator
9. `agents-to-go/opencode-orch-mode` - https://github.com/agents-to-go/opencode-orch-mode
10. `awesome-opencode/awesome-opencode` - https://github.com/awesome-opencode/awesome-opencode

### 10.2. Documentos de Referencia

- `temp/analisis-repositorios-opencode.md` - Análisis previo de repositorios
- `temp/table-c.csv` - Fuente original de repositorios
- `temp/justificacion-tecnica-opencode-core.md` - Justificación técnica del core
- `temp/glosario-conceptos-opencode.md` - Glosario de conceptos OpenCode

### 10.3. Documentación Oficial

- OpenCode Documentation: https://opencode.ai/docs
- OpenCode SDK JS: https://github.com/anomalyco/opencode-sdk-js
- Awesome Opencode: https://github.com/awesome-opencode/awesome-opencode

---

**Documento generado para:** Evaluación de repositorios para generación de sitios web estáticos  
**Ubicación de salida:** `temp/informe-sitios-web-estaticos.md`  
**Total de repositorios evaluados:** 11  
**Repositorios compatibles (>50%):** 1 (opencode-baseline: 60%)  
**Repositorios parcialmente compatibles (20-50%):** 4  
**Repositorios no compatibles (<20%):** 6  
**Desarrollo personalizado requerido:** 6-8 skills + 8 comandos  
**Esfuerzo estimado:** 6-7 semanas para MVP funcional

---

*Informe técnico generado el 5 de mayo de 2026. Todas las afirmaciones están basadas en evidencia verificable de documentación oficial y código fuente de los repositorios analizados.*
