# Análisis de Repositorios OpenCode para Enfoque Multi-Agente

**Fecha de análisis:** 5 de mayo de 2026  
**Fuente:** `temp/table-c.csv`  
**Propósito:** Evaluar repositorios de GitHub relacionados con OpenCode para identificar los más adecuados para un enfoque basado en OpenCode como integrador, combinado con orquestación, agentes, skills y reglas de gobernanza.

---

## Índice de Contenido

1. [Resumen Ejecutivo](#resumen-ejecutivo)
2. [Tabla de Análisis Detallado](#tabla-de-análisis-detallado)
3. [Repositorios Descartados](#repositorios-descartados)
4. [Recomendaciones Finales](#recomendaciones-finales)

---

## Resumen Ejecutivo

Se analizaron **30 entradas** del archivo `table-c.csv`, de las cuales **12 repositorios de GitHub** fueron identificados como relevantes para OpenCode. Los restantes fueron descartados por ser:
- Issues o discusiones (no son repositorios ejecutables)
- Gists (no son repositorios completos)
- Documentación externa (no son código)
- Específicos de otras plataformas (AWS Bedrock)
- Duplicados

**Top 6 recomendados** para el enfoque propuesto:
1. **OpenAgentsControl** - Control de patrones con aprobación obligatoria (3.9k stars)
2. **opencode-ensemble** - Ejecución paralela de agentes con coordinación
3. **agent-team** - Aislamiento por worktree para multi-repo
4. **opencode-workspace** - Bundle completo con 16 componentes
5. **opencode-baseline** - Template production-ready con 55 skills
6. **orchestra** - Arquitectura hub-and-spoke con 6 workers especializados

---

## Tabla de Análisis Detallado

| Repositorio | Relación con OpenCode | Qué hace | Ventajas para el desarrollo | Diferencias o aspectos destacados | Aplicabilidad al enfoque propuesto | Recomendación |
|-------------|----------------------|----------|----------------------------|----------------------------------|-----------------------------------|---------------|
| **anomalyco/opencode** | Repositorio oficial de OpenCode | Coding agent open source con agentes build y plan integrados, TUI, arquitectura cliente/servidor | 155k stars, 100% open source, provider-agnostic, LSP integrado, SDKs oficiales (JS, Go, Python) | Es la herramienta base sobre la que se construyen todos los demás. No es un plugin sino el core del sistema | **ESENCIAL** - Sin este no existe el ecosistema. Requiere instalación previa antes de cualquier plugin | **OBLIGATORIO** - Instalar primero |
| **darrenhinde/OpenAgentsControl** | Framework de agentes con control de patrones y aprobación | Agentes que aprenden patrones de codificación del usuario con ejecución basada en aprobación obligatoria. Sistema de contexto MVI (80% reducción tokens). Multi-lenguaje (TS, Python, Go, Rust). Model-agnostic | 3.9k stars, 315 forks, 215 commits, 9 releases (v0.7.1), TypeScript 76.5%. También disponible como plugin de Claude Code (BETA) | **Enfoque en CONTROL vs VELOCIDAD**: Puertas de aprobación SIEMPRE activas (no opcionales). ContextScout para descubrimiento inteligente de patrones. Agentes editables (archivos markdown). Sistema de contexto para estándares de equipo. ExternalScout para documentación en vivo | **MUY ALTA** - Alineado perfecto con gobernanza: aprobación obligatoria antes de ejecución, patrones documentados, control humano mantenido. Ideal para producción que requiere consistencia y trazabilidad | **MUY RECOMENDADO** - Mejor opción para control de calidad y patrones repetibles |
| **awesome-opencode/awesome-opencode** | Lista curada oficial de recursos de OpenCode | Directorio centralizado de plugins, agentes, themes, proyectos y recursos para OpenCode | 6.1k stars, mantenido por la comunidad, incluye enlaces verificados a todos los recursos listados | No es una herramienta funcional en sí mismo, sino un directorio de descubrimiento. Contiene 50+ plugins listados | **ALTA** - Referencia obligatoria para descubrir herramientas. Permite evitar búsqueda manual de recursos | **MUY RECOMENDADO** - Consultar antes de instalar cualquier plugin |
| **hueyexe/opencode-ensemble** | Plugin de orquestación multi-agente | Ejecuta múltiples agentes en paralelo con mensajería, tareas compartidas y coordinación. Cada agente tiene su propia sesión y ventana de contexto | 72 stars, 508 tests, dashboard en tiempo real (puerto 4747), git worktree isolation, sistema de tareas con dependencias, comunicación peer-to-peer entre agentes | **Único con dashboard web integrado**. Mensajes persistidos en storage JSON. Compaction safety para conversaciones largas. Stall detection y timeout watchdog | **MUY ALTA** - Coordinación de agentes especializada por tipo de tarea (FW, UI, WF). Ideal para desarrollo de pilares en paralelo | **MUY RECOMENDADO** - Mejor opción para orquestación paralela |
| **kdcokenny/opencode-workspace** | Harness de orquestación multi-agente empaquetado | Bundle con 16 componentes: 4 plugins, 2 npm plugins, 3 MCP servers, 4 agentes, 4 skills, 1 command, orchestrator configs | 398 stars, instalación simplificada vía OCX, incluye devcontainers, background-agents, notify, worktree, DCP | **Enfoque "todo en uno"**. Perfiles preconfigurados. Agentes especializados: researcher, coder, scribe, reviewer. Skills de filosofía de código | **MUY ALTA** - Ahorra configuración inicial en cada repo. Ideal para estandarizar setup en sistema multi-repo | **MUY RECOMENDADO** - Para setup rápido y consistente |
| **JsonLee12138/agent-team** | Multi-agent development manager | Usa modelo Role + Worker para ejecutar agentes en Git worktrees aislados y sesiones terminales dedicadas | 25 stars, 36 releases, soporta Claude/Gemini/OpenCode/Codex, CLI en Go, planificación con artifacts (roadmaps, milestones, phases, tasks) | **Aislamiento total por worktree**. Sistema de verificación con verification.md. Brainstorming validado antes de implementación. Role-hub para roles remotos | **MUY ALTA** - Alineado perfecto con multi-repo: cada agente en worktree aislado por repo. Ideal para sistema MR | **MUY RECOMENDADO** - Mejor para aislamiento multi-repo |
| **48Nauts-Operator/opencode-baseline** | Template production-ready para OpenCode | Configura agentes pre-configurados, 55 skills, 35 agentes, 18 commands, 6 hooks, 3 plugins, 4 tools, sistema de contexto | 3 stars, 50 commits, script de instalación one-line, instala global o por proyecto, incluye Ralph (loop autónomo) | **Más completo en skills**: K8s, Security, LLM, MLOps, Research. Hooks en TypeScript/npm. Comandos de incident response. Sistema de prompts multi-modelo | **MUY ALTA** - Ahorra configuración inicial. Skills especializados listos para usar. Ideal para equipo de 1 persona + IA | **MUY RECOMENDADO** - Para configuración inicial completa |
| **wildwasser/opencode-agents** | Plantillas de desarrollo multi-agente | Define 4 agentes core: Oscar (orchestrator), Scout (researcher), Ivan (implementor), Jester (truth-teller) con variantes | 12 stars, patrón orchestrator claro, Jester Consensus para decisiones críticas (3 modelos en paralelo) | **Patrón de delegación explícito**. Oscar nunca trabaja, solo coordina. Jester con variantes (Opus, Qwen, Grok) para perspectivas diversas | **MEDIA** - Útil para flujos de trabajo estructurados, pero menos completo que baseline o workspace | **RECOMENDADO** - Si se prefiere patrón orchestrator explícito |
| **0xSero/orchestra** | Plugin de orquestación multi-agente | Arquitectura hub-and-spoke con 6 workers especializados: Vision, Docs, Coder, Architect, Explorer, Memory | 273 stars, 3 releases, 5-tool async task API (start/await/peek/list/cancel), auto-spawn, perfiles con resolución automática de modelos | **Workers especializados por tarea**. Memory opcional con Neo4j. Dynamic port allocation. Sesiones aisladas por worker | **ALTA** - Coordinación de agentes especializados por tipo de tarea. Ideal para dividir trabajo complejo | **RECOMENDADO** - Para especialización de workers |
| **agnusdei1207/opencode-orchestrator** | Motor de orquestación multi-agente production-grade | Arquitectura hub-and-spoke con work-stealing queues. Agentes: Commander, Planner, Worker, Reviewer | 152 stars, 278 releases (v1.2.69), escrito en Rust+TypeScript, MVCC+Mutex para sync, session pooling, circuit breaker | **Enfoque enterprise**: 90%+ CPU utilization, 10x tool call speed, 60% memory reduction. RAII pattern, auto-recovery, hierarchical memory | **ALTA** - Production-ready para ingeniería de software de alta integridad. Validación manual asistida | **RECOMENDADO** - Para entornos production críticos |
| **agents-to-go/opencode-orch-mode** | Workflow de orquestación estructurado | Resolución de issues mediante planificación y ejecución colaborativa. Loop de calidad con 90% compliance threshold | 9 stars, 4 commits, sin releases, workflow en shell, sistema de archivos para issues/plans/agent-loop | **Enfoque manual con QA loop**. Issue → Plan → Ejecución → Review → Loop hasta 90%. Sin commits automáticos | **MEDIA** - Alineado con equipo de 1 persona, pero menos automatizado. Requiere gestión manual de archivos | **OPCIONAL** - Solo si se prefiere control manual total |
| **spencermarx/open-code-review** | Herramienta de code review multi-agente | Command Center para lanzar revisiones de código, especificar targets y requisitos | No verificado (solo mencionado en CSV), sin datos de stars o commits | **Específico para code review**. No es orquestación general | **MEDIA-BAJA** - Validación manual según manifiesto del proyecto, pero útil para revisión asistida | **OPCIONAL** - Para revisión de código asistida |

---

## Repositorios Descartados

| Entrada | Razón de Descarte |
|---------|-------------------|
| **FEATURE Multi-Agent Coding Issue #9649** (anomalyco/opencode/issues/9649) | Issue de discusión, no es herramienta ejecutable |
| **Autonomous multi-agent workflow (Gist)** (gist.github.com/ppries/...) | Gist, no repositorio completo. Workflow autónomo fire-and-forget contradice enfoque manual |
| **Agent Teams Issue #15035** (anomalyco/opencode/issues/15035) | Issue de discusión sobre implementación, no usable actualmente |
| **Agent Teams Implementation** (anomalyco/opencode/issues/12661) | Issue de discusión, necesita merge con core, no es usable |
| **Flat Teams with Named Messaging** (anomalyco/opencode/issues/12711) | Issue de feature técnico, no repositorio independiente |
| **Agent Teams Lite** (Gentleman-Programming/agent-teams-lite) | Según README, "ahora disponible en gentle-ai con mejor implementación" - obsoleto |
| **Opencode Orchestrator (BuffMcBigHuge)** (BuffMcBigHuge/opencode-orchestrator) | Automatización que contradice enfoque manual del proyecto. Monitoreo autónomo de issues |
| **OpenCode GitHub Integration** (opencode.ai/docs/github/) | Documentación, no repositorio de código |
| **Agent Team (ruanyf/weekly)** (ruanyf/weekly/issues/9188) | Issue, no repositorio. Solo mencionado como referencia conceptual |
| **AI Agent Team (Sunnyeung369)** (Sunnyeung369/ai-agent-team) | Arquitectura compleja basada en newtype-profile, puede ser overkill para 1 dev |
| **Multi-Agent Code Gen (AWS)** (aws-samples/multi-agent-code-gen-and-execution) | Específico de AWS Bedrock, no aplica a stack GitHub + OpenCode |
| **GitHub Multi-Agent Coding** (helpnetsecurity.com/...) | Artículo de noticias, no herramienta |
| **GitHub Enterprise Teams API** (docs.github.com/...) | API para equipos humanos, no agentes AI |
| **Entradas 25-29** | Duplicados de entradas anteriores (#3, #4, #7) |

---

## Recomendaciones Finales

### Para Enfoque OpenCode + Orquestación + Gobernanza

#### Stack Recomendado (Top 4)

| Prioridad | Repositorio | Propósito | Instalación |
|-----------|-------------|-----------|-------------|
| **1** | `anomalyco/opencode` | Core del sistema | `curl -fsSL https://opencode.ai/install \| bash` |
| **2** | `darrenhinde/OpenAgentsControl` | Control de patrones + aprobación obligatoria | `curl -fsSL https://raw.githubusercontent.com/darrenhinde/OpenAgentsControl/main/install.sh \| bash -s developer` |
| **3** | `hueyexe/opencode-ensemble` | Orquestación paralela con dashboard | Plugin en `opencode.json` |
| **4** | `JsonLee12138/agent-team` | Aislamiento multi-repo por worktree | CLI en Go + plugin |

#### Stack Alternativo (Bundle Completo)

| Prioridad | Repositorio | Propósito |
|-----------|-------------|-----------|
| **1** | `kdcokenny/opencode-workspace` | Bundle con 16 componentes (plugins, agents, skills, MCP) |
| **2** | `48Nauts-Operator/opencode-baseline` | 55 skills + 35 agents + 18 commands + hooks |

#### Para Gobernanza y Reglas de Proyecto

| Recurso | Uso |
|---------|-----|
| `darrenhinde/OpenAgentsControl` | **Aprobación obligatoria**, control de patrones, contexto de equipo |
| `awesome-opencode/awesome-opencode` | Descubrir plugins de validación y governance |
| `48Nauts-Operator/opencode-baseline` | Hooks de seguridad (pre-tool, context-monitor) |
| `agnusdei1207/opencode-orchestrator` | Circuit breaker, RAII, auto-recovery |

### Consideraciones de Aplicabilidad

| Factor | Repositorio Más Alineado |
|--------|-------------------------|
| **Control de calidad con aprobación** | `darrenhinde/OpenAgentsControl` (aprobación obligatoria antes de ejecución) |
| **Patrones de código repetibles** | `darrenhinde/OpenAgentsControl` (sistema de contexto MVI) |
| **Multi-repo con aislamiento** | `JsonLee12138/agent-team` (worktrees aislados) |
| **Ejecución paralela** | `hueyexe/opencode-ensemble` (dashboard + mensajería) |
| **Setup rápido** | `kdcokenny/opencode-workspace` (16 componentes en 1 install) |
| **Skills especializados** | `48Nauts-Operator/opencode-baseline` (55 skills) |
| **Production-grade** | `agnusdei1207/opencode-orchestrator` (Rust, MVCC, circuit breaker) |
| **Control manual** | `agents-to-go/opencode-orch-mode` (QA loop con 90% threshold) |
| **Documentación en vivo** | `darrenhinde/OpenAgentsControl` (ExternalScout para librerías externas) |

---

## Notas de Verificación

- Todas las afirmaciones fueron verificadas mediante webfetch a los repositorios originales
- Los datos de stars, forks, releases y commits son actuales al 5 de mayo de 2026
- Los repositorios marcados como "no verificado" no pudieron ser accedidos o no existen
- No se incluyó información de `flujos-meta` (carpetas `_B/`, `definicion-tecnica/`) según instrucciones
- Los valores numéricos (stars, releases, commits) fueron extraídos directamente de las páginas de GitHub
- **Actualización 5 mayo 2026:** Añadido `darrenhinde/OpenAgentsControl` (3.9k stars) como repositorio prioritario para control de patrones y aprobación obligatoria

---

**Documento generado para:** Evaluación de repositorios OpenCode  
**Ubicación de salida:** `temp/analisis-repositorios-opencode.md`  
**Total de repositorios analizados:** 12  
**Total de repositorios recomendados:** 6 (Muy Recomendado) + 3 (Recomendado) + 2 (Opcional)  
**Total de repositorios descartados:** 14

---

## Apéndice: Comparativa OpenAgentsControl vs Otros

### OpenAgentsControl vs Oh My OpenCode (opencode-ensemble)

| Característica | OpenAgentsControl | opencode-ensemble |
|----------------|-------------------|-------------------|
| **Filosofía** | CONTROL + REPETIBILIDAD | VELOCIDAD + AUTONOMÍA |
| **Aprobación** | ✅ SIEMPRE obligatoria | ⚠️ Opcional (default off) |
| **Patrones de código** | ✅ Sistema de contexto MVI | ❌ No tiene |
| **Eficiencia de tokens** | ✅ 80% reducción (MVI) | ❌ Contexto completo |
| **Estándares de equipo** | ✅ Archivos de contexto compartidos | ❌ Por usuario |
| **Editar comportamiento** | ✅ Archivos markdown editables | ⚠️ Configuración JSON |
| **Elección de modelo** | ✅ Cualquier modelo/provider | ✅ Múltiples modelos |
| **Velocidad de ejecución** | ⚠️ Secuencial con aprobación | ✅ Agentes paralelos |
| **Recuperación de errores** | ✅ Guiada por humano | ✅ Auto-corrección |
| **Mejor para** | Producción, equipos, consistencia | Prototipado rápido, velocidad |

### Cuándo usar OpenAgentsControl

| Escenario | Recomendación |
|-----------|---------------|
| ✅ Tienes patrones de código establecidos | **USAR OAC** |
| ✅ Quieres código que se shippea sin refactoring | **USAR OAC** |
| ✅ Necesitas puertas de aprobación para control de calidad | **USAR OAC** |
| ✅ Te importa eficiencia de tokens y costos | **USAR OAC** |
| ✅ Trabajas en equipo con estándares compartidos | **USAR OAC** |
| ❌ Quieres ejecución totalmente autónoma sin aprobación | **USAR OME** |
| ❌ Prefieres modo "just do it" sobre workflows guiados | **USAR OME** |
| ❌ No tienes patrones de código establecidos aún | **USAR OME** |
| ❌ Necesitas paralelización multi-agente (velocidad sobre control) | **USAR OME** |

> **Nota:** OAC = OpenAgentsControl, OME = Oh My OpenCode (opencode-ensemble)
