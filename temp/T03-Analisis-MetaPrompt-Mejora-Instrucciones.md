# Análisis del Meta-Prompt: "Especialista en mejora de instrucciones para IA en IDE"

## Índice de Contenidos

1. [Resumen del Meta-Prompt](#1-resumen-del-meta-prompt)
2. [Funcionamiento y Mecánica](#2-funcionamiento-y-mecánica)
3. [Limitaciones Identificadas](#3-limitaciones-identificadas)
4. [Complicaciones que Añade su Uso](#4-complicaciones-que-añade-su-uso)
5. [Propuestas de Mejora](#5-propuestas-de-mejora)
6. [Conclusión](#6-conclusión)

---

## 1. Resumen del Meta-Prompt

El prompt analizado define un **rol de especialista** cuya función es **reescribir y optimizar instrucciones** destinadas a otros modelos de IA que operan dentro de un **entorno de desarrollo (IDE / Codespaces)**.

**Estructura general del meta-prompt:**

| Componente | Descripción |
|------------|-------------|
| **Rol** | Especialista en mejora de instrucciones para IA en IDE |
| **Formato de entrada** | `M: [texto a mejorar]` — donde `M` significa "Mejorar" y el contenido entre corchetes es lo que se debe reescribir |
| **Formato de salida** | Únicamente la instrucción mejorada, sin texto adicional |
| **Restricciones** | 6 criterios obligatorios + un mecanismo de gestión de contexto |

---

## 2. Funcionamiento y Mecánica

### 2.1 Flujo de trabajo esperado

```
Usuario                         Modelo
  │                                │
  ├─ "M: [instrucción]" ─────────► │
  │                                ├─ Analiza la instrucción
  │                                ├─ La reescribe optimizada
  │                                ├─ Devuelve solo la versión mejorada
  │                                └─ Descarta la instrucción del contexto
  │                                │
  │ ◄─────── versión mejorada ─────┘
  │                                │
  ├─ "M: [nueva instrucción]" ───► │
  │                                └─ Trata de forma independiente
```

### 2.2 Criterios exigidos al modelo

| # | Criterio | Implicación |
|---|----------|-------------|
| 1 | Mantener el propósito original | El modelo no puede alterar la intención de la instrucción fuente |
| 2 | Eliminar ambigüedades y errores | Debe detectar y corregir imprecisiones del prompt original |
| 3 | Añadir detalles para eficacia | Enriquecer con contexto del IDE (rutas, archivos, herramientas) |
| 4 | Redactar en segunda persona | La salida debe usar "tú" o imperativo dirigido al modelo ejecutor |
| 5 | Estructura ordenada y comprensible | Formato claro, secciones, viñetas cuando proceda |
| 6 | Considerar interacción con el workspace | Asumir que el modelo ejecutor tiene acceso a archivos, terminal, repo |

### 2.3 Mecanismo de gestión de contexto

El meta-prompt exige que, tras cada mejora, el modelo **descarté completamente** la instrucción procesada de su contexto. Cada nueva petición `M:` debe tratarse como independiente, sin relación con las anteriores.

---

## 3. Limitaciones Identificadas

### 3.1 Limitaciones Estructurales

| # | Limitación | Explicación |
|---|------------|-------------|
| L1 | **Formato de entrada ambiguo** | El uso de `M: [texto]` mezcla un marcador (`M:`) con corchetes que pueden confundirse con sintaxis de array, Markdown o parámetros. Si el texto a mejorar contiene corchetes reales, el parsing es ambiguo. |
| L2 | **Dependencia de un formato rígido** | El usuario debe recordar exactamente `M: [texto]` cada vez. No se contemplan variaciones como mayúsculas/minúsculas, espacios extra, o ausencia de corchetes. |
| L3 | **Ausencia de validación del prompt fuente** | El meta-prompt no instruye al modelo para validar si la instrucción original es segura, viable o coherente antes de mejorarla. Se asume que todo lo que llegue entre corchetes es mejorable. |
| L4 | **Sin ejemplo de referencia** | No proporciona ningún ejemplo de "entrada → salida esperada". El modelo debe inferir el formato de salida únicamente a partir de descripciones abstractas. |
| L5 | **Sin especificación del destinatario** | No aclara si la instrucción mejorada va dirigida a otro modelo de IA, a un desarrollador humano, o a un sistema automatizado. El criterio 4 (segunda persona) asume un modelo, pero no se explicita. |
| L6 | **Prohibición de explicaciones contradictoria con el rol** | Se exige "solo la versión mejorada, sin texto adicional". Sin embargo, una instrucción optimizada para un IDE puede requerir contexto de por qué se hacen ciertas cosas. La prohibición absoluta puede generar instrucciones incompletas. |

### 3.2 Limitaciones de la Gestión de Contexto

| # | Limitación | Explicación |
|---|------------|-------------|
| L7 | **El descarte de contexto es imposible de garantizar** | El modelo no puede "descartar" información de su contexto de manera fiable. Instruirle que lo haga no equivale a que realmente ocurra. La información previa puede influir en respuestas posteriores aunque se le pida lo contrario. |
| L8 | **Pérdida de coherencia entre mejoras** | Al tratar cada instrucción como independiente, se pierde la capacidad de mantener un estilo consistente, un glosario de términos, o un historial de decisiones. |0|
| L9 | **Imposibilidad de mejora iterativa** | El mecanismo impide que el usuario pueda refinar una instrucción en varias rondas, ya que la versión anterior se descarta. No hay "versión 1 → feedback → versión 2". |
| L10 | **Contradicción con la naturaleza de los LLM** | Los modelos de lenguaje funcionan mejor con contexto continuo. Obligar al descarte va en contra de su diseño y perjudica la calidad de mejoras sucesivas. |

### 3.3 Limitaciones Prácticas

| # | Limitación | Explicación |
|---|------------|-------------|
| L11 | **No especifica el nivel de detalle de la mejora** | Una instrucción de una línea puede mejorarse añadiendo 3 párrafos o 3 palabras. No hay criterio sobre cuánta información añadir. |
| L12 | **Ignora el destinatario final** | Una instrucción para un modelo con acceso a terminal (como OpenCode o Claude Code) es distinta de una para un chat sin acceso al sistema de archivos. El meta-prompt no diferencia. |
| L13 | **Sin manejo de errores** | No se especifica qué hacer si la instrucción original es incoherente, peligrosa (ej. `rm -rf /`) o simplemente no mejorable. |
| L14 | **Falta de métrica de calidad** | No hay criterios para evaluar si la mejora es buena. El modelo no tiene forma de autoevaluarse. |

---

## 4. Complicaciones que Añade su Uso

### 4.1 Para el Usuario

| Complicación | Descripción |
|--------------|-------------|
| **Curva de aprendizaje del formato** | El usuario debe memorizar y aplicar correctamente `M: [texto]` incluyendo los corchetes. Errores de formato pueden producir resultados inesperados. |
| **Falsa sensación de control** | El usuario puede pensar que al usar este meta-prompt sus instrucciones quedarán perfectas, cuando en realidad la calidad de la mejora depende críticamente de la calidad de la instrucción original. |
| **Imposibilidad de iterar** | Si la primera mejora no es satisfactoria, el usuario no puede decir "mejor enfócate más en X" porque la instrucción anterior se descartó. Debe volver a escribir desde cero. |

### 4.2 Para el Modelo

| Complicación | Descripción |
|--------------|-------------|
| **Conflicto entre criterios** | El criterio 3 (añadir detalles) puede entrar en conflicto con la prohibición de "texto adicional antes o después". El modelo debe decidir qué es "detalle necesario" y qué es "texto adicional no permitido". |
| **Dilema del formato de salida** | Instrucciones complejas suelen beneficiarse de ejemplos, notas o advertencias. La prohibición de incluirlas puede resultar en instrucciones técnicamente correctas pero menos útiles. |
| **Ambigüedad del rol "especialista"** | No se define qué conocimientos tiene el especialista. ¿Debe ser experto en prompts, en PHP, en el IDE, en todo a la vez? El modelo debe adivinarlo. |
| **Presión por cumplir el descarte** | El modelo puede generar respuestas más genéricas o menos específicas para evitar que una instrucción previa "contamine" la siguiente, lo que reduce la calidad. |

### 4.3 Para el Flujo de Trabajo

| Complicación | Descripción |
|--------------|-------------|
| **Rotura de la cadena de pensamiento** | En un IDE, las instrucciones suelen encadenarse: "analiza esto → ahora modifica aquello → ahora prueba". Este meta-prompt rompe esa cadena deliberadamente. |
| **Dificultad de integración con OpenCode** | OpenCode funciona con sesiones continuas. Un meta-prompt que exige descartar contexto cada vez va contra el modelo de sesión de OpenCode. |
| **Depuración difícil** | Si el modelo produce una mejora incorrecta, no hay forma de rastrear por qué, porque no se permite añadir explicaciones. |

---

## 5. Propuestas de Mejora

### 5.1 Mejoras en el Formato de Entrada

| # | Problema | Propuesta |
|---|----------|-----------|
| M1 | `M: [texto]` es ambiguo | Usar un formato más explícito como `INSTRUCCIÓN A MEJORAR:` seguido del texto en un bloque de código o en una línea separada. Evitar corchetes que puedan confundirse con sintaxis del lenguaje. |
| M2 | Sin validación del prompt fuente | Añadir un paso explícito: "Antes de mejorar, identifica si la instrucción es segura, coherente y completa. Si no lo es, indícaselo al usuario." |
| M3 | Sin ejemplos | Incluir 2-3 ejemplos de "entrada original → salida mejorada" para que el modelo tenga referencias concretas del formato esperado. |
| M4 | Sin nivel de detalle configurable | Permitir al usuario especificar el nivel de detalle: `M+nivel: [texto]` donde nivel puede ser `mínimo`, `medio`, `máximo`. |

### 5.2 Mejoras en el Formato de Salida

| # | Problema | Propuesta |
|---|----------|-----------|
| M5 | Prohibición total de explicaciones | Permitir una sección opcional "**Notas:**" al final (separada de la instrucción) con aclaraciones importantes. |
| M6 | Sin destinatario explícito | Añadir un campo opcional: `DESTINATARIO: modelo/desarrollador/sistema`. Esto permite adaptar el nivel técnico de la instrucción. |
| M7 | Sin métrica de calidad | Instruir al modelo para que incluya al final un indicador de confianza: `**Confianza en esta mejora:** Alta/Media/Baja`. Útil para que el usuario sepa si debe revisar. |

### 5.3 Mejoras en la Gestión de Contexto

| # | Problema | Propuesta |
|---|----------|-----------|
| M8 | Descarte forzado imposible | Sustituir el descarte forzado por un mecanismo de **sesión**: "Puedes mantener contexto dentro de una misma sesión de mejora, pero comienza cada nueva instrucción sin asumir dependencias de la anterior a menos que el usuario las indique." |
| M9 | Sin iteración posible | Añadir un comando de iteración: `M-itera: [feedback sobre la última mejora]`. Esto permite refinar sin romper el flujo. |
| M10 | Pérdida de coherencia | Permitir un "glosario" persistente de términos y preferencias que se mantenga entre mejoras (por ejemplo, si el usuario siempre quiere instrucciones en español, no tener que repetirlo). |

### 5.4 Mejoras en la Integración con el IDE

| # | Problema | Propuesta |
|---|----------|-----------|
| M11 | Sin referencia al tipo de modelo destino | Especificar que la instrucción final debe incluir al inicio `[ENTORNO: OpenCode / Claude Code / Cursor / Genérico]`. Esto permite al modelo optimizador adaptar los verbos y herramientas que menciona. |
| M12 | Sin referencias a herramientas del IDE | Instruir al modelo para que, al mejorar, mencione herramientas concretas cuando proceda: "usa `read` para leer el archivo", "ejecuta `composer test`", "revisa el contenido del directorio `src/`". |
| M13 | Sin consideración de permisos | El modelo debe saber si el destinatario tiene permisos de escritura, bash, etc. (especialmente relevante en OpenCode con `permission.agent`). |

### 5.5 Mejora General del Meta-Prompt (Versión Síntesis)

Propuesta de reestructuración completa del meta-prompt:

```
Eres un optimizador de instrucciones para modelos de IA que operan en entornos
de desarrollo (IDE / Codespaces / OpenCode / Claude Code).

## Formato de entrada
El usuario escribirá:
  MEJORA: <instrucción a mejorar>
  [DESTINATARIO: modelo | desarrollador]  (opcional, por defecto: modelo)
  [NIVEL: mínimo | medio | máximo]        (opcional, por defecto: medio)

## Tu tarea
1. Analiza la instrucción. Si es peligrosa, incoherente o no mejorable,
   indícalo al usuario y espera una versión corregida.
2. Reescribe la instrucción para que sea más clara, precisa y ejecutable
   por un modelo de IA en un IDE.
3. Ten en cuenta que el modelo destinatario puede leer archivos, ejecutar
   comandos, editar código, buscar en el repositorio y navegar por el
   sistema de archivos del workspace.
4. La instrucción mejorada debe ir en segunda persona (tú / imperativo).

## Formato de salida
La instrucción mejorada, sin texto adicional antes ni después.
Opcionalmente, puedes añadir al final un bloque separado con:

  ---
  Notas:
  - Confianza: Alta/Media/Baja
  - (cualquier aclaración importante sobre la instrucción)

## Gestión de sesión
- Puedes mantener contexto durante una misma sesión de mejora.
- Cada nueva instrucción MEJORA: debe tratarse sin asumir dependencias
  de la anterior, a menos que el usuario use el comando:
    ITERA: <feedback>
  que sí se refiere a la última mejora entregada.

## Ejemplos

Entrada:
  MEJORA: dime cómo funciona este código
  DESTINATARIO: modelo

Salida esperada:
  Lee el archivo que tengo abierto en el editor. Analiza su estructura
  y explícame cómo funciona: qué hace cada función principal, cómo se
  relacionan entre sí y qué dependencias externas utiliza. Si hay
  patrones de diseño recognoscibles, menciónalos.
```

### 5.6 Tabla Resumen de Propuestas

| Ámbito | Propuesta | Beneficio | Coste de implementación |
|--------|-----------|-----------|------------------------|
| Entrada | Formato `MEJORA: texto` en lugar de `M: [texto]` | Elimina ambigüedad con corchetes | Mínimo |
| Entrada | Validación previa de la instrucción | Evita mejoras sobre prompts peligrosos | Mínimo |
| Entrada | Nivel de detalle configurable | Adaptable a diferentes necesidades | Bajo |
| Salida | Permitir notas opcionales | Mayor claridad sin ensuciar la instrucción | Bajo |
| Salida | Indicador de confianza | El usuario sabe si debe revisar | Mínimo |
| Contexto | Sesión continua en lugar de descarte forzado | Mejora calidad y permite iteración | Medio (cambio conceptual) |
| Contexto | Comando `ITERA:` para refinamiento | Flujo iterativo sin reinicio | Bajo |
| IDE | Referencia al tipo de modelo destino | Instrucciones adaptadas al ejecutor | Bajo |
| IDE | Mencionar herramientas concretas | Mayor precisión operativa | Bajo |
| General | Ejemplos incluidos en el meta-prompt | Referencia clara del formato esperado | Medio (diseño) |

---

## 6. Conclusión

### 6.1 Valor del Meta-Prompt Original

El meta-prompt tiene una **intención válida**: mejorar la calidad de las instrucciones que se envían a modelos de IA en entornos de desarrollo. Los 6 criterios base son acertados y cubren aspectos fundamentales (claridad, estructura, precisión, adecuación al IDE).

### 6.2 Problemas Principales

| Problema | Gravedad | Explicación |
|----------|----------|-------------|
| **Formato de entrada `M: [texto]`** | Alta | Ambigüedad sintáctica y propensa a errores de parsing |
| **Prohibición absoluta de explicaciones** | Alta | Entra en conflicto con el objetivo de instrucciones completas |
| **Descarte forzado de contexto** | Alta | Imposible de implementar fiablemente y contraproducente para la calidad |
| **Falta de iteración** | Media | El usuario no puede refinar sin empezar de cero |
| **Sin ejemplos** | Media | El modelo carece de referencia concreta del formato de salida esperado |
| **Sin consideración del destinatario** | Baja | Mejorable, pero no crítico |

### 6.3 Recomendación

**Usar una versión modificada del meta-prompt** que:
1. Reemplace `M: [texto]` por `MEJORA: <texto>` (más claro, sin corchetes)
2. Sustituya el descarte forzado por un modelo de sesión con soporte de iteración (`ITERA:`)
3. Permita notas optativas al final de la instrucción mejorada
4. Incluya 2-3 ejemplos de referencia
5. Permita al usuario especificar el destinatario y nivel de detalle

La versión modificada mantiene el propósito original y los 6 criterios, pero elimina las restricciones artificiales que perjudican la calidad del resultado.

---

*Documento generado como análisis crítico de un meta-prompt de mejora de instrucciones — Abril 2026*
