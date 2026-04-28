# Reglas del Proyecto

Este proyecto sigue reglas de gobernanza detalladas cargadas automáticamente vía `opencode.json` → `instructions`.

## Reglas Esenciales (resumen)

| ID | Regla | Descripción |
|----|-------|-------------|
| **GOV-PRE** | Consulta Obligatoria | Consultar `.gobernanza/inventario_recursos.md` antes de cualquier acción relevante |
| **GOV-R1** | No Asumir | No asumir valores no documentados. Detener acción si falta valor, registrar bloqueo fuera del inventario, solicitar confirmación |
| **GOV-R2** | Cero Hardcoding | Toda configuración debe provenir de fuentes externas verificadas. Validar variables obligatorias antes de usar |
| **GOV-R3** | Gestión de Secrets | Secrets nunca versionados. En despliegue, `@ftp-deployer` lee credenciales de variables de entorno |
| **GOV-R5** | Idioma y Estilo | Código en inglés, documentación en idioma del proyecto |
| **GOV-R8** | Despliegue | Despliegue solo vía `@ftp-deployer`. Prohibido CI/CD, FTP manual, scripts alternativos |
| **GOV-R10** | Estrategia de Pruebas | Tests antes de commit. Validar tests pasan antes de push a main |
| **GOV-R11** | Calidad de Código | Linters y análisis estático antes de commit. Proyecto debe compilar sin errores |
| **GOV-R12** | Convenciones de Commit | Commit con identificador, descripción detallada, registro explícito de cambios |
| **GOV-R13** | Contratos entre Servicios | Registrar contratos en `.gobernanza/inventario_recursos.md` |
| **GOV-R14** | Inventario Actualizado | Inventario solo con info verificada. Solo `@governance-updater` puede modificar. Auditorías por `@governance-auditor` |

## Documentos de Referencia

Cargados automáticamente en el contexto (vía `opencode.json` → `instructions`):

- `.gobernanza/reglas_universales.md` — Contrato completo de reglas
- `.gobernanza/inventario_recursos.md` — Inventario de recursos

Consultar bajo demanda:

- `.gobernanza/politica_versionamiento.md` — Política de versionamiento
- `.gobernanza/documentacion_tecnica_preventiva.md` — Conocimiento técnico preventivo (también disponible como skill)

## Agentes del Proyecto

| Agente | Propósito | Invocación |
|--------|-----------|------------|
| `@ftp-deployer` | Despliegue FTP | `@ftp-deployer despliega la WA` |
| `@governance-updater` | Actualización del inventario | `@governance-updater actualiza inventario` |
| `@governance-auditor` | Auditoría de consistencia | `@governance-auditor audita inventario` |

## Skills Disponibles

| Skill | Propósito | Invocación |
|-------|-----------|------------|
| `context7` | Documentación técnica de librerías | Automática o `skill({ name: "context7" })` |
| `documentacion-tecnica-preventiva` | Conocimiento técnico preventivo | Automática o `skill({ name: "documentacion-tecnica-preventiva" })` |

## Flujo de Gobernanza

```
1. Usuario solicita tarea
2. OpenCode carga reglas + inventario automáticamente
3. Agente ejecuta tarea siguiendo reglas
4. Si hay cambios en recursos → @governance-updater actualiza inventario + bitácora
5. Antes de despliegue → @governance-auditor audita consistencia
6. Despliegue → solo @ftp-deployer
```

---

*`AGENTS.md` — Creado según directrices OpenCode (opencode.ai/docs/rules)*
