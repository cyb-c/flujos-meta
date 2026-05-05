# Tabla de Contenido: Prompts OpenAgentsControl

| ID | Nombre Prompt | Descripción / Finalidad | Etiquetas |
|----|---------------|------------------------|-----------|
| 1 | [Actualizar informe de decisión con plan de instalación de OAC](#actualizar-informe-de-decision-con-plan-de-instalacion-de-oac) | Actualiza el informe de decisión del repositorio pyt0 eliminando el plan de implantación anterior y sustituyéndolo por un plan para crear un repositorio nuevo vacío, instalar OpenAgentsControl y sus dependencias, dejándolo listo para desarrollar proyectos con OAC. | openagentscontrol, instalacion, repositorio, plan, informe-decision |

---

## Actualizar informe de decisión con plan de instalación de OAC

Actualiza el archivo temp/10/informe-decision-repositorio-pyt0.md. Elimina el plan de implantación que has propuesto y sustitúyelo por un plan que consiga lo siguiente:

- Crear un repositorio nuevo y vacío, sin archivos iniciales.
- Instalar el proyecto OpenAgentsControl desde https://github.com/darrenhinde/OpenAgentsControl (OAC).
- Instalar todas las dependencias y requerimientos necesarios para que OAC pueda funcionar correctamente.
- Dejar el repositorio listo para empezar a trabajar sobre él utilizando OAC e iniciando el desarrollo del proyecto que se quiera desarrollar.

---

## Reglas para Escribir e Indexar Prompts en este Archivo

1. **Sigue el método de mejora**: Todo prompt aquí debe redactarse siguiendo el mismo criterio con el que se mejora una instrucción: lenguaje en segunda persona, sin abreviaciones, estructura clara, sin prefijos ni adornos (comillas, corchetes, frases introductorias), manteniendo el propósito original y añadiendo detalles que lo hagan más efectivo.

2. **Formato de cada prompt**: Cada prompt debe comenzar con un heading nivel 2 (`## Nombre del Prompt`) seguido del contenido del prompt.

3. **Nombre del Prompt**: Debe ser descriptivo y único. Usa mayúscula inicial en cada palabra significativa.

4. **Índice de contenido**: Cada prompt debe tener una fila en la tabla índice al inicio del archivo. La columna "Nombre Prompt" debe ser un anchor link a la sección correspondiente usando el formato `[Nombre](#nombre-en-minúsculas-con-guiones)`.

5. **ID inverso**: El ID más alto corresponde al prompt más reciente. Al agregar un nuevo prompt, asígnale el ID siguiente al máximo existente.

6. **Descripción / Finalidad**: Breve descripción de una línea que explique qué logra el prompt.

7. **Etiquetas**: Palabras clave separadas por comas, todas en minúsculas y sin tildes, que faciliten la búsqueda.

8. **Separación**: Entre la tabla índice y los prompts usa una línea `---`. Entre prompts también usa `---` como separador.
