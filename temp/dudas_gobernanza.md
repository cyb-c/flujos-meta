**Dudas y preguntas necesarias (pendientes de aclaración):**

1. **Mecanismo de integración preferido.** OpenCode ofrece dos vías para incorporar reglas externas: (a) campo `instructions` en `opencode.json` apuntando a los archivos de `gobernanza/`, o (b) volcar el contenido de las reglas directamente en `AGENTS.md`. ¿Cuál prefieres? instructions en opencode.json

2. **Ubicación de los archivos de gobernanza.** OpenCode reconoce `.opencode/` como directorio estándar para skills/agents/commands. ¿Deben trasladarse/copiarse los archivos de `gobernanza/` a `.opencode/`, o mantenerse en `gobernanza/` y referenciarlos desde `opencode.json`? Si, trasladarse.

3. **`inventario_recursos.md` como instrucción obligatoria.** Dado que todas las reglas ordenan consultar este archivo antes de actuar, y que OpenCode permite referenciarlo vía `instructions`, ¿debe incluirse `gobernanza/inventario_recursos.md` directamente en el array `instructions` de `opencode.json`? si, instructions en opencode.json

4. **R8 y el “agente de despliegue de repositorio”.** La regla R8 dice: “El único mecanismo válido de despliegue es el agente de despliegue de repositorio”. En el contexto de OpenCode, ¿a qué agente concreto se refiere? ¿A un agente OpenCode personalizado? ¿A un script/sistema externo? Esta ambigüedad impide verificar si la regla es implementable con las herramientas actuales. se refiere a .opencode/agents/ftp-deployer.md; consulta pre-proyecto/agentica/INDICE.md

5. **Skills vs. reglas para `documentacion_tecnica_preventiva.md`.** Este documento contiene conocimiento técnico que debe consultarse bajo ciertas condiciones. OpenCode Skills están diseñados precisamente para carga bajo demanda. ¿Debe convertirse en un Skill (`.opencode/skills/documentacion-tecnica-preventiva/SKILL.md`) o mantenerse como archivo referenciado desde `instructions`? 
Sí: **convertir `documentacion_tecnica_preventiva.md` en un Skill parece la mejor opción** si ese documento contiene conocimiento técnico que **no debe estar siempre en contexto**, sino consultarse **solo bajo ciertas condiciones**.

La razón es exactamente la que mencionas: la documentación oficial de OpenCode define los **Skills** como instrucciones reutilizables que se descubren desde el repo o desde el directorio global, y que se cargan **bajo demanda** mediante la herramienta nativa `skill`. Los agentes ven qué skills existen y pueden cargar el contenido completo cuando lo necesitan. ([OpenCode][1])

## Recomendación

Yo lo haría así:

```text
.opencode/
  skills/
    documentacion-tecnica-preventiva/
      SKILL.md
      documentacion_tecnica_preventiva.md
```

Y en `SKILL.md` pondría una definición breve, clara y accionable, por ejemplo:

```md
---
description: Consulta conocimiento técnico preventivo antes de modificar arquitectura, flujos críticos, integraciones, datos, seguridad, permisos o automatizaciones.
---

# Documentación técnica preventiva

Usa este skill cuando la tarea pueda afectar:

- arquitectura del proyecto
- flujos críticos
- automatizaciones
- integraciones externas
- configuración de entorno
- permisos
- datos persistentes
- seguridad
- despliegues
- scripts de ejecución
- comportamiento de agentes o herramientas

Antes de proponer o aplicar cambios, lee y aplica las reglas de:

- `documentacion_tecnica_preventiva.md`

Si el contenido de este skill entra en conflicto con instrucciones explícitas del usuario, advierte el conflicto antes de continuar.
```

El archivo largo quedaría separado:

```md
# documentacion_tecnica_preventiva.md

...
```


6. **Agentes referidos en las reglas.** Las reglas mencionan “agente de despliegue”, “flujo de gobernanza del proyecto”, “responsables de gestión y auditoría”. ¿Existen ya agentes OpenCode concretos que cumplan esos roles, o deben crearse como parte de la integración?
“agente de despliegue” ver 4
“flujo de gobernanza del proyecto”, “responsables de gestión y auditoría” corresponden a un agente a crear, eso te lo comentaré en otro prompt

7. **Bitácora y OpenCode.** `inventario_recursos_bitacora.md` es un registro de cambios manual. OpenCode no tiene un mecanismo nativo para esto. ¿Se espera que OpenCode actualice la bitácora automáticamente, o es un registro para revisión humana periódica?
Muevelo/Mantenerlo en un dir en raiz _registro_/ fuera de .opencode;