# Análisis de Integración de Gobernanza Bajo Directrices OpenCode

## Índice

1. [Objetivo del Análisis](#1-objetivo-del-análisis)
2. [Archivos Revisados](#2-archivos-revisados)
3. [Requisitos de OpenCode Aplicables](#3-requisitos-de-opencode-aplicables)
4. [Evaluación de Compatibilidad entre Reglas Actuales y OpenCode](#4-evaluación-de-compatibilidad-entre-reglas-actuales-y-opencode)
5. [Evaluación Específica de `inventario_recursos.md` como Parte Integrante de las Reglas](#5-evaluación-específica-de-inventario_recursosmd-como-parte-integrante-de-las-reglas)
6. [Riesgos de Separar Inventario y Reglas](#6-riesgos-de-separar-inventario-y-reglas)
7. [Propuesta de Integración Bajo Directrices OpenCode](#7-propuesta-de-integración-bajo-directrices-opencode)
8. [Cambios de Redacción Recomendados](#8-cambios-de-redacción-recomendados)
9. [Reglas que Deberían Mantenerse sin Cambios](#9-reglas-que-deberían-mantenerse-sin-cambios)
10. [Reglas que Deberían Reformularse](#10-reglas-que-deberían-reformularse)
11. [Evaluación de `temp/agente-inventariador.md` y Propuesta de División](#11-evaluación-de-tempagente-inventariadormd-y-propuesta-de-división)
12. [Reglas o Elementos No Compatibles](#12-reglas-o-elementos-no-compatibles)
13. [Recomendación Final Justificada](#13-recomendación-final-justificada)
14. [Guía de Uso del Sistema de Gobernanza OpenCode](#14-guía-de-uso-del-sistema-de-gobernanza-opencode)

---

## 1. Objetivo del Análisis

Evaluar los archivos de `.gobernanza/` para determinar cómo incorporarlos como reglas del proyecto bajo las directrices de OpenCode, aprovechando los mecanismos nativos de la plataforma (`instructions`, `AGENTS.md`, Skills, Agents) y garantizando que `inventario_recursos.md` permanezca como parte integrante e inseparable de las reglas.

El análisis se basa en:
- Contenido real de los archivos de `.gobernanza/`
- Documentación oficial de OpenCode (`opencode.ai/docs/rules`, `opencode.ai/docs/agents`, `opencode.ai/docs/skills`, `opencode.ai/docs/config`)
- Aclaraciones del usuario registradas en `temp/dudas_gobernanza.md`
- Contexto de agentes existentes en `pre-proyecto/agentica/INDICE.md` y `pre-proyecto/agentica/ftp-deployer-agent-spec.md`
- Evaluación de `temp/agente-inventariador.md` para su migración a `.opencode/agents/`

---

## 2. Archivos Revisados

### 2.1. Gobernanza del proyecto

| Archivo | Versión | Líneas | Rol en la Gobernanza |
|---------|---------|--------|----------------------|
| `.gobernanza/reglas_universales.md` | 1.1 | ~319 | Contrato de 14 reglas universales + jerarquía + referencia a versionamiento |
| `.gobernanza/inventario_recursos.md` | 1.1 | ~204 | Plantilla de inventario de recursos (10 secciones, leyenda, reglas de uso) |
| `.gobernanza/inventario_recursos_bitaacora.md` | 1.0 | ~54 | Bitácora de cambios del inventario |
| `.gobernanza/documentacion_tecnica_preventiva.md` | 1.0 | ~111 | Conocimiento técnico para prevenir errores |
| `.gobernanza/politica_versionamiento.md` | 1.0 | (nuevo) | Política de versionamiento extraída de reglas_universales |
| `.gobernanza/notas_cambios.md` | 1.1 | ~196 | Trazabilidad de cambios de la Capa 1 |

### 2.2. Agentes y Skills

| Archivo | Líneas | Rol |
|---------|--------|-----|
| `temp/agente-inventariador.md` | 599 | Agente de gestión de inventario (dual: actualización + auditoría) |
| `.opencode/agents/ftp-deployer.md` | — | Agente de despliegue FTP (ya implementado) |
| `.opencode/skills/context7/SKILL.md` | — | Skill de documentación técnica (movido desde `.skills/`) |
| `.skills/context7/SKILL.md` | 112 | Skill original (se moverá a `.opencode/skills/`) |

### 2.3. Documentación OpenCode consultada

| Recurso | URL |
|---------|-----|
| OpenCode Rules | https://opencode.ai/docs/rules/ |
| OpenCode Agents | https://opencode.ai/docs/agents/ |
| OpenCode Agent Skills | https://opencode.ai/docs/skills/ |
| OpenCode Config | https://opencode.ai/docs/config/ |

---

## 3. Requisitos de OpenCode Aplicables

### 3.1. Mecanismo de Instrucciones (`instructions`)

Las reglas del proyecto se incorporan mediante:
- **`AGENTS.md`** en la raíz del proyecto (instrucciones inline, creado/actualizado por `/init`)
- **Campo `instructions`** en `opencode.json` (referencias a archivos externos, rutas locales o URLs remotas)
- **Combinación:** los archivos listados en `instructions` se combinan con `AGENTS.md`

```json
{
  "instructions": ["CONTRIBUTING.md", "docs/guidelines.md", ".cursor/rules/*.md"]
}
```

### 3.2. Agentes OpenCode

Los agentes se definen como archivos Markdown con YAML frontmatter en `.opencode/agents/<nombre>.md`.

Parámetros clave:

| Parámetro | Descripción |
|-----------|-------------|
| `mode` | `primary`, `subagent`, o `all` |
| `description` | Obligatorio. Breve descripción del agente |
| `model` | Modelo específico para el agente |
| `temperature` | Control de creatividad (0.0-1.0) |
| `permission` | Control granular de permisos por herramienta |
| `prompt` | Ruta a archivo de prompt personalizado |

Formato de permisos:

```yaml
permission:
  read: allow
  edit: deny
  bash: allow
  glob: allow
  grep: allow
  task:
    "*": deny
    "ftp-deployer": allow
```

### 3.3. Skills OpenCode

Los skills se definen como directorios en `.opencode/skills/<nombre>/SKILL.md` con frontmatter YAML.

Requisitos:

| Campo | Requisito |
|-------|-----------|
| `name` | 1-64 caracteres, minúsculas con guiones, coincide con nombre del directorio |
| `description` | 1-1024 caracteres, descripción clara para que el agente elija |

Ubicaciones soportadas (proyecto): `.opencode/skills/`, `.claude/skills/`, `.agents/skills/`

### 3.4. Precedencia y Combinación

- `opencode.json` proyecto → sobreescribe config global → sobreescribe config remota
- Archivos en `instructions` se combinan con `AGENTS.md`
- Skills se cargan bajo demanda mediante la herramienta `skill`

### 3.5. Nomenclatura de Agentes

Según OpenCode Docs:
- El nombre del archivo sin extensión se convierte en el nombre del agente
- Debe coincidir con el `name` interno
- Solo caracteres alfanuméricos minúsculos con guiones
- Sin guiones al inicio/fin ni `--` consecutivo

---

## 4. Evaluación de Compatibilidad entre Reglas Actuales y OpenCode

### 4.1. Tabla de Compatibilidad por Regla

| Regla | Prioridad | Compatible | Observaciones |
|-------|-----------|:----------:|---------------|
| **Regla de Consulta Obligatoria de Inventario** | Crítica | ✅ | Traducible directamente como instrucción en `AGENTS.md` + `instructions` |
| **R1** — No asumir valores no documentados y convención de nombres | Crítica | ✅ | Contenido directamente usable |
| **R2** — Cero hardcoding y validación de variables de entorno | Crítica | ✅ | Contenido directamente usable |
| **R3** — Gestión de secrets y credenciales | Crítica | ✅ | Requiere vincular a `@ftp-deployer` y `@governance-updater` |
| **R5** — Idioma y estilo | Alta | ✅ | Contenido directamente usable |
| **R8** — Configuración de despliegue | Crítica | ✅ | Requiere referencia explícita a `@ftp-deployer` |
| **R10** — Estrategia de pruebas | Alta | ✅ | Contenido directamente usable |
| **R11** — Calidad de código antes de commit | Alta | ✅ | Contenido directamente usable |
| **R12** — Convenciones de commit | Media | ✅ | Contenido directamente usable |
| **R13** — Contratos entre servicios | Media | ✅ | Contenido directamente usable |
| **R14** — Variables de entorno del frontend e inventario actualizado | Alta | ✅ | Requiere referencia a `@governance-updater` y `@governance-auditor` |
| **Jerarquía de Documentos** | — | ✅ | Mecanismo interno |
| **Política de Versionamiento** | — | ✅ | Extraída a documento independiente `.gobernanza/politica_versionamiento.md` |

**Conclusión:** 100% compatible. No hay impedimentos técnicos.

### 4.2. Diagrama de Correspondencia

```
OpenCode                          Gobernanza del Proyecto
─────────                         ──────────────────────
AGENTS.md (raíz)              ─►  Reglas concisas + referencias
                                  (gestionado por /init)

opencode.json instructions    ─►  .gobernanza/reglas_universales.md
                                  .gobernanza/inventario_recursos.md

.opencode/agents/
├── ftp-deployer.md           ─►  Regla R8 (despliegue)
├── governance-updater.md     ─►  R14 + flujo de gobernanza (actualización inventario)
└── governance-auditor.md     ─►  R14 + auditorías de consistencia

.opencode/skills/
├── context7/SKILL.md         ─►  Documentación técnica vía API (movido de .skills/)
└── documentacion-tecnica-    ─►  Extraído de R18 como skill bajo demanda
    preventiva/SKILL.md

_registro_/                   ─►  .gobernanza/inventario_recursos_bitaacora.md
(fuera de .opencode/)              (.gitignore)

.gobernanza/                  ─►  Todos los documentos de gobernanza
├── politica_versionamiento.md     (extraído de reglas_universales)
├── notas_cambios.md               (trazabilidad)
```
---

## 5. Evaluación Específica de `inventario_recursos.md` como Parte Integrante de las Reglas

### 5.1. Dependencia Funcional

`inventario_recursos.md` es referenciado explícitamente por:

| Regla | Referencia |
|-------|------------|
| **Regla de Consulta Obligatoria** | "Todo agente debe consultar `inventario_recursos.md` antes de iniciar cualquier acción relevante" |
| **R1** (obligación 3) | "Consultar `inventario_recursos.md` antes de referenciar cualquier recurso, endpoint o variable" |
| **R1** (obligación 7) | "Los nombres específicos se registran en `inventario_recursos.md`" |
| **R2** (obligación 4) | "Referenciar `inventario_recursos.md` para conocer nombres de variables válidos" |
| **R5** (obligación 2) | "El locale por defecto debe estar documentado en `inventario_recursos.md`" |
| **R13** (obligación 1) | "Registrar contratos en `inventario_recursos.md`" |
| **R14** (obligaciones 3-5) | "Registrar en `inventario_recursos.md` con flag de sensibilidad" |
| **Política de versionamiento** | Referencia cruzada desde `.gobernanza/politica_versionamiento.md` |

**Total de referencias directas: 8 puntos de acoplamiento.**

### 5.2. Naturaleza del Documento

`inventario_recursos.md` es un documento que combina:
- **Metadatos** (versión, finalidad, restricciones)
- **Reglas de uso** (7 reglas operativas sobre qué puede contener)
- **Leyenda de estado** (5 símbolos con significado)
- **Secciones de contenido** (10 tablas para recursos, secrets, variables, etc.)
- **Notas de mantenimiento** (8 reglas de actualización y verificación)

### 5.3. Valoración

El inventario no puede separarse funcionalmente de las reglas porque:
- Las reglas ordenan consultarlo como paso previo obligatorio
- Las reglas ordenan registrar en él valores específicos
- Las reglas ordenan mantenerlo actualizado y verificado
- Es la fuente de verdad que permite ejecutar R1 y R2 (no asumir, no hardcodear)
- **Separándolos, R1 y R2 pierden su herramienta de validación**

---

## 6. Riesgos de Separar Inventario y Reglas (APROBADO)

| Riesgo | Descripción | Severidad | Explicación y Mitigación |
|--------|-------------|:---------:|--------------------------|
| **Reglas huérfanas** | R1 y R2 ordenan consultar inventario pero el inventario deja de ser obligatorio | Alta: **El inventario NUNCA, NUNCA, deja de ser obligatorio.** | **Explicación:** Las reglas R1 y R2 exigen consultar `inventario_recursos.md` como paso previo a cualquier acción. Si el inventario se separara funcionalmente de las reglas, un agente podría cumplir las reglas sin tener el inventario en contexto. **Mitigación:** El inventario se incluye en `opencode.json` → `instructions`, forzando su carga en contexto junto con las reglas. Además, `AGENTS.md` lo referencia explícitamente y los agentes `@governance-updater` y `@governance-auditor` garantizan su actualización y verificación. |
| **Inconsistencia de versiones** | Reglas e inventario desincronizados: un cambio en recursos se refleja en inventario pero no en reglas, o viceversa | Alta | **Explicación:** Las reglas y el inventario evolucionan a ritmos distintos. Las reglas pueden actualizarse (nuevas restricciones, cambios en procesos) mientras el inventario refleja recursos existentes. Si no hay un enlace que fuerce la coherencia, pueden divergir: reglas que referencian secciones del inventario que ya no existen, o inventario con recursos que contradicen las reglas. **Mitigación:** (1) El `REQUIREMENT_ID` en cada regla permite trazabilidad cruzada. (2) `@governance-auditor` verifica que el inventario cumple con lo que las reglas exigen. (3) Las reglas referencian el inventario con rutas explícitas (`.gobernanza/inventario_recursos.md`). (4) El versionado semántico de ambos documentos permite detectar desfases. |
| **Pérdida de la foto instantánea** | Agentes trabajan sin contexto actualizado de recursos porque el inventario no se cargó junto con las reglas | Alta | **Explicación:** El inventario sirve como "foto instantánea" del estado actual del proyecto. Si no se carga automáticamente con las reglas, cada agente debe acordarse de consultarlo por separado, lo que es frágil y propenso a olvidos. Un agente podría empezar a trabajar con información desactualizada o sin conocer los recursos existentes. **Mitigación:** (1) El inventario se carga automáticamente vía `opencode.json` → `instructions`, sin depender de que el agente recuerde consultarlo. (2) `AGENTS.md` incluye la Regla de Consulta Obligatoria como instrucción inline. (3) `@governance-updater` mantiene el inventario actualizado tras cada cambio. (4) `@governance-auditor` verifica periódicamente que el inventario refleja la realidad. |
| **Hardcoding reintroducido** | Sin un lugar único donde consultar, se reintroducen valores asumidos en el código | Media: **El uso del inventario para registrar y consultar dónde está la información es básico, imprescindible y obligatorio.** | **Explicación:** R1 (no asumir) y R2 (cero hardcoding) dependen de que exista una fuente única de verdad contra la cual validar. Si el inventario se separa, se pierde el punto de referencia único. Sin él, cada agente debe buscar la información en múltiples lugares o, peor, inventarla. **Mitigación:** R1 exige detener la acción si un valor no está documentado en el inventario. R2 exige leer toda configuración del inventario. Ambas reglas se refuerzan mutuamente: R1 obliga a consultar, R2 obliga a no hardcodear. `@governance-auditor` detecta valores hardcodeados que deberían estar en el inventario. |
| **Falta de trazabilidad** | Cambios en recursos quedan sin registrar porque no hay un mecanismo que fuerce el registro | Media: **No puede ser posible. Usar `_registro_/inventario_recursos_bitaacora.md` obligatoriamente.** | **Explicación:** Sin un mecanismo que fuerce el registro, los cambios en recursos, variables y configuraciones quedan sin documentación histórica. Esto impide saber qué cambió, cuándo y por qué. **Mitigación:** (1) `@governance-updater` debe registrar TODO cambio en `_registro_/inventario_recursos_bitaacora.md` antes de pasar a la siguiente tarea. (2) Las reglas R14 exigen explícitamente este registro. (3) `@governance-auditor` verifica que la bitácora esté actualizada durante sus auditorías. (4) Las notas de mantenimiento del inventario exigen verificar bitácora antes de cada commit. |

---

## 7. Propuesta de Integración Bajo Directrices OpenCode

### 7.1. Estructura de Archivos Final

```
raíz del proyecto/
│
├── opencode.json                    ← instructions a .gobernanza/ + agentes
├── AGENTS.md                        ← Creado por /init (reglas concisas + referencias)
├── .gitignore                       ← Incluye _registro_/
│
├── .gobernanza/                     ← Directorio canónico de gobernanza (renombrado)
│   ├── reglas_universales.md        ← Referenciado desde instructions (vía opencode.json)
│   ├── inventario_recursos.md       ← Referenciado desde instructions
│   ├── politica_versionamiento.md   ← Extraído de reglas_universales.md (documento independiente)
│   └── notas_cambios.md             ← Trazabilidad interna del equipo
│
├── _registro_/                      ← Fuera de .opencode/.gobernanza
│   └── inventario_recursos_bitaacora.md  ← Bitácora de cambios (.gitignore)
│
├── .opencode/
│   ├── agents/
│   │   ├── ftp-deployer.md          ← Agente de despliegue (R8) — YA EXISTE
│   │   ├── governance-updater.md    ← Agente de actualización de inventario (desde inventariador)
│   │   └── governance-auditor.md    ← Agente de auditoría de inventario (desde inventariador)
│   │
│   └── skills/
│       ├── context7/
│       │   └── SKILL.md             ← Movido desde .skills/context7/SKILL.md
│       └── documentacion-tecnica-preventiva/
│           ├── SKILL.md             ← Definición del skill (frontmatter + breve)
│           └── documentacion_tecnica_preventiva.md  ← Copia maestra (única)
│
└── pre-proyecto/
    └── agentica/
        ├── INDICE.md
        ├── ftp-deployer-agent-spec.md
        └── analisis-integracion-gobernanza-opencode.md  ← (este documento)
```

### 7.2. Configuración de `opencode.json`

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
      "description": "Actualiza el inventario de recursos del proyecto. Unico agente autorizado para modificar .gobernanza/inventario_recursos.md",
      "mode": "subagent",
      "temperature": 0.1,
      "permission": {
        "read": "allow",
        "edit": "allow",
        "write": "allow",
        "glob": "allow",
        "grep": "allow",
        "bash": "allow",
        "skill": "allow",
        "task": "deny",
        "webfetch": "deny"
      }
    },
    "governance-auditor": {
      "description": "Audita la consistencia entre inventario y recursos reales. Solo lectura, no modifica archivos.",
      "mode": "subagent",
      "temperature": 0.1,
      "permission": {
        "read": "allow",
        "glob": "allow",
        "grep": "allow",
        "bash": "allow",
        "edit": "deny",
        "write": "deny",
        "skill": "allow",
        "task": "deny",
        "webfetch": "deny"
      }
    }
  }
}
```

### 7.3. Decisión sobre `AGENTS.md`

**Decisión:** SÍ debe existir un `AGENTS.md` en la raíz.

**Justificación según OpenCode governance:**
- OpenCode recomienda `AGENTS.md` como el mecanismo principal de reglas del proyecto
- El comando `/init` escanea el repositorio y crea/actualiza `AGENTS.md`
- `AGENTS.md` es el primer archivo que OpenCode busca al iniciar sesión (precedencia máxima)
- Los archivos en `instructions` se COMBINAN con `AGENTS.md`, no lo reemplazan

**Propuesta de contenidos de `AGENTS.md`:**

```markdown
# Reglas del Proyecto

Este proyecto sigue reglas de gobernanza detalladas.
Las reglas completas y el inventario de recursos se cargan automáticamente via
opencode.json instructions.

## Reglas Esenciales (resumen)

1. **REQUIREMENT_ID: GOV-PRE** — Consultar inventario antes de cualquier acción.
2. **REQUIREMENT_ID: GOV-R1** — No asumir valores no documentados.
3. **REQUIREMENT_ID: GOV-R2** — Cero hardcoding, toda config de fuentes externas.
4. **REQUIREMENT_ID: GOV-R8** — Despliegue solo via @ftp-deployer.
5. **REQUIREMENT_ID: GOV-R14** — Inventario solo con info verificada.

## Documentos de Referencia

Cargados automáticamente en el contexto:
- .gobernanza/reglas_universales.md
- .gobernanza/inventario_recursos.md

## Agentes del Proyecto

- @ftp-deployer — Despliegue FTP
- @governance-updater — Actualización del inventario
- @governance-auditor — Auditoría de consistencia

## Skills Disponibles

- context7 — Documentación técnica de librerías
- documentacion-tecnica-preventiva — Conocimiento técnico preventivo
```

### 7.4. Mecanismo de Cumplimiento

```
1. OpenCode inicia sesión
2. Carga AGENTS.md (reglas esenciales + referencias)
3. Carga opencode.json → instructions → .gobernanza/reglas_universales.md + inventario_recursos.md
4. Ambas se combinan en contexto del LLM
5. El LLM debe cumplir las reglas y consultar inventario
6. Si necesita conocimiento técnico preventivo → skill tool carga SKILL.md
7. Si necesita desplegar → @ftp-deployer
8. Si necesita actualizar inventario → @governance-updater
9. Si necesita auditoría → @governance-auditor
10. Los cambios en recursos se registran en _registro_/inventario_recursos_bitaacora.md
```

### 7.5. Movimientos de Archivos

| Archivo Origen | Destino | Acción |
|----------------|---------|--------|
| `gobernanza/` (directorio) | `.gobernanza/` | Renombrar |
| `.skills/context7/SKILL.md` | `.opencode/skills/context7/SKILL.md` | Mover |
| `.gobernanza/documentacion_tecnica_preventiva.md` | — | **Eliminar** (única copia en skill) |
| `temp/agente-inventariador.md` | `.opencode/agents/governance-updater.md` + `governance-auditor.md` | Dividir y mover |

### 7.6. Bitácora en `_registro_/`

`inventario_recursos_bitaacora.md` se mueve a `_registro_/` y se añade a `.gitignore`.

---

## 8. Cambios de Redacción Recomendados

### 8.1. Por Obligación Técnica de OpenCode (APROBADO)

| Regla | Cambio | Motivo |
|-------|--------|--------|
| **R8** (obligación 8) | Cambiar "agente de despliegue del repositorio" por "el agente `@ftp-deployer` (definido en `.opencode/agents/ftp-deployer.md`)" | OpenCode necesita nombres de agente concretos para invocación vía `@` o Task |
| **R8** (obligación 9) | Cambiar "otros agentes" por "cualquier otro agente OpenCode distinto de `@ftp-deployer`" | Misma razón: nombres de agente explícitos |
| **R14** (obligación 6) | Cambiar "flujo de gobernanza del proyecto" por "el agente `@governance-updater`" | Vincular a agente concreto |
| **Regla de Consulta Obligatoria** | Añadir: "El incumplimiento será detectado en la siguiente auditoría de `@governance-auditor` y reportado como discrepancia." | Consecuencia definida |

### 8.2. Por Mejora del Cumplimiento (APROBADO)

| Regla | Cambio | Motivo |
|-------|--------|--------|
| **Todas las reglas** | Añadir cabecera `REQUIREMENT_ID: GOV-<ID>` | IDs estandarizados mejoran capacidad del LLM para referenciar reglas específicas |
| **R3** (obligación 2) | "En despliegue: usar secrets gestionados por la plataforma de despliegue. El agente `@ftp-deployer` leerá las credenciales de variables de entorno." | Vincular regla al agente concreto |
| **R14** (obligación 6) | Cambiar por "Ninguna persona o agente distinto de `@governance-updater` debe modificar `.gobernanza/inventario_recursos.md`." | Exclusividad de agente |

### 8.3. Por Mayor Seguimiento Durante el Ciclo de Vida (APROBADO)

| Regla | Cambio | Motivo |
|-------|--------|--------|
| **R14** (nueva) | "Después de cada acción que modifique recursos, `@governance-updater` debe actualizar `_registro_/inventario_recursos_bitaacora.md` antes de continuar." | OpenCode no tiene persistencia entre sesiones; la bitácora es el único mecanismo |
| **Notas de Mantenimiento** | "Antes de cada commit que afecte recursos, verificar que el inventario y la bitácora están actualizados." | Enganchar al ciclo de commits |

---

## 9. Reglas que Deberían Mantenerse sin Cambios

| Regla | Razón |
|-------|-------|
| **R1** (principio y obligaciones 1-4, 6-7) | Contenido universal. Las obligaciones 5 (detener acción) se refuerzan pero no se reformulan |
| **R2** (principio y obligaciones 1-5) | Contenido universal directamente usable |
| **R3** (principio y obligaciones 1, 3-6) | Contenido universal. Solo obligación 2 requiere mención a `@ftp-deployer` |
| **R5** | Contenido universal |
| **R10** | Contenido universal |
| **R11** | Contenido universal |
| **R12** | Contenido universal |
| **R13** | Contenido universal |
| **Jerarquía de Documentos** | Mecanismo interno |
| **Reglas de Uso del inventario** (7 reglas) | Contenido universal |
| **Leyenda de Estado** (5 símbolos) | Contenido universal |

---

## 10. Reglas que Deberían Reformularse (APROBADO)

| Regla | Cambio Necesario | Prioridad |
|-------|------------------|:---------:|
| **R8** (obligaciones 8-9) | Referencia explícita a `@ftp-deployer` como único agente de despliegue | Alta |
| **R3** (obligación 2) | Vincular a `@ftp-deployer` para gestión de secrets en despliegue | Alta |
| **R14** (obligación 6) | "Ningún agente distinto de `@governance-updater` puede modificar el inventario" | Alta |
| **Regla de Consulta Obligatoria** | Añadir consecuencia: reporte de discrepancia por `@governance-auditor` | Media |
| **Todas las reglas** | Añadir `REQUIREMENT_ID: GOV-<ID>` estandarizado | Baja |
| **R14** (nueva obligación) | Actualizar bitácora antes de pasar a siguiente tarea | Alta |
| **Notas de Mantenimiento** | Verificar inventario y bitácora antes de cada commit | Media |
| **Reglas universales** | Eliminar "Política de Versionamiento" del cuerpo. Referenciar `.gobernanza/politica_versionamiento.md` | Alta |

---

## 11. Evaluación de `temp/agente-inventariador.md` y Propuesta de División (APROBADO)

### 11.1. Análisis del Agente Original

`temp/agente-inventariador.md` (599 líneas) es un agente con responsabilidad dual:

| Modo | Función | Permisos Requeridos |
|------|---------|---------------------|
| **Normal (Actualización)** | Modificar `inventario_recursos.md`: crear, editar, eliminar entradas | read, write, edit, bash |
| **Auditor (Vigilancia)** | Escanear archivos y contrastar contra inventario SIN modificar | read, glob, grep, bash (pero NO write/edit) |

### 11.2. Problemas de Compatibilidad OpenCode

| Problema | Descripción | Solución |
|----------|-------------|----------|
| **Frontmatter `tools`** | Usa campo `tools` (deprecado) en lugar de `permission` | Migrar a `permission` |
| **Frontmatter `model`** | `model: sonnet` no es formato OpenCode | Cambiar a `model: anthropic/claude-sonnet-4-20250514` o no especificar |
| **Frontmatter `permissionMode`** | No es un campo OpenCode reconocido | Eliminar |
| **Falta `mode`** | No especifica si es `subagent` o `primary` | Añadir `mode: subagent` |
| **Dualidad permisos** | Modo auditor requiere menos permisos que modo normal | No es separable limpiamente en un solo agente |
| **Invocación `--auditor`** | Patrón no estándar; OpenCode usa `@nombre-agente` | Dos agentes separados |
| **Refs a `reglas_proyecto.md`** | Nombre antiguo | Cambiar a `.gobernanza/reglas_universales.md` |
| **Refs a `.roo/skills/`** | Ruta antigua de Context7 | Cambiar a `.opencode/skills/context7/SKILL.md` |
| **Refs a Prisma/Vercel/Docker** | Contenido específico del proyecto original | Eliminar; el inventario debe ser agnóstico |

### 11.3. Decisión: Dividir en 2 Agentes

**Decisión: DIVIDIR en 2 agentes OpenCode separados.**

**Justificación basada en OpenCode Docs:**

| Criterio | Un solo agente | Dos agentes separados |
|----------|:--------------:|:---------------------:|
| Especialización (OpenCode recomienda agentes enfocados) | ❌ Hace dos cosas distintas | ✅ Cada uno hace una cosa |
| Permisos (principio de mínimo privilegio) | ❌ El modo auditor necesitaría permisos de escritura que no usa | ✅ `governance-auditor` no tiene write/edit |
| Claridad de invocación (`@nombre`) | ❌ `@inventariador --auditor` no es intuitivo | ✅ `@governance-auditor` es explícito |
| Mantenibilidad | ❌ 599 líneas con dos flujos entremezclados | ✅ ~200 líneas cada uno, más simples |
| Separación de responsabilidades | ❌ Un bug en actualización podría afectar auditoría | ✅ Aislados |

### 11.4. Propuesta de los 2 Agentes

#### Agente 1: `@governance-updater`

**Archivo:** `.opencode/agents/governance-updater.md`

```markdown
---
name: governance-updater
description: >
  Actualiza el inventario de recursos del proyecto.
  Unico agente autorizado para modificar .gobernanza/inventario_recursos.md
mode: subagent
temperature: 0.1
permission:
  read: allow
  write: allow
  edit: allow
  glob: allow
  grep: allow
  bash: allow
  skill: allow
  task: deny
  webfetch: deny
---

Eres el agente responsable de mantener actualizado
.gobernanza/inventario_recursos.md como fuente única de verdad.

## Reglas obligatorias
1. Eres el UNICO agente autorizado para modificar el inventario.
2. Nunca inventes valores. Si falta información, reporta el vacío.
3. No incluyas secretos ni credenciales (solo nombres).
4. El inventario solo contiene información real, existente y verificada.
5. Todo cambio debe registrarse en _registro_/inventario_recursos_bitaacora.md.
6. Los cambios críticos requieren aprobación explícita del usuario.
7. Usa el skill context7 para verificar documentación oficial cuando sea necesario.

## Cuándo ejecutarte
Ejecútate cuando:
- Se haya creado, modificado o eliminado un recurso del proyecto
- Se haya añadido o cambiado una variable de entorno
- Se haya modificado la configuración de despliegue
- El usuario o el agente orquestador lo solicite explícitamente

## Obligatoriedad
Es OBLIGATORIO ejecutar una actualización del inventario:
- Después de crear, modificar o eliminar cualquier recurso
- Antes de un commit que afecte configuración o recursos
- Después de un despliegue

## Flujo de trabajo
1. Recibir solicitud o detectar cambio
2. Solicitar evidencia del cambio al agente ejecutor
3. Verificar la evidencia
4. Solicitar aprobación del usuario (si es cambio crítico)
5. Actualizar .gobernanza/inventario_recursos.md
6. Registrar en _registro_/inventario_recursos_bitaacora.md
7. Reportar resumen estructurado

## Cambio crítico (requiere aprobación)
- Eliminación de recursos de infraestructura
- Modificación de endpoints en uso
- Cambio de credenciales o secrets
- Cambios en configuración de producción
- Modificación de contratos entre servicios
```

#### Agente 2: `@governance-auditor`

**Archivo:** `.opencode/agents/governance-auditor.md`

```markdown
---
name: governance-auditor
description: >
  Audita la consistencia entre el inventario de recursos y los recursos reales
  del proyecto. Solo lectura, no modifica archivos.
mode: subagent
temperature: 0.1
permission:
  read: allow
  glob: allow
  grep: allow
  bash: allow
  edit: deny
  write: deny
  skill: allow
  task: deny
  webfetch: deny
---

Eres el agente responsable de auditar la consistencia entre
.gobernanza/inventario_recursos.md y los recursos reales del proyecto.

## Reglas obligatorias
1. NO modifiques ningun archivo. Eres solo lectura.
2. NO actualices el inventario directamente (eso corresponde a @governance-updater).
3. Genera siempre un reporte estructurado de las discrepancias encontradas.
4. Incluye evidencia de cada discrepancia.
5. Usa el skill context7 para verificar documentación oficial si es necesario.

## Clasificación de discrepancias
| Tipo | Descripción |
|------|-------------|
| No Documentada | Recurso existe en código/plataforma pero NO en inventario |
| No Configurada | Esta en inventario pero NO existe en el recurso real |
| Inconsistente | El valor documentado difiere del real |
| Recurso Huerfano | Existe en código pero no en inventario |
| Recurso Fantasma | Esta en inventario pero no en código |

## Cuándo ejecutarte (obligatorio)
Ejecuta una auditoría cuando:
- El usuario te invoque explícitamente (@governance-auditor)
- Antes de un despliegue a producción (OBLIGATORIO)
- Cuando hay errores de variables no encontradas (OBLIGATORIO)
- Después de agregar nuevas variables de entorno (RECOMENDADO)
- Antes de un commit importante de configuración (RECOMENDADO)

## Flujo de trabajo
1. Leer .gobernanza/inventario_recursos.md
2. Extraer recursos, variables, secrets documentados
3. Verificar existencia real en código y plataformas
4. Comparar listas y clasificar discrepancias
5. Generar reporte estructurado con evidencia
6. Reportar al usuario con acciones recomendadas
```

### 11.5. Impacto en Reglas Existentes

| Regla | Cambio |
|-------|--------|
| **R14** (obligación 6) | Cambiar "ninguna persona o agente debe modificar el inventario directamente" por "solo `@governance-updater` puede modificar el inventario" |
| **R14** (obligación 8) | Cambiar "auditorías periódicas" por "auditorías periódicas ejecutadas por `@governance-auditor`" |
| **Notas de Mantenimiento** (punto 3) | Cambiar "auditoría periódica" por "el agente `@governance-auditor` debe auditar periódicamente" |
| **Jerarquía de Documentos** | Añadir `@governance-updater` y `@governance-auditor` como agentes de Nivel 2 |
| **`inventario_recursos.md`** | Actualizar "Reglas de Uso" punto 4: "los cambios los ejecuta `@governance-updater`" |

---

## 12. Reglas o Elementos No Compatibles

No se identificaron reglas no compatibles con OpenCode.

### 12.1. Puntos resueltos

| Elemento | Estado | Resolución |
|----------|--------|------------|
| "Agente de despliegue" en R8 | ✅ Resuelto | Es `@ftp-deployer` |
| "Flujo de gobernanza del proyecto" en R14 | ✅ Resuelto | Es `@governance-updater` + `@governance-auditor` |
| "Responsables de gestión y auditoría" | ✅ Resuelto | `@governance-updater` y `@governance-auditor` |
| CI/CD en R3 y R8 | ✅ Verificado | Eliminado en Capa 1 |
| Política de Versionamiento | ✅ Resuelto | Extraída a `.gobernanza/politica_versionamiento.md` |

### 12.2. Archivos a eliminar

| Archivo | Motivo |
|---------|--------|
| `.skills/context7/SKILL.md` | Movido a `.opencode/skills/context7/SKILL.md` |
| `.gobernanza/documentacion_tecnica_preventiva.md` | Copia maestra eliminada; única fuente en el skill |

### 12.3. Archivos a añadir a `.gitignore`

```
_registro_/
```

---

## 13. Recomendación Final Justificada

### Orden de Ejecución Recomendado

| Paso | Acción | Depende de |
|:----:|--------|------------|
| 1 | Renombrar `gobernanza/` → `.gobernanza/` | — |
| 2 | Mover `.skills/context7/` → `.opencode/skills/context7/` | — |
| 3 | Eliminar `.gobernanza/documentacion_tecnica_preventiva.md` (única copia en skill) | Paso 2 |
| 4 | Mover `inventario_recursos_bitaacora.md` → `_registro_/` + añadir a `.gitignore` | — |
| 5 | Crear `.opencode/skills/documentacion-tecnica-preventiva/SKILL.md` + contenido | Paso 3 |
| 6 | Crear `.opencode/agents/governance-updater.md` (desde `temp/agente-inventariador.md`) | Análisis sección 11 |
| 7 | Crear `.opencode/agents/governance-auditor.md` (desde `temp/agente-inventariador.md`) | Análisis sección 11 |
| 8 | Actualizar `.gobernanza/reglas_universales.md`: reformular R3, R8, R14 + añadir REQUIREMENT_ID | Pasos 1, 6, 7 |
| 9 | Extraer "Política de Versionamiento" → `.gobernanza/politica_versionamiento.md` | Paso 1 |
| 10 | Actualizar `.gobernanza/inventario_recursos.md`: referencias a agentes | Pasos 6, 7 |
| 11 | Crear `AGENTS.md` en raíz con reglas esenciales + referencias | — |
| 12 | Crear/actualizar `opencode.json` con instructions + agentes | Todos los pasos anteriores |

### Justificación

1. **Viabilidad técnica inmediata:** Las 14 reglas son compatibles con OpenCode. El mecanismo `instructions` de `opencode.json` soporta archivos Markdown con reglas contractuales.

2. **Integridad del sistema de gobernanza:** `inventario_recursos.md` queda referenciado desde `instructions`, cargado en contexto junto con las reglas. No hay separación funcional.

3. **División del agente inventariador:** La decisión de dividir en `@governance-updater` y `@governance-auditor` está alineada con:
   - OpenCode Docs: agentes especializados para tareas específicas
   - Principio de mínimo privilegio: el auditor no necesita permisos de escritura
   - Claridad de invocación: nombres explícitos sin flags no estándar

4. **`AGENTS.md` como complemento:** No reemplaza a `instructions` sino que las complementa, siguiendo la recomendación de OpenCode de tener `AGENTS.md` para reglas concisas y referencias.

5. **Política de versionamiento independiente:** Al extraerla a `.gobernanza/politica_versionamiento.md`, se simplifican las reglas universales y se mantiene la trazabilidad sin sobrecargar el contrato principal.

6. **Skills correctamente ubicados:** `context7` en `.opencode/skills/` (única ubicación canónica) y `documentacion-tecnica-preventiva` como skill bajo demanda, evitando contaminar el contexto con documentación que no siempre es necesaria.

---

## 14. Guía de Uso del Sistema de Gobernanza OpenCode

### 14.1. Cómo OpenCode Aplica la Gobernanza Automáticamente

OpenCode aplica la gobernanza del proyecto de forma automática mediante dos mecanismos documentados oficialmente:

**Mecanismo 1 — Carga de Instrucciones en el Contexto del LLM**

Según la documentación oficial de OpenCode ([Rules](https://opencode.ai/docs/rules/)), los archivos listados en el campo `instructions` de `opencode.json` se **combinan con `AGENTS.md`** y se incluyen en el contexto del LLM en cada sesión. Esto significa que:

- `.gobernanza/reglas_universales.md` se carga automáticamente al iniciar cada sesión.
- `.gobernanza/inventario_recursos.md` se carga automáticamente al iniciar cada sesión.
- El LLM recibe ambas como instrucciones de cumplimiento obligatorio desde el primer mensaje.
- El usuario **no necesita solicitar explícitamente** que se carguen; ocurre por defecto.

**Mecanismo 2 — Activación de Skills Bajo Demanda**

Según la documentación oficial de OpenCode ([Agent Skills](https://opencode.ai/docs/skills/)), los skills se listan en la descripción de la herramienta `skill` y el agente los carga llamando a `skill({ name: "..." })` cuando los necesita. Esto significa que:

- El agente ve los skills disponibles (`context7`, `documentacion-tecnica-preventiva`) en su descripción de herramientas.
- El agente decide autónomamente cargar un skill cuando la tarea lo requiere.
- El usuario **puede solicitar explícitamente** el uso de un skill si el agente no lo activa por sí mismo.

**Mecanismo 3 — Invocación de Agentes Especializados**

Según la documentación oficial de OpenCode ([Agents](https://opencode.ai/docs/agents/)), los subagentes pueden ser invocados:
- **Automáticamente** por agentes primarios para tareas especializadas según su descripción.
- **Manualmentente** por el usuario mediante la arroba `@nombre-del-agente`.

### 14.2. Ejemplos de Prompts para el Usuario

#### Uso Explícito de la Gobernanza

Estos prompts invocan directamente las reglas y agentes del sistema:

```
@governance-updater se ha añadido una nueva variable de entorno DATABASE_URL en producción. Actualiza el inventario.
```

```
@governance-auditor realiza una auditoría completa del inventario antes del despliegue.
```

```
@ftp-deployer despliega la última versión de la web-app.
```

```
@governance-auditor verifica que todos los recursos documentados en el inventario existen realmente en el proyecto.
```

#### Uso de Skills Bajo Demanda

Estos prompts activan skills específicos:

```
Usa el skill context7 para verificar la sintaxis correcta de configuración de variables de entorno.
```

```
Carga el skill documentacion-tecnica-preventiva antes de modificar la arquitectura del proyecto.
```

#### Solicitud de Acción sin Especificar Agente (Delegación Automática)

OpenCode, al tener las reglas en contexto, puede determinar autónomamente qué agente invocar:

```
Se ha creado un nuevo endpoint /api/users. ¿Qué debo hacer?
```
→ El LLM, al leer R14 en contexto, determinará que debe invocar `@governance-updater` para registrar el nuevo endpoint en el inventario.

```
Necesito desplegar los cambios que acabo de hacer.
```
→ El LLM, al leer R8 en contexto, determinará que debe invocar `@ftp-deployer` como único mecanismo válido.

```
Antes de continuar, quiero asegurarme de que todo está en orden.
```
→ El LLM, al leer las reglas de consulta obligatoria y R14, puede sugerir ejecutar `@governance-auditor` para verificar consistencia.

### 14.3. Activación Indirecta (Sin Mención Explícita del Usuario)

El sistema de gobernanza puede activarse sin que el usuario lo indique manualmente en los siguientes casos documentados:

| Disparador | Mecanismo OpenCode | Comportamiento |
|------------|-------------------|----------------|
| Inicio de sesión | Carga de `instructions` + `AGENTS.md` | Las reglas y el inventario están en contexto desde el primer mensaje. El LLM debe cumplirlas aunque el usuario no las mencione. |
| Tarea que afecta recursos | Descripción del agente en `opencode.json` | El agente primario puede delegar automáticamente en `@governance-updater` si detecta que la tarea implica cambios en recursos, basándose en la descripción del subagente. |
| Tarea técnica compleja | Skill `documentacion-tecnica-preventiva` | El LLM puede cargar el skill si estima que la tarea implica riesgos técnicos (arquitectura, seguridad, integraciones). |
| Consulta técnica | Skill `context7` | El LLM puede cargar context7 si necesita verificar documentación oficial de una librería o herramienta. |

**Importante:** La activación autónoma de skills y la delegación automática a subagentes depende del modelo LLM y de cómo interpreta las instrucciones en contexto. OpenCode proporciona los mecanismos (instrucciones en contexto, descripciones de agentes, listado de skills), pero la decisión final de activarlos recae en el modelo. La documentación oficial de OpenCode no garantiza que un modelo específico active siempre un skill o agente determinado sin instrucción explícita.

### 14.4. Buenas Prácticas

| Práctica | Descripción | Base Documental |
|----------|-------------|-----------------|
| **Siempre iniciar con el inventario cargado** | El inventario se carga automáticamente vía `instructions`. Confiar en que está en contexto. | OpenCode Docs — Rules: los archivos en `instructions` se combinan con `AGENTS.md` |
| **Usar `@governance-auditor` antes de desplegar** | La regla R14 y las notas de mantenimiento exigen auditoría pre-despliegue. Invocarlo manualmente si el agente no lo hace. | `.gobernanza/reglas_universales.md` — R14 + Notas de Mantenimiento |
| **Delegar en `@governance-updater` tras cada cambio** | Después de crear, modificar o eliminar cualquier recurso, invocar al actualizador. | `.gobernanza/reglas_universales.md` — R14 |
| **Usar el skill `documentacion-tecnica-preventiva` en tareas de riesgo** | Antes de modificar arquitectura, flujos críticos, seguridad o integraciones, cargar el skill. | `.opencode/skills/documentacion-tecnica-preventiva/SKILL.md` — condiciones de uso |
| **No asumir valores no documentados** | Si el inventario no contiene un valor, detener la acción y preguntar. | `.gobernanza/reglas_universales.md` — R1 obligación 5 |
| **Registrar en la bitácora** | Cada cambio en recursos debe quedar en `_registro_/inventario_recursos_bitaacora.md`. | `.gobernanza/reglas_universales.md` — R14 nueva obligación |
| **Solo `@ftp-deployer` para despliegues** | Ningún otro agente, script o método manual está autorizado. | `.gobernanza/reglas_universales.md` — R8 obligación 8-9 |

### 14.5. Casos de Uso Prácticos

#### Caso 1: Desarrollo de una Nueva Funcionalidad

```
Usuario: Añade un nuevo endpoint GET /api/products que devuelva la lista de productos.

1. OpenCode carga las reglas y el inventario automáticamente al iniciar.
2. El LLM lee el inventario y encuentra los endpoints existentes, la estructura del proyecto y las convenciones.
3. El LLM implementa el endpoint siguiendo R2 (cero hardcoding: usa variables de entorno para config).
4. El LLM, al leer R13, documenta el nuevo contrato en el inventario.
5. El LLM, al leer R14, invoca @governance-updater para registrar el cambio en el inventario y la bitácora.
6. Opcional: el usuario ejecuta @governance-auditor para verificar consistencia antes del despliegue.
7. El usuario ejecuta @ftp-deployer para desplegar (único mecanismo válido según R8).
```

#### Caso 2: Corrección de un Error en Producción

```
Usuario: La API está devolviendo 500 en el endpoint /api/auth/login.

1. OpenCode carga reglas e inventario.
2. El usuario puede cargar el skill documentacion-tecnica-preventiva si el error es recurrente.
3. El LLM diagnostica el error siguiendo R18 (consulta preventiva) y las guías del skill.
4. Tras corregir, el LLM (guiado por R14) invoca @governance-updater.
5. El usuario ejecuta @ftp-deployer para desplegar la corrección.
6. @governance-auditor verifica post-despliegue (obligatorio según R14).
```

#### Caso 3: Auditoría Periódica de Consistencia

```
Usuario: @governance-auditor realiza una auditoría completa del inventario.

1. El agente auditor lee .gobernanza/inventario_recursos.md (✅, ⚠️, 🔲, 🚫, 🗑️).
2. Escanea los recursos reales en el proyecto (código, configuraciones).
3. Compara listas y clasifica discrepancias (no documentadas, no configuradas, inconsistentes, etc.).
4. Genera reporte estructurado con evidencia.
5. Reporta al usuario con acciones recomendadas.
6. Si hay discrepancias, el usuario invoca @governance-updater para corregirlas.
```

### 14.6. Limitaciones y Condiciones Relevantes

| Limitación | Descripción | Fuente |
|------------|-------------|--------|
| **La activación autónoma de skills no está garantizada** | El LLM puede optar por no cargar un skill aunque esté disponible. La descripción del skill ayuda pero no fuerza la carga. | OpenCode Docs — Skills: los skills se listan y el agente los carga cuando los necesita. No hay garantía de activación automática. |
| **La delegación automática a subagentes depende del modelo** | El agente primario puede delegar en subagentes vía Task tool, pero no hay garantía documentada de que un modelo específico lo haga siempre. | OpenCode Docs — Agents: los subagentes pueden ser invocados automáticamente por agentes primarios. |
| **Las instrucciones en `instructions` se combinan pero no sustituyen a `AGENTS.md`** | Si hay conflicto, OpenCode no documenta un orden de precedencia específico entre `instructions` y `AGENTS.md`. Ambos se combinan en el contexto. | OpenCode Docs — Rules: los archivos en `instructions` se combinan con `AGENTS.md`. |
| **Skills ocultos por permisos** | Si un skill tiene permiso `deny` en la configuración, no aparece en la lista de skills disponibles y el agente no puede cargarlo. | OpenCode Docs — Skills: `deny` oculta el skill del agente. |
| **El inventario solo contiene información verificada** | No pueden registrarse valores hipotéticos, pendientes o no confirmados. Si un recurso no existe, no debe estar en el inventario. | `.gobernanza/inventario_recursos.md` — Reglas de Uso 5-7. |
| **La bitácora no está en el contexto del LLM por defecto** | `_registro_/inventario_recursos_bitaacora.md` no está en `instructions` de `opencode.json`. Solo `@governance-updater` la utiliza al actualizar el inventario. | Estructura de archivos propuesta (sección 7.1) — la bitácora está fuera de `.opencode/` y `.gobernanza/`. |
| **El orden de las `instructions` importa** | OpenCode combina los archivos en el orden listado en `instructions`. El primer archivo tiene más peso en la precedencia del contexto. | No documentado explícitamente por OpenCode. Práctica recomendada: listar `reglas_universales.md` primero, `inventario_recursos.md` después. |

---

*Documento generado el 28 de abril de 2026. Versión 2.0.*
*Basado en: `.gobernanza/*` (5 archivos), documentación oficial OpenCode (Rules, Agents, Skills, Config), `temp/dudas_gobernanza.md`, `pre-proyecto/agentica/INDICE.md`, `pre-proyecto/agentica/ftp-deployer-agent-spec.md`, `temp/agente-inventariador.md`.*
