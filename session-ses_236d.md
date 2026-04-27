# Prompt reutilizable para documentación

**Session ID:** ses_236d29849ffe7w4PllRJcAY0BN
**Created:** 4/26/2026, 9:44:49 AM
**Updated:** 4/26/2026, 9:47:35 AM

---

## User

Lee 
anallizador/php-workflow/01_como-definir-un-workflow.md
anallizador/pipeflow-php/01_como-definir-un-workflow.md
Apoyandote en esos 2 archvios, crea un prompt reutulizable para ordenar la creacion de doc similar para otros  repos.
Pregunta si necesitas aclarar algo y no hagas nada hasta obtener respuesta a tus preguntas. 

---

## Assistant (Build · Qwen3.5 Plus · 16.8s)

_Thinking:_

El usuario quiere que lea dos archivos específicos para entender su estructura y contenido, y luego cree un prompt reutilizable. Primero necesito leer ambos archivos para entender qué contienen.

**Tool: read**

**Input:**
```json
{
  "filePath": "/workspaces/flujos-meta/anallizador/php-workflow/01_como-definir-un-workflow.md"
}
```

**Output:**
```
<path>/workspaces/flujos-meta/anallizador/php-workflow/01_como-definir-un-workflow.md</path>
<type>file</type>
<content>
1: # ¿Cómo se define un workflow en este repositorio?
2: 
3: ## Introducción
4: 
5: Un **workflow** (flujo de trabajo) es como una receta de cocina: es una serie de pasos que se ejecutan en un orden específico para completar una tarea.
6: 
7: En este repositorio (`php-workflow`), los workflows se definen usando **PHP** de una manera muy organizada y fácil de entender.
8: 
9: ---
10: 
11: ## Estructura básica de un workflow
12: 
13: Para crear un workflow, se sigue este patrón simple:
14: 
15: ```php
16: $resultado = (new \PHPWorkflow\Workflow('NombreDelWorkflow'))
17:     ->etapa1(new Paso1())
18:     ->etapa2(new Paso2())
19:     ->etapa3(new Paso3())
20:     ->executeWorkflow();
21: ```
22: 
23: ### Partes principales:
24: 
25: 1. **`new Workflow('Nombre')`** - Crea un nuevo workflow y le pone un nombre
26: 2. **Las etapas** (como `->process()`, `->validate()`, etc.) - Definen los pasos a ejecutar
27: 3. **`->executeWorkflow()`** - Ejecuta todo el workflow
28: 
29: ---
30: 
31: ## Las etapas disponibles (stages)
32: 
33: Un workflow tiene **7 etapas** que se ejecutan en este orden:
34: 
35: | Etapa | ¿Para qué sirve? |
36: |-------|------------------|
37: | `->prepare()` | Preparar datos antes de empezar |
38: | `->validate()` | Validar que todo esté correcto |
39: | `->before()` | Pasos previos al proceso principal |
40: | `->process()` | **El paso principal** (obligatorio) |
41: | `->onSuccess()` | Qué hacer si todo salió bien |
42: | `->onError()` | Qué hacer si algo falló |
43: | `->after()` | Limpieza final (siempre se ejecuta) |
44: 
45: ---
46: 
47: ## Ejemplo completo
48: 
49: Imagina que queremos crear un workflow para **"Agregar una canción a una playlist"**:
50: 
51: ```php
52: $resultado = (new \PHPWorkflow\Workflow('AgregarCancionAPlaylist'))
53:     ->validate(new UsuarioPuedeEditarPlaylist())
54:     ->validate(new PlaylistNoTieneCancion())
55:     ->before(new AceptarSugerenciaAbierta())
56:     ->process(new AgregarCancion())
57:     ->onSuccess(new NotificarSeguidores())
58:     ->onSuccess(new GuardarEnLog())
59:     ->onError(new RecuperarDatos())
60:     ->executeWorkflow();
61: ```
62: 
63: ### ¿Qué pasa aquí?
64: 
65: 1. **Valida** que el usuario pueda editar la playlist
66: 2. **Valida** que la canción no esté ya en la playlist
67: 3. **Antes de procesar**, acepta sugerencias abiertas si las hay
68: 4. **Procesa** agregando la canción
69: 5. **Si tuvo éxito**, notifica a los seguidores y guarda un registro
70: 6. **Si hubo error**, intenta recuperar los datos
71: 
72: ---
73: 
74: ## ¿Cómo se crea un paso (step)?
75: 
76: Cada paso es una **clase** que debe cumplir dos requisitos:
77: 
78: ### 1. Tener una descripción
79: 
80: ```php
81: public function getDescription(): string
82: {
83:     return 'Agregar la canción a la playlist';
84: }
85: ```
86: 
87: ### 2. Tener un método `run()` con la lógica
88: 
89: ```php
90: public function run(
91:     \PHPWorkflow\WorkflowControl $control,
92:     \PHPWorkflow\State\WorkflowContainer $container
93: ): void {
94:     // Aquí va tu código
95:     // Por ejemplo:
96:     $playlist->agregarCancion($cancion);
97: }
98: ```
99: 
100: ---
101: 
102: ## Resumen visual
103: 
104: ```
105: ┌─────────────────────────────────────────┐
106: │  new Workflow('Mi Workflow')            │
107: │     ↓                                   │
108: │  ->prepare(...)    (opcional)           │
109: │     ↓                                   │
110: │  ->validate(...)   (opcional)           │
111: │     ↓                                   │
112: │  ->before(...)     (opcional)           │
113: │     ↓                                   │
114: │  ->process(...)    (OBLIGATORIO)        │
115: │     ↓                                   │
116: │  ->onSuccess(...)  (opcional)           │
117: │  ->onError(...)    (opcional)           │
118: │     ↓                                   │
119: │  ->after(...)      (opcional)           │
120: │     ↓                                   │
121: │  ->executeWorkflow()                    │
122: └─────────────────────────────────────────┘
123: ```
124: 
125: ---
126: 
127: ## Puntos clave para recordar
128: 
129: ✅ Un workflow **siempre** debe tener al menos un paso en la etapa `->process()`  
130: ✅ Cada paso es una **clase separada** que implementa un método `run()`  
131: ✅ Los workflows se ejecutan con `->executeWorkflow()`  
132: ✅ Las etapas se ejecutan en orden: Prepare → Validate → Before → Process → OnSuccess/OnError → After  
133: ✅ Puedes usar múltiples pasos en una misma etapa  
134: 
135: ---
136: 
137: ## Archivos importantes en el repositorio
138: 
139: | Archivo | ¿Qué contiene? |
140: |---------|----------------|
141: | `src/Workflow.php` | La clase principal que define un workflow |
142: | `src/Step/WorkflowStep.php` | La interfaz que deben cumplir todos los pasos |
143: | `src/Stage/` | Las diferentes etapas disponibles |
144: | `tests/WorkflowTest.php` | Ejemplos de cómo se usan los workflows |
145: 
146: ---
147: 
148: *Documento creado para personas sin experiencia previa en este repositorio.*

(End of file - total 148 lines)
</content>
```

**Tool: read**

**Input:**
```json
{
  "filePath": "/workspaces/flujos-meta/anallizador/pipeflow-php/01_como-definir-un-workflow.md"
}
```

**Output:**
```
<path>/workspaces/flujos-meta/anallizador/pipeflow-php/01_como-definir-un-workflow.md</path>
<type>file</type>
<content>
1: # ¿Cómo se define un workflow en este repositorio?
2: 
3: ## Introducción
4: 
5: En este repositorio (`pipeflow-php`), los workflows se llaman **pipelines** (tuberías o flujos).
6: 
7: Un **pipeline** es como una cadena de montaje: los datos pasan por una serie de pasos (llamados **stages** o etapas), y cada paso transforma o procesa esos datos antes de pasarlos al siguiente.
8: 
9: ---
10: 
11: ## Dos formas de definir un workflow
12: 
13: En este repositorio, puedes definir un workflow de **dos maneras**:
14: 
15: ### 1. Con XML (recomendado para no programadores)
16: ### 2. Con código PHP (para programadores)
17: 
18: ---
19: 
20: ## Forma 1: Definir con XML (la más fácil)
21: 
22: Un workflow en XML se define así:
23: 
24: ```xml
25: <?xml version="1.0" encoding="utf-8"?>
26: <pipeline id="mi_workflow">
27:   <stages>
28:     <stage type="NombreDelStage">
29:       <settings>
30:         <param name="parametro1">valor1</param>
31:         <param name="parametro2">valor2</param>
32:       </settings>
33:     </stage>
34:   </stages>
35: </pipeline>
36: ```
37: 
38: ### Partes principales del XML:
39: 
40: | Elemento | ¿Qué hace? |
41: |----------|------------|
42: | `<pipeline id="...">` | Define el workflow y le pone un nombre |
43: | `<stages>` | Contiene todos los pasos del workflow |
44: | `<stage type="...">` | Un paso específico (hay varios tipos) |
45: | `<settings>` | Las configuraciones de ese paso |
46: | `<param name="...">` | Un parámetro o dato para el paso |
47: 
48: ---
49: 
50: ## Ejemplo completo en XML
51: 
52: Imagina un workflow que **saluda y guarda un mensaje**:
53: 
54: ```xml
55: <?xml version="1.0" encoding="utf-8"?>
56: <pipeline id="saludo">
57:   <stages>
58:     <!-- Paso 1: Guardar un mensaje en el contexto -->
59:     <stage type="SetValue">
60:       <settings>
61:         <param name="parameterName">mensaje</param>
62:         <param name="parameterValue">¡Hola Pipeflow!</param>
63:       </settings>
64:     </stage>
65:     
66:     <!-- Paso 2: Mostrar el mensaje -->
67:     <stage type="Echo">
68:       <settings>
69:         <param name="text">%%mensaje%%</param>
70:       </settings>
71:     </stage>
72:   </stages>
73: </pipeline>
74: ```
75: 
76: ### ¿Qué pasa aquí?
77: 
78: 1. **`SetValue`** guarda el texto "¡Hola Pipeflow!" en una variable llamada `mensaje`
79: 2. **`Echo`** muestra el mensaje (usando `%%mensaje%%` para recuperar el valor)
80: 
81: ---
82: 
83: ## Forma 2: Definir con código PHP
84: 
85: También puedes crear el workflow directamente en PHP:
86: 
87: ```php
88: use Marcosiino\Pipeflow\Core\Pipeline;
89: use Marcosiino\Pipeflow\PipeFlow;
90: 
91: // 1. Registrar los stages disponibles
92: PipeFlow::registerStages();
93: 
94: // 2. Crear el pipeline
95: $pipeline = new Pipeline();
96: 
97: // 3. Configurar y cargar el XML (o agregar stages manualmente)
98: $pipeline->setupWithXML($xmlConfiguration);
99: 
100: // 4. Ejecutar el workflow
101: $resultado = $pipeline->execute();
102: ```
103: 
104: ---
105: 
106: ## Los tipos de stages disponibles
107: 
108: El repositorio incluye varios **stages** predefinidos:
109: 
110: | Stage | ¿Para qué sirve? |
111: |-------|------------------|
112: | `SetValue` | Guardar un valor en el contexto |
113: | `Echo` | Mostrar/mostrar un valor |
114: | `If` | Ejecutar pasos solo si se cumple una condición |
115: | `ForEach` | Repetir pasos para cada elemento de una lista |
116: | `For` | Repetir pasos un número específico de veces |
117: | `Delay` | Pausar el workflow por un tiempo |
118: | `JSONDecode` | Leer datos en formato JSON |
119: | `JSONEncode` | Convertir datos a JSON |
120: | `ExplodeString` | Dividir un texto en partes |
121: | `RandomArrayItem` | Elegir un elemento al azar de una lista |
122: | `ArrayCount` | Contar elementos de una lista |
123: | `ArrayPath` | Obtener un valor de una estructura anidada |
124: | `SumOperation` | Sumar valores |
125: 
126: ---
127: 
128: ## ¿Cómo funciona el contexto (context)?
129: 
130: El **contexto** es como una "caja" donde los stages guardan y recuperan datos:
131: 
132: ```
133: ┌─────────────────────────────────────┐
134: │  CONTEXTO (PipelineContext)         │
135: │  ┌───────────────────────────────┐  │
136: │  │ mensaje = "¡Hola Pipeflow!"   │  │
137: │  │ usuario = "Marco"             │  │
138: │  │ items = [1, 2, 3]             │  │
139: │  └───────────────────────────────┘  │
140: └─────────────────────────────────────┘
141: ```
142: 
143: - Cada stage **lee** datos del contexto
144: - Cada stage **escribe** datos al contexto
145: - El contexto pasa de un stage al siguiente
146: 
147: ### ¿Cómo se referencia un valor del contexto?
148: 
149: Usando `%%nombre%%`:
150: 
151: ```xml
152: <param name="text">Hola %%usuario%%</param>
153: <!-- Si "usuario" = "Marco", se convierte en "Hola Marco" -->
154: ```
155: 
156: ---
157: 
158: ## Resumen visual de un workflow
159: 
160: ```
161: ┌─────────────────────────────────────────────┐
162: │  <?xml version="1.0"?>                      │
163: │  <pipeline id="mi_workflow">                │
164: │    <stages>                                 │
165: │      <stage type="SetValue">...</stage>     │
166: │      <stage type="If">...</stage>           │
167: │      <stage type="ForEach">...</stage>      │
168: │      <stage type="Echo">...</stage>         │
169: │    </stages>                                │
170: │  </pipeline>                                │
171: └─────────────────────────────────────────────┘
172:                     ↓
173: ┌─────────────────────────────────────────────┐
174: │  PHP:                                       │
175: │  $pipeline->setupWithXML($xml);             │
176: │  $pipeline->execute();                      │
177: └─────────────────────────────────────────────┘
178: ```
179: 
180: ---
181: 
182: ## Puntos clave para recordar
183: 
184: ✅ Un workflow se llama **Pipeline**  
185: ✅ Se puede definir en **XML** (más fácil) o en **PHP**  
186: ✅ Cada paso se llama **Stage**  
187: ✅ Los stages comparten datos mediante el **Contexto**  
188: ✅ Para usar un valor del contexto: `%%nombre%%`  
189: ✅ Debes registrar los stages con `PipeFlow::registerStages()` antes de usar  
190: ✅ Se ejecuta con `$pipeline->execute()`  
191: 
192: ---
193: 
194: ## Archivos importantes en el repositorio
195: 
196: | Archivo | ¿Qué contiene? |
197: |---------|----------------|
198: | `src/Core/Pipeline.php` | La clase principal del workflow |
199: | `src/Core/PipelineContext.php` | El contenedor de datos compartido |
200: | `src/Stages/` | Todos los stages disponibles |
201: | `DOCUMENTATION.md` | Documentación completa con ejemplos |
202: | `README.md` | Introducción y casos de uso |
203: 
204: ---
205: 
206: *Documento creado para personas sin experiencia previa en este repositorio.*

(End of file - total 206 lines)
</content>
```

---

## Assistant (Build · Qwen3.5 Plus · 6.7s)

_Thinking:_

He leído ambos archivos. Ahora entiendo la estructura y el estilo de documentación. Antes de crear el prompt reutilizable, tengo algunas preguntas para aclarar:

1. ¿Qué tipo de repositorios objetivo tienen? (¿son todos PHP o pueden ser de otros lenguajes?)
2. ¿El prompt debe ser en español o inglés?
3. ¿Hay alguna sección específica que quieran mantener o modificar del formato actual?
4. ¿Para qué audiencia está dirigida la documentación? (¿principiantes, desarrolladores experimentados, ambos?)

Voy a preguntar estas dudas antes de proceder.

He leído ambos archivos. Antes de crear el prompt reutilizable, necesito aclarar:

1. **¿Los repositorios objetivo son todos de PHP** o pueden ser de otros lenguajes?
2. **¿El prompt debe estar en español** o lo prefieres en inglés?
3. **¿Hay alguna sección específica** del formato actual que quieras mantener, modificar o eliminar?
4. **¿La audiencia objetivo es siempre principiantes** sin experiencia en el repositorio, o puede variar?

---

## User

1 más que sobre el lenguaje, me interesa sobre lo que hace el repo
2 ES
3 igual está bien, más lo que se quiera añadir  al ejec el  prompt para mejorar el  conocimiento del repo a analizar
4 sin exp en el repo

---

## Assistant (Build · Qwen3.5 Plus · 24.1s)

_Thinking:_

El usuario quiere un prompt reutilizable para crear documentación similar en otros repositorios. Las respuestas fueron:

1. Más importante que el lenguaje es lo que hace el repo - el prompt debe enfocarse en la funcionalidad/proósito del repositorio
2. En español
3. El formato actual está bien, se puede añadir lo que sea necesario para mejorar el conocimiento del repo
4. La audiencia son personas sin experiencia en el repositorio

Voy a crear un prompt reutilizable que capture la estructura y estilo de ambos documentos, enfocado en entender qué hace el repositorio más que el lenguaje específico.

## Prompt Reutilizable para Crear Documentación de Workflows/Pipelines

```markdown
# Prompt para Generar Documentación: "¿Cómo se define un workflow en este repositorio?"

## Instrucciones para el analista

Analiza el repositorio y genera un documento educativo siguiendo esta estructura:

---

## Estructura del Documento a Generar

### 1. Título
`# ¿Cómo se define un workflow en este repositorio?`

### 2. Introducción
- Explica qué nombre recibe el concepto de "workflow" en ESTE repositorio específico (Pipeline, Flow, Workflow, Process, etc.)
- Usa una analogía cotidiana (receta de cocina, cadena de montaje, tuberías, etc.)
- Menciona el nombre técnico del repositorio entre backticks
- Indica qué lenguaje/patrón se usa para definirlos

### 3. Formas de definición
- ¿Se define con código, XML, YAML, JSON, interfaz visual?
- ¿Hay múltiples formas? Descríbelas todas
- Indica cuál es la recomendada y por qué

### 4. Estructura básica (con ejemplo mínimo)
- Muestra el ejemplo más simple posible que funcione
- Señala las partes principales con comentarios
- Usa bloques de código con sintaxis resaltada

### 5. Ejemplo completo (caso de uso real)
- Crea un ejemplo con propósito claro (ej: "Agregar canción a playlist", "Saludar y guardar mensaje")
- Muestra múltiples pasos/etapas trabajando juntos
- Explica qué pasa en cada paso

### 6. Componentes disponibles
- Lista TODOS los tipos de pasos/etapas/stages disponibles
- Usa una tabla con: | Nombre | ¿Para qué sirve? |
- Incluye descripciones cortas y claras

### 7. ¿Cómo se crea un paso personalizado? (si aplica)
- Muestra la interfaz/clase base a implementar
- Indica los métodos obligatorios
- Da un ejemplo mínimo funcional

### 8. Mecanismo de intercambio de datos
- Explica CÓMO los pasos comparten información entre sí
- ¿Hay un contexto? ¿variables? ¿estado compartido?
- Usa diagrama ASCII si ayuda a visualizar
- Muestra la sintaxis para leer/escribir datos

### 9. Resumen visual del flujo
- Crea un diagrama ASCII que muestre el ciclo de vida completo
- Desde la definición hasta la ejecución
- Marca qué es obligatorio vs opcional

### 10. Puntos clave para recordar
- Lista con ✅ de 5-7 conceptos fundamentales
- Enfócate en lo que NO puede olvidar un principiante

### 11. Archivos importantes del repositorio
| Archivo | ¿Qué contiene? |
|---------|----------------|
| `ruta/al/archivo` | Descripción clara |

Incluye al menos 4-5 archivos clave para explorar

### 12. Footer
`*Documento creado para personas sin experiencia previa en este repositorio.*`

---

## Reglas de Estilo

1. **Tono**: Conversacional, como explicarle a un compañero
2. **Analogías**: Usa comparaciones con cosas cotidianas
3. **Formato**: 
   - Títulos con `##` y `###`
   - Código con backticks triples y lenguaje
   - Tablas para comparaciones
   - Separadores `---` entre secciones
   - Listas con viñetas para puntos clave
4. **Diagramas**: ASCII simple cuando ayude a visualizar
5. **Énfasis**: **Negritas** para términos técnicos la primera vez
6. **Longitud**: Cada sección debe ser escaneable en <30 segundos

---

## Preguntas Guía para Analizar el Repositorio

Antes de escribir, responde:

1. ¿Qué patrón implementa? (Workflow, Pipeline, Command Chain, etc.)
2. ¿Cuál es el nombre de la clase/función principal?
3. ¿Cómo se ejecuta un workflow completo?
4. ¿Qué pasos/etapas existen y cuál es obligatorio?
5. ¿Cómo se pasan datos entre pasos?
6. ¿Hay ejemplos en los tests que pueda usar como referencia?
7. ¿Qué archivos debería leer un principiante primero?

---

## Checklist de Validación

- [ ] El ejemplo mínimo es copiable y funcional
- [ ] El ejemplo completo tiene propósito claro
- [ ] Todos los stages/pasos disponibles están listados
- [ ] El mecanismo de datos está explicado
- [ ] Hay diagrama visual del flujo
- [ ] Los puntos clave son memorables
- [ ] Los archivos importantes son reales y existen
- [ ] Un principiante podría crear su primer workflow solo con este doc
```

---

¿Quieres que ajuste algo del prompt o lo doy por terminado?

---

