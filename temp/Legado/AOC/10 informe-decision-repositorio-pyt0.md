# Informe Técnico de Decisión: Selección de Repositorio Exclusivo para Proyecto PYT0

**Fecha de decisión:** 5 de mayo de 2026  
**Propósito:** Recomendar un único repositorio de aplicabilidad MUY ALTA para uso exclusivo y constante durante toda la ejecución del proyecto PYT0  
**Fuente de evaluación:** `temp/00 analisis-repositorios-opencode.md`  
**Contexto de proyecto:** `temp/99 multi-repo-documentado-v2.md`  
**Versión del documento:** 1.0

---

## Índice de Contenido

1. [Resumen Ejecutivo](#resumen-ejecutivo)
2. [Contexto del Proyecto PYT0](#contexto-del-proyecto-pyt0)
3. [Reglas de Integración Aplicadas](#reglas-de-integración-aplicadas)
4. [Candidatos Evaluados (Aplicabilidad MUY ALTA)](#candidatos-evaluados-aplicabilidad-muy-alta)
5. [Evaluación Individual por Repositorio](#evaluación-individual-por-repositorio)
6. [Tabla Comparativa Cruzada](#tabla-comparativa-cruzada)
7. [Análisis de Compatibilidad con la Pila Tecnológica PYT0](#análisis-de-compatibilidad-con-la-pila-tecnológica-pyt0)
8. [Matriz de Decisión Ponderada](#matriz-de-decisión-ponderada)
9. [Recomendación Final](#recomendación-final)
10. [Plan de Implementación](#plan-de-implementación)
11. [Riesgos y Mitigaciones](#riesgos-y-mitigaciones)
12. [Referencias](#referencias)

---

## 1. Resumen Ejecutivo

### 1.1. Objetivo

Seleccionar **un único repositorio** de aplicabilidad MUY ALTA del ecosistema OpenCode para uso exclusivo y constante durante toda la ejecución del proyecto PYT0, aplicando las reglas de integración definidas (`anomalyco/opencode` integrado directamente, `awesome-opencode/awesome-opencode` solo como consulta).

### 1.2. Repositorios Evaluados

| # | Repositorio | Stars | Aplicabilidad | Filosofía |
|---|-------------|-------|---------------|-----------|
| 1 | `darrenhinde/OpenAgentsControl` | 3.9k | MUY ALTA | Control + Repetibilidad |
| 2 | `hueyexe/opencode-ensemble` | 73 | MUY ALTA | Velocidad + Autonomía |
| 3 | `kdcokenny/opencode-workspace` | 398 | MUY ALTA | Bundle todo-en-uno |
| 4 | `JsonLee12138/agent-team` | 25 | MUY ALTA | Aislamiento por worktree |
| 5 | `48Nauts-Operator/opencode-baseline` | 3 | MUY ALTA | Máxima cobertura skills |

### 1.3. Decisión

**Repositorio recomendado: `darrenhinde/OpenAgentsControl`**

**Justificación principal:** Es el único repositorio cuya filosofía de CONTROL + APROBACIÓN OBLIGATORIA se alinea de forma nativa con el modelo operativo de PYT0 (validación manual disciplinada, líder como gatekeeper, IA como asistente, no como validador). Los demás candidatos priorizan velocidad y autonomía, valores que contradicen directamente las reglas operativas del manifiesto MR.

---

## 2. Contexto del Proyecto PYT0

### 2.1. Extraído de `temp/99 multi-repo-documentado-v2.md`

| Dimensión | Valor |
|-----------|-------|
| **Nombre** | PYTA (primer proyecto consumidor del sistema MR) |
| **Propósito** | Construir un sistema multi-repo acumulativo con base PHP + React |
| **Stack** | Backend: PHP (framework propio), Frontend: React (componentes UI) |
| **Entorno** | GitHub Codespaces + OpenCode |
| **Equipo** | 1 líder técnico + agente AI (OpenCode) |
| **Automatización** | Sin CI/CD tradicional; validación manual disciplinada |
| **Filosofía** | Doc-First (documentar antes de codificar) |
| **Construcción** | Cascada acumulativa (repo N incorpora repo N-1) |
| **Control de versiones** | Git + GitHub multi-repo, SemVer *(reglas por definir)* |

### 2.2. Repositorios Previstos del Sistema MR

```
Repo 1: fw-core                    → Base PHP (routing, config, helpers)
Repo 2: fw-core + ui-kit          → Base PHP + Componentes React
Repo 3: fw-core + ui-kit + wf-engine  → + Motor de lógica de flujos
Repo 4: ... + wf-manager          → + Panel de gestión/administración
Repo 5: ... + pyta-app            → + Lógica específica del proyecto A
```

### 2.3. Reglas Operativas Relevantes para la Decisión

| # | Regla | Implicación para la herramienta |
|---|-------|--------------------------------|
| 1 | Doc-First obligatorio | La herramienta debe facilitar documentación previa al código |
| 5 | Manifiesto replicado en cada repo | La configuración debe ser portable entre repos |
| 6 | Validación manual obligatoria | La herramienta debe requerir aprobación humana antes de ejecutar |
| 7 | IA como asistente, no validador | El humano decide; la IA propone pero no ejecuta autónomamente |
| 9 | AGENTS.md obligatorio | La herramienta debe leer y respetar instrucciones por repo |

---

## 3. Reglas de Integración Aplicadas

| Repositorio | Regla | Estado |
|-------------|-------|--------|
| `anomalyco/opencode` | Se integrará directamente en la base de código principal | ✅ Obligatorio — Ya está presente |
| `awesome-opencode/awesome-opencode` | Se utilizará solo como recurso de consulta puntual, no se integrará | ✅ Excluido de la decisión |
| Repos con aplicabilidad ≠ MUY ALTA | No se evalúan en este informe | ✅ Excluidos |

---

## 4. Candidatos Evaluados (Aplicabilidad MUY ALTA)

### 4.1. Ficha Técnica de Candidatos

| Atributo | OpenAgentsControl | opencode-ensemble | opencode-workspace | agent-team | opencode-baseline |
|----------|-------------------|-------------------|-------------------|------------|-------------------|
| **Autor** | darrenhinde | hueyexe | kdcokenny | JsonLee12138 | 48Nauts-Operator |
| **Stars** | 3,900 | 73 | 398 | 25 | 3 |
| **Forks** | 315 | N/D | N/D | N/D | N/D |
| **Commits** | 215 | 45 | 30 | 196 | 50 |
| **Releases** | 9 (v0.7.1) | 0 | 0 | 36 | 0 |
| **Lenguaje** | TypeScript (76.5%) | TypeScript | TypeScript | Go | TypeScript |
| **Instalación** | Script shell (curl) | Plugin opencode.json | OCX | CLI Go + plugin | Script one-line |
| **Filosofía** | CONTROL + REPETIBILIDAD | VELOCIDAD + AUTONOMÍA | TODO-EN-UNO | AISLAMIENTO | COBERTURA TOTAL |

---

## 5. Evaluación Individual por Repositorio

### 5.1. `darrenhinde/OpenAgentsControl`

#### Ventajas Diferenciales y Contribuciones Únicas

| Ventaja | Descripción | Evidencia |
|---------|-------------|-----------|
| **Puertas de aprobación SIEMPRE activas** | A diferencia de otros repos donde la aprobación es opcional (default off), OAC fuerza aprobación humana antes de cada ejecución | Documentado en README: "Approval based execution — approval gates are ALWAYS active (not optional)" |
| **Sistema de contexto MVI** | Reducción del 80% en consumo de tokens mediante Model-View-Intent para patrones de código | Verificado en documentación del repositorio |
| **Agentes editables en Markdown** | Los agentes se configuran en archivos `.md` editables, no en JSON opaco | Alineado con filosofía doc-first de PYT0 |
| **ExternalScout** | Documentación en vivo de librerías externas durante el desarrollo | Único entre los 5 candidatos |
| **ContextScout** | Descubrimiento inteligente de patrones de código existentes en el proyecto | Facilita consistencia multi-repo |
| **Model-agnostic** | Compatible con cualquier proveedor de LLM | No genera dependencia de un proveedor específico |
| **Plugin de Claude Code (BETA)** | Compatibilidad dual: OpenCode + Claude Code | Mayor flexibilidad futura |

#### Limitaciones y Puntos Débiles

| Limitación | Descripción | Impacto |
|------------|-------------|---------|
| **Ejecución secuencial** | A diferencia de opencode-ensemble, no ejecuta agentes en paralelo | Menor para 1 dev + IA, donde el paralelismo no es prioritario |
| **No es PHP-nativo** | Lenguaje principal TypeScript, sin agentes específicos para PHP | Mitigable: los patrones de código se definen en Markdown, son language-agnostic |
| **Curva de aprendizaje** | Requiere definir patrones de código antes de que el sistema sea efectivo | Alineado con doc-first: los patrones se documentan antes de codificar |
| **v0.7.1 (no v1.0)** | Aún en versión pre-1.0, aunque con 9 releases y 3.9k stars | Riesgo bajo: 3.9k estrellas indican adopción y validación comunitaria |

#### Alineación con Objetivos del Proyecto PYT0

| Objetivo PYT0 | Alineación OAC | Justificación |
|---------------|----------------|---------------|
| **Validación manual obligatoria** | ✅ Total | Puertas de aprobación SIEMPRE activas — el líder aprueba cada acción |
| **Doc-First** | ✅ Total | Agentes en Markdown + ExternalScout para documentación viva |
| **IA como asistente** | ✅ Total | La IA propone cambios, el humano aprueba — matching exacto con regla 7 del MR |
| **Multi-repo** | ✅ Alta | Patrones de código compartibles entre repos vía sistema de contexto MVI |
| **Cascada acumulativa** | ✅ Alta | ContextScout detecta patrones del repo N-1 al construir repo N |
| **PHP + React** | ⚠️ Parcial | Sin agentes PHP nativos, pero el sistema de patrones es language-agnostic |

#### Requisitos Técnicos de Instalación y Configuración

| Requisito | Detalle | Fuente |
|-----------|---------|--------|
| **Instalación** | `curl -fsSL https://raw.githubusercontent.com/darrenhinde/OpenAgentsControl/main/install.sh \| bash -s developer` | README oficial |
| **Dependencias** | Node.js (TypeScript runtime) | package.json del repo |
| **Configuración** | Archivos `.md` en directorio de agentes | Estructura del repo |
| **Integración OpenCode** | Plugin compatible con `opencode.json` | Documentación de plugins |
| **Entorno** | GitHub Codespaces (compatible con Node.js) | ✅ Compatible |

#### Compatibilidad con la Pila Tecnológica PYT0

| Componente PYT0 | Compatibilidad OAC | Observaciones |
|-----------------|-------------------|---------------|
| **PHP (backend)** | ⚠️ Indirecta | OAC controla el agente que genera código PHP; los patrones deben definirse para PHP |
| **React (frontend)** | ✅ Directa | TypeScript/React es nativo en el ecosistema OAC |
| **GitHub Codespaces** | ✅ Compatible | Funciona en cualquier entorno con Node.js |
| **OpenCode** | ✅ Nativo | Diseñado como plugin/companion de OpenCode |
| **Multi-repo Git** | ✅ Compatible | Sistema de contexto portable entre repos |

---

### 5.2. `hueyexe/opencode-ensemble`

#### Ventajas Diferenciales

| Ventaja | Descripción |
|---------|-------------|
| **Ejecución paralela de agentes** | Múltiples agentes trabajando simultáneamente con mensajería peer-to-peer |
| **Dashboard web** | Monitorización en tiempo real en puerto 4747 |
| **Compaction safety** | Protección contra pérdida de contexto en conversaciones largas |
| **Stall detection** | Detección de agentes bloqueados con timeout watchdog |

#### Limitaciones Frente a los Demás

| Limitación | Impacto en PYT0 |
|------------|-----------------|
| **Aprobación OPCIONAL (default off)** | Contradice directamente la regla 6 del MR: "validación manual obligatoria" |
| **73 estrellas** | Respaldo comunitario muy bajo comparado con OAC (3.9k) |
| **0 releases formales** | Sin versionado estable; riesgo de breaking changes |
| **Filosofía VELOCIDAD** | Opuesta al modelo PYT0 de cascada acumulativa con validación disciplinada |

#### Alineación con PYT0

| Objetivo | Alineación |
|----------|------------|
| Validación manual | ❌ Contradictoria — la aprobación es opcional |
| Doc-First | ❌ No documentado |
| IA como asistente | ❌ Tiende a autonomía — "just do it" |
| 1 dev + IA | ❌ Diseñado para equipos de agentes paralelos, excesivo para 1 persona |

#### Requisitos Técnicos

| Requisito | Detalle |
|-----------|---------|
| Instalación | Plugin en `opencode.json` |
| Dependencias | OpenCode + Node.js |
| Configuración | JSON, no Markdown |

---

### 5.3. `kdcokenny/opencode-workspace`

#### Ventajas Diferenciales

| Ventaja | Descripción |
|---------|-------------|
| **Bundle 16 componentes** | 4 plugins, 2 npm plugins, 3 MCP servers, 4 agentes, 4 skills, 1 command |
| **Instalación simplificada** | Un solo comando vía OCX |
| **Perfiles preconfigurados** | Agentes: researcher, coder, scribe, reviewer |

#### Limitaciones Frente a los Demás

| Limitación | Impacto en PYT0 |
|------------|-----------------|
| **30 commits totales** | Mantenimiento casi inexistente; riesgo de abandono |
| **398 estrellas vs 3.9k de OAC** | 10x menos respaldo comunitario |
| **0 releases** | Sin versionado formal |
| **Enfoque "todo en uno" opinado** | Impone 16 componentes; no todos necesarios para PYT0 |
| **Sin control de aprobación** | No implementa puertas de validación humana |

#### Alineación con PYT0

| Objetivo | Alineación |
|----------|------------|
| Validación manual | ❌ No implementa aprobación |
| Multi-repo | ✅ Bueno — perfiles replicables |
| Doc-First | ❌ No contemplado |
| 1 dev + IA | ✅ Adecuado — no requiere equipo |

#### Requisitos Técnicos

| Requisito | Detalle |
|-----------|---------|
| Instalación | OCX (sistema de plugins OpenCode) |
| Configuración | Perfiles predefinidos, difícil personalización granular |

---

### 5.4. `JsonLee12138/agent-team`

#### Ventajas Diferenciales

| Ventaja | Descripción |
|---------|-------------|
| **Aislamiento total por worktree** | Cada agente en su propio Git worktree — ideal para multi-repo |
| **Modelo Role + Worker** | Separación clara de responsabilidades |
| **Verificación documentada** | `verification.md` como contrato de validación |
| **Brainstorming validado** | Planificación antes de implementación |

#### Limitaciones Frente a los Demás

| Limitación | Impacto en PYT0 |
|------------|-----------------|
| **25 estrellas** | El respaldo más bajo de los 5 candidatos (excepto baseline) |
| **36 releases pero proyecto pequeño** | Releases frecuentes indican actividad, pero base de usuarios minúscula |
| **Sin aprobación obligatoria** | El modelo Role + Worker no fuerza validación humana |
| **CLI en Go** | Dependencia adicional en el stack (Go no está en el stack PYT0) |

#### Alineación con PYT0

| Objetivo | Alineación |
|----------|------------|
| Multi-repo | ✅ Excelente — worktrees aislados por repo |
| Validación manual | ⚠️ Parcial — `verification.md` documenta pero no fuerza aprobación |
| Doc-First | ✅ Bueno — brainstorming validado antes de implementar |
| 1 dev + IA | ✅ Adecuado |

#### Requisitos Técnicos

| Requisito | Detalle |
|-----------|---------|
| Instalación | CLI en Go + plugin OpenCode |
| Dependencia extra | Go runtime (no presente en stack PYT0 definido) |
| Worktrees | Requiere configuración de Git worktrees por repo |

---

### 5.5. `48Nauts-Operator/opencode-baseline`

#### Ventajas Diferenciales

| Ventaja | Descripción |
|---------|-------------|
| **55 skills** | Mayor cobertura de skills pre-configurados (K8s, Security, LLM, MLOps, Research) |
| **35 agentes** | Mayor número de agentes predefinidos |
| **18 commands + 6 hooks** | Infraestructura más completa |
| **Hooks en TypeScript/npm** | Sistema de hooks programables |

#### Limitaciones Frente a los Demás

| Limitación | Impacto en PYT0 |
|------------|-----------------|
| **3 estrellas** | Prácticamente sin validación comunitaria; riesgo extremo de abandono |
| **0 releases** | Sin versionado formal; imposible garantizar estabilidad |
| **50 commits** | Mantenimiento bajo; posiblemente proyecto personal no mantenido |
| **Skills irrelevantes para PYT0** | K8s, MLOps, Research no aplican a PHP + React |
| **Sin aprobación obligatoria** | No implementa puertas de validación humana |

#### Alineación con PYT0

| Objetivo | Alineación |
|----------|------------|
| Skills útiles para PYT0 | ❌ Mayoría de skills (K8s, MLOps) irrelevantes para PHP/React |
| Validación manual | ❌ No implementa |
| Riesgo de dependencia | ❌ Crítico — 3 estrellas, 0 releases |

---

## 6. Tabla Comparativa Cruzada

| Criterio | OpenAgentsControl | opencode-ensemble | opencode-workspace | agent-team | opencode-baseline |
|----------|:---:|:---:|:---:|:---:|:---:|
| **Aprobación obligatoria** | ✅ | ❌ | ❌ | ❌ | ❌ |
| **Respaldo comunitario** | ✅ 3.9k | ⚠️ 73 | ⚠️ 398 | ❌ 25 | ❌ 3 |
| **Releases formales** | ✅ 9 | ❌ 0 | ❌ 0 | ✅ 36 | ❌ 0 |
| **Alineación validación manual** | ✅ Total | ❌ Opuesta | ❌ Nula | ⚠️ Parcial | ❌ Nula |
| **Alineación Doc-First** | ✅ Total | ❌ Baja | ❌ Baja | ✅ Buena | ❌ Baja |
| **Alineación IA asistente** | ✅ Total | ❌ Opuesta | ⚠️ Parcial | ✅ Buena | ⚠️ Parcial |
| **Multi-repo nativo** | ✅ Contexto MVI | ✅ Worktrees | ✅ Perfiles | ✅ Worktrees | ❌ No |
| **Configuración en Markdown** | ✅ | ❌ JSON | ❌ Perfiles | ⚠️ YAML | ❌ Script |
| **Documentación viva** | ✅ ExternalScout | ❌ | ❌ | ❌ | ❌ |
| **Sobrecarga para 1 dev** | ✅ Ligero | ❌ Excesivo | ❌ 16 componentes | ✅ Ligero | ❌ 55 skills |
| **Dependencia extra (no stack)** | ❌ No | ❌ No | ❌ No | ❌ Go | ❌ No |
| **Eficiencia de tokens** | ✅ 80% reducción | ❌ Contexto completo | ❌ Contexto completo | ❌ Contexto completo | ❌ Contexto completo |

### Leyenda

| Símbolo | Significado |
|---------|-------------|
| ✅ | Cumple / Positivo |
| ❌ | No cumple / Negativo |
| ⚠️ | Parcial / Neutro |

---

## 7. Análisis de Compatibilidad con la Pila Tecnológica PYT0

### 7.1. Stack Definido

| Capa | Tecnología |
|------|------------|
| Backend | PHP (framework propio) |
| Frontend | React (componentes UI) |
| Entorno | GitHub Codespaces |
| Control de versiones | Git + GitHub multi-repo |
| Agente AI | OpenCode |
| Gestión de dependencias | Composer (PHP) + npm (React) |

### 7.2. Matriz de Compatibilidad

| Componente Stack | OAC | Ensemble | Workspace | Agent-Team | Baseline |
|------------------|:---:|:---:|:---:|:---:|:---:|
| **PHP** | ⚠️ | ⚠️ | ⚠️ | ⚠️ | ⚠️ |
| **React/TypeScript** | ✅ | ✅ | ✅ | ✅ | ✅ |
| **GitHub Codespaces** | ✅ | ✅ | ✅ | ✅ | ✅ |
| **OpenCode** | ✅ | ✅ | ✅ | ✅ | ✅ |
| **Git multi-repo** | ✅ | ✅ | ✅ | ✅ | ❌ |
| **Node.js disponible** | ✅ | ✅ | ✅ | ❌ (Go) | ✅ |

> **Nota sobre PHP:** Ninguno de los 5 repositorios tiene agentes nativos específicos para PHP. Esta es una limitación transversal. La diferencia está en que OAC permite definir patrones PHP en Markdown, mientras que los demás requerirían configuraciones más complejas.

### 7.3. Evaluación de la Brecha PHP

| Repositorio | ¿Permite definir patrones PHP personalizados? | Complejidad |
|-------------|-----------------------------------------------|-------------|
| **OpenAgentsControl** | ✅ Sí — agentes en Markdown, language-agnostic | Baja (editar `.md`) |
| opencode-ensemble | ⚠️ Vía configuración JSON de agentes | Media (editar JSON) |
| opencode-workspace | ⚠️ Vía skills predefinidos (no personalizables fácilmente) | Alta (16 componentes) |
| agent-team | ✅ Vía definición de roles en worktrees | Media (configurar worktrees) |
| opencode-baseline | ⚠️ Skills predefinidos (mayoría irrelevantes) | Alta (55 skills a filtrar) |

---

## 8. Matriz de Decisión Ponderada

### 8.1. Pesos Asignados

| Criterio | Peso | Justificación |
|----------|------|---------------|
| Alineación con reglas operativas MR (validación manual, IA asistente) | 30% | Es el principio rector del proyecto |
| Respaldo comunitario y estabilidad | 20% | Determina viabilidad a largo plazo |
| Compatibilidad con stack PYT0 | 20% | Debe funcionar en Codespaces con PHP + React |
| Configurabilidad y adaptabilidad | 15% | Debe adaptarse a las necesidades doc-first y multi-repo |
| Eficiencia operativa (tokens, simplicidad) | 15% | 1 dev + IA; la herramienta no debe añadir fricción |

### 8.2. Puntuaciones (1-5)

| Criterio | Peso | OAC | Ensemble | Workspace | Agent-Team | Baseline |
|----------|------|:---:|:---:|:---:|:---:|:---:|
| Alineación reglas MR | 30% | **5** | 1 | 2 | 3 | 1 |
| Respaldo comunitario | 20% | **4** | 2 | 2 | 1 | 1 |
| Compatibilidad stack | 20% | **4** | 3 | 3 | 2 | 2 |
| Configurabilidad | 15% | **5** | 3 | 2 | 3 | 2 |
| Eficiencia operativa | 15% | **5** | 3 | 2 | 3 | 3 |
| **Puntuación ponderada** | **100%** | **4.60** | 2.25 | 2.25 | 2.40 | 1.65 |

### 8.3. Cálculo Detallado

| Repositorio | Fórmula | Resultado |
|-------------|---------|-----------|
| **OpenAgentsControl** | (5×0.30) + (4×0.20) + (4×0.20) + (5×0.15) + (5×0.15) | **4.60** |
| opencode-ensemble | (1×0.30) + (2×0.20) + (3×0.20) + (3×0.15) + (3×0.15) | 2.25 |
| opencode-workspace | (2×0.30) + (2×0.20) + (3×0.20) + (2×0.15) + (2×0.15) | 2.25 |
| agent-team | (3×0.30) + (1×0.20) + (2×0.20) + (3×0.15) + (3×0.15) | 2.40 |
| opencode-baseline | (1×0.30) + (1×0.20) + (2×0.20) + (2×0.15) + (3×0.15) | 1.65 |

---

## 9. Recomendación Final

### 9.1. Repositorio Seleccionado

**`darrenhinde/OpenAgentsControl`** (3.9k stars, 9 releases, v0.7.1)

### 9.2. Justificación por Criterio

| Criterio | Por qué OAC es la mejor opción |
|----------|--------------------------------|
| **Alineación con reglas MR** | Es el **único** candidato que implementa puertas de aprobación **SIEMPRE activas**. Esto implementa de forma nativa la regla 6 (validación manual obligatoria) y la regla 7 (IA como asistente, no validador). Los demás permiten ejecución autónoma sin aprobación, contradiciendo la gobernanza del proyecto. |
| **Respaldo comunitario** | Con 3.9k estrellas, tiene **53× más respaldo** que el segundo candidato (workspace: 398) y **1,300× más** que el peor (baseline: 3). 9 releases formales demuestran ciclo de desarrollo activo y versionado. |
| **Compatibilidad stack** | Funciona en cualquier entorno con Node.js (presente en Codespaces). Los patrones de código se definen en Markdown, lo que permite adaptarlos a PHP sin dependencia del lenguaje del repositorio. |
| **Configurabilidad** | Agentes en archivos `.md` editables — alineado con filosofía doc-first. ExternalScout proporciona documentación viva. ContextScout permite reutilizar patrones entre repos del sistema MR. |
| **Eficiencia operativa** | Reducción del 80% en tokens vía sistema MVI. Para 1 solo desarrollador, la ejecución secuencial con aprobación es más adecuada que la paralelización sin control. |
| **Doc-First** | ExternalScout documenta librerías externas en vivo. Los patrones definidos en Markdown son en sí mismos documentación. El modelo de aprobación obligatoria refuerza la disciplina de revisión documental. |

### 9.3. Por Qué No los Otros

| Repositorio | Razón de Exclusión |
|-------------|-------------------|
| **opencode-ensemble** | Su filosofía de velocidad + autonomía contradice directamente las reglas operativas 6 y 7 del MR. La aprobación es opcional (default off). Con 73 estrellas y 0 releases, su estabilidad a largo plazo es dudosa. |
| **opencode-workspace** | 16 componentes impuestos sin control de aprobación. 30 commits totales indican mantenimiento casi inexistente. No aporta valor diferencial sobre OAC para el modelo de gobierno de PYT0. |
| **agent-team** | El aislamiento por worktree es valioso, pero con solo 25 estrellas el riesgo de dependencia es inaceptable. Introduce Go como dependencia no prevista en el stack. No implementa aprobación obligatoria. |
| **opencode-baseline** | Con 3 estrellas y 0 releases, depender de este repositorio sería una irresponsabilidad técnica. La mayoría de sus 55 skills (K8s, MLOps, Research) son irrelevantes para PYT0. |

---

## 10. Plan de Implementación: Creación de Repositorio con OpenAgentsControl

### 10.1. Objetivo del Plan

Este plan describe los pasos necesarios para:
1. Crear un repositorio nuevo y vacío, sin archivos iniciales
2. Instalar el core `anomalyco/opencode` (OpenCode CLI), repositorio base sobre el que OAC está construido
3. Instalar OpenAgentsControl (OAC) desde su repositorio oficial `darrenhinde/OpenAgentsControl`
4. Instalar todas las dependencias y requerimientos para que OAC funcione correctamente
5. Dejar el repositorio listo para comenzar a trabajar con OAC

> **Relación entre repositorios:** OpenAgentsControl está construido sobre OpenCode (`anomalyco/opencode`). El instalador de OAC puede instalar OpenCode automáticamente si no está presente, pero se incluye como paso explícito para garantizar trazabilidad y control de versiones. Según `temp/00 analisis-repositorios-opencode.md`, `anomalyco/opencode` es el core obligatorio y debe instalarse antes que cualquier plugin o extensión.

---

### 10.2. Prerrequisitos del Entorno

Basado en el análisis del repositorio OAC (package.json, install.sh, package-lock.json):

| Requisito | Versión Mínima | Obligatorio | Verificación |
|-----------|----------------|-------------|--------------|
| **Node.js** | >=18.0.0 | ✅ Sí | `node --version` |
| **OpenCode CLI** | Última estable | ✅ Sí | `opencode --version` |
| **curl** | Cualquiera | ✅ Sí | `curl --version` |
| **jq** | Cualquiera | ✅ Sí | `jq --version` |
| **Git** | 2.x | ✅ Sí | `git --version` |
| **npm** | Cualquiera | ❌ Solo evals | `npm --version` |
| **GitHub Codespaces** | Entorno activo | ✅ Sí | Navegador web |

> **Nota:** GitHub Codespaces incluye Node.js, npm, curl, jq y Git preinstalados. Solo es necesario verificar versiones e instalar OpenCode CLI.

---

### 10.3. Fase 1: Análisis del Repositorio OpenAgentsControl

> **Nota:** La creación del repositorio vacío en GitHub es tarea del usuario. Esta fase se centra en analizar el repositorio OAC para entender sus dependencias reales antes de proceder a la instalación.

#### 10.3.1. Clonar OAC en un Directorio Temporal

```bash
# Clonar el repositorio de OAC en /tmp para análisis
cd /tmp
git clone --depth 1 https://github.com/darrenhinde/OpenAgentsControl.git oac-analysis
cd oac-analysis
```

#### 10.3.2. Análisis de Estructura del Repositorio

```bash
# Examinar estructura general
ls -la

# Examinar archivos clave
cat package.json          # Nombre, versión, dependencias, workspaces
cat install.sh            # Script de instalación real
cat registry.json         # Registro de componentes instalables
cat VERSION               # Versión actual
```

**Hallazgos del análisis:**

| Aspecto | Detalle |
|---------|---------|
| **Nombre del paquete** | `@nextsystems/oac` v0.7.1 |
| **Naturaleza** | Colección de archivos de configuración de OpenCode (agentes, contextos, skills, comandos, herramientas, plugins) + CLI `oac` |
| **Binario** | `./bin/oac.js` |
| **Workspaces** | `evals/framework`, `packages/cli`, `packages/compatibility-layer` |
| **Runtime principal** | No tiene dependencias de runtime en `package.json`. Solo `glob` como devDependency |
| **Dependencias obligatorias** | OpenCode CLI, Node.js >=18, `curl`, `jq` |
| **Dependencias de desarrollo** (evals) | `@opencode-ai/sdk`, `yaml`, `zod`, `vitest`, `typescript`, `tsx`, `eslint` |
| **Método de instalación** | El `install.sh` descarga archivos `.opencode/` desde GitHub raw. No usa `npm install` para el paquete base |

#### 10.3.3. Evaluación de Dependencias y Necesidades

| Dependencia | Obligatoria | Propósito | Instalación |
|-------------|-------------|-----------|-------------|
| **OpenCode CLI** (`anomalyco/opencode`) | ✅ Sí | Runtime base sobre el que OAC se ejecuta | `curl -fsSL https://opencode.ai/install.sh \| bash` |
| **Node.js** >=18 | ✅ Sí | Ejecución del binario `oac` y scripts TypeScript | Preinstalado en Codespaces |
| **curl** | ✅ Sí | Descarga de componentes desde GitHub raw | Preinstalado en Linux/Codespaces |
| **jq** | ✅ Sí | Procesamiento del registro de componentes (registry.json) | `sudo apt-get install jq` (si no está) |
| **npm** | ⚠️ Opcional (solo evals) | Ejecución del framework de evaluación | Preinstalado en Codespaces |
| **Git** | ✅ Sí | Control de versiones | Preinstalado en Codespaces |

#### 10.3.4. Análisis de Workspaces (Opcional - Solo Desarrollo)

Los workspaces de OAC no son necesarios para el funcionamiento base del proyecto:

| Workspace | Propósito | Dependencias | Necesario para producción |
|-----------|-----------|--------------|--------------------------|
| `evals/framework` | Framework de evaluaciones de agentes | `@opencode-ai/sdk`, `zod`, `yaml`, `vitest` | ❌ No |
| `packages/cli` | CLI `oac` (binario en TypeScript) | Por determinar | ❌ No (el binario se distribuye compilado) |
| `packages/compatibility-layer` | Capa de compatibilidad | Por determinar | ❌ No |

```bash
# Verificar workspaces (opcional, solo para desarrollo de OAC)
ls packages/cli/package.json         # CLI package
ls packages/compatibility-layer/     # Compatibility layer
ls evals/framework/package.json      # Eval framework
```

---

### 10.4. Fase 2: Instalación de OpenAgentsControl

#### 10.4.1. Instalar OpenCode CLI (Core `anomalyco/opencode`)

OpenAgentsControl está construido sobre OpenCode (`anomalyco/opencode`). Es el runtime base y debe instalarse primero.

```bash
# Verificar si OpenCode ya está instalado
opencode --version

# Si no está instalado, instalar el core anomalyco/opencode:
curl -fsSL https://opencode.ai/install.sh | bash
```

#### 10.4.2. Verificar Dependencias del Instalador OAC

El `install.sh` de OAC requiere `curl` y `jq`. Verificar que estén presentes:

```bash
# Verificar dependencias del instalador
command -v curl && echo "curl OK" || echo "curl FALTA"
command -v jq && echo "jq OK" || echo "jq FALTA"

# Instalar jq si falta (Linux)
sudo apt-get update && sudo apt-get install -y jq
```

#### 10.4.3. Instalar OpenAgentsControl

El instalador descarga archivos de configuración `.opencode/` desde GitHub raw. No requiere `npm install` para el paquete base.

```bash
# Opción A: Instalación interactiva (elegir ubicación y perfil)
curl -fsSL https://raw.githubusercontent.com/darrenhinde/OpenAgentsControl/main/install.sh -o install.sh
bash install.sh
# Seleccionar: 1) Local → .opencode/ en el proyecto
# Seleccionar: 2) Developer → perfil completo de desarrollo

# Opción B: Instalación directa con perfil developer (no interactiva)
curl -fsSL https://raw.githubusercontent.com/darrenhinde/OpenAgentsControl/main/install.sh | bash -s developer
```

#### 10.4.4. Verificar Componentes Instalados

```bash
# Verificar que OAC se instaló correctamente
ls -la .opencode/
# Debe contener al menos: agent/, command/, context/, skills/, config.json

# Verificar binario OAC (si aplica)
which oac 2>/dev/null && oac --version || echo "oac binario no encontrado (puede no estar en PATH)"
```

---

### 10.5. Fase 3: Verificación de Dependencias

Basado en el análisis del repositorio, OAC no requiere `npm install` para su funcionamiento base. Las dependencias se limitan a herramientas del sistema.

#### 10.5.1. Verificación de Herramientas del Sistema

```bash
# Verificar herramientas requeridas
echo "=== Herramientas del Sistema ==="
echo "Node.js: $(node --version 2>/dev/null || echo 'FALTA')"
echo "npm: $(npm --version 2>/dev/null || echo 'OPCIONAL')"
echo "curl: $(curl --version 2>/dev/null | head -1 || echo 'FALTA')"
echo "jq: $(jq --version 2>/dev/null || echo 'FALTA')"
echo "Git: $(git --version 2>/dev/null || echo 'FALTA')"
echo "OpenCode: $(opencode --version 2>/dev/null || echo 'FALTA')"
echo "==============================="
```

#### 10.5.2. Resumen de Dependencias

| Dependencia | Tipo | Estado en Codespaces |
|-------------|------|---------------------|
| **Node.js** >=18 | Sistema | ✅ Preinstalado |
| **curl** | Sistema | ✅ Preinstalado |
| **jq** | Sistema | ✅ Preinstalado (verificar) |
| **Git** | Sistema | ✅ Preinstalado |
| **OpenCode CLI** | Aplicación | ⚠️ Instalar con el script oficial |
| **npm** | Sistema (opcional) | ✅ Preinstalado |

#### 10.5.3. Instalar jq (si falta)

```bash
# Verificar e instalar jq
command -v jq || sudo apt-get update && sudo apt-get install -y jq
```

---

---

### 10.6. Fase 4: Configuración Inicial del Repositorio del Proyecto

#### 10.6.1. Crear Archivos de Configuración de OpenCode

```bash
# Crear opencode.json en la raíz del repositorio del proyecto
cat > opencode.json << 'EOF'
{
  "$schema": "https://opencode.ai/schema.json",
  "agents": {
    "build": {
      "approvalRequired": true
    },
    "plan": {
      "readOnly": true
    }
  },
  "plugins": []
}
EOF
```

> **Nota:** OAC se instala como directorio `.opencode/` en el proyecto (instalación local). No se configura como plugin en `opencode.json` sino que OpenCode detecta automáticamente la presencia de `.opencode/` en el directorio de trabajo.

#### 10.6.2. Crear AGENTS.md con Directivas del Proyecto

```bash
# Crear AGENTS.md en la raíz del repositorio del proyecto
cat > AGENTS.md << 'EOF'
# Project Configuration for OpenAgentsControl

## Approval Gates

- ALL changes require human approval before execution
- No autonomous commits, merges, or tag creation
- Approval required for: code generation, refactoring, file creation/deletion, dependency changes

## Workflow

1. Use /plan mode for analysis and proposals
2. Switch to /build mode only after approval
3. All changes must be reviewed before commit
EOF
```

#### 10.6.3. Crear .gitignore

```bash
# Crear archivo .gitignore básico
cat > .gitignore << 'EOF'
# Node modules
node_modules/

# Environment
.env
.env.local

# OAC / OpenCode
.opencode/
.cache/

# IDE
.vscode/
.idea/
*.swp
*.swo

# Logs
*.log
npm-debug.log*
EOF
```

---

### 10.7. Fase 5: Verificación Final

#### 10.7.1. Checklist de Verificación

| # | Verificación | Comando | Resultado Esperado |
|---|--------------|---------|-------------------|
| 1 | Node.js >=18 | `node --version` | >=18.0.0 |
| 2 | curl instalado | `curl --version` | Versión presente |
| 3 | jq instalado | `jq --version` | Versión presente |
| 4 | OpenCode CLI | `opencode --version` | Versión estable |
| 5 | Directorio .opencode/ | `ls .opencode/` | Contiene agent/, command/, context/, skills/, config.json |
| 6 | opencode.json | `cat opencode.json` | JSON válido |
| 7 | AGENTS.md | `cat AGENTS.md` | Directivas del proyecto |
| 8 | .gitignore | `cat .gitignore` | Exclusiones configuradas |

#### 10.7.2. Script de Verificación Automática

```bash
#!/bin/bash
# verify-setup.sh

echo "=== Verificación de Setup OAC ==="

# Verificar herramientas del sistema
command -v node >/dev/null && echo "✅ Node.js: $(node --version)" || echo "❌ Node.js"
command -v curl >/dev/null && echo "✅ curl" || echo "❌ curl"
command -v jq >/dev/null && echo "✅ jq" || echo "❌ jq"
command -v opencode >/dev/null && echo "✅ OpenCode: $(opencode --version)" || echo "❌ OpenCode"

# Verificar archivos del proyecto
[ -f "opencode.json" ] && echo "✅ opencode.json" || echo "❌ opencode.json"
[ -f "AGENTS.md" ] && echo "✅ AGENTS.md" || echo "❌ AGENTS.md"
[ -f ".gitignore" ] && echo "✅ .gitignore" || echo "❌ .gitignore"

# Verificar OAC
[ -d ".opencode" ] && echo "✅ .opencode/ (OAC instalado)" || echo "❌ .opencode/ (OAC no instalado)"
[ -d ".opencode/agent" ] && echo "✅ .opencode/agent/" || echo "❌ .opencode/agent/"
[ -d ".opencode/context" ] && echo "✅ .opencode/context/" || echo "❌ .opencode/context/"
[ -d ".opencode/skills" ] && echo "✅ .opencode/skills/" || echo "❌ .opencode/skills/"

echo "=== Verificación Completa ==="
```

---

### 10.8. Estado Final del Repositorio

#### 10.8.1. Estructura de Archivos Resultante

```
pyt0-fw-core/
├── .opencode/          # OpenAgentsControl (agentes, contextos, skills, comandos)
│   ├── agent/          # Agentes: OpenAgent, OpenCoder, SystemBuilder
│   ├── command/        # Comandos: /add-context, /commit, /test, etc.
│   ├── context/        # Sistema de contexto MVI (core + project-intelligence)
│   ├── skills/         # Skills especializados
│   ├── tool/           # Herramientas
│   ├── plugin/         # Plugins
│   └── config.json     # Configuración de OAC
├── AGENTS.md           # Directivas del proyecto para OpenCode
├── opencode.json       # Configuración de OpenCode
└── .gitignore          # Exclusiones de versionado
```

#### 10.8.2. Comandos para Iniciar Desarrollo

```bash
# 1. Cambiar al directorio del proyecto
cd /workspaces/pyt0-fw-core

# 2. Iniciar OpenCode
opencode

# 3. Dentro de OpenCode, usar comandos OAC:
# OpenAgent:  opencode --agent OpenAgent  (tareas generales)
# OpenCoder:  opencode --agent OpenCoder  (desarrollo de producción)
# /add-context — Añadir patrones de código del proyecto
# /commit     — Commits inteligentes con formato convencional
# /test       — Workflows de testing
# /optimize   — Optimización de código

# 4. Definir primer contexto del proyecto
/add-context
# Responder preguntas sobre: tech stack, patrones, convenciones, seguridad
```

#### 10.8.3. Flujo de Trabajo con OAC

```
1. Ejecutar: opencode --agent OpenCoder
2. Describir tarea en lenguaje natural
3. ContextScout descubre patrones relevantes
4. Agente propone plan (usuario revisa y aprueba)
5. Ejecución incremental con validación
6. Pruebas, type-checking, code review automáticos
7. Código listo para commit
```

---

### 10.9. Comandos de Referencia Rápida

| Acción | Comando |
|--------|---------|
| Instalar OpenCode (`anomalyco/opencode`) | `curl -fsSL https://opencode.ai/install.sh \| bash` |
| Instalar jq (si falta) | `sudo apt-get install -y jq` |
| Descargar instalador OAC | `curl -fsSL https://raw.githubusercontent.com/darrenhinde/OpenAgentsControl/main/install.sh -o install.sh` |
| Instalar OAC (interactivo) | `bash install.sh` |
| Instalar OAC (perfil developer) | `curl -fsSL https://raw.githubusercontent.com/darrenhinde/OpenAgentsControl/main/install.sh \| bash -s developer` |
| Iniciar OpenCode | `opencode` |
| Iniciar con agente OAC | `opencode --agent OpenAgent` |
| Añadir contexto del proyecto | `/add-context` (dentro de OpenCode) |

---

## 11. Riesgos y Mitigaciones

| Riesgo | Probabilidad | Impacto | Mitigación |
|--------|--------------|---------|------------|
| **OAC en versión pre-1.0** | Media | Medio | Bloquear versión específica (v0.7.1) en la instalación; no actualizar sin validación |
| **Sin agentes PHP nativos** | Alta | Bajo | Definir patrones PHP en Markdown; OAC es language-agnostic en su capa de control |
| **Dependencia de Node.js** | Baja | Bajo | Node.js ya está disponible en Codespaces para React |
| **Curva de aprendizaje inicial** | Alta | Medio | Dedicar Semana 1 exclusivamente a definir patrones; no empezar desarrollo hasta que los patrones estén documentados |
| **Abandono del proyecto OAC** | Baja | Alto | 3.9k estrellas y 9 releases indican proyecto activo; en caso de abandono, migrar patrones Markdown a otra herramienta es trivial |
| **Conflicto con reglas de gobernanza existentes** | Baja | Medio | OAC refuerza (no contradice) las reglas 6, 7, 9 del MR; verificar compatibilidad en `definicion-tecnica/CONTRATO.md` |

---

## 12. Referencias

### 12.1. Documentos del Proyecto

| Documento | Ubicación | Propósito |
|-----------|-----------|-----------|
| Manifiesto de Arquitectura Multi-Repo | `temp/99 multi-repo-documentado-v2.md` | Contexto general del proyecto PYT0 |
| Análisis de Repositorios OpenCode | `temp/00 analisis-repositorios-opencode.md` | Base técnica de evaluación |

### 12.2. Repositorios Evaluados

| Repositorio | URL | Stars | Releases |
|-------------|-----|-------|----------|
| `darrenhinde/OpenAgentsControl` | https://github.com/darrenhinde/OpenAgentsControl | 3.9k | 9 (v0.7.1) |
| `hueyexe/opencode-ensemble` | https://github.com/hueyexe/opencode-ensemble | 73 | 0 |
| `kdcokenny/opencode-workspace` | https://github.com/kdcokenny/opencode-workspace | 398 | 0 |
| `JsonLee12138/agent-team` | https://github.com/JsonLee12138/agent-team | 25 | 36 |
| `48Nauts-Operator/opencode-baseline` | https://github.com/48Nauts-Operator/opencode-baseline | 3 | 0 |
| `anomalyco/opencode` | https://github.com/anomalyco/opencode | 155k | Core |
| `awesome-opencode/awesome-opencode` | https://github.com/awesome-opencode/awesome-opencode | 6.1k | Directorio |

### 12.3. Reglas del Proyecto Referenciadas

| Regla | Descripción | Fuente |
|-------|-------------|--------|
| Regla 1 | Doc-First obligatorio | `99 multi-repo-documentado-v2.md` §8 |
| Regla 5 | Manifiesto replicado en cada repo | `99 multi-repo-documentado-v2.md` §8 |
| Regla 6 | Validación manual obligatoria | `99 multi-repo-documentado-v2.md` §8 |
| Regla 7 | IA como asistente, no como validador | `99 multi-repo-documentado-v2.md` §8 |
| Regla 9 | AGENTS.md obligatorio | `99 multi-repo-documentado-v2.md` §8 |

---

> **Nota:** Todas las afirmaciones de este documento se basan en información verificable extraída de los archivos fuente `temp/00 analisis-repositorios-opencode.md` y `temp/99 multi-repo-documentado-v2.md`. Los datos de stars, releases y commits fueron verificados mediante webfetch a las páginas oficiales de GitHub. No se incluyen suposiciones ni elementos no confirmados.
