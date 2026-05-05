## Prompt Reutilizable para Crear Documentación de Workflows/Pipelines

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

---