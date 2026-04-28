# Reglas del Proyecto

> **Aplicación:** Estas reglas aplican a todos los agentes y colaboradores del proyecto.
> **Versión:** 5.1
> **Fuente de verdad:** Para valores específicos (nombres de recursos, variables de entorno, endpoints, credenciales), consultar `inventario_recursos.md`.

---

## Contexto del Proyecto

**Stack Tecnológico:**
- **Frontend/Backend:** Next.js 14 (App Router) + TypeScript
- **ORM:** Prisma 5.x
- **Base de Datos:** PostgreSQL
- **Styling:** TailwindCSS + shadcn/ui
- **Testing:** Jest + React Testing Library
- **Deployment:** Vercel, o VPS con Docker + nginx/Traefik
- **Runtime:** Node.js 20+
- **Gestor de paquetes:** npm

---

## Reglas Obligatorias

### R1 — No asumir valores no documentados

**Prioridad:** Crítica

Si hay duda sobre nombres de recursos, endpoints, contratos entre servicios, variables de entorno o cualquier valor no documentado, **preguntar antes de generar código**.

- No inventar nombres de variables de entorno, rutas API, o configuraciones de base de datos.
- No asumir URLs, credenciales, connection strings, o IDs de recursos.
- Consultar `inventario_recursos.md` antes de referenciar cualquier recurso, endpoint o variable.
- Validar la disponibilidad de variables de entorno en los archivos `.env.*` documentados.

---

### R2 — Cero hardcoding

**Prioridad:** Crítica

No codificar literales de credenciales, connection strings, URLs de servicios, IDs de base de datos, claves API, o cualquier valor que pueda variar entre entornos.

- Usar variables de entorno (`.env.*` o secrets de plataforma de despliegue).
- En el código servidor: leer de `process.env` dentro de Route Handlers o Server Components.
- En el frontend: usar variables con prefijo `NEXT_PUBLIC_` documentadas en `.env.example`.
- Referenciar `inventario_recursos.md` para conocer los nombres de variables válidos y su propósito.
- No incluir datos, consultas SQL, enlaces ni configuraciones fijas en archivos versionados.

---

### R3 — Gestión de secrets y credenciales

**Prioridad:** Crítica

Todas las claves, tokens, conexión a bases de datos y certificados se guardan en almacenamiento seguro, **nunca versionado en el repositorio**.

- **En desarrollo local:** Usar archivos `.env.development` o `.env.local` (listados en `.gitignore`).
- **Para despliegue en Vercel:** Usar Vercel Environment Variables (dashboard o CLI), autenticación con `VERCEL_TOKEN`.
- **Para despliegue en plataformas alternativas:** Usar configuración nativa de Docker, o VPS.
- **En GitHub Secrets:** Guardar tokens de autenticación (VERCEL_TOKEN) para CLI headless.
- **Connection strings de BD:** Solo a través de `DATABASE_URL` en variables de entorno.
- **Para acceso a servicios externos:** Guardar tokens en variables de entorno, nunca en el código.
- Usar archivos `.env.example` para documentar qué variables son requeridas, sin incluir valores reales.
- El archivo `lib/prisma.ts` debe usar `process.env.DATABASE_URL` de forma segura.

---

### R4 — Validación y acceso seguro a variables de entorno

**Prioridad:** Alta

Cada componente o ruta que acceda a variables de entorno debe hacerlo de forma **segura y validada**.

- Crear validadores con **Zod** para variables de entorno críticas (ej. `DATABASE_URL`, claves API).
- Centralizar la lectura de variables en módulos específicos (ej. `lib/env.ts` o `config/environment.ts`).
- Validar la presencia de variables requeridas en tiempo de inicialización, no en runtime.
- Usar `process.env` solo dentro de Server Components y Route Handlers, nunca en código de cliente.
- Para variables que llegan al frontend, marcarlas explícitamente con prefijo `NEXT_PUBLIC_` en `.env` files.

---

### R5 — Idioma y estilo

**Prioridad:** Alta

| Elemento | Idioma |
|----------|--------|
| Código (variables, funciones, tipos, comentarios) | Inglés |
| Documentación del proyecto y explicaciones de diseño | Español de España |
| Mensajes de error de APIs al cliente | Idioma del usuario final |
| Mensajes al usuario (i18n) | Sistema multidioma con `es-ES` por defecto |

---

### R6 — Convención de respuestas HTTP

**Prioridad:** Media

| Tipo | Estructura | Status |
|------|------------|--------|
| Éxito con payload | `{ data: ... }` | 2xx |
| Éxito sin payload | `{ message: "..." }` | 200/204 |
| Error | `{ error: "..." }` | 4xx/5xx |

- No exponer stack traces en producción.

---

### R7 — CORS y seguridad de orígenes

**Prioridad:** Media

Las aplicaciones que sirven a frontends deben respetar CORS.

- Los orígenes permitidos se configuran vía variables de entorno.
- Los encabezados deben aplicarse globalmente.
- Las preflight requests (OPTIONS) deben responderse correctamente.

---

### R8 — Configuración de despliegue

**Prioridad:** Crítica

El despliegue debe ser reproducible y seguro, sin exponer credenciales en archivos versionados.

- Localizar todas las variables de entorno en el archivo `.env.example` documentado.
- Usar secrets gestionados por la plataforma (Vercel Environment Variables, GitHub Secrets).
- La `DATABASE_URL` y credenciales sensibles se inyectan desde la plataforma, no desde el repositorio.
- Declarar todas las dependencias necesarias en `package.json` con versiones pinned (evitar `*`).
- El `Dockerfile` debe mapear correctamente las variables de build y runtime.
- Ejecutar `npm run build` como verificación pre-despliegue.
- Los scripts de despliegue (`deploy.sh`) no deben contener credenciales literales.

---

### R9 — Migraciones de esquema de base de datos

**Prioridad:** Alta

Los cambios en el esquema de bases de datos se implementan mediante archivos de migración numerados (`001-initial.sql`, `002-add-table.sql`, etc.).

- No ejecutar DDL dinámico en el código en tiempo de ejecución.
- Las migraciones deben ser idempotentes cuando sea posible.

---

### R10 — Estrategia de pruebas

**Prioridad:** Alta

Usar un framework de test apropiado que ejecute el código en el entorno real o emulado.

- Configurar mocks y bindings en el archivo de configuración del test, no en cada caso de prueba.
- Ejecutar tests localmente antes de hacer commit: `npm run test`
- Validar que tests pasan antes de hacer push a `main` o solicitar PR.

---

### R11 — Calidad de código antes de commit

**Prioridad:** Alta

Ejecutar linters y typechecks; el proyecto debe compilarse sin errores.

- Resolver o silenciar advertencias relevantes en el commit que introduce nuevos archivos o dependencias.
- Incluir ejecución de tests si el proyecto tiene estrategia de pruebas activa.

---

### R12 — Convenciones de commit

**Prioridad:** Media

Cada commit debe tener:

- Un identificador proporcionado por el usuario (fecha/hora o número de ticket), salvo que el usuario responda "Orquestador Decide".
- Descripción detallada y comprensible sin revisar el diff.
- Registro explícito de todos los cambios: qué se modificó, archivos afectados, naturaleza del cambio (creación, modificación, eliminación, reorganización o corrección).

**Excepción:** Si el usuario responde "Orquestador Decide", el orquestador generará el identificador.

---

### R13 — Contratos entre servicios

**Prioridad:** Media

Documentar las rutas, métodos y formatos de request/response de cada endpoint consumido entre servicios.

- Registrar contratos en `inventario_recursos.md` o documento dedicado.
- Verificar disponibilidad antes de desplegar dependencias.

---

### R14 — Variables de entorno del frontend

**Prioridad:** Alta

- Declarar y documentar todas las variables expuestas al frontend en CI.
- Validar su presencia en tiempo de ejecución en lugar de en la carga del módulo.
- Registrar en `inventario_recursos.md` con flag de sensibilidad.

---

### R15 — Inventario de recursos actualizado

**Prioridad:** Media

**Solo el agente `inventariador` puede actualizar `inventario_recursos.md`.**

- Ningún otro agente (ejecutores, orquestador, inventory-auditor) tiene permiso para modificar el inventario directamente.
- **Los usuarios humanos TAMPOCO deben modificar el inventario directamente.**
- Los usuarios deben solicitar cambios en el inventario a través del orquestador, quien delegará en `inventariador`.
- El orquestador debe invocar al agente `inventariador` después de las pruebas y antes del commit cuando haya cambios en recursos.
- La consistencia del inventario debe verificarse mediante auditorías periódicas con el agente `inventory-auditor`.

**Ejemplo de prompt para solicitar cambios en el inventario:**

```
Necesito actualizar el inventario:
- Tipo de cambio: [crear/modificar/eliminar/corregir]
- Recurso: [nombre del recurso]
- Detalles: [descripción del cambio]

Por favor, invoca al inventariador para actualizar.
```

---

### R16 — Convención de nombres para variables de entorno (opcional)

**Prioridad:** Baja

Para mantener consistencia en nombres de variables de entorno, seguir estas convenciones:

- **Bases de datos:** `DATABASE_URL`, `POSTGRES_*` (específicas de conexión)
- **Servicios externos:** `[SERVICE]_API_KEY`, `[SERVICE]_SECRET` (ej. `OPENAI_API_KEY`)
- **URLs públicas o internas:** `API_BASE_URL`, `PUBLIC_API_URL`, variable descriptiva
- **Flags de comportamiento:** `ENABLE_*`, `DEBUG_*` (ej. `DEBUG_MODE`)
- **Variables públicas (frontend):** Siempre con prefijo `NEXT_PUBLIC_` (ej. `NEXT_PUBLIC_API_BASE_URL`)

> **Nota:** Los nombres específicos y su propósito se registran en `inventario_recursos.md`.

---

### R17 — Reglas de Despliegue en Vercel

**Prioridad:** Crítica

Los despliegues en Vercel deben ser controlados y coordinados, sin despliegues automáticos en push.

- **Despliegues automáticos en push:** Están desactivados para evitar despliegues no controlados.
- **Despliegues a través del agente-deployment:** Los despliegues solo deben ejecutarse siguiendo el procedimiento documentado en `agente-deployment.md`.
- **Configuración de despliegue automático:** El archivo `vercel.json` contiene la configuración `git.deploymentEnabled: false` que desactiva los despliegues automáticos.
- **Despliegue manual:** Para desplegar manualmente a producción, usar el comando `vercel deploy --prod` después de autenticarse con `vercel login`.
- **Coordinación de despliegues:** El agente-orquestador debe coordinar todos los despliegues para asegurar que se siga el proceso correcto.
- **Validación pre-despliegue:** Antes de cualquier despliegue, ejecutar `npm run build` para verificar que el proyecto compila sin errores.
- **Variables de entorno:** Asegurar que todas las variables de entorno requeridas estén configuradas en Vercel Environment Variables antes del despliegue.

> **Nota:** Esta regla complementa la R8 (Configuración de despliegue) y es específica para el flujo de trabajo en Vercel.

---

### R18 — Consulta obligatoria de conocimiento técnico preventivo

**Prioridad:** Crítica

**Todos los agentes y colaboradores deben consultar `conocimiento_tecnico_preventivo.md` antes de:**

- **Planificar** cambios, mejoras o nuevas funcionalidades
- **Diseñar** arquitecturas, componentes o flujos de trabajo
- **Desarrollar** código, configuraciones o integraciones
- **Corregir** errores, bugs o comportamientos inesperados
- **Depurar** problemas, fallos o inconsistencias
- **Probar** funcionalidades, integraciones o flujos críticos
- **Desplegar** cambios a entornos de staging o producción

**Propósito del documento:**
- Contiene conocimiento técnico validado contra el código real
- Documenta errores comunes y sus soluciones probadas
- Proporciona guías de prevención para evitar fallos conocidos
- Complementa `inventario_recursos.md` con conocimiento operativo

**Responsabilidades específicas:**

1. **Orquestador:**
   - Debe verificar que los agentes ejecutores hayan consultado el documento antes de asignar tareas
   - Debe incorporar referencias al documento en los prompts de trabajo

2. **Agentes ejecutores:**
   - Deben consultar el documento al inicio de cada tarea
   - Deben aplicar las guías de prevención relevantes a su trabajo
   - Deben reportar cualquier discrepancia encontrada entre el documento y la realidad del código

3. **Inventariador:**
   - Debe mantener el documento actualizado con nuevos conocimientos validados
   - Debe coordinar con el inventory-auditor para validar la precisión del contenido

4. **Inventory-auditor:**
   - Debe auditar periódicamente la consistencia entre el documento y el código real
   - Debe reportar desviaciones para su corrección

**Excepciones:**
- Tareas triviales o de mantenimiento rutinario que no afectan funcionalidades críticas
- Consultas de referencia rápida para valores específicos (usar `inventario_recursos.md` en su lugar)

> **Nota:** Este documento es complementario a `inventario_recursos.md`. Mientras el inventario documenta **qué existe**, el conocimiento técnico preventivo documenta **cómo evitar errores** con lo que existe.

---

## Referencias a Documentos de Gobernanza

| Documento | Propósito |
|-----------|-----------|
| `reglas_proyecto.md` | Define todas las reglas del proyecto (este documento) |
| `inventario_recursos.md` | Fuente de verdad para recursos, variables de entorno, endpoints y configuración |
| `conocimiento_tecnico_preventivo.md` | Conocimiento técnico validado para prevenir errores comunes y fallos conocidos |
| `.agents/orquestador.md` | Define el rol, responsabilidades y flujo de trabajo del agente orquestador |
| `.agents/inventariador.md` | Agente exclusivo para actualizar el inventario de recursos |
| `.agents/inventory-auditor.md` | Agente especializado en auditar la consistencia del inventario |
| `.agents/ejecutores/*` | Agentes ejecutores con criterios operativos específicos de cada dominio |

---

## Jerarquía de Documentos de Gobernanza

### Niveles de Prioridad

Los documentos de gobernanza siguen una jerarquía de tres niveles:

| Nivel | Documento | Propósito | Autoridad |
|--------|-----------|-----------|------------|
| **Nivel 1** | `reglas_proyecto.md` | Reglas generales aplicables a todos los agentes y colaboradores | Máxima autoridad |
| **Nivel 2** | Archivos de agentes (`.agents/*.md`) | Criterios operativos específicos de cada agente | Autoridad sobre su dominio |
| **Nivel 3** | `inventario_recursos.md` | Fuente de verdad para valores específicos (recursos, variables, endpoints) | Autoridad sobre valores específicos |
| **Nivel 3** | `conocimiento_tecnico_preventivo.md` | Conocimiento técnico validado para prevenir errores comunes y fallos conocidos | Autoridad sobre prevención de errores |

### Regla de Conflicto

En caso de discrepancia entre documentos:

1. **Prevalece el documento de nivel superior:**
   - Si hay conflicto entre un agente y `reglas_proyecto.md`, prevalece `reglas_proyecto.md`
   - Si hay conflicto entre `inventario_recursos.md` y un agente, prevalece el agente (Nivel 2 > Nivel 3)

2. **Valores específicos:**
   - Para nombres de recursos, variables de entorno, endpoints y credenciales, `inventario_recursos.md` es la fuente de verdad
   - Para comportamientos y procesos, prevalece el documento de nivel superior

3. **Resolución de conflictos:**
   - Si se detecta un conflicto, reportar al orquestador
   - El orquestador decidirá cuál es la interpretación correcta
   - Los documentos deben actualizarse para reflejar la decisión

### Orden de Lectura Recomendado

Para nuevos colaboradores o agentes:

1. **Primero:** Leer `reglas_proyecto.md` para entender las reglas generales
2. **Segundo:** Leer el archivo del agente específico para entender criterios operativos
3. **Tercero:** Consultar `inventario_recursos.md` para valores específicos cuando sea necesario

### Dependencias entre Documentos

| Documento | Depende de | Motivo |
|-----------|--------------|---------|
| `inventario_recursos.md` | `reglas_proyecto.md` | Debe cumplir con las reglas generales |
| `conocimiento_tecnico_preventivo.md` | `reglas_proyecto.md` + `inventario_recursos.md` | Debe cumplir con reglas generales y basarse en inventario validado |
| `.agents/inventariador.md` | `reglas_proyecto.md` + `inventario_recursos.md` + `conocimiento_tecnico_preventivo.md` | Aplica reglas generales, gestiona inventario y conocimiento técnico |
| `.agents/inventory-auditor.md` | `reglas_proyecto.md` + `inventario_recursos.md` + `conocimiento_tecnico_preventivo.md` | Aplica reglas generales y audita inventario y conocimiento técnico |
| `.agents/orquestador.md` | `reglas_proyecto.md` + todos los agentes | Coordina según reglas y criterios de cada agente |
| `.agents/ejecutores/*` | `reglas_proyecto.md` + `inventario_recursos.md` + `conocimiento_tecnico_preventivo.md` | Aplican reglas generales y consultan inventario y conocimiento técnico |

> **Nota:** Esta jerarquía asegura que exista un orden claro de autoridad y que los conflictos se resuelvan de manera consistente.

---

## Asignación de Responsabilidades

### Mapeo de Reglas a Agentes Responsables

| Regla | Responsable Principal | Agentes de Apoyo | Descripción |
|--------|----------------------|-------------------|-------------|
| R1 — No asumir valores no documentados | Orquestador | Todos los agentes | Verifica que no se asuman valores sin documentación |
| R2 — Cero hardcoding | Inventariador (validación) + Ejecutores (implementación) | Inventory-auditor (verificación) | Asegura que no haya valores hardcodeados |
| R3 — Gestión de secrets y credenciales | Inventariador | Deployment agents | Gestiona secrets y credenciales de forma segura |
| R4 — Validación y acceso seguro a variables de entorno | Inventariador | Todos los agentes | Valida el acceso seguro a variables de entorno |
| R5 — Idioma y estilo | Todos los agentes | - | Aplica idioma y estilo según reglas |
| R6 — Convención de respuestas HTTP | nextjs-api | - | Implementa convención de respuestas HTTP |
| R7 — CORS y seguridad de orígenes | nextjs-api | - | Implementa CORS y seguridad de orígenes |
| R8 — Configuración de despliegue | deployment-vercel/deployment-vps | Inventariador | Configura despliegue de forma reproducible y segura |
| R9 — Migraciones de esquema de base de datos | prisma-database | Inventariador | Gestiona migraciones de base de datos |
| R10 — Estrategia de pruebas | testing | - | Implementa estrategia de pruebas |
| R11 — Calidad de código antes de commit | Todos los agentes | - | Ejecuta linters y typechecks antes de commit |
| R12 — Convenciones de commit | Orquestador | - | Aplica convenciones de commit |
| R13 — Contratos entre servicios | Orquestador | Ejecutores técnicos | Documenta contratos entre servicios |
| R14 — Variables de entorno del frontend | frontend-react | Inventariador | Gestiona variables de entorno del frontend |
| R15 — Inventario de recursos actualizado | Inventariador | Inventory-auditor | Mantiene el inventario actualizado |
| R16 — Convención de nombres | Inventariador | Todos los agentes | Aplica convención de nombres |
| R17 — Reglas de Despliegue en Vercel | deployment-vercel | Orquestador | Controla y coordina despliegues en Vercel |
| R18 — Consulta obligatoria de conocimiento técnico preventivo | Orquestador | Todos los agentes | Obliga a consultar conocimiento técnico preventivo antes de planificar, diseñar, desarrollar, corregir, depurar, probar o desplegar |

### Roles Principales por Agente

| Agente | Rol Principal | Reglas Clave |
|---------|----------------|----------------|
| **Orquestador** | Coordinación y validación de ambigüedades | R1, R12, R13, R17, R18 |
| **Inventariador** | Gestión exclusiva del inventario y conocimiento técnico | R2, R3, R4, R14, R15, R16, R18 |
| **Inventory-Auditor** | Verificación de consistencia del inventario y conocimiento técnico | R2, R15, R18 |
| **nextjs-api** | Implementación de rutas API | R6, R7 |
| **prisma-database** | Gestión de base de datos | R9 |
| **frontend-react** | Implementación de componentes React | R14 |
| **typescript** | Tipado y validación estática | R11 |
| **testing** | Estrategia de pruebas | R10, R11 |
| **deployment-vercel** | Despliegue en Vercel | R3, R8, R17 |
| **deployment-vps** | Despliegue en VPS/Docker | R3, R8 |

### Flujo de Responsabilidad

1. **Antes de iniciar trabajo:**
   - Todos los agentes consultan `reglas_proyecto.md` para reglas generales
   - Cada agente consulta su archivo específico para criterios operativos
   - Se consulta `inventario_recursos.md` para valores específicos

2. **Durante la ejecución:**
   - Los agentes ejecutores implementan según sus criterios operativos
   - El inventariador mantiene el inventario actualizado
   - El inventory-auditor verifica consistencia periódicamente

3. **Para conflictos o ambigüedades:**
   - Los agentes reportan al orquestador
   - El orquestador decide según la jerarquía de documentos
   - Se documenta la decisión para futuras referencias

> **Nota:** Esta asignación de responsabilidades asegura que cada regla tenga un dueño claro y que los agentes sepan qué se espera de ellos.

---

## Nota sobre Criterios Operativos de Dominio

Los **criterios operativos específicos de cada dominio técnico** residen en los agentes ejecutores correspondientes, no en este documento.

| Agente | Criterios Operativos |
|--------|---------------------|
| `nextjs-api` | Rutas API, validación de schemas con Zod, manejo de errores, CORS |
| `prisma-database` | Migraciones, modelos de BD, queries optimizadas, índices |
| `frontend-react` | Componentes React, hooks, variables de entorno frontend, shadcn/ui |
| `typescript` | Tipado, genéricos, tipos de utilidad, validación estática |
| `testing` | Jest, React Testing Library, mocks de BD, fixtures de prueba |
| `deployment-vercel` | Variables de entorno en Vercel, despliegue automático, preview URLs |
| `deployment-vps` | Docker, nginx/Traefik, secrets en archivo .env, reinicio de servicios |

Consulta los archivos de agentes ejecutores para los criterios operativos específicos de cada dominio.

---

## Política de Versionamiento de Documentos

### Versiones Actuales

| Documento | Versión Actual | Última Actualización |
|-----------|----------------|----------------------|
| `reglas_proyecto.md` | 5.2 | 2026-04-20 |
| `inventario_recursos.md` | 5.0 | [fecha] |
| `conocimiento_tecnico_preventivo.md` | 1.0 | 2026-04-20 |
| `.agents/orquestador.md` | - | [pendiente] |
| `.agents/inventariador.md` | - | [fecha] |
| `.agents/inventory-auditor.md` | - | [fecha] |

### Reglas de Versionamiento

1. **Versiones independientes:**
   - Cada documento de gobernanza tiene su propio número de versión
   - Los cambios en un documento NO requieren actualizar la versión de otros
   - La versión se incrementa cuando hay cambios significativos en el contenido

2. **Incremento de versión:**
   - **Versión mayor (X.0):** Cambios estructurales importantes, adición de nuevas secciones, reorganización significativa
   - **Versión menor (0.X):** Cambios moderados, adición de nuevas reglas, modificaciones existentes
   - **Versión de parche (no aplicada):** Correcciones menores, typos, formato

3. **Historial de cambios:**
   - `inventario_recursos.md`: Tiene sección específica de historial de cambios
   - `reglas_proyecto.md`: Los cambios se documentan en commits del repositorio
   - Archivos de agentes: Los cambios se documentan en commits del repositorio

4. **Sincronización entre documentos:**
   - Los documentos pueden tener versiones diferentes
   - No es necesario mantener sincronización de versiones entre documentos
   - Para cambios que afectan múltiples documentos, actualizar cada uno independientemente

5. **Notificación de cambios:**
   - Los cambios significativos en `reglas_proyecto.md` deben comunicarse a todos los agentes
   - Los cambios en `inventario_recursos.md` deben comunicarse a inventariador e inventory-auditor
   - Los cambios en archivos de agentes deben comunicarse a los agentes afectados

### Proceso de Actualización

1. **Identificar necesidad de cambio:**
   - Revisión periódica de consistencia
   - Detección de problemas o ambigüedades
   - Solicitud de mejoras por parte de colaboradores

2. **Evaluar impacto:**
   - Determinar qué documentos se ven afectados
   - Evaluar si el cambio es mayor o menor
   - Identificar agentes o colaboradores que deben ser notificados

3. **Implementar cambio:**
   - Actualizar el documento correspondiente
   - Incrementar la versión según el tipo de cambio
   - Documentar el cambio en el historial (si aplica)

4. **Notificar a interesados:**
   - Comunicar el cambio a los agentes afectados
   - Actualizar referencias cruzadas si es necesario
   - Solicitar confirmación de comprensión

> **Nota:** Esta política de versionamiento asegura que los cambios en la documentación de gobernanza se gestionen de manera controlada y que todos los interesados sean notificados oportunamente.
