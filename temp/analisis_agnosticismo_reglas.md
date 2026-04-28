# Análisis de Agnosticismo: De `reglas_proyecto.md` a Reglas Reutilizables

## Índice

1. [Resumen del Objetivo](#1-resumen-del-objetivo)
2. [Criterios Usados para Identificar Dependencias Específicas](#2-criterios-usados-para-identificar-dependencias-específicas)
3. [Elementos Claramente Dependientes del Proyecto Actual](#3-elementos-claramente-dependientes-del-proyecto-actual)
4. [Elementos Parcialmente Reutilizables si se Reformulan](#4-elementos-parcialmente-reutilizables-si-se-reformulan)
5. [Elementos ya Agnósticos o Reutilizables sin Cambios](#5-elementos-ya-agnósticos-o-reutilizables-sin-cambios)
6. [Propuesta de Generalización para `inventario_recursos.md`](#6-propuesta-de-generalización-para-inventario_recursosmd)
7. [Conclusión y Recomendaciones](#7-conclusión-y-recomendaciones)

---

## 1. Resumen del Objetivo

Analizar el archivo `temp/reglas_proyecto.md` para identificar qué partes están acopladas al proyecto concreto (Next.js + TypeScript + Prisma + Vercel) y proponer generalizaciones que permitan convertir estas reglas en una base reutilizable, independiente de la tecnología (PHP, TypeScript, Cloudflare, Node.js, etc.).

Este documento **no modifica** `reglas_proyecto.md`. Es un análisis preparatorio para revisión del usuario antes de proceder a la reescritura.

**Nota sobre `inventario_recursos.md`:** Tras revisión de ejemplos en `temp/inventario_recursos_1.md` y `temp/inventario_recursos_2.md`, se confirma que `inventario_recursos.md` es un **documento estructural universal** que debe permanecer como parte de las reglas agnósticas. La dependencia no está en el documento en sí, sino en el contenido concreto que pueda alojar. Ver [sección 6](#6-propuesta-de-generalización-para-inventario_recursosmd).

---

## 2. Criterios Usados para Identificar Dependencias Específicas

Se clasifica como **dependencia específica del proyecto** cualquier elemento que:

| Criterio | Descripción |
|----------|-------------|
| **Stack tecnológico concreto** | Menciona tecnologías, frameworks, librerías o herramientas específicas (Next.js, Prisma, Vercel, Zod, TailwindCSS, shadcn/ui, Jest, npm, etc.) |
| **Nombres de archivo/ruta propietarios** | Referencia documentos o rutas que solo existen en este proyecto (`.agents/`, `agente-deployment.md`, etc.) |
| **Convenciones de plataforma** | Usa convenciones exclusivas de una plataforma (`NEXT_PUBLIC_`, `process.env`, `vercel.json`, `Vercel Environment Variables`) |
| **Agentes internos** | Menciona agentes o roles definidos solo para este proyecto (`inventariador`, `orquestador`, `inventory-auditor`, `deployment-vercel`) |
| **Comandos específicos** | Usa comandos de ecosistema concreto (`npm run`, `vercel deploy`, `npx prisma`) |
| **Variables de entorno fijas** | Nombres concretos de env vars (`DATABASE_URL`, `OPENAI_API_KEY`, `VERCEL_TOKEN`) |

> **Aclaración:** `inventario_recursos.md` no se considera dependencia específica. El documento como concepto estructural (inventario de recursos del proyecto) es universal y reutilizable. Lo que debe evitarse es que su **contenido** contenga valores, rutas o decisiones de un único proyecto. Ver [sección 6](#6-propuesta-de-generalización-para-inventario_recursosmd).

---

## 3. Elementos Claramente Dependientes del Proyecto Actual

### Tabla de Dependencias Fuertes

| ID | Regla / Fragmento Afectado | Tipo de Dependencia | Por qué no es agnóstica | Propuesta de Generalización | Impacto Esperado | Aprobación (Sí/No) | Comentarios |
|----|---------------------------|---------------------|--------------------------|----------------------------|------------------|---------------------|-------------|
| D01 | Stack tecnológico (líneas 11-19): Next.js 14, TypeScript, Prisma 5.x, PostgreSQL, TailwindCSS, shadcn/ui, Jest, Vercel, Docker, Node.js 20+, npm | Stack tecnológico concreto | Define un stack fijo; un proyecto en PHP + Laravel + MySQL no comparte nada de esto. | Eliminar el stack fijo. Sustituir por sección `<!-- STACK: definido por el proyecto -->` o variable de configuración. | Alta — la cabecera deja de ser vinculante; cada proyecto declara su stack. | — | — |
| D02 | R4 — "Crear validadores con Zod" (línea 75) | Librería específica | Zod es una librería JS/TS; en PHP se usaría PHP Filter o Symfony Validator. | Cambiar a "Crear validadores con la librería de esquemas/validación del stack (Zod, PHP Filter, Pydantic, etc.)". | Media — el principio se conserva, la implementación se delega al stack. | — | — |
| D03 | R4 — "Centralizar en `lib/env.ts` o `config/environment.ts`" (línea 76) | Ruta/convención de proyecto específica | `lib/env.ts` es una convención Next.js/TypeScript; en PHP sería `config/env.php` o similar. | Cambiar a "Centralizar la lectura en módulos específicos según la convención del proyecto (ej. `lib/env.ts`, `config/database.php`, `src/settings.py`)". | Media — el patrón se mantiene, la ruta se parametriza. | — | — |
| D04 | R4 — "Usar `process.env` solo dentro de Server Components y Route Handlers" (línea 78) | Concepto de framework concreto | `process.env`, `Server Components` y `Route Handlers` son específicos de Next.js/Node.js. | Cambiar a "Acceder a variables de entorno solo en backend/servidor, nunca exponerlas directamente al cliente sin prefijo explícito". | Alta — elimina referencias a Next.js. | — | — |
| D05 | R4 — "Prefijo `NEXT_PUBLIC_`" (línea 79) | Convención de framework | `NEXT_PUBLIC_` es específico de Next.js para exponer vars al frontend. | Reemplazar por "prefijo/configuración definida por el framework para vars públicas (ej. `NEXT_PUBLIC_`, `REACT_APP_`, `VITE_`, `PUBLIC_`)". | Media — se conserva el concepto de vars públicas. | — | — |
| D06 | R5 — "Sistema multidioma con `es-ES` por defecto" (línea 92) | Configuración regional fija | Asume español de España; un proyecto puede usar cualquier locale. | Cambiar a "Usar sistema de i18n/configuración regional definida por el proyecto (por defecto, el locale que corresponda)". | Baja — fácil de parametrizar. | — | — |
| D07 | R8 — "Declarar dependencias en `package.json` con versiones pinned" (línea 131) | Ecosistema concreto | `package.json` y `npm` son de Node.js; en PHP sería `composer.json`, en Python `pyproject.toml`. | Cambiar a "Declarar dependencias en el gestor de paquetes del proyecto (`package.json`, `composer.json`, `Cargo.toml`, `requirements.txt`, etc.) con versiones fijas". | Media — el principio es universal. | — | — |
| D08 | R8 — "Ejecutar `npm run build` como verificación pre-despliegue" (línea 133) | Comando de ecosistema concreto | `npm run build` es de Node.js; en PHP sería `composer install --no-dev`, en Rust `cargo build`. | Cambiar a "Ejecutar el comando de build/compilación definido por el proyecto (`npm run build`, `composer install --no-dev`, `cargo build`, etc.)". | Baja — es un ejemplo fácilmente generalizable. | — | — |
| D09 | R8 — "El `Dockerfile` debe mapear correctamente las variables" (línea 132) | Herramienta concreta | Asume Docker como contenedor; puede no usarse. | Cambiar a "Si se usa contenedor, mapear correctamente las variables de build y runtime". | Baja — se condiciona al uso de contenedores. | — | — |
| D10 | R9 — "Migraciones mediante archivos numerados (`001-initial.sql`)" (línea 142) | Convención de nombrado concreta | Usa SQL puro; si se usa ORM como Prisma o Doctrine, las migraciones tienen otro formato. | Cambiar a "Los cambios de esquema se implementan mediante archivos de migración según la convención del proyecto (SQL numerado, migraciones de ORM, etc.)". | Media — el principio de migraciones se conserva. | — | — |
| D11 | R10 — "Usar Jest + React Testing Library" + "mocks y bindings en configuración" (líneas 153-156) | Stack de testing concreto | Jest y RTL son específicos de JS/TS. PHP usa PHPUnit; Python usa pytest. | Cambiar a "Usar framework de test del proyecto (`jest`, `phpunit`, `pytest`, etc.). Configurar mocks a nivel de framework, no por caso de prueba." | Media — el principio es universal. | — | — |
| D12 | R10 — "Ejecutar `npm run test`" (línea 156) | Comando de ecosistema concreto | `npm run test` es de Node.js. | Cambiar a "Ejecutar el comando de test definido por el proyecto (`npm run test`, `vendor/bin/phpunit`, `pytest`, etc.)". | Baja — es un ejemplo fácilmente generalizable. | — | — |
| D13 | R14 — "Variables expuestas al frontend" + "prefijo `NEXT_PUBLIC_`" (líneas 201-203) | Convención de framework | Misma dependencia que D05. | Generalizar igual que D05: las vars públicas siguen la convención del framework. | Media — acoplado a D05. | — | — |
| D14 | R15 — Agente `inventariador` y `inventory-auditor` (líneas 207-228) | Arquitectura de agentes propietaria | El sistema de agentes que gestiona el inventario (`inventariador`) es específico. El **concepto** de `inventario_recursos.md` es agnóstico (ver sección 6), pero los roles que lo administran no. | Separar: el documento `inventario_recursos.md` se mantiene como regla agnóstica. Las reglas sobre quién lo gestiona (agentes) se externalizan o parametrizan. | Alta — la regla R15 se divide en parte agnóstica (el documento) y parte dependiente (el agente). | — | — |
| D15 | R16 — "Nombres `DATABASE_URL`, `NEXT_PUBLIC_*`, `OPENAI_API_KEY`" (líneas 237-242) | Nombres de variables concretas | Son convenciones de Node.js/Next.js; un proyecto en otro stack usaría otras convenciones. | Cambiar a "Seguir las convenciones de nombrado definidas por el proyecto/stack (ej. `DATABASE_URL`, `APP_DB_URL`, `DB_CONNECTION`)". | Media — el principio de consistencia es universal. | — | — |
| D16 | R17 — Toda la regla: Vercel, `vercel.json`, `vercel deploy`, `VERCEL_TOKEN` (líneas 248-263) | Plataforma de despliegue concreta | Vercel es una plataforma específica; proyectos en AWS, Cloudflare, Railway, etc. no la usan. | Convertir en regla genérica de "Control de despliegues": la plataforma se define por proyecto. La regla específica de Vercel pasa a ser un "template" o ejemplo. | Alta — elimina dependencia total de Vercel. | — | — |
| D17 | R18 — "Consultar `conocimiento_tecnico_preventivo.md`" (líneas 270-309) | Documento propietario | El nombre y propósito del documento son específicos de este proyecto. | Renombrar conceptualmente a "documento de conocimiento técnico preventivo", cuyo nombre y ubicación se definen por proyecto. | Media — el concepto es universal, el nombre es propio. | — | — |
| D18 | Sección "Referencias a Documentos de Gobernanza" — documentos `.agents/*` (líneas 315-323) | Arquitectura de agentes propietaria | Los agentes `orquestador`, `inventariador`, `inventory-auditor`, `ejecutores` son específicos. | Mover a un "sistema de gobernanza" genérico; los roles y agentes se definen por proyecto. | Alta — todo el sistema de agentes es propietario. | — | — |
| D19 | Sección "Asignación de Responsabilidades" — agentes `nextjs-api`, `prisma-database`, `frontend-react`, etc. (líneas 384-437) | Roles de agente específicos del stack | Los agentes están nombrados por tecnología concreta del proyecto. | Sustituir por roles genéricos: "API developer", "Database manager", "Frontend developer", etc. O eliminar y dejar la asignación a cada proyecto. | Alta — toda la sección es dependiente del stack y la org actual. | — | — |
| D20 | R3 — "`lib/prisma.ts` debe usar `process.env.DATABASE_URL`" (línea 65) | ORM + variable + ruta específicos | Prisma es un ORM específico, `lib/prisma.ts` es una ruta de proyecto. | Cambiar a "El módulo de conexión a BD del proyecto debe usar variables de entorno de forma segura". | Alta — referencias muy concretas. | — | — |
| D21 | R3 — "VERCEL_TOKEN" y "GitHub Secrets" (líneas 60-61) | Plataforma concreta | VERCEL_TOKEN solo existe en el ecosistema Vercel. | Cambiar a "Usar secrets gestionados por la plataforma de despliegue/CI (GitHub Secrets, GitLab CI vars, AWS Secrets Manager, etc.)". | Media — el concepto se generaliza. | — | — |
| D22 | R2 — "En código servidor: `process.env`; frontend: `NEXT_PUBLIC_`" (líneas 45-46) | Convención de framework | Misma dependencia que D04 y D05. | Generalizar igual que D04 y D05. | Alta — acoplado a D04 y D05. | — | — |
| D23 | "Nota sobre Criterios Operativos de Dominio" — agentes nombrados por tecnología (líneas 441-456) | Roles de agente específicos | `nextjs-api`, `prisma-database`, `frontend-react`, `deployment-vercel`, etc. | Misma propuesta que D19. | Alta — acoplado a D19. | — | — |
| D24 | R3 — Referencia a Vercel Environment Variables, Docker, VPS (líneas 59-63) | Plataforma de despliegue concreta | Mezcla plataformas específicas que pueden no usarse. | Generalizar a "según la plataforma de despliegue del proyecto (Vercel, AWS, Railway, servidor propio, etc.)". | Media — el principio de secrets es universal. | — | — |
| D25 | R6 — "No exponer stack traces en producción" (línea 106) | Práctica general (agnóstica) | En realidad es agnóstica. Mover a sección correcta. | — (ya agnóstico) | — | — | — |
| D26 | R13 — "Registrar contratos en `inventario_recursos.md`" (línea 192) | Documento estructural universal | ~~El nombre del documento es específico.~~ `inventario_recursos.md` es un concepto agnóstico. La referencia es correcta. | **Mantener tal cual.** El inventario de recursos es universal; registrar contratos allí es la conducta esperada. | Ninguno — no es una dependencia. | — | — |
| D27 | R2 — "Referenciar `inventario_recursos.md`" (línea 47) | Documento estructural universal | ~~El nombre del documento es específico.~~ `inventario_recursos.md` es un concepto agnóstico. | **Mantener tal cual.** Consultar el inventario antes de hardcodear es correcto. | Ninguno — no es una dependencia. | — | — |
| D28 | R1 — "Consultar `inventario_recursos.md`" (línea 33) | Documento estructural universal | ~~El nombre del documento es específico.~~ `inventario_recursos.md` es un concepto agnóstico. | **Mantener tal cual.** Consultar el inventario como fuente de verdad es la conducta esperada. | Ninguno — no es una dependencia. | — | — |
| D29 | R8 — "Localizar variables en `.env.example`" (línea 128) | Archivo de convención | `.env.example` no es universal (aunque es muy común). Python usa `.env.example` o `.env.template`. | Mantener `.env.example` como convención recomendada pero no obligatoria, o hacerlo configurable. | Baja — es una convención muy extendida. | — | — |
| D30 | R14 — "Registrar en `inventario_recursos.md` con flag de sensibilidad" (línea 203) | Documento estructural universal | ~~El inventario y su sistema de flags son específicos.~~ `inventario_recursos.md` es agnóstico; el flag de sensibilidad es parte de su estructura. | **Mantener tal cual.** La estructura del inventario incluye flags de sensibilidad. Si se decide cambiar el flag, se parametriza. | Bajo — si se acepta la estructura propuesta en sección 6, no hay cambio. | — | — |
| D31 | R9 — "No ejecutar DDL dinámico en código en runtime" (línea 144) | Práctica general (agnóstica) | Es una buena práctica universal. | — (ya agnóstico) | — | — | — |
| D32 | R16 — "Nota: nombres específicos se registran en `inventario_recursos.md`" (línea 244) | Documento estructural universal | ~~El nombre del documento es específico.~~ `inventario_recursos.md` es un concepto agnóstico. | **Mantener tal cual.** La nota es correcta: los nombres específicos se registran en el inventario. | Ninguno — no es una dependencia. | — | — |
| D33 | Secciones "Jerarquía de Documentos", "Orden de Lectura", "Dependencias entre Documentos" (líneas 327-376) | Arquitectura documental propietaria | Todo el sistema de gobernanza (niveles, agentes, jerarquía) es específico. | Crear un "sistema de gobernanza" genérico parametrizable: niveles, documentos y roles se definen por proyecto. Incluir `inventario_recursos.md` como documento estándar en la jerarquía. | Alta — reestructuración profunda. | — | — |
| D34 | Sección "Política de Versionamiento" — referencias a documentos propietarios (líneas 459-521) | Documentos propietarios | Menciona `inventario_recursos.md`, `conocimiento_tecnico_preventivo.md`, `.agents/*`. | Generalizar a "cada documento de gobernanza del proyecto tiene su propio versionado". `inventario_recursos.md` se mantiene como documento estándar con versionado propio. | Media — el concepto es universal, los nombres de agentes no. | — | — |
| D35 | R3 — "Usar archivos `.env.development` o `.env.local` (listados en `.gitignore`)" (línea 58) | Convención de framework | `.env.development` y `.env.local` son convenciones de Next.js/Node.js (con `dotenv`). | Cambiar a "Usar archivos de entorno local según la convención del proyecto (`.env.local`, `.env.development`, `.env.dev`), siempre listados en `.gitignore`". | Baja — fácil de generalizar. | — | — |
| D36 | R8 — "Usar secrets gestionados por la plataforma (Vercel Environment Variables, GitHub Secrets)" (línea 129) | Plataforma concreta | Vercel y GitHub son plataformas específicas. | Cambiar a "Usar secrets gestionados por la plataforma de despliegue/CI del proyecto". | Media — ya propuesto en D21. | — | — |
| D37 | R17 — "Configuración `git.deploymentEnabled: false` en `vercel.json`" (línea 256) | Archivo y plataforma concreta | `vercel.json` es específico de Vercel. | Eliminar o mover a ejemplo/template. La regla genérica: "Desactivar despliegues automáticos en push si aplica". | Alta — acoplado a D16. | — | — |
| D38 | R5 — "Código en inglés, documentación en español" (líneas 89-91) | Convención de idioma | La separación código/documentación es válida, pero los idiomas pueden variar. | Hacer configurables los idiomas: "Código en [idioma], documentación en [idioma]". El valor por defecto se deja abierto. | Baja — fácil de parametrizar. | — | — |

---

## 4. Elementos Parcialmente Reutilizables si se Reformulan

| ID | Regla / Fragmento Afectado | Tipo de Dependencia | Por qué no es agnóstica | Propuesta de Generalización | Impacto Esperado | Aprobación (Sí/No) | Comentarios |
|----|---------------------------|---------------------|--------------------------|----------------------------|------------------|---------------------|-------------|
| P01 | R1 — "No asumir valores no documentados" (líneas 25-35) | Principio universal con ejemplos dependientes | El principio es universal. Los ejemplos de plataformas/herramientas son dependientes, pero la referencia a `inventario_recursos.md` es correcta y debe mantenerse. | Mantener el principio y la referencia a `inventario_recursos.md`. Sustituir solo los ejemplos de plataforma (`.env.*` como concepto se mantiene). | Baja — la referencia a `inventario_recursos.md` ya no se considera dependencia. | — | — |
| P02 | R2 — "Cero hardcoding" (líneas 38-49) | Principio universal con ejemplos dependientes | El principio es universal. Los ejemplos (`process.env`, `NEXT_PUBLIC_`) son dependientes. La referencia a `inventario_recursos.md` es correcta. | Mantener el principio y la referencia a `inventario_recursos.md`. Generalizar ejemplos de framework igual que D04, D05. | Media — tocar varios fragmentos pequeños. | — | — |
| P03 | R3 — "Gestión de secrets" (líneas 53-66) | Principio universal con ejemplos dependientes | El principio "no versionar secrets" es universal. Plataformas y archivos mencionados son dependientes. | Mantener el principio. Generalizar plataformas y archivos igual que D20, D21, D24, D35. | Media — tocar varios fragmentos. | — | — |
| P04 | R4 — "Validación segura de variables de entorno" (líneas 69-80) | Principio universal con ejemplos dependientes | El principio "validar y centralizar" es universal. Zod, `lib/env.ts`, `process.env` son dependientes. | Mantener el principio. Generalizar ejemplos igual que D02, D03, D04. | Media — tocar varios fragmentos. | — | — |
| P05 | R6 — "Convención de respuestas HTTP" (líneas 96-107) | Principio universal | La estructura `{ data, error }` es agnóstica. El "no exponer stack traces" también. | Se mantiene tal cual. | Ninguno — ya es reutilizable. | — | — |
| P06 | R7 — "CORS y seguridad de orígenes" (líneas 110-119) | Principio universal | El concepto CORS es universal. "Configurar vía variables de entorno" también. | Se mantiene tal cual. | Ninguno — ya es reutilizable. | — | — |
| P07 | R8 — "Configuración de despliegue" (líneas 123-135) | Principio universal con ejemplos dependientes | "Despliegue reproducible" es universal. `package.json`, `npm run build`, `Dockerfile` son dependientes. | Mantener el principio. Generalizar igual que D07, D08, D09, D29. | Media — tocar varios fragmentos. | — | — |
| P08 | R9 — "Migraciones de esquema de BD" (líneas 139-146) | Principio universal con ejemplos dependientes | "Migraciones idempotentes" es universal. El formato `001-initial.sql` es dependiente. | Mantener el principio. Generalizar igual que D10. | Baja — un solo fragmento. | — | — |
| P09 | R10 — "Estrategia de pruebas" (líneas 149-157) | Principio universal con ejemplos dependientes | "Tests antes de commit" es universal. `npm run test` es dependiente. | Mantener el principio. Generalizar igual que D11, D12. | Baja — un solo fragmento. | — | — |
| P10 | R11 — "Calidad de código antes de commit" (líneas 161-169) | Principio universal | "Ejecutar linters y typechecks" es universal, aunque "typecheck" es más de TS. | Cambiar "typechecks" por "análisis estático" (typecheck, lint, etc.). | Baja — mínimo ajuste. | — | — |
| P11 | R12 — "Convenciones de commit" (líneas 173-183) | Principio universal | "Mensajes descriptivos" es universal. La excepción "Orquestador Decide" es dependiente. | Mantener. La excepción es parte del flujo de este proyecto; en una versión agnóstica se elimina o se deja como ejemplo. | Baja — solo la excepción es dependiente. | — | — |
| P12 | R13 — "Contratos entre servicios" (líneas 187-194) | Principio universal con referencia correcta | "Documentar contratos" es universal. "Registrar en `inventario_recursos.md`" es correcto y debe mantenerse. | Mantener el principio y la referencia a `inventario_recursos.md`. El inventario es el lugar natural para contratos. | Ninguno — la referencia ya es correcta. | — | — |
| P13 | R16 — "Convención de nombres para variables de entorno" (líneas 233-244) | Convención con nombres específicos | El patrón `[SERVICE]_API_KEY` es universal. `NEXT_PUBLIC_` y `DATABASE_URL` son dependientes. | Mantener el patrón. Los prefijos y nombres se definen por proyecto. | Baja — solo ajustar ejemplos. | — | — |
| P14 | R5 — "Idioma y estilo" (líneas 84-93) | Convención con valores configurables | La tabla de usos de idioma es un buen formato. Los valores (español, inglés) son configurables. | Mantener la tabla como plantilla; los idiomas se definen por proyecto. | Baja — solo parametrizar valores. | — | — |

---

## 5. Elementos ya Agnósticos o Reutilizables sin Cambios

| ID | Regla / Fragmento | Razón |
|----|-------------------|-------|
| A01 | R1 (principio): "Si hay duda, preguntar antes de generar código" | Principio universal en cualquier proyecto. |
| A02 | R1: "No inventar nombres de variables de entorno, rutas API o configuraciones" | Principio universal de no asumir. |
| A03 | R1: "No asumir URLs, credenciales, connection strings o IDs de recursos" | Principio universal. |
| A04 | R1: "Validar disponibilidad de variables de entorno en `.env.*`" | Principio universal (el formato `.env.*` es estándar de facto). |
| A05 | R2 (principio): "No codificar credenciales, connection strings, URLs, IDs, API keys" | Principio universal. |
| A06 | R2: "Usar variables de entorno" | Principio universal. |
| A07 | R2: "No incluir datos, consultas SQL, enlaces ni configuraciones fijas en archivos versionados" | Principio universal. |
| A08 | R3 (principio): "Claves, tokens, conexiones y certificados nunca versionados en el repositorio" | Principio universal. |
| A09 | R3: "Usar `.env.example` para documentar variables requeridas sin valores reales" | Principio universal. |
| A10 | R6: "Estructura de respuestas HTTP" y "No exponer stack traces en producción" | Principios universales de API design. |
| A11 | R7: "CORS configurable por variables de entorno" | Principio universal. |
| A12 | R8 (principio): "Despliegue reproducible y seguro, sin credenciales versionadas" | Principio universal. |
| A13 | R9 (principio): "Migraciones idempotentes" + "No DDL dinámico en runtime" | Principios universales de gestión de BD. |
| A14 | R10 (principio): "Ejecutar tests localmente antes de commit" | Principio universal. |
| A15 | R10: "Configurar mocks en configuración de test, no en cada caso" | Principio universal de testing. |
| A16 | R11 (principio): "Ejecutar linters; el proyecto debe compilar sin errores" | Principio universal (compilar = build/typecheck según el lenguaje). |
| A17 | R11: "Resolver o silenciar advertencias relevantes" | Principio universal. |
| A18 | R12 (principio): "Descripción detallada sin revisar el diff" | Principio universal de commits. |
| A19 | R12: "Registro explícito de cambios" | Principio universal. |
| A20 | R13 (principio): "Documentar rutas, métodos y formatos request/response" | Principio universal de contratos entre servicios. |
| A21 | R13: "Verificar disponibilidad antes de desplegar dependencias" | Principio universal. |
| A22 | R18 (principio): "Consultar documentación técnica preventiva antes de planificar, diseñar, desarrollar, corregir, depurar, probar o desplegar" | Principio universal (el nombre del documento es lo dependiente). |
| A23 | Jerarquía de prioridad entre documentos (Nivel 1 > 2 > 3) | Concepto universal de gobernanza documental. |
| A24 | Regla de conflicto entre documentos | Concepto universal. |
| A25 | Versionado independiente por documento | Concepto universal. |
| A26 | Proceso de actualización de documentos | Concepto universal. |
| A27 | **`inventario_recursos.md` como concepto** — documento central de inventario de recursos, configuraciones, secrets (nombres), contratos, stack, comandos y archivos de configuración | Documento estructural universal. Todo proyecto necesita un punto de entrada único para conocer sus recursos. Los ejemplos `temp/inventario_recursos_1.md` y `temp/inventario_recursos_2.md` confirman que la estructura (leyenda, secciones, historial) es reusable. | — | — |
| A28 | **Regla de consulta obligatoria:** Leer `inventario_recursos.md` antes de iniciar cualquier acción relevante para tener una "foto instantánea" del proyecto | Principio universal: antes de actuar, conocer el estado actual de los recursos. | — | — |
| A29 | **Estructura del inventario:** Leyenda de estados (✅ ⚠️ 🔲 🚫 🗑️), secciones por tipo de recurso, historial de cambios, vacíos pendientes | Formato de documento reusable que aparece consistente en ambos ejemplos revisados. | — | — |

---

## 6. Propuesta de Generalización para `inventario_recursos.md`

Basada en los ejemplos `temp/inventario_recursos_1.md` (concreto, relleno) y `temp/inventario_recursos_2.md` (template con placeholders), y en `temp/agente-inventariador.md` que define su propósito y estructura.

### 6.1. Principio rector

`inventario_recursos.md` es un **documento estructural universal** que debe existir en todo proyecto que adopte estas reglas. No es una dependencia específica; es parte del esqueleto de gobernanza del proyecto.

### 6.2. Función del documento

- **Fuente única de verdad** para recursos del proyecto: infraestructura, configuración, variables de entorno, secrets (nombres, nunca valores), integraciones, contratos entre servicios, stack tecnológico, comandos y archivos de configuración.
- **Punto de entrada** para cualquier agente o colaborador: antes de iniciar una acción relevante, leer `inventario_recursos.md` para obtener una "foto instantánea" del estado y recursos del proyecto.
- **Registro histórico** de cambios en la configuración y recursos del proyecto.

### 6.3. Estructura agnóstica propuesta

```markdown
# Inventario de Recursos y Configuración

> **Finalidad:** Fuente única de verdad para recursos del proyecto.
> **Versión:** X.Y
> **Importante:** Gestionado según las reglas de gobernanza del proyecto.

## Leyenda de Estado
(✅ ⚠️ 🔲 🚫 🗑️ — símbolos universales)

## Reglas de Uso
- No inventar valores.
- No incluir secretos ni credenciales en texto plano.
- Consultar antes de ejecutar trabajo con impacto operativo.

## 1. Resumen del Proyecto
(Nombre, finalidad, repositorio, stack — valores del proyecto, sin fijar tecnologías)

## 2. Secrets para Despliegue (nombres, nunca valores)
## 3. Secrets de Desarrollo Local (nombres, nunca valores)
## 4. Recursos del Proyecto
(Infraestructura, servicios, plataformas — según corresponda al stack)

## 5. Configuración de Despliegue
## 6. Variables de Entorno
## 7. Integraciones Externas
## 8. Contratos entre Servicios
## 9. Stack Tecnológico
## 10. Comandos de Desarrollo
## 11. Archivos de Configuración
## 12. Vacíos Pendientes de Confirmación
## 13. Historial de Cambios
```

### 6.4. Reglas que debe cumplir en su versión agnóstica

1. **Sin valores de proyecto incrustados:** Los campos deben estar vacíos o usar placeholders (`[VALOR]`) en la plantilla base. Cada proyecto los completa.
2. **Sin tecnologías fijas:** Las secciones de recursos (ej. sección 4) deben ser genéricas, no "Cloudflare Workers" ni "Vercel". Cada proyecto detalla sus propios tipos de recurso.
3. **Secrets como nombres, nunca valores:** La regla de seguridad se mantiene universal.
4. **Estructura modular:** Cada sección puede incluirse o excluirse según el proyecto (ej. un proyecto sin BD omite la sección de migraciones).
5. **Actualización continua:** El documento se mantiene durante la vida del proyecto, no es una plantilla estática.

### 6.5. Impacto en las reglas existentes

| Regla | Cambio Propuesto |
|-------|-----------------|
| R1, R2, R13, R14, R16 | Mantener referencias a `inventario_recursos.md`. No requieren cambio. |
| R15 | Separar en: (a) el documento `inventario_recursos.md` como regla agnóstica, (b) el agente `inventariador` como rol configurable por proyecto. |
| Jerarquía de documentos | Incluir `inventario_recursos.md` como documento de nivel estándar (Nivel 3 o equivalente). |
| Sección de dependencias entre docs | `inventario_recursos.md` es documento base que todos los agentes/roles deben consultar. |

### 6.6. Estado de los archivos de ejemplo revisados

| Archivo | Naturaleza | Utilidad para la plantilla agnóstica |
|---------|-----------|--------------------------------------|
| `temp/inventario_recursos_1.md` | Concreto, relleno con valores reales de "Prompt Database" (Next.js + Prisma + Vercel) | Ejemplo de cómo se ve un inventario completado. No usable directamente como plantilla por su contenido específico. |
| `temp/inventario_recursos_2.md` | Template con placeholders (`[VALOR]`) orientado a Cloudflare | Base más cercana a una plantilla agnóstica. Las secciones son reusables; los tipos de recurso (Workers, KV, D1) son específicos de Cloudflare y deberían generalizarse. |
| `temp/agente-inventariador.md` | Definición del rol que gestiona el inventario | Describe el propósito, estructura y reglas operativas del inventario. Útil para entender la función del documento, aunque el rol "inventariador" es específico. |

---

## 7. Conclusión y Recomendaciones

### Resumen Cuantitativo

| Categoría | Cantidad |
|-----------|----------|
| Elementos claramente dependientes (D01-D38) | 38 |
| Elementos parcialmente reutilizables (P01-P14) | 14 |
| Elementos ya agnósticos (A01-A29) | 29 |

> **Nota:** Respecto a la versión anterior del análisis, los items D26-D28, D30, D32 fueron reclasificados de "dependientes" a "correctos y agnósticos" tras confirmar que `inventario_recursos.md` es un concepto universal. Se añadieron A27-A29 para reflejar esta corrección.

### Hallazgos Principales

1. **Alto acoplamiento al stack Next.js + TypeScript**: Las reglas R2, R3, R4, R8, R10 y R14 contienen numerosas referencias a `NEXT_PUBLIC_`, `process.env`, `package.json`, `npm`, `lib/env.ts`, que son específicos de Node.js/Next.js.

2. **Dependencia total de la plataforma Vercel**: La regla R17 es completamente dependiente de Vercel. Las reglas R3 y R8 también tienen bloques dedicados a Vercel.

3. **Sistema de gobernanza propietario**: Las secciones de "Asignación de Responsabilidades", "Jerarquía de Documentos", "Referencias a Documentos" y "Criterios Operativos" están fuertemente acopladas a los nombres de agentes y roles específicos del proyecto (`orquestador`, `inventariador`, `inventory-auditor`, `nextjs-api`, `prisma-database`, etc.).

4. **`inventario_recursos.md` como documento estructural universal**: A diferencia de `conocimiento_tecnico_preventivo.md` (que sí es propietario), `inventario_recursos.md` es un documento de inventario que toda proyecto necesita. Su estructura (leyenda, secciones por recurso, historial) es reusable. Su contenido debe ser llenado por cada proyecto, sin valores fijos.

5. **Núcleo universal subyacente**: Aproximadamente 29 elementos (buenas prácticas como "no hardcodear", "validar variables de entorno", "ejecutar tests", más el concepto de inventario de recursos) son universales y se pueden mantener sin cambios.

### Recomendaciones para el Siguiente Paso

1. **Estrategia de capas**: Propongo estructurar las nuevas reglas agnósticas en dos capas:
   - **Capa 1 — Reglas universales** (independientes del stack): R1, R2 (principio), R6, R7, R11, R12, R13, los principios de R3, R4, R8, R9, R10, R18, y el concepto de `inventario_recursos.md`.
   - **Capa 2 — Adaptadores por ecosistema**: Ejemplos concretos para Node.js, PHP, Rust, etc. (opcional, fuera del alcance de este análisis).

2. **Prioridad de generalización** (de mayor a menor impacto):
   | Prioridad | Elementos | Esfuerzo |
   |-----------|-----------|----------|
   | 1 | D01 (stack tecnológico), D16/D37 (Vercel), D19/D23 (agentes) | Alto |
   | 2 | D04/D05/D22 (process.env/NEXT_PUBLIC_), D02 (Zod), D07/D08 (npm/package.json) | Medio |
   | 3 | D14/D17/D18/D33/D34 (agentes y documentos propietarios, excluyendo inventario_recursos.md) | Medio |
   | 4 | P01-P14 (reformulaciones menores) | Bajo |

3. **Formato de salida recomendado**: Un único documento `reglas_universales.md` donde:
   - Cada regla use `[PLATFORM]` o `[STACK]` como placeholder.
   - Las secciones de gobernanza y roles sean parametrizables.
   - `inventario_recursos.md` se incluya como documento estándar con su estructura propuesta (sección 6).
   - Se incluya un preámbulo que explique cómo adaptar las reglas a cada proyecto.

4. **Próximo paso concreto**: Una vez aprobado este análisis, proceder a la reescritura del documento final siguiendo la estructura de capas propuesta:
   - Mantener `inventario_recursos.md` como documento fijo en la jerarquía.
   - Eliminar dependencias de stack, plataforma y agentes.
   - Sustituir por placeholders o configuraciones.
   - Generar una plantilla base de `inventario_recursos.md` siguiendo la estructura de la sección 6.

---

*Documento generado el 2026-04-28. Basado exclusivamente en `temp/reglas_proyecto.md` (v5.1, 521 líneas), `temp/inventario_recursos_1.md` (v6.1, 316 líneas), `temp/inventario_recursos_2.md` (v5.0, 307 líneas), y `temp/agente-inventariador.md` (599 líneas).*
