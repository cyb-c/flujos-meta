# R04 — Documento Aclarativo para Sistema Doc-First

---

## Índice

1. [Introducción](#1-introducción)
2. [Área de Negocio y Objetivos](#2-área-de-negocio-y-objetivos)
3. [Área de Producto WooCommerce](#3-área-de-producto-woocommerce)
4. [Área de Inteligencia Artificial](#4-área-de-inteligencia-artificial)
5. [Área de Documentación de Origen (PDFs)](#5-área-de-documentación-de-origen-pdfs)
6. [Área de Proceso y Estados](#6-área-de-proceso-y-estados)
7. [Área de Trazabilidad y Log](#7-área-de-trazabilidad-y-log)
8. [Área de Seguridad](#8-área-de-seguridad)
9. [Área de Base de Datos WordPress](#9-área-de-base-de-datos-wordpress)
10. [Área de Terminología](#10-área-de-terminología)
11. [Resumen de Pendientes por Prioridad](#11-resumen-de-pendientes-por-prioridad)
12. [Matriz de Impacto](#12-matriz-de-impacto)

---

## 1. Introducción

### 1.1 Propósito de este documento

Este documento recopila todas las decisiones, aclaraciones y definiciones que deben resolverse **antes** de abordar la creación del sistema doc-first definido en `PyR/03-R02.md`.

Su objetivo es identificar lagunas, riesgos y dependencias que, de no resolverse previamente, impedirían la redacción completa y operativa de los 4 Contratos del sistema doc-first.

### 1.2 Fuentes utilizadas

| Documento | Aporte principal |
| --------- | ---------------- |
| `PyR/01-R01.md` | Preguntas de aclaración iniciales |
| `PyR/02-R01_r.md` | Respuestas oficiales del líder del proyecto |
| `PyR/03-R02.md` | Propuesta de sistema doc-first (4 Contratos) |
| `PyR/04-R03.md` | Evaluación de R02.md con riesgos y recomendaciones |
| `02-Boceto_B09.md` | Boceto actualizado del entendimiento del proyecto |

### 1.3 Qué NO incluye este documento

De acuerdo con las restricciones establecidas, este documento **NO incluye**:

* Decisiones sobre framework tecnológico para la WA
* Decisiones sobre motor de workflow o flujo de proceso

Estos aspectos serán tratados en la fase de arquitectura técnica (Contrato 4).

### 1.4 Clasificación de pendientes

Cada pendiente se clasifica según su impacto en el desarrollo:

| Tipo | Definición |
| ---- | ---------- |
| **BLOQUEANTE** | Impide la redacción completa del Contrato asociado y/o el inicio del desarrollo del módulo. Debe resolverse antes de continuar. |
| **ALTA** | Necesario para la completitud del sistema doc-first. Puede retrasar la validación de los Contratos. |
| **MEDIA** | Deseable para la completitud pero no impide el avance inmediato. Puede resolverse en paralelo. |
| **BAJA** | Complementario. Puede resolverse durante o después del desarrollo de Contratos. |

---

## 2. Área de Negocio y Objetivos

### 2.1 Operacionalización de objetivos de negocio

**Fuente:** R01-r respuesta 1, R03 sección 5.1

**Situación actual:**
R01-r respuesta 1 establece objetivos de negocio claros:
* Reducir tiempo
* Eliminar errores
* Procesar alto volumen
* Información veraz
* Legibilidad
* Posicionamiento (SEO/LLM)

Sin embargo, estos objetivos no están operacionalizados en métricas concretas.

**Qué debe aclararse:**

| Pregunta | Motivo | Impacto si no se resuelve | Prioridad |
| -------- | ------ | ------------------------- | --------- |
| ¿Qué reducción de tiempo se espera? (ej: 80% menos tiempo por ficha) | Para definir KPIs medibles en Contrato 1 | No se puede validar el éxito del sistema | ALTA |
| ¿Qué se considera "error" en este contexto? (ej: dato técnico incorrecto, formato inconsistente, ortografía) | Para definir criterios de calidad | No hay forma de medir "eliminar errores" | ALTA |
| ¿Existe un objetivo de throughput? (ej: X PDFs por día/semana) | Para dimensionar el sistema | Riesgo de sub/sobre-dimensionamiento | MEDIA |
| ¿Qué criterios definen "información veraz"? | Para establecer validación de calidad | Subjetividad en aprobación de contenido | MEDIA |
| ¿Qué métricas de SEO se consideran? (ej: score Yoast, palabras clave, longitud) | Para definir requisitos de generación de contenido | El contenido puede no cumplir objetivos de posicionamiento | ALTA |
| ¿Qué significa "optimizado para LLM" concretamente? | Área emergente sin estándares definidos | El contenido puede no ser visible en búsquedas por IA | MEDIA |

**Relación con riesgos R03:**
* R03 sección 5.1: "Objetivos SEO/LLM no operacionalizados" — Probabilidad Alta, Impacto Medio

**Acción requerida:**
Sesión de definición de KPIs con líder del proyecto y stakeholders de negocio.

---

### 2.2 Criterios de calidad de contenido

**Fuente:** R01-r respuesta 1, R03 sección 3.2

**Situación actual:**
Se menciona que el contenido debe ser "fácil de entender", "veraz", "orientado a SEO/LLM", pero no hay criterios concretos.

**Qué debe aclararse:**

| Pregunta | Motivo | Impacto si no se resuelve | Prioridad |
| -------- | ------ | ------------------------- | --------- |
| ¿Qué nivel de legibilidad se requiere? (ej: Flesch-Szigriszt, nivel educativo) | Para validar contenido generado | Contenido puede ser demasiado técnico o simplista | MEDIA |
| ¿Existen plantillas o estructuras de ficha tipo a seguir? | Para definir formato de salida de IA | Inconsistencia entre productos publicados | ALTA |
| ¿Hay restricciones de longitud para descripciones? | Para configurar límites de generación de IA | Contenido puede exceder límites de WooCommerce o UX | MEDIA |
| ¿Qué tono de comunicación debe usarse? (ej: técnico, comercial, mixto) | Para definir prompts de IA | Inconsistencia en voz de marca | MEDIA |
| ¿Existen palabras clave obligatorias por categoría de producto? | Para SEO | Pérdida de oportunidades de posicionamiento | ALTA |

**Relación con riesgos R03:**
* R03 sección 2.3: "SEO/LLM: R01-r respuesta 1 menciona redacciones orientadas a mejorar posicionamiento, pero no hay requisito concreto"

**Acción requerida:**
Revisión de fichas de producto existentes (si las hay) y definición de estándares de contenido con equipo de marketing/comunicación.

---

## 3. Área de Producto WooCommerce

### 3.1 Campos personalizados de WooCommerce

**Fuente:** R01-r respuesta 11, R03 sección 5.1 y 5.4

**Situación actual:**
R01-r respuesta 11 indica: *"Los campos personalizados ya existen y están definidos en el WooCommerce en producción. Pero está pendiente la definición detallada de dichos campos para que la salida generada por la IA quede encajada y relacionada con los campos en WooCommerce de forma automática."*

**Este es un PENDIENTE BLOQUEANTE crítico.**

**Qué debe aclararse:**

| Pregunta | Motivo | Impacto si no se resuelve | Prioridad |
| -------- | ------ | ------------------------- | --------- |
| ¿Cuál es la lista completa de campos personalizados? | La IA debe generar contenido para cada campo | **BLOQUEANTE**: Sin esto, la IA no sabe qué generar | BLOQUEANTE |
| ¿Qué tipo de dato es cada campo? (texto, número, fecha, select, boolean) | Para validar formato de salida de IA | Errores de validación en API WooCommerce | BLOQUEANTE |
| ¿Qué campos son obligatorios y cuáles opcionales? | Para definir validación de contenido | Productos incompletos o rechazo de API | BLOQUEANTE |
| ¿Existen dependencias entre campos? (ej: si campo A=X, entonces campo B es obligatorio) | Para lógica de generación condicional | Inconsistencias en datos de producto | BLOQUEANTE |
| ¿Hay restricciones de longitud por campo? | Para limitar generación de IA | Errores de validación o truncamiento | BLOQUEANTE |
| ¿Los campos tienen valores predefinidos/limitados? (ej: select con opciones) | Para validar salidas de IA | Valores inválidos en campos restringidos | BLOQUEANTE |
| ¿Existe documentación técnica de estos campos? | Para referencia en Contrato 3 | Improvisación en definición de campos | BLOQUEANTE |
| ¿Qué campos son visibles al público y cuáles son internos? | Para priorizar calidad de generación | Esfuerzo mal dirigido en campos no visibles | MEDIA |

**Relación con riesgos R03:**
* R03 sección 5.1: "Pendientes bloqueantes en Contrato 3" — Probabilidad Alta, Impacto Crítico
* R03 sección 5.4: "Campos WooCommerce exactos — Requiere sesión de definición con stakeholder técnico de WooCommerce"

**Acción requerida:**
**SESIÓN URGENTE** con stakeholder técnico de WooCommerce para:
1. Listar todos los campos personalizados
2. Documentar tipo, obligatoriedad, restricciones y dependencias
3. Proporcionar ejemplos de valores válidos
4. Identificar campos críticos para SEO/LLM

**Formato de salida esperado:**
Documento técnico con tabla de campos que incluya:
* Nombre del campo (meta_key)
* Etiqueta visible
* Tipo de dato
* Obligatorio (sí/no)
* Longitud mínima/máxima
* Valores permitidos (si aplica)
* Descripción del propósito
* Ejemplo de valor válido

---

## 4. Área de Inteligencia Artificial

### 4.1 Roles de IA y documento específico

**Fuente:** R01-r respuesta 7, B08 sección 6, R03 sección 5.4

**Situación actual:**
R01-r respuesta 7 indica: *"Está pendiente de ser creado, junto con los roles concretos a usar en cada prompt, los parámetros de entrada, la salida del resultado y las dependencias entre cada una de las ejecuciones de IA."*

**Qué debe aclararse:**

| Pregunta | Motivo | Impacto si no se resuelve | Prioridad |
| -------- | ------ | ------------------------- | --------- |
| ¿Cuántos roles de IA se necesitan? | Para definir arquitectura de procesamiento | Sub/sobre-procesamiento de contenido | BLOQUEANTE |
| ¿Qué hace cada rol concretamente? | Para diseñar prompts específicos | Resultados inconsistentes o incompletos | BLOQUEANTE |
| ¿Qué entrada recibe cada rol? | Para definir flujo de datos | Dependencias rotas entre ejecuciones | BLOQUEANTE |
| ¿Qué salida debe generar cada rol? | Para validar resultados | Contenido no usable para WooCommerce | BLOQUEANTE |
| ¿Qué roles dependen de resultados de otros roles? | Para secuenciar ejecuciones | Orden incorrecto de procesamiento | BLOQUEANTE |
| ¿Qué roles son independientes? | Para optimizar ejecución paralela | Ineficiencia en tiempo de procesamiento | MEDIA |
| ¿Cómo se maneja la variabilidad entre ejecuciones? | Para consistencia de resultados | Resultados diferentes para mismo PDF | ALTA |
| ¿Existe validación automática de resultados de IA? | Para calidad | Errores no detectados hasta revisión humana | ALTA |

**Relación con riesgos R03:**
* R03 sección 5.4: "Roles concretos de IA — Requiere crear documento específico de roles/prompts de IA"

**Acción requerida:**
Crear documento específico de IA que incluya:
* Diagrama de flujo de ejecuciones de IA
* Descripción de cada rol con propósito
* Especificación de inputs/outputs por rol
* Matriz de dependencias entre roles
* Criterios de validación de resultados

**Nota:** Este documento es insumo directo para el Contrato 3.

---

### 4.2 Proveedores de IA y CRUD de configuración

**Fuente:** R01-r respuesta 8, R03 sección 5.2

**Situación actual:**
R01-r respuesta 8 indica: *"No hay un proveedor de IA. En la configuración de la WA, el administrador debe tener un CRUD para añadir proveedores, APIs y límites de uso o consumo."*

**Qué debe aclararse:**

| Pregunta | Motivo | Impacto si no se resuelve | Prioridad |
| -------- | ------ | ------------------------- | --------- |
| ¿Qué proveedores de IA se esperan soportar inicialmente? | Para diseñar arquitectura compatible | Limitación futura de proveedores | ALTA |
| ¿Los prompts deben ser idénticos entre proveedores o adaptables? | Para estrategia de prompts | Dependencia de proveedor específico | ALTA |
| ¿Qué límites de consumo se deben poder configurar? (ej: tokens/día, requests/hora) | Para diseño del CRUD | Riesgo de sobrecoste o bloqueo por límites | ALTA |
| ¿Cómo se selecciona el proveedor por defecto? | Para flujo operativo | Confusión en operación diaria | MEDIA |
| ¿Se puede cambiar de proveedor mid-ejecución? | Para manejo de fallos | Bloqueo si proveedor falla | MEDIA |
| ¿Qué credenciales se deben almacenar por proveedor? | Para diseño de seguridad | Riesgo de seguridad o funcionalidad rota | ALTA |
| ¿Cómo se registra el consumo por proveedor? | Para trazabilidad y costes | Imposibilidad de optimizar costes | MEDIA |

**Relación con riesgos R03:**
* R03 sección 5.2: "CRUD de proveedores IA ambiguo — R01-r respuesta 8 requiere CRUD pero no está claro en qué Contrato vive"

**Acción requerida:**
Definir especificación funcional del CRUD de proveedores que incluya:
* Campos del formulario de alta de proveedor
* Tipos de autenticación soportados (API key, OAuth, etc.)
* Límites configurables y sus unidades
* Métricas de consumo a registrar
* Criterios de selección de proveedor por defecto

---

## 5. Área de Documentación de Origen (PDFs)

### 5.1 Tipos exactos de PDF

**Fuente:** B08 secciones 2 y 47, R03 sección 5.4

**Situación actual:**
B08 sección 47 indica: *"Qué tipos exactos de PDF existen: fichas individuales, catálogos, manuales, documentos mixtos, documentos escaneados o digitales."*

**Qué debe aclararse:**

| Pregunta | Motivo | Impacto si no se resuelve | Prioridad |
| -------- | ------ | ------------------------- | --------- |
| ¿Cuál es la distribución de tipos de PDF? (ej: 70% fichas, 20% catálogos, 10% otros) | Para priorizar desarrollo de extractores | Extractor puede no cubrir casos principales | ALTA |
| ¿Existen PDFs escaneados (imagen) vs digitales (texto seleccionable)? | Para definir necesidad de OCR | Extracción fallida en PDFs escaneados | BLOQUEANTE |
| ¿Qué porcentaje de PDFs son escaneados? | Para dimensionar necesidad de OCR | Coste innecesario si son pocos | ALTA |
| ¿Los catálogos contienen múltiples productos? | Para flujo de multiproducto | Proceso incorrecto para catálogos | ALTA |
| ¿Existen PDFs con tablas complejas? | Para estrategia de extracción | Pérdida de datos estructurados | ALTA |
| ¿Hay PDFs con imágenes críticas no extraíbles como texto? | Para flujo de imágenes | Información visual perdida | MEDIA |
| ¿Se dispone de una muestra representativa de los 100+ PDFs? | Para análisis y pruebas | Desarrollo sin datos reales | ALTA |

**Relación con riesgos R03:**
* R03 sección 5.4: "Tipos exactos de PDF — Requiere análisis de muestra representativa de los 100+ PDFs"

**Acción requerida:**
1. Recopilar muestra representativa de PDFs (mínimo 20-30 archivos)
2. Clasificar por tipo (ficha, catálogo, manual, escaneado, digital, mixto)
3. Identificar patrones comunes y casos especiales
4. Documentar características que afectan extracción (tablas, imágenes, columnas)

---

### 5.2 Criterios de extracción aceptable

**Fuente:** B08 sección 4, R03 sección 2.3

**Situación actual:**
No hay criterios definidos para qué constituye una extracción "suficiente" o cómo manejar extracciones incompletas.

**Qué debe aclararse:**

| Pregunta | Motivo | Impacto si no se resuelve | Prioridad |
| -------- | ------ | ------------------------- | --------- |
| ¿Qué porcentaje de contenido extraído se considera aceptable? (ej: 90% del texto) | Para validación automática | Proceso continúa con datos incompletos | ALTA |
| ¿Qué se hace si la extracción es incompleta? | Para flujo de errores | Resultados de IA incorrectos | ALTA |
| ¿Se permite reintento automático de extracción? | Para resiliencia | Procesos fallidos innecesariamente | MEDIA |
| ¿Cómo se detecta que la extracción falló? | Para manejo de errores | Fallos silenciosos | ALTA |
| ¿Qué elementos son críticos que se extraigan sí o sí? (ej: nombre de producto, especificaciones técnicas) | Para validación mínima | Productos publicados sin datos esenciales | BLOQUEANTE |

**Acción requerida:**
Definir criterios de calidad de extracción que incluyan:
* Porcentaje mínimo de texto extraído
* Elementos críticos obligatorios
* Proceso de validación post-extracción
* Manejo de extracciones incompletas

---

## 6. Área de Proceso y Estados

### 6.1 Criterios de aprobación y rechazo

**Fuente:** B08 sección 47, R03 sección 5.4

**Situación actual:**
B08 sección 47 indica: *"Qué criterios usa la revisión manual final para aprobar o rechazar."*

**Qué debe aclararse:**

| Pregunta | Motivo | Impacto si no se resuelve | Prioridad |
| -------- | ------ | ------------------------- | --------- |
| ¿Qué criterios debe usar el usuario para aprobar? | Para entrenamiento y UX | Aprobaciones inconsistentes | ALTA |
| ¿Qué errores son motivo automático de rechazo? | Para validación previa | Rechazos evitables después de revisión | MEDIA |
| ¿Puede el usuario aprobar con correcciones menores? | Para flujo operativo | Bloqueo por perfeccionismo | MEDIA |
| ¿Existe una lista de verificación (checklist) de aprobación? | Para consistencia | Criterios subjetivos variables | ALTA |
| ¿Qué nivel de calidad SEO debe verificarse en aprobación? | Para cumplimiento de objetivos | Contenido aprobado sin cumplir SEO | ALTA |

**Relación con riesgos R03:**
* R03 sección 5.4: "Criterios de aprobación/rechazo — Requiere sesión con usuarios operativos para definir criterios"

**Acción requerida:**
Sesión con usuarios operativos para:
1. Definir checklist de aprobación
2. Identificar errores bloqueantes vs corregibles
3. Establecer umbrales de calidad aceptables
4. Documentar criterios en guía de usuario

---

### 6.2 Timeouts y tiempos de espera

**Fuente:** B08 sección 26, R03 sección 2.2

**Situación actual:**
El botón de cancelación debe estar disponible "mientras se ejecutan los procesos", pero no hay tiempos definidos.

**Qué debe aclararse:**

| Pregunta | Motivo | Impacto si no se resuelve | Prioridad |
| -------- | ------ | ------------------------- | --------- |
| ¿Cuál es el tiempo máximo esperado de procesamiento por PDF? | Para UX y timeouts | Usuarios abandonan por lentitud percibida | MEDIA |
| ¿Existe un timeout general del proceso? | Para manejo de fallos | Procesos colgados indefinidamente | ALTA |
| ¿El timeout varía por tipo/size de PDF? | Para precisión | Timeouts prematuros o tardíos | MEDIA |
| ¿Qué ocurre si se supera el timeout? | Para flujo de errores | Estados inconsistentes | ALTA |
| ¿Se notifica al usuario si el proceso está tardando más de lo esperado? | Para UX | Abandono por percepción de fallo | MEDIA |

**Acción requerida:**
Definir política de timeouts que incluya:
* Timeout general del proceso
* Timeouts por etapa (extracción, IA, publicación)
* Comportamiento ante timeout
* Notificaciones al usuario

---

## 7. Área de Trazabilidad y Log

### 7.1 Formato y ubicación del log

**Fuente:** B08 sección 39, R01-r respuesta 14, R03 sección 2.2

**Situación actual:**
B08 sección 39 indica: *"Cómo se guarda el log desde el inicio y paso a paso hasta el final está por definir"* y *"Dónde se guardará exactamente el log histórico"*.

**Qué debe aclararse:**

| Pregunta | Motivo | Impacto si no se resuelve | Prioridad |
| -------- | ------ | ------------------------- | --------- |
| ¿El log se guarda en tabla de WordPress o en archivo? | Para diseño técnico | Imposibilidad de implementar | BLOQUEANTE |
| ¿Se guarda en ambos lugares (tabla + archivo)? | Para redundancia | Sobre-ingeniería o falta de respaldo | MEDIA |
| ¿Qué estructura mínima debe tener el log? | Para consistencia | Logs incompletos o inconsistentes | ALTA |
| ¿Se incluye el texto completo del log o solo referencias? | Para diseño de almacenamiento | Tablas sobredimensionadas o información insuficiente | ALTA |
| ¿Cuál es la política de retención del log? (¿cuánto tiempo se conserva?) | Para dimensionamiento | Acumulación indefinida o pérdida prematura | MEDIA |
| ¿El log es inmutable o puede editarse? | Para integridad | Riesgo de manipulación | ALTA |
| ¿Qué identificador de usuario se guarda? (login, ID, nombre visible) | Para trazabilidad | Imposibilidad de auditar quién hizo qué | ALTA |

**Relación con riesgos R03:**
* R03 sección 2.2: "El log histórico necesita ubicación y formato definidos: ¿tabla WordPress? ¿archivo? ¿ambos?"

**Acción requerida:**
Definir especificación de log que incluya:
* Ubicación primaria y secundaria (si aplica)
* Schema de tabla o formato de archivo
* Campos obligatorios por entrada de log
* Política de retención y archivado
* Identificador de usuario a registrar

---

### 7.2 Referencia de error al usuario

**Fuente:** B08 sección 36, R03 sección 2.2

**Situación actual:**
B08 sección 36 indica: *"si surge un error, el usuario verá: un mensaje estándar; una referencia asociada al error o al log completo."*

**Qué debe aclararse:**

| Pregunta | Motivo | Impacto si no se resuelve | Prioridad |
| -------- | ------ | ------------------------- | --------- |
| ¿Qué formato tiene la referencia de error? (ej: código, ID de log, timestamp) | Para implementación | Usuario no puede reportar error efectivamente | ALTA |
| ¿El usuario ve un código de error o una descripción? | Para UX | Confusión al reportar errores | MEDIA |
| ¿La referencia permite al admin localizar el log rápidamente? | Para soporte | Diagnóstico lento de incidencias | ALTA |
| ¿Se muestra la referencia en pantalla y/o por email? | Para canales de comunicación | Usuario pierde referencia de error | MEDIA |

**Acción requerida:**
Definir formato de referencia de error que incluya:
* Estructura del código/referencia (ej: ERR-YYYYMMDD-XXXX)
* Información visible para el usuario
* Información visible para el admin
* Canal de comunicación (pantalla, email, ambos)

---

## 8. Área de Seguridad

### 8.1 Decisiones de seguridad no negociables

**Fuente:** R03 sección 2.4 y 6.4

**Situación actual:**
R03 recomienda: *"Mover decisiones de seguridad (nonces, CSRF, autenticación) a 'no negociables' en lugar de pendientes."*

**Qué debe aclararse:**

| Pregunta | Motivo | Impacto si no se resuelve | Prioridad |
| -------- | ------ | ------------------------- | --------- |
| ¿Se implementará validación de nonces para todas las acciones POST/PUT/DELETE? | Para seguridad | Vulnerabilidad CSRF | BLOQUEANTE |
| ¿Cómo se gestionan los nonces en arquitectura WA externa? | Para implementación | Nonces inválidos o seguridad comprometida | BLOQUEANTE |
| ¿La validación de cookies WordPress es suficiente para autenticación? | Para seguridad | Sesiones comprometidas | ALTA |
| ¿Se requiere autenticación de dos factores para admin? | Para seguridad de configuración | Riesgo de configuración maliciosa | MEDIA |
| ¿Las APIs de IA se almacenan cifradas en la base de datos? | Para seguridad de credenciales | Exposición de APIs si hay breach | ALTA |
| ¿Qué nivel de log de seguridad se requiere? (intentos de login fallidos, accesos no autorizados) | Para auditoría de seguridad | Imposibilidad de detectar ataques | MEDIA |

**Relación con riesgos R03:**
* R03 sección 2.4: "Nonces/CSRF: Mencionado como pendiente, pero es crítico para seguridad. Debería ser decisión temprana."

**Acción requerida:**
Definir política de seguridad que incluya:
* Estrategia de nonces/CSRF para WA externa
* Validación de autenticación WordPress
* Cifrado de credenciales sensibles
* Requisitos de log de seguridad
* Política de contraseñas y sesiones

---

## 9. Área de Base de Datos WordPress

### 9.1 Schema de tabla específica para texto PDF

**Fuente:** R01-r respuesta 12, R03 sección 2.4 y 5.1

**Situación actual:**
R01-r respuesta 12 indica: *"Debe crearse. En WordPress se guarda el texto extraído del PDF y debe quedar referenciado al producto que se crea con la API de WooCommerce."*

**Qué debe aclararse:**

| Pregunta | Motivo | Impacto si no se resuelve | Prioridad |
| -------- | ------ | ------------------------- | --------- |
| ¿Cuál es el nombre de la tabla? | Para implementación | Imposibilidad de crear tabla | BLOQUEANTE |
| ¿Qué campos mínimos debe tener la tabla? | Para diseño de schema | Tabla incompleta o rediseño posterior | BLOQUEANTE |
| ¿Se almacena el texto completo o solo referencia al archivo? | Para dimensionamiento | Tabla sobredimensionada o información insuficiente | BLOQUEANTE |
| ¿Cómo se relaciona con la tabla de productos de WooCommerce? | Para integridad referencial | Imposibilidad de vincular texto-producto | BLOQUEANTE |
| ¿Se guardan versiones múltiples del texto (antes/después de corrección)? | Para trazabilidad | Pérdida de histórico de cambios | MEDIA |
| ¿La tabla tiene índices para búsquedas? | Para rendimiento | Consultas lentas en grandes volúmenes | ALTA |
| ¿Se requiere respaldo independiente de esta tabla? | Para continuidad de negocio | Pérdida de texto extraído si hay fallo | MEDIA |

**Relación con riesgos R03:**
* R03 sección 5.1: "Schema de tabla WordPress no definido — R01-r respuesta 12 dice 'debe crearse' sin estructura. Riesgo de rediseño posterior."

**Acción requerida:**
Definir schema de tabla que incluya:
* Nombre de tabla (ej: wp_pdf_productos_textos)
* Campos con tipos de dato
* Claves primarias y foráneas
* Índices necesarios
* Relación con tablas WooCommerce

**Schema preliminar sugerido (pendiente de validación):**

```sql
CREATE TABLE wp_pdf_productos_textos (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT UNSIGNED NOT NULL,
    pdf_nombre VARCHAR(255) NOT NULL,
    pdf_ruta_subcarpeta VARCHAR(500) NOT NULL,
    texto_extraido LONGTEXT NOT NULL,
    fecha_creacion DATETIME NOT NULL,
    producto_woocommerce_id BIGINT UNSIGNED DEFAULT NULL,
    estado_proceso ENUM('pendiente', 'en_proceso', 'aprobado', 'rechazado', 'cancelado', 'fallo') NOT NULL,
    log_referencia VARCHAR(100) DEFAULT NULL,
    INDEX idx_user_id (user_id),
    INDEX idx_producto_id (producto_woocommerce_id),
    INDEX idx_estado (estado_proceso),
    FOREIGN KEY (user_id) REFERENCES wp_users(ID)
);
```

---

## 10. Área de Terminología

### 10.1 Glosario unificado

**Fuente:** R03 sección 3.1 y 5.3

**Situación actual:**
R03 indica: *"B08 usa términos inconsistentes (WA, web-app, Web-App; WooC, WooCommerce; admin, Admin). Un glosario evita ambigüedades."*

**Qué debe aclararse:**

| Término | Variantes encontradas | Término recomendado | Motivo |
| ------- | --------------------- | ------------------- | ------ |
| Web-App externa | WA, web-app, Web-App, web app | WA | Consistencia en documentos |
| WooCommerce | WooC, WooCommerce, WC | WooCommerce | Nombre oficial |
| Administrador | admin, Admin, administrador | Admin | Para rol específico |
| Usuario operativo | usuario, Usuario, usuario operador | Usuario | Para diferenciar de Admin |
| Biblioteca de Medios | BMWP, media library, biblioteca de medios | Biblioteca de Medios de WordPress | Claridad |
| API WooCommerce | API-WooC, API-WooCommerce, APIW | API de WooCommerce | Claridad |
| PDF | - | PDF | Consistente |
| IA | - | IA | Consistente |

**Acción requerida:**
Crear documento de glosario que:
* Liste todos los términos técnicos del proyecto
* Defina cada término de forma precisa
* Establezca el término canónico a usar en documentación
* Incluya equivalentes en inglés si aplica

---

## 11. Resumen de Pendientes por Prioridad

### 11.1 Pendientes BLOQUEANTES

| # | Pendiente | Área | Acción requerida | Responsable sugerido |
| - | --------- | ---- | ---------------- | -------------------- |
| B1 | Campos WooCommerce exactos | Producto | Sesión de definición técnica | Stakeholder WooCommerce |
| B2 | Roles de IA y documento específico | IA | Crear documento de roles/prompts | Líder técnico + IA |
| B3 | Schema de tabla WordPress | Base de datos | Definir estructura completa | Arquitecto técnico |
| B4 | Nonces/CSRF para WA externa | Seguridad | Decidir estrategia de implementación | Arquitecto técnico |
| B5 | Ubicación y formato del log | Trazabilidad | Decidir tabla vs archivo + schema | Arquitecto técnico |
| B6 | Elementos críticos de extracción | PDF | Definir qué debe extraerse sí o sí | Líder proyecto + Operaciones |

### 11.2 Pendientes de Prioridad ALTA

| # | Pendiente | Área | Acción requerida |
| - | --------- | ---- | ---------------- |
| A1 | KPIs de objetivos de negocio | Negocio | Sesión de definición de métricas |
| A2 | Criterios de calidad SEO | Negocio | Definir requisitos de posicionamiento |
| A3 | Estructura de ficha tipo | Producto | Revisar plantillas existentes |
| A4 | Muestra representativa de PDFs | PDF | Recopilar y clasificar 20-30 PDFs |
| A5 | Criterios de aprobación/rechazo | Proceso | Sesión con usuarios operativos |
| A6 | Formato de referencia de error | Trazabilidad | Definir estructura de código de error |
| A7 | Cifrado de APIs de IA | Seguridad | Definir estrategia de cifrado |
| A8 | Proveedores de IA esperados | IA | Listar proveedores a soportar |

### 11.3 Pendientes de Prioridad MEDIA

| # | Pendiente | Área | Acción requerida |
| - | --------- | ---- | ---------------- |
| M1 | Objetivo de throughput | Negocio | Definir volumen esperado por período |
| M2 | Criterios de legibilidad | Negocio | Definir métricas de legibilidad |
| M3 | Política de retención de log | Trazabilidad | Definir tiempo de conservación |
| M4 | Timeouts del proceso | Proceso | Definir tiempos máximos por etapa |
| M5 | Glosario unificado | Terminología | Crear documento de glosario |

---

## 12. Matriz de Impacto

### 12.1 Impacto en Contratos de `PyR/03-R02.md`

| Contrato | Pendientes que afectan | Impacto si no se resuelven |
| -------- | ---------------------- | -------------------------- |
| **Contrato 1: Funcional** | A1, A2, M1, M2 | No se pueden definir KPIs ni criterios de éxito |
| **Contrato 2: Proceso** | A5, A6, M3, M4 | No se pueden definir criterios de aceptación ni manejo de errores |
| **Contrato 3: Contenido/IA** | B1, B2, A3, A4, A8 | **BLOQUEADO**: No se puede definir qué contenido generar sin campos WC ni roles de IA |
| **Contrato 4: Técnico** | B3, B4, B5, A7 | **BLOQUEADO**: No se puede definir arquitectura sin schema, seguridad ni log |

### 12.2 Secuencia recomendada de resolución

```
FASE 1 (Inmediata - Semana 1):
├─ B1: Campos WooCommerce (bloquea Contrato 3)
├─ B2: Roles de IA (bloquea Contrato 3)
├─ B3: Schema tabla WordPress (bloquea Contrato 4)
└─ A4: Muestra de PDFs (necesario para B2 y A3)

FASE 2 (Semana 2):
├─ B4: Nonces/CSRF (bloquea Contrato 4)
├─ B5: Formato de log (bloquea Contrato 4)
├─ B6: Elementos críticos extracción (necesario para Contrato 3)
├─ A1: KPIs de negocio (necesario para Contrato 1)
└─ A3: Estructura de ficha (necesario para Contrato 3)

FASE 3 (Semana 3):
├─ A2: Criterios SEO (Contrato 1 y 3)
├─ A5: Criterios aprobación (Contrato 2)
├─ A6: Referencia de error (Contrato 2)
├─ A7: Cifrado APIs (Contrato 4)
└─ A8: Proveedores IA (Contrato 3 y 4)

FASE 4 (Paralelo a redacción de Contratos):
├─ M1: Throughput (Contrato 1)
├─ M2: Legibilidad (Contrato 1 y 3)
├─ M3: Retención de log (Contrato 2 y 4)
├─ M4: Timeouts (Contrato 2 y 4)
└─ M5: Glosario (todos los documentos)
```

### 12.3 Riesgo de no resolver antes del doc-first

| Escenario | Consecuencia | Mitigación |
| --------- | ------------ | ---------- |
| Redactar Contratos sin resolver BLOQUEANTES | Contratos incompletos o con lagunas críticas | **No recomendado**: Esperar resolución de B1-B6 |
| Redactar Contratos sin resolver ALTA | Contratos con secciones marcadas como pendientes | Aceptable si los pendientes están explícitamente marcados |
| Redactar Contratos sin resolver MEDIA | Contratos completables, detalles en fase posterior | Aceptable, estos pueden resolverse en paralelo |
| Comenzar desarrollo sin Contratos completos | Desarrollo sin guía clara, re-trabajo seguro | **Altamente desaconsejado** |

---

## Conclusión

Este documento identifica **6 pendientes BLOQUEANTES**, **8 pendientes de Prioridad ALTA** y **5 pendientes de Prioridad MEDIA** que deben resolverse antes o durante la creación del sistema doc-first.

**Recomendación crítica:** No iniciar la redacción de los Contratos 3 y 4 hasta que los pendientes BLOQUEANTES B1, B2, B3, B4, B5 y B6 estén resueltos. Los Contratos 1 y 2 pueden comenzar con los pendientes ALTA marcados explícitamente.

**Próximos pasos sugeridos:**

1. Convocar sesión urgente para B1 (Campos WooCommerce)
2. Asignar responsable para B2 (Documento de IA)
3. Convocar sesión de arquitectura para B3, B4, B5 (Schema, Seguridad, Log)
4. Recopilar muestra de PDFs para A4 (insumo para múltiples pendientes)
5. Una vez resueltos B1-B6, iniciar redacción de Contratos 3 y 4
6. Redactar Contratos 1 y 2 en paralelo con resolución de pendientes ALTA

---

*Documento generado como aclarativo para preparación del sistema doc-first definido en `PyR/03-R02.md`*

*Fuentes: `PyR/01-R01.md`, `PyR/02-R01_r.md`, `PyR/03-R02.md`, `PyR/04-R03.md`, `02-Boceto_B09.md`*
