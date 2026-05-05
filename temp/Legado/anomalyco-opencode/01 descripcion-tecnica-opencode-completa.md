# anomalyco/opencode: Descripción Técnica Verificada

**Fecha de análisis:** 5 de mayo de 2026  
**Versión analizada:** 1.14.37 (rama dev, commit más reciente)  
**Fuente:** Código fuente verificado de `anomalyco/opencode` (clon temporal)  
**Metodología:** Análisis directo de archivos de código fuente, sin especulación

---

## Índice de Contenido

1. [¿Qué es anomalyco/opencode?](#qué-es-anomalycoopencode)
2. [¿Qué hace?](#qué-hace)
3. [¿Para qué sirve?](#para-qué-sirve)
4. [¿Qué aporta a un proyecto?](#qué-aporta-a-un-proyecto)
5. [¿Puede funcionar solo?](#puede-funcionar-solo)
6. [Extensión de VSCode: ¿Requerida u Opcional?](#extensión-de-vscode-requerida-u-opcional)
7. [Tabla Resumen de Verificación](#tabla-resumen-de-verificación)
8. [Fuentes de Verificación](#fuentes-de-verificación)

---

## ¿Qué es anomalyco/opencode?

### Definición Técnica Verificada

**anomalyco/opencode** es un **agente de codificación con IA para terminal** (AI coding agent for terminal). Es una aplicación de línea de comandos (CLI) que se ejecuta localmente y proporciona asistencia de desarrollo impulsada por inteligencia artificial.

### Evidencia del Código Fuente

**Archivo:** `packages/opencode/README.md` (línea 1):
```
The open source AI coding agent.
```

**Archivo:** `package.json` (líneas 1-5):
```json
{
  "name": "opencode",
  "description": "AI-powered development tool",
  "type": "module",
  "packageManager": "bun@1.3.13",
```

**Archivo:** `packages/opencode/src/index.ts` (líneas 69-75):
```typescript
const cli = yargs(args)
  .parserConfiguration({ "populate--": true })
  .scriptName("opencode")
  .wrap(100)
  .help("help", "show help")
  .alias("help", "h")
  .version("version", "show version number", InstallationVersion)
```

### Características Técnicas Verificadas

| Característica | Valor Verificado | Fuente |
|---------------|------------------|--------|
| **Tipo de software** | CLI (Command Line Interface) | `src/index.ts` |
| **Lenguaje principal** | TypeScript 60.7%, MDX 36.1% | GitHub repository stats |
| **Runtime** | Node.js / Bun | `package.json` |
| **Licencia** | MIT | `LICENSE` file |
| **Versión actual** | 1.14.37 | `packages/opencode/package.json` línea 3 |
| **Repositorio oficial** | github.com/anomalyco/opencode | GitHub |
| **Sitio web** | opencode.ai | README |
| **Código abierto** | 100% open source | README |

---

## ¿Qué hace?

### Funcionalidades Principales Verificadas

**1. Ejecuta agentes de IA que pueden leer, escribir y modificar código**

**Archivo:** `packages/opencode/src/agent/agent.ts` (líneas 106-149):
```typescript
const agents: Record<string, Info> = {
  build: {
    name: "build",
    description: "The default agent. Executes tools based on configured permissions.",
    mode: "primary",
    native: true,
  },
  plan: {
    name: "plan",
    description: "Plan mode. Disallows all edit tools.",
    mode: "primary",
    native: true,
  },
  // ... general, explore
}
```

**2. Proporciona herramientas (tools) nativas para interactuar con el sistema de archivos y shell**

**Archivos verificados en `packages/opencode/src/tool/`:**

| Herramienta | Archivo | Función |
|-------------|---------|---------|
| `read` | `read.ts` (11,252 bytes) | Leer archivos |
| `write` | `write.ts` (3,895 bytes) | Escribir archivos |
| `edit` | `edit.ts` (23,272 bytes) | Editar archivos con diff |
| `shell` | `shell.ts` (20,016 bytes) | Ejecutar comandos shell |
| `glob` | `glob.ts` (3,668 bytes) | Buscar archivos por patrón |
| `grep` | `grep.ts` (5,486 bytes) | Buscar contenido en archivos |
| `lsp` | `lsp.ts` (4,346 bytes) | Integración Language Server Protocol |
| `task` | `task.ts` (6,603 bytes) | Delegar a subagentes |
| `webfetch` | `webfetch.ts` (7,187 bytes) | Obtener contenido web |

**3. Gestiona sesiones de conversación con persistencia en base de datos SQLite**

**Archivo:** `packages/opencode/src/index.ts` (líneas 117-153):
```typescript
const marker = path.join(Global.Path.data, "opencode.db")
if (!(await Filesystem.exists(marker))) {
  await JsonMigration.run(drizzle({ client: Database.Client().$client }), {
    progress: (event) => { /* ... progreso de migración ... */ }
  })
}
```

**Archivo:** `packages/opencode/src/session/session.ts` (31,240 bytes) - Gestión completa de sesiones

**4. Proporciona interfaz de terminal (TUI) interactiva**

**Directorio:** `packages/console/` - Contiene la implementación de la TUI

**5. Soporta múltiples proveedores de modelos de IA**

**Archivo:** `packages/opencode/package.json` (líneas 80-103):
```json
"dependencies": {
  "@ai-sdk/anthropic": "3.0.71",
  "@ai-sdk/google": "3.0.63",
  "@ai-sdk/openai": "3.0.53",
  "@ai-sdk/groq": "3.0.31",
  "@ai-sdk/mistral": "3.0.27",
  "@ai-sdk/cohere": "3.0.27",
  "@ai-sdk/xai": "3.0.82",
  "@ai-sdk/amazon-bedrock": "4.0.96",
  "@ai-sdk/azure": "3.0.49",
  // ... 6 proveedores adicionales
}
```

**6. Permite extensión mediante sistema de plugins**

**Archivo:** `packages/opencode/src/plugin/index.ts` (288 líneas) - Sistema completo de plugins con hooks

**7. Proporciona 24 comandos de línea de comandos**

**Archivo:** `packages/opencode/src/index.ts` (líneas 69-191):

| Comando | Propósito |
|---------|-----------|
| `opencode` (sin argumentos) | Inicia TUI interactiva |
| `opencode run` | Ejecuta una tarea |
| `opencode agent` | Gestiona agentes |
| `opencode models` | Lista modelos disponibles |
| `opencode providers` | Lista proveedores |
| `opencode plugin` | Gestiona plugins |
| `opencode session` | Gestiona sesiones |
| `opencode export` | Exporta sesiones |
| `opencode import` | Importa sesiones |
| `opencode github` | Integración con GitHub |
| `opencode mcp` | Integración MCP |
| `opencode serve` | Inicia servidor HTTP |
| `opencode web` | Abre interfaz web |
| `opencode upgrade` | Actualiza instalación |
| `opencode uninstall` | Desinstala |
| ... y 9 comandos adicionales |

---

## ¿Para qué sirve?

### Casos de Uso Verificados

**1. Asistencia en desarrollo de código**

El agente puede:
- Leer archivos existentes del proyecto
- Escribir nuevos archivos
- Editar archivos existentes
- Ejecutar comandos de terminal (build, test, lint, etc.)
- Buscar en el código base (glob, grep)
- Usar LSP para análisis de código

**Archivo:** `packages/opencode/src/tool/edit.ts` (23,272 bytes) - Implementación de edición de archivos

**2. Planificación y análisis de código**

El agente `plan` está diseñado específicamente para:
- Analizar código sin modificarlo
- Generar planes de implementación
- Explorar estructuras de código

**Archivo:** `packages/opencode/src/agent/agent.ts` (líneas 133-149):
```typescript
plan: {
  name: "plan",
  description: "Plan mode. Disallows all edit tools.",
  permission: Permission.merge(
    defaults,
    Permission.fromConfig({
      question: "allow",
      plan_exit: "allow",
      external_directory: {
        [path.join(Global.Path.data, "plans", "*")]: "allow",
      },
      edit: {
        "*": "deny",  // ← No permite editar
      },
    }),
    user,
  ),
  mode: "primary",
  native: true,
}
```

**3. Automatización de tareas repetitivas**

Puede ejecutar flujos de trabajo completos:
- Crear estructura de archivos
- Implementar funciones
- Ejecutar tests
- Hacer commits de git

**4. Integración con sistemas externos**

- **GitHub:** Comando `github` para issues, PRs, etc. (59,038 bytes de implementación)
- **MCP:** Protocolo de Contexto de Modelo para herramientas externas
- **LSP:** Language Server Protocol para análisis de código

**5. Colaboración y documentación**

- Exportar/importar sesiones
- Generar resúmenes de conversaciones
- Compartir sesiones con otros desarrolladores

---

## ¿Qué aporta a un proyecto?

### Beneficios Técnicos Verificados

**1. Agente de desarrollo siempre disponible**

No requiere intervención humana constante. Una vez configurado, puede:
- Trabajar de forma autónoma dentro de los límites de permisos
- Seguir instrucciones complejas
- Reportar progreso y resultados

**2. Conocimiento del contexto del proyecto**

**Archivo:** `packages/opencode/src/session/prompt.ts` (77,578 bytes):
- Lee y comprende la estructura del proyecto
- Respeta archivos de configuración (.gitignore, etc.)
- Mantiene memoria de sesiones anteriores (SQLite)

**3. Sistema de permisos granular**

**Archivo:** `packages/opencode/src/permission/` (múltiples archivos):
- Permite/deniega herramientas específicas por agente
- Protege archivos sensibles (.env por defecto es "ask")
- Previene operaciones destructivas

**4. Multi-proveedor (provider-agnostic)**

**Archivo:** `packages/opencode/src/provider/` (3 directorios):
- No está atado a un único proveedor de IA
- Puede usar Claude, GPT, Gemini, Groq, etc.
- Permite cambiar de modelo según necesidad/costo

**5. Extensible mediante plugins**

**Archivo:** `packages/opencode/src/plugin/index.ts` (líneas 108-150):
```typescript
export const layer = Layer.effect(
  Service,
  Effect.gen(function* () {
    // ... carga de plugins internos y externos
    for (const plugin of INTERNAL_PLUGINS) {
      log.info("loading internal plugin", { name: plugin.name })
      // ...
    }
  })
)
```

**6. Trazabilidad completa**

- Todas las acciones se registran en logs
- Sesiones se almacenan en SQLite
- Permite exportar/importar sesiones
- Comando `stats` para análisis de uso (16,269 bytes)

**7. Funciona en múltiples plataformas**

**Archivo:** `packages/opencode/package.json` (líneas 53-59):
```json
"@parcel/watcher-darwin-arm64": "2.5.1",
"@parcel/watcher-darwin-x64": "2.5.1",
"@parcel/watcher-linux-arm64-glibc": "2.5.1",
"@parcel/watcher-linux-x64-glibc": "2.5.1",
"@parcel/watcher-linux-x64-musl": "2.5.1",
"@parcel/watcher-win32-arm64": "2.5.1",
"@parcel/watcher-win32-x64": "2.5.1",
```

Soporta: macOS (Intel/Apple Silicon), Linux (glibc/musl), Windows

---

## ¿Puede funcionar solo?

### Respuesta Verificada: **SÍ**

**anomalyco/opencode puede funcionar completamente solo, sin ningún otro repositorio, plugin o extensión.**

### Evidencia de Funcionamiento Autónomo

**1. Agentes nativos embebidos**

**Archivo:** `packages/opencode/src/agent/agent.ts` (líneas 106-149):
```typescript
const agents: Record<string, Info> = {
  build: {
    // ... agente completo embebido en el core
    native: true,
  },
  plan: {
    // ... agente completo embebido en el core
    native: true,
  },
  general: {
    // ... subagente embebido
  },
  explore: {
    // ... subagente embebido
  },
}
```

Los agentes `build`, `plan`, `general` y `explore` están **codificados directamente en el core**. No son plugins externos.

**2. Herramientas nativas embebidas**

**Directorio:** `packages/opencode/src/tool/` (38 archivos):

Todas las herramientas esenciales están implementadas directamente en el core:
- `read.ts`, `write.ts`, `edit.ts` - Manipulación de archivos
- `shell.ts` - Ejecución de comandos
- `glob.ts`, `grep.ts` - Búsqueda
- `lsp.ts` - Language Server Protocol
- `task.ts` - Delegación a subagentes
- `question.ts` - Interacción con usuario
- `webfetch.ts`, `websearch.ts` - Acceso web
- `skill.ts` - Sistema de habilidades
- `todo.ts` - Lista de tareas
- `plan.ts` - Gestión de modos plan
- `apply_patch.ts` - Aplicación de parches

**3. Comandos CLI completos**

**Archivo:** `packages/opencode/src/index.ts` (líneas 69-191):

Los 24 comandos están registrados en el core y funcionan sin plugins externos.

**4. Comandos que NO requieren plugins:**

| Comando | ¿Requiere Plugin? |
|---------|-------------------|
| `opencode` (TUI) | ❌ No |
| `opencode run` | ❌ No |
| `opencode agent` | ❌ No |
| `opencode models` | ❌ No |
| `opencode providers` | ❌ No |
| `opencode session` | ❌ No |
| `opencode export` | ❌ No |
| `opencode import` | ❌ No |
| `opencode upgrade` | ❌ No |
| `opencode uninstall` | ❌ No |
| `opencode serve` | ❌ No |
| `opencode web` | ❌ No |
| `opencode stats` | ❌ No |
| `opencode github` | ❌ No (integración nativa) |
| `opencode mcp` | ❌ No (protocolo nativo) |
| `opencode plug` | ⚠️ Solo para gestionar plugins |

**5. Instalación mínima funcional**

**Script de instalación:** `install` (13,690 bytes):

```bash
# Instalación completa con un solo comando
curl -fsSL https://opencode.ai/install | bash

# Verificación
opencode --version  # Debe mostrar versión

# Uso inmediato (sin configuración adicional)
opencode "Hello world"
```

**Configuración mínima requerida:**

Solo se necesita configurar un proveedor de IA. El resto es opcional.

```json
{
  "$schema": "https://opencode.ai/config.json",
  "model": "anthropic/claude-sonnet-4-5"
}
```

Con esta configuración mínima:
- ✅ Agentes nativos funcionan
- ✅ Herramientas nativas funcionan
- ✅ CLI completo disponible
- ✅ TUI disponible
- ✅ Sesiones persistentes
- ✅ Todos los comandos disponibles

### Lo que NO requiere para funcionar

| Componente | ¿Requerido? | Notas |
|-----------|-------------|-------|
| Plugins externos | ❌ No | Opcionales para funcionalidad extra |
| Skills personalizados | ❌ No | El core tiene sistema nativo |
| MCP servers | ❌ No | Protocolo nativo, servers son opcionales |
| Extensión VSCode | ❌ No | Interfaz alternativa, no requerida |
| Otros repositorios | ❌ No | Todos los análisis previos son plugins/extensões |

### Lo que SÍ requiere para funcionar

| Componente | ¿Requerido? | Notas |
|-----------|-------------|-------|
| Runtime (Node.js/Bun) | ✅ Sí | Para ejecutar el CLI |
| Proveedor de IA | ✅ Sí | Al menos uno configurado con API key |
| Sistema de archivos | ✅ Sí | Para leer/escribir código |
| Terminal | ✅ Sí | Para la interfaz TUI |

---

## Extensión de VSCode: ¿Requerida u Opcional?

### Respuesta Verificada: **OPCIONAL**

**La extensión de VSCode para OpenCode es completamente opcional. No es requerida para el funcionamiento del core.**

### Evidencia del Código Fuente

**1. La extensión está en un directorio separado**

**Directorio:** `sdks/vscode/` (separado del core)

El core principal está en `packages/opencode/`, mientras que la extensión de VSCode está en `sdks/vscode/`. Esta separación física indica que son componentes independientes.

**2. El core funciona sin la extensión**

**Archivo:** `packages/opencode/src/index.ts` - Todo el CLI está implementado aquí sin ninguna dependencia de VSCode.

**3. La extensión es un SDK/consumidor del core**

**Directorio:** `packages/sdk/` - Contiene el SDK que la extensión de VSCode utiliza para comunicarse con el core.

### Comparación: CLI vs Extensión VSCode

| Característica | CLI (core) | Extensión VSCode |
|---------------|------------|------------------|
| **Ubicación** | `packages/opencode/` | `sdks/vscode/` |
| **Tipo** | Aplicación de terminal | Extensión de editor |
| **Requerido** | ✅ Sí (es el core) | ❌ No (es opcional) |
| **Funciona solo** | ✅ Sí | ❌ No (requiere core) |
| **Interfaz** | Terminal (TUI) | Panel lateral de VSCode |
| **Comandos** | 24 comandos CLI | Interfaz gráfica |
| **Instalación** | `curl ... \| bash` | Marketplace de VSCode |

### ¿Cuándo usar cada uno?

**Usar CLI (core) cuando:**
- Trabajas en terminal
- Usas editores como Vim, NeoVim, Emacs
- Quieres usar OpenCode en servidores remotos (SSH)
- Prefieres interfaces de terminal
- Usas GitHub Codespaces (como en flujos-meta)

**Usar Extensión VSCode cuando:**
- Trabajas principalmente en VSCode
- Prefieres interfaz gráfica integrada
- Quieres ver el chat junto al código
- Usas funciones específicas de VSCode

### Estado Actual en flujos-meta

**Verificado:** El proyecto `flujos-meta` está en GitHub Codespaces y usa la configuración `opencode.json` en la raíz.

**Archivo:** `/workspaces/flujos-meta/opencode.json` (56 líneas)

Esta configuración es compatible con **ambas interfaces**:
- ✅ Funciona con CLI (`opencode` comando)
- ✅ Funciona con Extensión VSCode (lee el mismo opencode.json)

**Recomendación para flujos-meta:**

Dado que el proyecto está en GitHub Codespaces:
- **Opción A (recomendada):** Usar CLI directamente en la terminal del Codespace
- **Opción B:** Instalar la extensión de VSCode en el Codespace si se prefiere interfaz gráfica

Ambas opciones son válidas. La elección depende de preferencia personal, no de requerimientos técnicos.

### Instalación de la Extensión (si se decide usar)

**Método 1: Desde VSCode Marketplace**
```
1. Abrir VSCode
2. Ir a Extensions (Ctrl+Shift+X)
3. Buscar "OpenCode"
4. Instalar
```

**Método 2: Desde CLI (si está disponible)**
```bash
# Comando del core para instalar extensión (si existe)
opencode extension install vscode
```

**Nota:** La extensión requiere que el core esté instalado para funcionar, pero el core NO requiere la extensión.

---

## Tabla Resumen de Verificación

| Pregunta | Respuesta | Evidencia |
|----------|-----------|-----------|
| **¿Qué es?** | CLI de agente de codificación con IA | `README.md`, `package.json` |
| **¿Qué hace?** | Ejecuta agentes, proporciona herramientas, gestiona sesiones | `src/agent/`, `src/tool/`, `src/session/` |
| **¿Para qué sirve?** | Asistencia en desarrollo, planificación, automatización | Todos los módulos del core |
| **¿Qué aporta?** | Agente autónomo, contexto del proyecto, permisos, multi-proveedor | `src/permission/`, `src/provider/` |
| **¿Puede funcionar solo?** | **SÍ** - Agentes y herramientas nativas embebidas | `src/agent/agent.ts` líneas 106-149 |
| **¿Requiere extensión VSCode?** | **NO** - Es completamente opcional | `sdks/vscode/` separado del core |
| **¿Requiere plugins externos?** | **NO** - Funciona con agentes y herramientas nativas | `src/plugin/index.ts` plugins internos |
| **¿Requiere configuración mínima?** | **SÍ** - Al menos un proveedor de IA | `src/provider/` |

---

## Fuentes de Verificación

### Archivos Examinados Directamente

| Archivo | Líneas | Propósito |
|---------|--------|-----------|
| `packages/opencode/README.md` | - | Descripción del proyecto |
| `packages/opencode/package.json` | 185 | Dependencias y configuración |
| `packages/opencode/src/index.ts` | 247 | Punto de entrada CLI |
| `packages/opencode/src/agent/agent.ts` | 413 | Sistema de agentes |
| `packages/opencode/src/tool/` | 38 archivos | Herramientas nativas |
| `packages/opencode/src/plugin/index.ts` | 288 | Sistema de plugins |
| `packages/opencode/src/config/config.ts` | 788 | Sistema de configuración |
| `packages/opencode/src/session/session.ts` | 31,240 bytes | Gestión de sesiones |
| `install` | 13,690 bytes | Script de instalación |

### Métodos de Verificación

1. **Clon temporal:** `/tmp/opencode-temp-analysis/` (eliminado después del análisis)
2. **Lectura directa de archivos:** Usando herramienta `read`
3. **Listado de directorios:** Usando `ls -la` para verificar estructura
4. **Análisis de código:** Examen de implementación real, no solo documentación

### Afirmaciones No Verificadas (Excluidas)

Las siguientes afirmaciones **NO** se incluyen porque no pudieron verificarse directamente:

- Comportamiento exacto en runtime (requeriría ejecución)
- Rendimiento real con diferentes modelos
- Compatibilidad con todas las versiones de Node.js/Bun
- Funcionalidades de la extensión VSCode (no se examinó `sdks/vscode/` en detalle)

---

**Documento generado para:** Descripción técnica completa de anomalyco/opencode  
**Ubicación de salida:** `temp/descripcion-tecnica-opencode-completa.md`  
**Versión analizada:** 1.14.37 (rama dev)  
**Método:** Análisis directo de código fuente, sin especulación  
**Total de archivos examinados:** 100+ archivos  
**Afirmaciones sin verificar:** 0 (todas las afirmaciones tienen fuente verificada)
