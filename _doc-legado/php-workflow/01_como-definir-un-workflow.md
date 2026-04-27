# ¿Cómo se define un workflow en este repositorio?

## Introducción

Un **workflow** (flujo de trabajo) es como una receta de cocina: es una serie de pasos que se ejecutan en un orden específico para completar una tarea.

En este repositorio (`php-workflow`), los workflows se definen usando **PHP** de una manera muy organizada y fácil de entender.

---

## Estructura básica de un workflow

Para crear un workflow, se sigue este patrón simple:

```php
$resultado = (new \PHPWorkflow\Workflow('NombreDelWorkflow'))
    ->etapa1(new Paso1())
    ->etapa2(new Paso2())
    ->etapa3(new Paso3())
    ->executeWorkflow();
```

### Partes principales:

1. **`new Workflow('Nombre')`** - Crea un nuevo workflow y le pone un nombre
2. **Las etapas** (como `->process()`, `->validate()`, etc.) - Definen los pasos a ejecutar
3. **`->executeWorkflow()`** - Ejecuta todo el workflow

---

## Las etapas disponibles (stages)

Un workflow tiene **7 etapas** que se ejecutan en este orden:

| Etapa | ¿Para qué sirve? |
|-------|------------------|
| `->prepare()` | Preparar datos antes de empezar |
| `->validate()` | Validar que todo esté correcto |
| `->before()` | Pasos previos al proceso principal |
| `->process()` | **El paso principal** (obligatorio) |
| `->onSuccess()` | Qué hacer si todo salió bien |
| `->onError()` | Qué hacer si algo falló |
| `->after()` | Limpieza final (siempre se ejecuta) |

---

## Ejemplo completo

Imagina que queremos crear un workflow para **"Agregar una canción a una playlist"**:

```php
$resultado = (new \PHPWorkflow\Workflow('AgregarCancionAPlaylist'))
    ->validate(new UsuarioPuedeEditarPlaylist())
    ->validate(new PlaylistNoTieneCancion())
    ->before(new AceptarSugerenciaAbierta())
    ->process(new AgregarCancion())
    ->onSuccess(new NotificarSeguidores())
    ->onSuccess(new GuardarEnLog())
    ->onError(new RecuperarDatos())
    ->executeWorkflow();
```

### ¿Qué pasa aquí?

1. **Valida** que el usuario pueda editar la playlist
2. **Valida** que la canción no esté ya en la playlist
3. **Antes de procesar**, acepta sugerencias abiertas si las hay
4. **Procesa** agregando la canción
5. **Si tuvo éxito**, notifica a los seguidores y guarda un registro
6. **Si hubo error**, intenta recuperar los datos

---

## ¿Cómo se crea un paso (step)?

Cada paso es una **clase** que debe cumplir dos requisitos:

### 1. Tener una descripción

```php
public function getDescription(): string
{
    return 'Agregar la canción a la playlist';
}
```

### 2. Tener un método `run()` con la lógica

```php
public function run(
    \PHPWorkflow\WorkflowControl $control,
    \PHPWorkflow\State\WorkflowContainer $container
): void {
    // Aquí va tu código
    // Por ejemplo:
    $playlist->agregarCancion($cancion);
}
```

---

## Resumen visual

```
┌─────────────────────────────────────────┐
│  new Workflow('Mi Workflow')            │
│     ↓                                   │
│  ->prepare(...)    (opcional)           │
│     ↓                                   │
│  ->validate(...)   (opcional)           │
│     ↓                                   │
│  ->before(...)     (opcional)           │
│     ↓                                   │
│  ->process(...)    (OBLIGATORIO)        │
│     ↓                                   │
│  ->onSuccess(...)  (opcional)           │
│  ->onError(...)    (opcional)           │
│     ↓                                   │
│  ->after(...)      (opcional)           │
│     ↓                                   │
│  ->executeWorkflow()                    │
└─────────────────────────────────────────┘
```

---

## Puntos clave para recordar

✅ Un workflow **siempre** debe tener al menos un paso en la etapa `->process()`  
✅ Cada paso es una **clase separada** que implementa un método `run()`  
✅ Los workflows se ejecutan con `->executeWorkflow()`  
✅ Las etapas se ejecutan en orden: Prepare → Validate → Before → Process → OnSuccess/OnError → After  
✅ Puedes usar múltiples pasos en una misma etapa  

---

## Archivos importantes en el repositorio

| Archivo | ¿Qué contiene? |
|---------|----------------|
| `src/Workflow.php` | La clase principal que define un workflow |
| `src/Step/WorkflowStep.php` | La interfaz que deben cumplir todos los pasos |
| `src/Stage/` | Las diferentes etapas disponibles |
| `tests/WorkflowTest.php` | Ejemplos de cómo se usan los workflows |

---

*Documento creado para personas sin experiencia previa en este repositorio.*
