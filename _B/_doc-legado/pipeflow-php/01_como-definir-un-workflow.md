# ¿Cómo se define un workflow en este repositorio?

## Introducción

En este repositorio (`pipeflow-php`), los workflows se llaman **pipelines** (tuberías o flujos).

Un **pipeline** es como una cadena de montaje: los datos pasan por una serie de pasos (llamados **stages** o etapas), y cada paso transforma o procesa esos datos antes de pasarlos al siguiente.

---

## Dos formas de definir un workflow

En este repositorio, puedes definir un workflow de **dos maneras**:

### 1. Con XML (recomendado para no programadores)
### 2. Con código PHP (para programadores)

---

## Forma 1: Definir con XML (la más fácil)

Un workflow en XML se define así:

```xml
<?xml version="1.0" encoding="utf-8"?>
<pipeline id="mi_workflow">
  <stages>
    <stage type="NombreDelStage">
      <settings>
        <param name="parametro1">valor1</param>
        <param name="parametro2">valor2</param>
      </settings>
    </stage>
  </stages>
</pipeline>
```

### Partes principales del XML:

| Elemento | ¿Qué hace? |
|----------|------------|
| `<pipeline id="...">` | Define el workflow y le pone un nombre |
| `<stages>` | Contiene todos los pasos del workflow |
| `<stage type="...">` | Un paso específico (hay varios tipos) |
| `<settings>` | Las configuraciones de ese paso |
| `<param name="...">` | Un parámetro o dato para el paso |

---

## Ejemplo completo en XML

Imagina un workflow que **saluda y guarda un mensaje**:

```xml
<?xml version="1.0" encoding="utf-8"?>
<pipeline id="saludo">
  <stages>
    <!-- Paso 1: Guardar un mensaje en el contexto -->
    <stage type="SetValue">
      <settings>
        <param name="parameterName">mensaje</param>
        <param name="parameterValue">¡Hola Pipeflow!</param>
      </settings>
    </stage>
    
    <!-- Paso 2: Mostrar el mensaje -->
    <stage type="Echo">
      <settings>
        <param name="text">%%mensaje%%</param>
      </settings>
    </stage>
  </stages>
</pipeline>
```

### ¿Qué pasa aquí?

1. **`SetValue`** guarda el texto "¡Hola Pipeflow!" en una variable llamada `mensaje`
2. **`Echo`** muestra el mensaje (usando `%%mensaje%%` para recuperar el valor)

---

## Forma 2: Definir con código PHP

También puedes crear el workflow directamente en PHP:

```php
use Marcosiino\Pipeflow\Core\Pipeline;
use Marcosiino\Pipeflow\PipeFlow;

// 1. Registrar los stages disponibles
PipeFlow::registerStages();

// 2. Crear el pipeline
$pipeline = new Pipeline();

// 3. Configurar y cargar el XML (o agregar stages manualmente)
$pipeline->setupWithXML($xmlConfiguration);

// 4. Ejecutar el workflow
$resultado = $pipeline->execute();
```

---

## Los tipos de stages disponibles

El repositorio incluye varios **stages** predefinidos:

| Stage | ¿Para qué sirve? |
|-------|------------------|
| `SetValue` | Guardar un valor en el contexto |
| `Echo` | Mostrar/mostrar un valor |
| `If` | Ejecutar pasos solo si se cumple una condición |
| `ForEach` | Repetir pasos para cada elemento de una lista |
| `For` | Repetir pasos un número específico de veces |
| `Delay` | Pausar el workflow por un tiempo |
| `JSONDecode` | Leer datos en formato JSON |
| `JSONEncode` | Convertir datos a JSON |
| `ExplodeString` | Dividir un texto en partes |
| `RandomArrayItem` | Elegir un elemento al azar de una lista |
| `ArrayCount` | Contar elementos de una lista |
| `ArrayPath` | Obtener un valor de una estructura anidada |
| `SumOperation` | Sumar valores |

---

## ¿Cómo funciona el contexto (context)?

El **contexto** es como una "caja" donde los stages guardan y recuperan datos:

```
┌─────────────────────────────────────┐
│  CONTEXTO (PipelineContext)         │
│  ┌───────────────────────────────┐  │
│  │ mensaje = "¡Hola Pipeflow!"   │  │
│  │ usuario = "Marco"             │  │
│  │ items = [1, 2, 3]             │  │
│  └───────────────────────────────┘  │
└─────────────────────────────────────┘
```

- Cada stage **lee** datos del contexto
- Cada stage **escribe** datos al contexto
- El contexto pasa de un stage al siguiente

### ¿Cómo se referencia un valor del contexto?

Usando `%%nombre%%`:

```xml
<param name="text">Hola %%usuario%%</param>
<!-- Si "usuario" = "Marco", se convierte en "Hola Marco" -->
```

---

## Resumen visual de un workflow

```
┌─────────────────────────────────────────────┐
│  <?xml version="1.0"?>                      │
│  <pipeline id="mi_workflow">                │
│    <stages>                                 │
│      <stage type="SetValue">...</stage>     │
│      <stage type="If">...</stage>           │
│      <stage type="ForEach">...</stage>      │
│      <stage type="Echo">...</stage>         │
│    </stages>                                │
│  </pipeline>                                │
└─────────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────┐
│  PHP:                                       │
│  $pipeline->setupWithXML($xml);             │
│  $pipeline->execute();                      │
└─────────────────────────────────────────────┘
```

---

## Puntos clave para recordar

✅ Un workflow se llama **Pipeline**  
✅ Se puede definir en **XML** (más fácil) o en **PHP**  
✅ Cada paso se llama **Stage**  
✅ Los stages comparten datos mediante el **Contexto**  
✅ Para usar un valor del contexto: `%%nombre%%`  
✅ Debes registrar los stages con `PipeFlow::registerStages()` antes de usar  
✅ Se ejecuta con `$pipeline->execute()`  

---

## Archivos importantes en el repositorio

| Archivo | ¿Qué contiene? |
|---------|----------------|
| `src/Core/Pipeline.php` | La clase principal del workflow |
| `src/Core/PipelineContext.php` | El contenedor de datos compartido |
| `src/Stages/` | Todos los stages disponibles |
| `DOCUMENTATION.md` | Documentación completa con ejemplos |
| `README.md` | Introducción y casos de uso |

---

*Documento creado para personas sin experiencia previa en este repositorio.*
