# A02 — Análisis Comparativo de Herramientas de Workflow para el Proyecto

---

## Índice de Contenido

1. [Resumen Ejecutivo](#1-resumen-ejecutivo)
2. [Descripción de las Herramientas Analizadas](#2-descripción-de-las-herramientas-analizadas)
3. [Síntesis de las Necesidades del Proyecto según Boceto_B09.md](#3-síntesis-de-las-necesidades-del-proyecto-según-boceto_b09md)
4. [Evaluación Individual por Herramienta](#4-evaluación-individual-por-herramienta)
   - [4.1 FlowCrafter](#41-flowcrafter)
   - [4.2 php-workflow](#42-php-workflow)
   - [4.3 Pipeflow PHP](#43-pipeflow-php)
   - [4.4 Workflow Engine Core](#44-workflow-engine-core)
5. [Comparativa Directa entre Herramientas](#5-comparativa-directa-entre-herramientas)
6. [Clasificación y Descarte](#6-clasificación-y-descarte)
7. [Riesgos, Limitaciones y Dependencias](#7-riesgos-limitaciones-y-dependencias)
8. [Flecos Pendientes de Resolver](#8-flecos-pendientes-de-resolver)
9. [Conclusión y Recomendación para el Usuario](#9-conclusión-y-recomendación-para-el-usuario)

---

## 1. Resumen Ejecutivo

### 1.1 Propósito del Análisis

Este documento evalúa cuatro herramientas de workflow para PHP (`FlowCrafter`, `php-workflow`, `Pipeflow PHP`, `Workflow Engine Core`) frente a las necesidades del proyecto descrito en `02-Boceto_B09.md`.

El objetivo es determinar qué herramienta es más adecuada para implementar el **motor de flujo de proceso** de la Web-App (WA) que automatiza la transformación de PDFs en productos WooCommerce.

### 1.2 Conclusión Anticipada

| Herramienta | Clasificación | Veredicto |
| ----------- | ------------- | --------- |
| **Pipeflow PHP** | ✅ Recomendable | **Mejor encaje global** |
| **php-workflow** | ⚠️ Parcialmente recomendable | Viable con limitaciones |
| **FlowCrafter** | ⚠️ Parcialmente recomendable | Viable para casos específicos |
| **Workflow Engine Core** | ❌ No recomendable | Descartar (alpha, no producción) |

### 1.3 Hallazgos Clave

| Hallazgo | Impacto |
| -------- | ------- |
| **Pipeflow PHP** tiene casos de uso reales con WordPress + generación de contenido con IA | Alto encaje con el proyecto |
| **Workflow Engine Core** está en versión alpha (NO producción) | Descarte inmediato |
| **FlowCrafter** requiere infraestructura CLI corriendo | Complejidad añadida innecesaria |
| **php-workflow** no tiene persistencia de estado | Limitación para trazabilidad |
| **Ninguna herramienta** cubre todos los requisitos del proyecto | Se requerirá extensión personalizada |

---

## 2. Descripción de las Herramientas Analizadas

### 2.1 FlowCrafter

| Característica | Descripción |
| -------------- | ----------- |
| **Nombre completo** | wundii/flowcrafter |
| **Descripción** | Herramienta para crear y automatizar flujos de trabajo con ejecución asíncrona, colas y programación por horario |
| **Enfoque principal** | Automatización con cola de tareas y programación horaria |
| **Persistencia** | ✅ Sí (almacenamiento configurable: MySQL, Redis) |
| **Programación** | ✅ Sí (cron integrado) |
| **Cola de tareas** | ✅ Sí (observer) |
| **Instalación** | `composer require wundii/flowcrafter` |
| **Licencia** | No especificada en guías |

### 2.2 php-workflow

| Característica | Descripción |
| -------------- | ----------- |
| **Nombre completo** | wol-soft/php-workflow |
| **Descripción** | Biblioteca para implementar pasos de proceso individuales de forma estructurada usando etapas predefinidas |
| **Enfoque principal** | Organización de pasos de proceso con validaciones y manejo de errores |
| **Persistencia** | ❌ No (sin estado, ejecución puntual) |
| **Etapas predefinidas** | ✅ 7 etapas (Prepare, Validate, Before, Process, OnSuccess, OnError, After) |
| **Versión** | 2.1.1 (estable, mantenido) |
| **Licencia** | MIT |

### 2.3 Pipeflow PHP

| Característica | Descripción |
| -------------- | ----------- |
| **Nombre completo** | marcosiino/pipeflow-php |
| **Descripción** | Motor de pipelines ligero que permite definir flujos en XML para que incluso no-programadores puedan editarlos |
| **Enfoque principal** | Automatizaciones editables por no-programadores vía XML |
| **Persistencia** | ❌ No (sin estado, ejecución puntual) |
| **Stages pre-incluidos** | ✅ 14 stages (SetValue, Echo, If, ForEach, JSONDecode, etc.) |
| **Configuración** | ✅ XML (primario) + PHP (secundario) |
| **Casos de uso reales** | ✅ 2 sitios en producción (PagineDaColorare.it, Fiaberello.it) |
| **Licencia** | BSD 3-Clause |

### 2.4 Workflow Engine Core

| Característica | Descripción |
| -------------- | ----------- |
| **Nombre completo** | solution-forest/workflow-engine-core |
| **Descripción** | Motor de workflows con estados, reintentos, timeouts y eventos para procesos de negocio complejos |
| **Enfoque principal** | Ejecutar procesos de negocio con estados, reintentos, timeouts y persistencia |
| **Persistencia** | ✅ Sí (StorageAdapter configurable) |
| **Reintentos** | ✅ Hasta N reintentos configurables |
| **Timeouts** | ✅ Timeout configurable por paso |
| **Eventos** | ✅ 7 tipos de eventos notificables |
| **Versión** | v0.0.3-alpha |
| **¿Listo para producción?** | ❌ **NO** (en desarrollo activo) |
| **Licencia** | MIT |

---

## 3. Síntesis de las Necesidades del Proyecto según Boceto_B09.md

### 3.1 Naturaleza del Proceso a Automatizar

El proyecto requiere automatizar un **flujo secuencial con estados** que incluye:

```
Login → Subir PDF → Extraer texto → Procesar con IA (múltiples ejecuciones) → 
Formulario de revisión → Aprobación/Rechazo → API WooCommerce → Publicación
```

### 3.2 Requisitos Funcionales del Flujo

| Requisito | Descripción | Prioridad |
| --------- | ----------- | --------- |
| **Secuencialidad** | Pasos que se ejecutan en orden específico | Crítica |
| **Estados visibles** | Usuario debe ver avance del proceso | Alta |
| **Cancelación** | Usuario puede cancelar durante ejecución | Alta |
| **Manejo de errores** | Diferentes comportamientos según tipo de error | Crítica |
| **Trazabilidad** | Log completo desde inicio hasta fin | Crítica |
| **Persistencia de estado** | Conservar estado para recuperación/admin | Alta |
| **Múltiples ejecuciones de IA** | Roles diferenciados, algunos dependientes entre sí | Crítica |
| **Aprobación humana** | Punto de decisión antes de publicación | Crítica |
| **Conservación/eliminación** | Archivos se conservan o borran según resultado | Alta |

### 3.3 Requisitos Técnicos del Flujo

| Requisito | Descripción |
| --------- | ----------- |
| **Ejecución asíncrona** | Proceso puede tardar segundos/minutos |
| **Timeouts** | Límites de tiempo por paso (implícito en cancelación) |
| **Reintentos** | No especificado explícitamente, pero deseable para fallos transitorios |
| **Log paso a paso** | Cada paso debe registrarse con identidad de usuario |
| **Integración con WordPress** | Validación de usuarios, guardado de texto/media |
| **Integración con WooCommerce** | API para crear productos |
| **Integración con IA** | Múltiples proveedores, múltiples ejecuciones |

### 3.4 Criterios de Evaluación

Cada herramienta se evaluará según:

| Criterio | Peso |
| -------- | ---- |
| Encaje con flujo secuencial | Alto |
| Capacidad de manejo de estados | Alto |
| Persistencia de estado | Medio |
| Manejo de errores | Alto |
| Trazabilidad/log | Alto |
| Facilidad de integración con WordPress | Alto |
| Facilidad de integración con APIs externas (IA, WooCommerce) | Alto |
| Madurez de la herramienta | Medio |
| Documentación disponible | Medio |
| Casos de uso reales similares | Alto |

---

## 4. Evaluación Individual por Herramienta

### 4.1 FlowCrafter

#### 4.1.1 Propósito y Arquitectura

| Aspecto | Evaluación |
| ------- | ---------- |
| **Propósito** | Automatización con ejecución asíncrona, colas y programación horaria |
| **Arquitectura** | Messages (Init/Data/Return) → Stubs → Flow → Storage |
| **Patrón** | Front controller con CLI corriendo (observer + scheduler) |
| **Enfoque** | Procesos que necesitan ejecución en segundo plano |

#### 4.1.2 Capacidades que Sí Cubre

| Capacidad | Encaje con B09 |
| --------- | -------------- |
| **Ejecución secuencial** | ✅ Stubs se ejecutan en orden definido |
| **Persistencia de estado** | ✅ Almacenamiento configurable (MySQL, Redis) |
| **Ejecución asíncrona** | ✅ Cola de tareas (observer) |
| **Registro de ejecución** | ✅ Registro completo de ejecución |
| **Detección de errores** | ✅ Registro de errores |
| **Interfaz visual** | ✅ Pantalla web para ver estado de procesos |
| **Diagramas automáticos** | ✅ Genera diagramas Mermaid del flujo |

#### 4.1.3 Carencias Detectadas

| Carencia | Impacto en proyecto |
| -------- | ------------------- |
| **Sin etapas predefinidas** | Requiere definir toda la estructura desde cero |
| **Sin validaciones nativas** | Validaciones deben implementarse manualmente en Stubs |
| **Sin reintentos automáticos** | No hay mecanismo built-in para retry |
| **Sin timeouts** | No hay límite de tiempo por paso |
| **Sin condiciones nativas** | Control de flujo condicional debe implementarse manualmente |
| **Sin bucles nativos** | No hay soporte para iteración sobre colecciones |
| **Requiere CLI corriendo** | Necesita observer y scheduler activos constantemente |

#### 4.1.4 Complejidad Añadida

| Complejidad | Descripción |
| ----------- | ----------- |
| **Infraestructura** | Requiere CLI corriendo (observer + scheduler) |
| **Configuración inicial** | 7 comandos CLI para configurar (config:create, storage:init, dev, service, observer, scheduler, diagram:mermaid) |
| **Curva de aprendizaje** | 4 conceptos: Messages, Stubs, Flow, Ejecución |
| **Tiempo primera automatización** | 1-2 horas estimado |

#### 4.1.5 Riesgos Técnicos

| Riesgo | Probabilidad | Impacto |
| ------ | ------------ | ------- |
| **Infraestructura compleja** | Alta | Requiere procesos CLI corriendo en producción |
| **Sin reintentos** | Media | Fallos transitorios no se recuperan automáticamente |
| **Sin timeouts** | Media | Procesos pueden colgarse indefinidamente |
| **Documentación limitada** | Media | Difficult para nuevos desarrolladores |
| **Madurez no especificada** | Media | Riesgo de abandono o cambios breaking |

#### 4.1.6 Limitaciones Funcionales

| Limitación | Descripción |
| ---------- | ----------- |
| **Control de flujo limitado** | Cada Stub decide qué devolver, sin control explícito del flujo |
| **Sin eventos** | No hay sistema de notificación de cambios de estado |
| **Sin workflows anidados** | No se puede componer flujos complejos |

#### 4.1.7 Dependencia o Acoplamiento

| Dependencia | Nivel |
| ----------- | ----- |
| **Infraestructura CLI** | Alto (observer + scheduler deben correr) |
| **Storage** | Medio (configurable, pero requiere inicialización) |
| **Frameworks** | Bajo (independiente) |

#### 4.1.8 Mantenibilidad

| Aspecto | Evaluación |
| ------- | ---------- |
| **Código organizado** | ✅ Stubs separados por responsabilidad |
| **Testing integrado** | ❌ No específico |
| **Documentación** | ⚠️ docs/ disponible pero no especificada calidad |
| **Extensibilidad** | ✅ Stubs personalizados posibles |

#### 4.1.9 Facilidad de Integración

| Integración | Evaluación |
| ----------- | ---------- |
| **WordPress** | ⚠️ Requiere adaptación (no hay casos documentados) |
| **WooCommerce API** | ✅ Guzzle HTTP disponible |
| **APIs de IA** | ✅ Guzzle HTTP disponible |
| **Sistema de archivos** | ✅ No hay restricciones |

#### 4.1.10 Impacto sobre el Desarrollo Futuro

| Impacto | Descripción |
| ------- | ----------- |
| **Positivo** | Infraestructura completa para procesos asíncronos |
| **Negativo** | Complejidad operacional de mantener CLI corriendo |
| **Neutral** | Código PHP moderno, fácil de extender |

#### 4.1.11 Dudas o Flecos Pendientes

| Duda | Estado |
| ---- | ------ |
| ¿Cómo se integra con WordPress para validación de usuarios? | ❓ No documentado |
| ¿Cómo se maneja la cancelación de procesos en curso? | ❓ No especificado |
| ¿Qué pasa si el observer se detiene? | ❓ No especificado comportamiento |
| ¿Cómo se registra la identidad del usuario en el log? | ❓ No especificado |

---

### 4.2 php-workflow

#### 4.2.1 Propósito y Arquitectura

| Aspecto | Evaluación |
| ------- | ---------- |
| **Propósito** | Organizar pasos de proceso individuales con validaciones y registro detallado |
| **Arquitectura** | Workflow → Stages (7) → Steps → WorkflowContainer → WorkflowResult |
| **Patrón** | Pipeline de etapas predefinidas |
| **Enfoque** | Pasos de proceso estructurados con validaciones |

#### 4.2.2 Capacidades que Sí Cubre

| Capacidad | Encaje con B09 |
| --------- | -------------- |
| **Ejecución secuencial** | ✅ Steps se ejecutan en orden de stages |
| **7 etapas predefinidas** | ✅ Prepare, Validate, Before, Process, OnSuccess, OnError, After |
| **Validaciones duras/suaves** | ✅ Validaciones que detienen o continúan |
| **Registro detallado** | ✅ Log con estados (ok, failed, skipped) + SVG + GraphViz |
| **Control de flujo** | ✅ skipStep, failStep, failWorkflow, skipWorkflow, warning |
| **Bucles nativos** | ✅ Loop con interfaz LoopControl (continue/break) |
| **Workflows anidados** | ✅ NestedWorkflow (workflow dentro de otro) |
| **Datos compartidos** | ✅ WorkflowContainer (get/set/unset/has) |
| **Dependencias de pasos** | ✅ Atributos PHP 8.0+ #[Required] |
| **Testing integrado** | ✅ WorkflowTestTrait (assertDebugLog, expectFailAtStep, etc.) |
| **Workshop incluido** | ✅ Ejercicio práctico cubre múltiples características |

#### 4.2.3 Carencias Detectadas

| Carencia | Impacto en proyecto |
| -------- | ------------------- |
| **Sin persistencia** | ❌ Estado no se conserva entre ejecuciones |
| **Sin ejecución asíncrona** | ❌ Ejecución síncrona única |
| **Sin reintentos automáticos** | ❌ No hay mecanismo built-in para retry |
| **Sin timeouts** | ❌ No hay límite de tiempo por paso |
| **Sin condiciones nativas** | ⚠️ Manejo manual en código |
| **Sin acciones pre-incluidas** | ❌ 0 actions, todas personalizadas |
| **Sin programación horaria** | ❌ No hay scheduler |

#### 4.2.4 Complejidad Añadida

| Complejidad | Descripción |
| ----------- | ----------- |
| **Infraestructura** | ✅ Baja (solo código, sin CLI corriendo) |
| **Configuración inicial** | ✅ Baja (solo Composer) |
| **Curva de aprendizaje** | 5 conceptos: Steps, WorkflowControl, Stages, WorkflowContainer, WorkflowResult |
| **Tiempo primera automatización** | 30-60 minutos estimado |

#### 4.2.5 Riesgos Técnicos

| Riesgo | Probabilidad | Impacto |
| ------ | ------------ | ------- |
| **Sin persistencia** | Alta | Imposible recuperar estado tras fallo |
| **Sin reintentos** | Media | Fallos transitorios no se recuperan |
| **Sin timeouts** | Media | Procesos pueden colgarse |
| **Madurez buena** | ✅ Baja | v2.1.1 estable, mantenido desde Nov 2024 |

#### 4.2.6 Limitaciones Funcionales

| Limitación | Descripción |
| ---------- | ----------- |
| **Ejecución síncrona única** | No soporta procesos largos en segundo plano |
| **Sin eventos** | No hay sistema de notificación de cambios |
| **Sin configuración no-código** | Solo código PHP, no editable por no-programadores |

#### 4.2.7 Dependencia o Acoplamiento

| Dependencia | Nivel |
| ----------- | ----- |
| **Infraestructura** | ✅ Bajo (solo código) |
| **PHP** | ✅ PHP 7.4+ compatible |
| **Frameworks** | ✅ Bajo (independiente) |

#### 4.2.8 Mantenibilidad

| Aspecto | Evaluación |
| ------- | ---------- |
| **Código organizado** | ✅ Steps separados por responsabilidad |
| **Testing integrado** | ✅ WorkflowTestTrait incluido |
| **Documentación** | ✅ README.md extenso |
| **Extensibilidad** | ✅ WorkflowStep personalizado posible |
| **Calidad de código** | ✅ CodeClimate maintainability, Coveralls coverage |

#### 4.2.9 Facilidad de Integración

| Integración | Evaluación |
| ----------- | ---------- |
| **WordPress** | ⚠️ No hay casos documentados, pero viable |
| **WooCommerce API** | ✅ Guzzle HTTP disponible |
| **APIs de IA** | ✅ Guzzle HTTP disponible |
| **Sistema de archivos** | ✅ No hay restricciones |

#### 4.2.10 Impacto sobre el Desarrollo Futuro

| Impacto | Descripción |
| ------- | ----------- |
| **Positivo** | Código bien organizado, fácil de mantener |
| **Negativo** | Sin persistencia limita trazabilidad completa |
| **Neutral** | Maduro y estable, bajo riesgo de cambios breaking |

#### 4.2.11 Dudas o Flecos Pendientes

| Duda | Estado |
| ---- | ------ |
| ¿Cómo se integra el log con el sistema de log del proyecto? | ❓ No especificado |
| ¿Cómo se maneja la cancelación de procesos en curso? | ❓ No especificado |
| ¿Cómo se registra la identidad del usuario? | ❓ No especificado, pero viable vía WorkflowContainer |

---

### 4.3 Pipeflow PHP

#### 4.3.1 Propósito y Arquitectura

| Aspecto | Evaluación |
| ------- | ---------- |
| **Propósito** | Crear pipelines configurables en XML que no-programadores puedan editar |
| **Arquitectura** | XML/PHP → PipelineXMLConfigurator → StageFactory → Pipeline → PipelineContext |
| **Patrón** | Pipeline con stages configurables vía XML |
| **Enfoque** | Automatizaciones editables por no-programadores |

#### 4.3.2 Capacidades que Sí Cubre

| Capacidad | Encaje con B09 |
| --------- | -------------- |
| **Ejecución secuencial** | ✅ Stages se ejecutan en orden definido |
| **14 stages pre-incluidos** | ✅ SetValue, Echo, If, ForEach, For, JSONDecode, JSONEncode, ArrayCount, ArrayPath, ExplodeString, SumOperation, Delay, RandomArrayItem, RandomValue |
| **Control de flujo condicional** | ✅ Stage If con 8 operadores |
| **Bucles nativos** | ✅ ForEach (sobre arrays) + For (rango numérico) |
| **Datos compartidos** | ✅ PipelineContext (set/get/delete/check) |
| **Referencias anidadas** | ✅ Navegación con notación de puntos (usuario.direccion.ciudad) |
| **Placeholders en texto** | ✅ %%variable%% y %%variable[indice]%% |
| **Validación de configuración** | ✅ Validación XSD de archivos XML |
| **Configuración dual** | ✅ XML (primario) + PHP (secundario) |
| **Casos de uso reales** | ✅ 2 sitios en producción con WordPress + IA |

#### 4.3.3 Carencias Detectadas

| Carencia | Impacto en proyecto |
| -------- | ------------------- |
| **Sin persistencia** | ❌ Estado no se conserva entre ejecuciones |
| **Sin ejecución asíncrona** | ❌ Ejecución síncrona única |
| **Sin reintentos automáticos** | ❌ No hay mecanismo built-in para retry |
| **Sin timeouts** | ❌ No hay límite de tiempo por paso |
| **Manejo básico de errores** | ⚠️ Solo manejo básico, sin recuperación avanzada |
| **Sin eventos** | ❌ No hay sistema de notificación de cambios |
| **Sin interfaz visual** | ❌ Solo XML, sin diagramas automáticos |

#### 4.3.4 Complejidad Añadida

| Complejidad | Descripción |
| ----------- | ----------- |
| **Infraestructura** | ✅ Baja (solo código, sin CLI corriendo) |
| **Configuración inicial** | ✅ Baja (solo Composer + registerStages) |
| **Curva de aprendizaje** | 4 conceptos: Contexto, Stages, Referencias, Control Flujo |
| **Tiempo primera automatización** | 15-30 minutos (XML) estimado |

#### 4.3.5 Riesgos Técnicos

| Riesgo | Probabilidad | Impacto |
| ------ | ------------ | ------- |
| **Sin persistencia** | Alta | Imposible recuperar estado tras fallo |
| **Sin reintentos** | Media | Fallos transitorios no se recuperan |
| **Sin timeouts** | Media | Procesos pueden colgarse |
| **Madurez buena** | ✅ Baja | Usado en producción real (2 sitios) |

#### 4.3.6 Limitaciones Funcionales

| Limitación | Descripción |
| ---------- | ----------- |
| **Ejecución síncrona única** | No soporta procesos largos en segundo plano |
| **Sin configuración de reintentos** | No hay retry logic |
| **XML puede ser verboso** | Flujos complejos requieren XML extenso |

#### 4.3.7 Dependencia o Acoplamiento

| Dependencia | Nivel |
| ----------- | ----- |
| **Infraestructura** | ✅ Bajo (solo código) |
| **PHP** | ✅ PHP moderno (no especifica versión mínima) |
| **Frameworks** | ✅ Bajo (independiente, pero funciona con WordPress) |

#### 4.3.8 Mantenibilidad

| Aspecto | Evaluación |
| ------- | ---------- |
| **Código organizado** | ✅ Stages separados por responsabilidad |
| **Testing integrado** | ❌ No específico |
| **Documentación** | ✅ README.md + DOCUMENTATION.md detallada |
| **Extensibilidad** | ✅ AbstractPipelineStage + AbstractStageFactory |
| **XML editable** | ✅ No-programadores pueden modificar flujos |

#### 4.3.9 Facilidad de Integración

| Integración | Evaluación |
| ----------- | ---------- |
| **WordPress** | ✅ **Casos reales documentados** (PagineDaColorare.it, Fiaberello.it) |
| **WooCommerce API** | ✅ Mencionado en documentación: "fetch WooCommerce products" |
| **APIs de IA** | ✅ **Casos reales documentados** (generación de contenido con IA) |
| **Sistema de archivos** | ✅ No hay restricciones |

#### 4.3.10 Impacto sobre el Desarrollo Futuro

| Impacto | Descripción |
| ------- | ----------- |
| **Positivo** | XML editable por no-programadores, stages pre-incluidos |
| **Negativo** | Sin persistencia limita trazabilidad |
| **Neutral** | Maduro, usado en producción, bajo riesgo |

#### 4.3.11 Dudas o Flecos Pendientes

| Duda | Estado |
| ---- | ------ |
| ¿Cómo se integra el log con el sistema de log del proyecto? | ❓ No especificado |
| ¿Cómo se maneja la cancelación de procesos en curso? | ❓ No especificado |
| ¿Cómo se registra la identidad del usuario? | ❓ No especificado, pero viable vía PipelineContext |
| ¿Existe plugin oficial de WordPress? | ❌ No disponible públicamente según documentación |

---

### 4.4 Workflow Engine Core

#### 4.4.1 Propósito y Arquitectura

| Aspecto | Evaluación |
| ------- | ---------- |
| **Propósito** | Ejecutar procesos de negocio con estados, reintentos, timeouts y persistencia |
| **Arquitectura** | WorkflowBuilder → WorkflowDefinition → WorkflowEngine → Executor → StateManager → StorageAdapter |
| **Patrón** | Motor de estados con persistencia y eventos |
| **Enfoque** | Procesos de negocio complejos con gestión avanzada de estados |

#### 4.4.2 Capacidades que Sí Cubre

| Capacidad | Encaje con B09 |
| --------- | -------------- |
| **Ejecución secuencial** | ✅ Steps se ejecutan en orden definido |
| **Persistencia de estado** | ✅ StorageAdapter configurable |
| **Estados del proceso** | ✅ 7 estados: PENDING, RUNNING, WAITING, PAUSED, COMPLETED, FAILED, CANCELLED |
| **Reintentos automáticos** | ✅ Hasta N reintentos configurables |
| **Timeouts** | ✅ Timeout configurable por paso |
| **Condiciones nativas** | ✅ Vía ConditionAction |
| **Datos compartidos** | ✅ WorkflowContext (get/set) |
| **Eventos** | ✅ 7 tipos: Started, Completed, Failed, Cancelled, StepCompleted, StepFailed, StepRetried |
| **Acciones pre-incluidas** | ✅ 5 acciones: LogAction, EmailAction, HttpAction, DelayAction, ConditionAction |
| **Ayudante simplificado** | ✅ SimpleWorkflow para ejecución secuencial simple |
| **Integración Laravel** | ✅ solution-forest/workflow-engine-laravel disponible |
| **Calidad de código** | ✅ PHPStan Nivel 6 (100% sin errores) |
| **Tests** | ✅ 93 tests con 224+ verificaciones |

#### 4.4.3 Carencias Detectadas

| Carencia | Impacto en proyecto |
| -------- | ------------------- |
| **Versión alpha** | ❌ **NO listo para producción** |
| **Sin ejecución asíncrona nativa** | ❌ Depende de implementación |
| **Sin programación horaria** | ❌ No hay scheduler |
| **Sin workflows anidados** | ❌ No hay soporte |
| **Sin bucles nativos** | ❌ No hay soporte para iteración |
| **Acciones pre-incluidas limitadas** | ⚠️ Solo 5 acciones básicas |
| **Sin configuración no-código** | ❌ Solo código PHP |

#### 4.4.4 Complejidad Añadida

| Complejidad | Descripción |
| ----------- | ----------- |
| **Infraestructura** | ⚠️ Media (StorageAdapter necesario) |
| **Configuración inicial** | ⚠️ Media (Actions + Builder + Engine + Storage) |
| **Curva de aprendizaje** | 7 conceptos: Actions, Builder, Engine, State, Context, Events, Storage |
| **Tiempo primera automatización** | 1-2 horas estimado |

#### 4.4.5 Riesgos Técnicos

| Riesgo | Probabilidad | Impacto |
| ------ | ------------ | ------- |
| **Versión alpha** | ✅ **Alta** | **NO usar en producción**, cambios breaking posibles |
| **En desarrollo activo** | ✅ Alta | API puede cambiar, funciones incompletas |
| **Sin casos de uso reales** | Media | No hay validación en producción |
| **Madurez baja** | ✅ Alta | v0.0.3-alpha, riesgo elevado |

#### 4.4.6 Limitaciones Funcionales

| Limitación | Descripción |
| ---------- | ----------- |
| **NO producción** | Limitación crítica según documentación |
| **Sin bucles** | No hay soporte para iteración sobre colecciones |
| **Sin workflows anidados** | No se puede componer flujos complejos |

#### 4.4.7 Dependencia o Acoplamiento

| Dependencia | Nivel |
| ----------- | ----- |
| **StorageAdapter** | ⚠️ Medio (requiere implementación) |
| **PHP** | ⚠️ PHP 8.3+ requerido (más estricto que otros) |
| **Frameworks** | ✅ Bajo (independiente, pero tiene integración Laravel) |

#### 4.4.8 Mantenibilidad

| Aspecto | Evaluación |
| ------- | ---------- |
| **Código organizado** | ✅ Actions separadas por responsabilidad |
| **Testing integrado** | ✅ 93 tests con 224+ verificaciones |
| **Documentación** | ✅ README.md + AGENTS.md + PLAN.md + CHANGELOG.md |
| **Extensibilidad** | ✅ BaseAction + StorageAdapter + EventDispatcher personalizables |
| **Plan de futuro** | ✅ PLAN.md con mejoras planificadas |

#### 4.4.9 Facilidad de Integración

| Integración | Evaluación |
| ----------- | ---------- |
| **WordPress** | ❓ No hay casos documentados |
| **WooCommerce API** | ✅ HttpAction disponible |
| **APIs de IA** | ✅ HttpAction disponible |
| **Sistema de archivos** | ✅ No hay restricciones |

#### 4.4.10 Impacto sobre el Desarrollo Futuro

| Impacto | Descripción |
| ------- | ----------- |
| **Positivo** | Sistema de estados completo, reintentos, timeouts, eventos |
| **Negativo** | **Alpha = riesgo alto para producción** |
| **Neutral** | Código limpio, bien testeado, pero en evolución |

#### 4.4.11 Dudas o Flecos Pendientes

| Duda | Estado |
| ---- | ------ |
| ¿Cuándo estará listo para producción? | ❓ PLAN.md menciona mejoras futuras, sin fecha |
| ¿Cómo se integra con WordPress para validación de usuarios? | ❓ No documentado |
| ¿Cómo se maneja la cancelación de procesos en curso? | ✅ Soportado vía cancel() |
| ¿Cómo se registra la identidad del usuario? | ❓ No especificado, pero viable vía WorkflowContext |

---

## 5. Comparativa Directa entre Herramientas

### 5.1 Tabla Comparativa de Características Clave

| Característica | FlowCrafter | php-workflow | Pipeflow PHP | Workflow Engine Core |
| -------------- | ----------- | ------------ | ------------ | -------------------- |
| **Persistencia** | ✅ Sí | ❌ No | ❌ No | ✅ Sí |
| **Ejecución asíncrona** | ✅ Sí | ❌ No | ❌ No | ⚠️ Depende |
| **Reintentos** | ❌ No | ❌ No | ❌ No | ✅ Sí |
| **Timeouts** | ❌ No | ❌ No | ❌ No | ✅ Sí |
| **Estados del proceso** | ⚠️ Parcial | ❌ No | ❌ No | ✅ 7 estados |
| **Eventos** | ❌ No | ❌ No | ❌ No | ✅ 7 tipos |
| **Stages/Actions pre-incluidas** | ❌ 0 | ❌ 0 | ✅ 14 | ✅ 5 |
| **Configuración no-código** | ❌ No | ❌ No | ✅ XML | ❌ No |
| **Casos de uso reales** | ❓ No documentados | ❓ No documentados | ✅ 2 sitios | ❓ No (alpha) |
| **Listo para producción** | ❓ No especificado | ✅ Sí | ✅ Sí | ❌ **NO (alpha)** |
| **Requiere infraestructura** | ✅ Alta (CLI) | ❌ Baja | ❌ Baja | ⚠️ Media (Storage) |
| **Integración WordPress** | ❓ No documentada | ❓ No documentada | ✅ **Casos reales** | ❓ No documentada |
| **Integración IA** | ✅ Viable | ✅ Viable | ✅ **Casos reales** | ✅ Viable |

### 5.2 Encaje con Requisitos del Proyecto

| Requisito B09 | FlowCrafter | php-workflow | Pipeflow PHP | Workflow Engine Core |
| ------------- | ----------- | ------------ | ------------ | -------------------- |
| **Secuencialidad** | ✅ Alto | ✅ Alto | ✅ Alto | ✅ Alto |
| **Estados visibles** | ⚠️ Parcial | ❌ No | ❌ No | ✅ Alto |
| **Cancelación** | ❓ No especificado | ⚠️ Manual (skipWorkflow) | ⚠️ Manual | ✅ Nativa |
| **Manejo de errores** | ⚠️ Registro | ✅ Detallado | ⚠️ Básico | ✅ Avanzado |
| **Trazabilidad/log** | ✅ Completo | ✅ Detallado | ⚠️ Básico | ✅ Completo |
| **Persistencia de estado** | ✅ Sí | ❌ No | ❌ No | ✅ Sí |
| **Múltiples ejecuciones IA** | ✅ Viable | ✅ Viable | ✅ **Casos reales** | ✅ Viable |
| **Aprobación humana** | ⚠️ Manual | ⚠️ Manual | ⚠️ Manual | ⚠️ Manual |
| **Conservación/eliminación** | ✅ Viable | ✅ Viable | ✅ Viable | ✅ Viable |

### 5.3 Madurez y Soporte

| Indicador | FlowCrafter | php-workflow | Pipeflow PHP | Workflow Engine Core |
| --------- | ----------- | ------------ | ------------ | -------------------- |
| **Versión** | ❓ No especificada | 2.1.1 (estable) | ❓ No especificada | v0.0.3-alpha |
| **¿Producción?** | ❓ No especificado | ✅ Sí | ✅ Sí | ❌ **NO** |
| **Licencia** | ❓ No especificada | MIT | BSD 3-Clause | MIT |
| **Stars GitHub** | ❓ No especificado | 27+ | 70+ | ❓ No especificado |
| **Tests** | ❓ No especificados | ✅ Sí (Coveralls) | ❓ No especificados | ✅ 93 tests |
| **Documentación** | ⚠️ docs/ | ✅ README extenso | ✅ README + DOCUMENTATION | ✅ README + AGENTS + PLAN |
| **Casos reales** | ❓ No | ❓ No | ✅ 2 sitios | ❓ No |

---

## 6. Clasificación y Descarte

### 6.1 Herramientas Recomendables

#### ✅ Pipeflow PHP — **MEJOR ENCAJE GLOBAL**

**Razones para recomendar:**

1. **Casos de uso reales documentados** con WordPress + generación de contenido con IA (exactamente el tipo de proyecto B09)
2. **14 stages pre-incluidos** que cubren necesidades comunes (JSONDecode, JSONEncode, If, ForEach, Delay, etc.)
3. **Configuración XML** que permite edición por no-programadores (ventaja para mantenimiento futuro)
4. **Integración con WordPress documentada** (PagineDaColorare.it, Fiaberello.it)
5. **Madurez suficiente** para producción (2 sitios en producción)
6. **Baja complejidad de infraestructura** (solo código, sin CLI corriendo)
7. **Licencia BSD 3-Clause** (permisiva para uso comercial)

**Condiciones para uso:**

- Implementar sistema de log personalizado para trazabilidad completa
- Implementar manejo de cancelación de procesos
- Registrar identidad de usuario en PipelineContext
- Crear stages personalizados para integración con WordPress y WooCommerce

---

### 6.2 Herramientas Parcialmente Recomendables

#### ⚠️ php-workflow — **VIABLE CON LIMITACIONES**

**Razones para considerar:**

1. **Madurez y estabilidad** (v2.1.1, mantenido desde Nov 2024)
2. **7 etapas predefinidas** que organizan bien el flujo (Prepare, Validate, Before, Process, OnSuccess, OnError, After)
3. **Validaciones duras/suaves** útiles para control de calidad
4. **Registro detallado** con múltiples formatos de salida (StringLog, SVG, GraphViz)
5. **Testing integrado** con WorkflowTestTrait
6. **Workshop incluido** para aprendizaje del equipo

**Limitaciones que impiden recomendación plena:**

1. **Sin persistencia** — imposible recuperar estado tras fallo
2. **Sin casos de uso reales documentados** — no hay validación en producción
3. **Sin integración WordPress documentada** — requiere adaptación
4. **0 actions pre-incluidas** — todo debe implementarse desde cero

**Condiciones para uso:**

- Aceptar limitación de sin persistencia
- Implementar log personalizado fuera de la herramienta
- Implementar stages personalizados para WordPress/WooCommerce/IA

---

#### ⚠️ FlowCrafter — **VIABLE PARA CASOS ESPECÍFICOS**

**Razones para considerar:**

1. **Persistencia de estado** — permite recuperación tras fallos
2. **Ejecución asíncrona nativa** — útil para procesos largos
3. **Cola de tareas** — permite encolar múltiples procesos
4. **Programación horaria** — útil si se necesitan procesos programados
5. **Interfaz visual** — permite ver estado de procesos

**Limitaciones que impiden recomendación plena:**

1. **Requiere infraestructura CLI corriendo** (observer + scheduler) — complejidad operacional
2. **Sin reintentos automáticos** — limitación para fallos transitorios
3. **Sin timeouts** — procesos pueden colgarse
4. **0 Stubs pre-incluidos** — todo debe implementarse desde cero
5. **Sin casos de uso reales documentados** — no hay validación en producción
6. **Madurez no especificada** — riesgo de abandono

**Condiciones para uso:**

- Aceptar complejidad de infraestructura CLI
- Implementar reintentos manualmente
- Implementar timeouts manualmente
- Validar madurez del proyecto antes de adoptar

---

### 6.3 Herramientas No Recomendables / Descartables

#### ❌ Workflow Engine Core — **DESCARTAR POR AHORA**

**Razones para descartar:**

1. **Versión alpha (v0.0.3-alpha)** — **NO listo para producción** según documentación explícita
2. **En desarrollo activo** — API puede cambiar, funciones incompletas
3. **Sin casos de uso reales** — no hay validación en producción
4. **PHP 8.3+ requerido** — más estricto que alternativas (php-workflow soporta 7.4+)
5. **Riesgo elevado** para proyecto con plazo definido (18 mayo 2026)

**Aunque tiene características deseables:**

- ✅ Persistencia de estado
- ✅ Reintentos automáticos
- ✅ Timeout configurables
- ✅ 7 estados del proceso
- ✅ 7 tipos de eventos
- ✅ 93 tests con 224+ verificaciones

**Recomendación:** Monitorear el proyecto y considerar migración futura cuando alcance versión estable (v1.0+).

---

## 7. Riesgos, Limitaciones y Dependencias

### 7.1 Riesgos Comunes a Todas las Herramientas

| Riesgo | Impacto | Mitigación |
| ------ | ------- | ---------- |
| **Ninguna cubre todos los requisitos B09** | Requiere extensión personalizada | Aceptar que se desarrollarán componentes custom |
| **Sin integración nativa con WordPress** | Requiere adaptación para validación de usuarios | Implementar middleware/stages personalizados |
| **Sin registro de identidad de usuario** | Requiere implementación manual | Pasar usuario en contexto (WorkflowContainer/PipelineContext) |
| **Sin manejo nativo de cancelación** | Requiere implementación manual | Implementar mecanismo de flag de cancelación |

### 7.2 Riesgos Específicos por Herramienta

| Herramienta | Riesgo Específico | Mitigación |
| ----------- | ----------------- | ---------- |
| **FlowCrafter** | Infraestructura CLI compleja | Evaluar si asíncrono es realmente necesario |
| **php-workflow** | Sin persistencia | Implementar log externo para trazabilidad |
| **Pipeflow PHP** | Sin persistencia | Implementar log externo para trazabilidad |
| **Workflow Engine Core** | Alpha, no producción | **Descartar** hasta versión estable |

### 7.3 Dependencias Críticas

| Dependencia | Herramientas Afectadas | Impacto |
| ----------- | ---------------------- | ------- |
| **PHP 8.3+** | Workflow Engine Core | Requiere servidor actualizado |
| **CLI corriendo** | FlowCrafter | Requiere procesos daemon en producción |
| **StorageAdapter** | FlowCrafter, Workflow Engine Core | Requiere configuración adicional |
| **WordPress endpoint** | Todas | Requiere desarrollo de endpoint personalizado |

---

## 8. Flecos Pendientes de Resolver

### 8.1 Pendientes Comunes a Todas las Herramientas

| Pendiente | Estado | Acción Requerida |
| --------- | ------ | ---------------- |
| **Integración con validación WordPress** | ❓ No documentado en ninguna | Crear endpoint en WordPress para `is_user_logged_in()` |
| **Registro de identidad de usuario** | ❓ No especificado | Pasar usuario en contexto y registrar en log |
| **Manejo de cancelación** | ⚠️ Parcial (solo Workflow Engine Core tiene cancel()) | Implementar flag de cancelación comprobado en cada paso |
| **Sistema de log unificado** | ❓ No integrado | Implementar servicio de log que todas las herramientas puedan usar |
| **Stages personalizados para WordPress** | ❓ No incluidos | Crear stages para: guardar texto, guardar media, crear producto WooCommerce |

### 8.2 Pendientes Específicos

#### FlowCrafter

| Pendiente | Estado |
| --------- | ------ |
| ¿Cómo se integra con WordPress? | ❓ No documentado |
| ¿Qué pasa si el observer se detiene? | ❓ No especificado |
| ¿Madurez del proyecto? | ❓ No especificada |

#### php-workflow

| Pendiente | Estado |
| --------- | ------ |
| ¿Cómo se integra el log con el sistema del proyecto? | ❓ No especificado |
| ¿Cómo se maneja la cancelación? | ❓ No especificado |

#### Pipeflow PHP

| Pendiente | Estado |
| --------- | ------ |
| ¿Existe plugin oficial de WordPress? | ❌ No disponible públicamente |
| ¿Cómo se integra el log con el sistema del proyecto? | ❓ No especificado |

#### Workflow Engine Core

| Pendiente | Estado |
| --------- | ------ |
| ¿Cuándo estará listo para producción? | ❓ Sin fecha (PLAN.md menciona mejoras futuras) |
| ¿Cómo se integra con WordPress? | ❓ No documentado |

---

## 9. Conclusión y Recomendación para el Usuario

### 9.1 Opción Más Adecuada

**Pipeflow PHP es la herramienta más adecuada** para este proyecto por las siguientes razones:

1. **Casos de uso reales documentados** con WordPress + generación de contenido con IA (PagineDaColorare.it, Fiaberello.it) — exactamente el tipo de automatización que requiere B09
2. **14 stages pre-incluidos** que cubren necesidades comunes del proyecto (JSONDecode para APIs de IA, Delay para rate limiting, If para condiciones, ForEach para múltiples productos/modelos)
3. **Configuración XML** que permite edición futura por no-programadores (ventaja para mantenimiento a largo plazo)
4. **Integración con WordPress documentada** — aunque no hay plugin oficial público, los casos reales demuestran viabilidad
5. **Madurez suficiente** para producción (2 sitios en producción, licencia BSD 3-Clause)
6. **Baja complejidad de infraestructura** — solo código, sin CLI corriendo constantemente
7. **Documentación completa** — README.md + DOCUMENTATION.md detallada

### 9.2 Condiciones Bajo las Cuales Podría Usarse

**Pipeflow PHP puede usarse si:**

1. ✅ Se acepta implementar sistema de log personalizado para trazabilidad completa
2. ✅ Se acepta implementar manejo de cancelación de procesos (flag comprobado en cada stage)
3. ✅ Se acepta registrar identidad de usuario en PipelineContext manualmente
4. ✅ Se crean stages personalizados para:
   - Validación de usuarios contra WordPress
   - Guardado de texto en tabla WordPress
   - Guardado de imágenes en biblioteca de medios
   - Creación de productos en WooCommerce
   - Llamadas a APIs de IA con manejo de múltiples proveedores
5. ✅ Se implementa mecanismo de reintentos manual para fallos transitorios
6. ✅ Se implementan timeouts manuales para procesos largos

### 9.3 Riesgos a Vigilar

| Riesgo | Probabilidad | Impacto | Mitigación |
| ------ | ------------ | ------- | ---------- |
| **Sin persistencia de estado** | Alta | Imposible recuperar estado tras fallo | Implementar log en base de datos que sirva como respaldo |
| **Sin reintentos automáticos** | Media | Fallos transitorios no se recuperan | Implementar retry logic en stages de llamadas externas (IA, WooCommerce) |
| **Sin timeouts nativos** | Media | Procesos pueden colgarse | Implementar timeout checking en cada stage |
| **Plugin WordPress no oficial** | Alta | Requiere desarrollo personalizado | Aceptar desarrollo de plugin interno |
| **Documentación de integración WP limitada** | Media | Curva de aprendizaje inicial | Basarse en casos reales documentados (PagineDaColorare.it) |

### 9.4 Flecos Pendientes de Resolver Antes de Decisión Final

| Fleco | Prioridad | Acción |
| ----- | --------- | ------ |
| **Definir schema de tabla de log** | Alta | Crear estructura de tabla para trazabilidad completa |
| **Diseñar stages personalizados** | Alta | Listar stages necesarios para WordPress, WooCommerce, IA |
| **Validar integración con WordPress** | Alta | Crear endpoint de prueba para validación de usuarios |
| **Definir mecanismo de cancelación** | Media | Implementar flag de cancelación en PipelineContext |
| **Evaluar necesidad de persistencia** | Media | Determinar si se requiere recuperación de estado o solo log |

### 9.5 Recomendaciones Antes de Tomar Decisión Final

1. **Crear prototipo con Pipeflow PHP** (1-2 días)
   - Implementar flujo básico: login → subir PDF → extraer texto
   - Validar integración con WordPress
   - Estimar esfuerzo de stages personalizados

2. **Evaluar php-workflow como alternativa** (1 día)
   - Crear mismo prototipo básico
   - Comparar complejidad de implementación
   - Evaluar si 7 etapas predefinidas aportan valor suficiente

3. **Descartar Workflow Engine Core definitivamente** hasta que:
   - Alcance versión v1.0+
   - Tenga casos de uso reales en producción
   - El equipo valide estabilidad

4. **Considerar FlowCrafter solo si:**
   - Se determina que la ejecución asíncrona es crítica
   - El equipo acepta complejidad de infraestructura CLI
   - Se valida madurez del proyecto (contactar autor, revisar issues)

5. **Documentar decisiones de arquitectura** en R04-ACLARATIVO.md:
   - Herramienta seleccionada y justificación
   - Stages personalizados a desarrollar
   - Estrategia de log y trazabilidad
   - Mecanismo de cancelación

### 9.6 Decisión Recomendada

**Se recomienda proceder con Pipeflow PHP** como motor de workflow para el proyecto, con las siguientes acciones inmediatas:

1. **Semana 1:** Crear prototipo de validación
2. **Semana 2:** Implementar stages personalizados para WordPress
3. **Semana 3:** Implementar stages personalizados para WooCommerce e IA
4. **Semana 4:** Implementar sistema de log y trazabilidad
5. **Semana 5:** Implementar mecanismo de cancelación
6. **Semana 6:** Pruebas de integración completa

**Plan de contingencia:** Si Pipeflow PHP presenta limitaciones críticas durante el prototipo, evaluar php-workflow como alternativa secundaria.

---

*Documento generado como análisis comparativo de herramientas de workflow para el proyecto de automatización de productos WooCommerce*

*Fuentes:*
- *`anallizador/comparativa_herramientas_workflow_php.md`*
- *`anallizador/repos-wf/flowcrafter/guia_flowcrafter_principiantes.md`*
- *`anallizador/repos-wf/php-workflow/guia_php_workflow_principiantes.md`*
- *`anallizador/repos-wf/pipeflow-php/guia_pipeflow_php_principiantes.md`*
- *`anallizador/repos-wf/workflow-engine-core/guia_workflow_engine_core_principiantes.md`*
- *`02-Boceto_B09.md`*
