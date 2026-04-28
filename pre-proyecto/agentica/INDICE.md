# Índice de Agentes y Skills — pre-proyecto/agentica

**Última actualización:** 28 de abril de 2026

---

## 📁 Carpeta: `pre-proyecto/agentica/`

Especificaciones de agentes OpenCode diseñados para el proyecto.

Cada especificación describe el propósito, diseño, permisos, modo de invocación y flujo operativo del agente. La implementación real del agente se ubica en `.opencode/agents/` siguiendo la convención de OpenCode (`opencode.ai/docs/agents`).

| # | Archivo de especificación | Ruta en `pre-proyecto/agentica/` | Agente real en `.opencode/` | Modo | Propósito | Creado | Actualizado |
|---|---------------------------|----------------------------------|-----------------------------|------|-----------|--------|-------------|
| 1 | `ftp-deployer-agent-spec.md` | `pre-proyecto/agentica/ftp-deployer-agent-spec.md` | `.opencode/agents/ftp-deployer.md` | `subagent` | Despliega archivos de la WA por FTP al servidor compartido con verificación posterior | 28 abr 2026 | 28 abr 2026 |

---

## 📁 Carpeta: `.skills/` (raíz del proyecto)

Skills instalados en el directorio `.skills/` compatible con OpenCode y Claude.

Cada skill es un conjunto de instrucciones reutilizables que los agentes pueden cargar bajo demanda mediante la herramienta `skill`.

| # | Nombre del skill | Ruta | Propósito | Creado | Actualizado |
|---|------------------|------|-----------|--------|-------------|
| 1 | `context7` | `.skills/context7/SKILL.md` | Consultar documentación actualizada de librerías y frameworks vía API Context7 | — | 28 abr 2026 |

---

## 📁 Carpeta: `.opencode/agents/`

Directorio donde residen los archivos de definición de agentes OpenCode implementados.

| # | Agente real | Archivo | Especificación asociada | Modo | Invocación | Creado | Actualizado |
|---|-------------|---------|------------------------|------|------------|--------|-------------|
| 1 | `ftp-deployer` | `.opencode/agents/ftp-deployer.md` | `pre-proyecto/agentica/ftp-deployer-agent-spec.md` | `subagent` | `@ftp-deployer` o vía Task | 28 abr 2026 | 28 abr 2026 |

---

## 📁 Carpeta: `.opencode/skills/`

Directorio donde pueden residir skills personalizados del proyecto (adicionales a los de `.skills/`).

Actualmente **vacío**.

---

## 📊 Relación entre componentes

```
pre-proyecto/agentica/                          .opencode/agents/                    .skills/ / .opencode/skills/
│                                               │                                    │
├── ftp-deployer-agent-spec.md  ────────►       ├── ftp-deployer.md                  │
│       (especificación)                        │    (implementación real)           │
│                                               │                                    ├── .skills/context7/SKILL.md
│                                               │                                    │    (skill de documentación)
│                                               │                                    │
│                                               │                                    └── .opencode/skills/ (vacío)
│          ┌────────────────────────────────────┘
│          │
│          ▼
│   Usuario invoca @ftp-deployer
│   o agente orquestador delega vía Task
```

---

## 🔑 Convenciones de nomenclatura

| Elemento | Regla | Ejemplo |
|----------|-------|---------|
| **Archivo de especificación** (en `pre-proyecto/agentica/`) | Nombre descriptivo en inglés, guiones, sufijo `-agent-spec.md` | `ftp-deployer-agent-spec.md` |
| **Archivo de agente real** (en `.opencode/agents/`) | Nombre del agente (sin extensión) = identificador. Minúsculas, guiones. | `ftp-deployer.md` → agente `ftp-deployer` |
| **Skill** (en `.skills/` o `.opencode/skills/`) | Nombre en minúsculas con guiones, coincide con nombre del directorio | `.skills/context7/SKILL.md` → `name: context7` |

---

## 📋 Orden recomendado de lectura

| Prioridad | Ruta | Motivo |
|-----------|------|--------|
| 1 | `pre-proyecto/agentica/ftp-deployer-agent-spec.md` | Especificación completa del primer agente del proyecto |
| 2 | `.opencode/agents/ftp-deployer.md` | Implementación real del agente desplegador FTP |
| 3 | `.skills/context7/SKILL.md` | Skill base para consultar documentación actualizada |

---

## 🔗 Referencias cruzadas

| Documento | Relación |
|-----------|----------|
| `pre-proyecto/INDICE.md` | Índice general del proyecto que referencia `pre-proyecto/implantacion/` |
| `pre-proyecto/implantacion/00-decisiones-generales-implantacion.md` | Decisiones de implantación que los agentes deben respetar |
| `pre-proyecto/implantacion/00-INDICE-Implantacion.md` | Índice de documentación de implantación |
| `pre-proyecto/implantacion/10-Decisiones-Etapa01-Slim-FTP.md` | Decisiones específicas de Etapa 1 (Slim en raíz, sin wa-slim/) |
| `pre-proyecto/implantacion/40-Despliegue-Etapa01-Slim-FTP.md` | Procedimiento de despliegue que el agente `ftp-deployer` ejecuta |
| `pre-proyecto/implantacion/Etapa01_Slim-Despliegue-FTP.md` | Documento de transición (sustituido, trazabilidad histórica) |
| Documentación oficial OpenCode (Agentes) | https://opencode.ai/docs/agents |
| Documentación oficial OpenCode (Skills) | https://opencode.ai/docs/skills |
| Documentación oficial OpenCode (Permisos) | https://opencode.ai/docs/permissions |

---

## 📝 Notas sobre el agente desplegador

### Agente identificado: `ftp-deployer`

**Propósito:** Desplegar archivos de la Web-App por FTP al servidor compartido con verificación posterior.

**Implementación:**
- Archivo: `.opencode/agents/ftp-deployer.md`
- Especificación: `pre-proyecto/agentica/ftp-deployer-agent-spec.md`
- Modo: `subagent`
- Invocación: `@ftp-deployer` o vía delegación Task desde orquestador

**Flujo de despliegue:**
1. Pre-validación del directorio fuente y credenciales
2. Preparación del paquete (composer install --no-dev)
3. Conexión FTP mediante lftp
4. Transferencia con mirror --reverse
5. Verificación post-despliegue (HTTP 200, contenido)
6. Informe estructurado del resultado

**Rutas:**
- Origen: Directorio del proyecto (configurable)
- Destino: `/home/beevivac/stg2.cofemlevante.es/` (despliegue directo, sin subdirectorios fijos)
- Servidor: `ftp.bee-viva.es:21` (FTPS explícito)

**Seguridad:**
- Credenciales desde variables de entorno (`CONTRASENYA_FTP_WA`)
- Nunca expone contraseñas en logs o mensajes
- Usa FTPS explícito (TLS)

### Plan de despliegue actualizado

El despliegue **no se plantea como FTP manual**, sino como **despliegue mediante el agente `@ftp-deployer`**:

- El agente puede invocarse manualmente: `@ftp-deployer despliega la WA`
- Un agente orquestador puede delegar vía Task
- El agente sigue el plan en `Etapa01_Slim-Despliegue-FTP.md`
- Las rutas son configurables, no hardcodeadas

---

*Documento generado el 28 de abril de 2026*  
*Pre-proyecto — Web-App de Automatización WooCommerce*
