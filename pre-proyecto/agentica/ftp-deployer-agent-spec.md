# Especificación del Agente Desplegador FTP

**Versión:** 1.0  
**Fecha:** 28 de abril de 2026  
**Estado:** Especificación pendiente de implementación

---

## Índice de Contenido

1. [Objetivo del agente desplegador FTP](#1-objetivo-del-agente-desplegador-ftp)
2. [Contexto de uso dentro del proyecto](#2-contexto-de-uso-dentro-del-proyecto)
3. [Requisitos de OpenCode aplicables](#3-requisitos-de-opencode-aplicables)
4. [Diseño propuesto del agente](#4-diseño-propuesto-del-agente)
5. [Forma de invocación manual por el usuario](#5-forma-de-invocación-manual-por-el-usuario)
6. [Forma de invocación por un agente orquestador](#6-forma-de-invocación-por-un-agente-orquestador)
7. [Flujo completo de despliegue FTP](#7-flujo-completo-de-despliegue-ftp)
8. [Validaciones previas al despliegue](#8-validaciones-previas-al-despliegue)
9. [Verificaciones posteriores al despliegue](#9-verificaciones-posteriores-al-despliegue)
10. [Gestión segura de credenciales](#10-gestión-segura-de-credenciales)
11. [Gestión de errores y mensajes esperados](#11-gestión-de-errores-y-mensajes-esperados)
12. [Archivos o configuración necesarios](#12-archivos-o-configuración-necesarios)
13. [Limitaciones conocidas](#13-limitaciones-conocidas)
14. [Preguntas o decisiones pendientes](#14-preguntas-o-decisiones-pendientes)

---

## 1. Objetivo del agente desplegador FTP

Desplegar archivos de la Web-App (WA) desde el workspace/Codespace hacia el servidor de hosting compartido mediante FTP, verificar que el despliegue se completó correctamente e informar errores de forma clara y accionable.

**Propósito operativo:** Automatizar la tarea repetitiva de subir archivos por FTP durante el desarrollo, permitiendo invocaciones rápidas tanto manuales como automatizadas.

---

## 2. Contexto de uso dentro del proyecto

### 2.1 Ciclo de vida

El agente se usará durante **todo el ciclo de vida del proyecto**:
- **Etapa 1 (actual):** Despliegue de Slim + "Hola mundo"
- **Etapas 2+:** Despliegue incremental de nuevas funcionalidades
- **Mantenimiento:** Despliegue de parches y actualizaciones

### 2.2 Relación con otros documentos

| Documento | Relación |
|-----------|----------|
| `pre-proyecto/implantacion/00-decisiones-generales-implantacion.md` | Decisiones de implantación que el agente debe respetar |
| `pre-proyecto/implantacion/Etapa01_Slim-Despliegue-FTP.md` | Plan detallado con comandos FTP, rutas y estructura |
| `pre-proyecto/wa-slim/deploy.sh` | Script de despliegue que el agente puede invocar o emular |

### 2.3 Límites del agente

El agente **no debe**:
- Hacer `push` a GitHub ni depender de GitHub para desplegar
- Modificar archivos del proyecto (solo transferirlos)
- Guardar o exponer contraseñas en claro
- Ejecutar comandos en el servidor remoto

---

## 3. Requisitos de OpenCode aplicables

### 3.1 Formato de archivo de agente

Según la documentación oficial de OpenCode (`opencode.ai/docs/agents`), los agentes se definen como archivos Markdown con YAML frontmatter en:

- **Por proyecto:** `.opencode/agents/<nombre>.md`
- **Global:** `~/.config/opencode/agents/<nombre>.md`

El nombre del archivo **sin extensión** se convierte en el nombre del agente.

### 3.2 Convenciones de nomenclatura

| Regla | Aplicación |
|-------|------------|
| El nombre del archivo debe coincidir con el `name` interno | `ftp-deployer` |
| Caracteres: alfanumérico minúscula con guiones | `ftp-deployer` ✅ |
| Sin guiones al inicio/fin ni `--` consecutivo | ✅ Cumple |

### 3.3 Modos de agente aplicables

| Modo | Aplicable | Justificación |
|------|-----------|---------------|
| `subagent` | ✅ | Invocable manualmente vía `@ftp-deployer` y por orquestador vía Task |
| `primary` | ❌ | No necesita ser agente primario (no se cicla con Tab) |
| `all` | ❌ | Preferimos modo explícito `subagent` |

### 3.4 Permisos necesarios

| Permiso | Valor | Justificación |
|---------|-------|---------------|
| `bash` | `allow` | Necesita ejecutar `lftp`, `composer install`, `curl` de verificación |
| `read` | `allow` | Necesita leer archivos del proyecto para verificar estructura |
| `glob` | `allow` | Necesita encontrar archivos a desplegar |
| `grep` | `allow` | Necesita buscar patrones en configuración |
| `edit` | `deny` | No debe modificar archivos |
| `webfetch` | `deny` | No necesita fetch web |
| `task` | `deny` | No debe invocar otros subagentes |
| `skill` | `ask` | Podría cargar skills auxiliares |

### 3.5 Parámetros adicionales

| Parámetro | Valor | Justificación |
|-----------|-------|---------------|
| `temperature` | `0.1` | Comportamiento determinista y predecible |
| `steps` | `20` | Suficiente para el flujo completo de despliegue |
| `model` | No especificar | Usar modelo del agente primario que lo invoca |

### 3.6 Archivo de implementación

```
.opencode/agents/ftp-deployer.md
```

---

## 4. Diseño propuesto del agente

### 4.1 Estructura del archivo de agente

```
.opencode/agents/ftp-deployer.md
```

```markdown
---
description: Despliega archivos de la WA por FTP al servidor compartido con verificación posterior
mode: subagent
temperature: 0.1
permission:
  bash: allow
  read: allow
  glob: allow
  grep: allow
  edit: deny
  webfetch: deny
  task: deny
  skill: ask
---

Eres un agente desplegador FTP. Tu función es transferir archivos de la Web-App
desde el Codespace/workspace al servidor de hosting compartido mediante FTP.

## Reglas obligatorias

1. Nunca guardes ni expongas contraseñas en claro en logs, mensajes o archivos.
2. Lee las credenciales FTP exclusivamente de variables de entorno.
3. No ejecutes comandos en el servidor remoto.
4. No hagas push a GitHub.
5. Verifica siempre que el despliegue se completó correctamente.
6. Informa errores de forma clara y con pasos de corrección.

## Flujo de trabajo

1. PRE-VALIDACIÓN: Verifica que el directorio fuente existe y tiene contenido.
2. VERIFICAR CLIENTE: Comprueba si lftp está instalado; si no, instálalo.
3. PREPARAR PAQUETE: Ejecuta composer install --no-dev --optimize-autoloader si
   existe composer.json.
4. CONECTAR FTP: Usa las credenciales de variables de entorno para conectar.
5. TRANSFERIR: Sube los archivos usando lftp mirror --reverse.
6. VERIFICAR: Comprueba que los archivos se transfirieron correctamente.
7. INFORMAR: Resume el resultado con archivos transferidos, errores, y siguiente paso.

## Rutas predefinidas

- Origen: pre-proyecto/wa-slim/
- Destino FTP: /home/beevivac/stg2.cofemlevante.es/wa-slim/
- Servidor FTP: ftp.bee-viva.es
- Puerto: 21
- Usuario: ftp-wa@levantecofem.es
- Variable de entorno para contraseña: CONTRASENYA_FTP_WA

## Respuesta esperada

Tras cada despliegue, proporciona un resumen estructurado con:
- ✅ Archivos transferidos (número y tamaño total)
- ✅ URL de verificación
- ⚠️ Errores encontrados (si los hay)
- ➡️ Siguiente paso recomendado
```

### 4.2 Lógica interna del agente

El agente no necesita archivos de script externos. Su lógica se basa en comandos bash secuenciales, todos ellos documentados en el prompt del agente. No requiere código auxiliar fuera del archivo `.opencode/agents/ftp-deployer.md`.

### 4.3 Separación de responsabilidades

| Capa | Responsabilidad | Dónde se define |
|------|----------------|-----------------|
| **Configuración** | Rutas, servidor, puerto | Prompt del agente (fijo) |
| **Credenciales** | Usuario y contraseña | Variables de entorno (`CONTRASENYA_FTP_WA`) |
| **Lógica de despliegue** | Comandos lftp, verificación | Prompt del agente |
| **Validaciones** | Pre-validación y post-verificación | Prompt del agente |

---

## 5. Forma de invocación manual por el usuario

### 5.1 Desde el TUI de OpenCode

```bash
@ftp-deployer despliega la última versión
```

```bash
@ftp-deployer despliega solo el directorio public/
```

```bash
@ftp-deployer verifica el estado del último despliegue
```

### 5.2 Desde la CLI de OpenCode (modo headless)

```bash
opencode run "@ftp-deployer despliega la WA completa"
```

---

## 6. Forma de invocación por un agente orquestador

### 6.1 Configuración de permisos en `opencode.json`

Para que un agente orquestador pueda invocar al desplegador FTP:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "agent": {
    "orchestrator": {
      "mode": "primary",
      "permission": {
        "task": {
          "*": "deny",
          "ftp-deployer": "allow"
        }
      }
    }
  }
}
```

### 6.2 Flujo de invocación desde orquestador

1. El orquestador recibe una tarea que requiere despliegue
2. El orquestador invoca el subagente `ftp-deployer` mediante la herramienta `Task`
3. El subagente ejecuta el despliegue completo
4. El subagente devuelve un resumen estructurado al orquestador
5. El orquestador incorpora el resultado en su respuesta al usuario

### 6.3 Ejemplo de delegación desde orquestador

```
@orchestrator Implementa el fix de autenticación y despliega

El orquestador delegaría:
1. @general Implementar el fix en el código
2. @ftp-deployer Desplegar los cambios
```

---

## 7. Flujo completo de despliegue FTP

### 7.1 Diagrama de flujo

```
┌─────────────────────────────────────────────────┐
│               INICIO                            │
│         (Invocación manual u orquestador)       │
└─────────────────────┬───────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────┐
│           PRE-VALIDACIÓN                         │
│  • ¿Existe pre-proyecto/wa-slim/?               │
│  • ¿Tiene archivos?                              │
│  • ¿Existe composer.json?                        │
│  • ¿Existe CONTRASENYA_FTP_WA en entorno?       │
└───────────┬─────────────────────────────────────┘
            │
            ▼ (si falla, ERROR)
┌─────────────────────────────────────────────────┐
│        VERIFICAR CLIENTE FTP                     │
│  ¿lftp está instalado?                           │
│  ├── Sí → Continuar                              │
│  └── No → Instalar (sudo apt-get install -y lftp)│
└───────────┬─────────────────────────────────────┘
            │
            ▼
┌─────────────────────────────────────────────────┐
│        PREPARAR PAQUETE                          │
│  • composer install --no-dev --optimize-autoloader│
│  • Verificar vendor/autoload.php existe          │
│  • Registrar tamaño total del paquete            │
└───────────┬─────────────────────────────────────┘
            │
            ▼
┌─────────────────────────────────────────────────┐
│        CONECTAR Y TRANSFERIR (lftp)              │
│  lftp -e "                                       │
│    open ftp.bee-viva.es;                         │
│    user ftp-wa@levantecofem.es $CONTRASENYA_FTP_WA;│
│    cd /home/beevivac/stg2.cofemlevante.es;       │
│    mirror --reverse --delete ./ wa-slim/;        │
│    bye                                           │
│  "                                              │
└───────────┬─────────────────────────────────────┘
            │
            ▼ (si falla, ERROR)
┌─────────────────────────────────────────────────┐
│        VERIFICAR POST-DESPLIEGUE                 │
│  • curl -I https://stg2.cofemlevante.es/         │
│    /wa-slim/public/ → ¿200 OK?                   │
│  • curl contenido → ¿"Hola mundo"?               │
│  • lftp -e "ls -la wa-slim/" para ver archivos   │
└───────────┬─────────────────────────────────────┘
            │
            ▼
┌─────────────────────────────────────────────────┐
│        INFORMAR RESULTADO                        │
│  • Resumen estructurado                          │
│  • Errores si los hay                            │
│  • Siguiente paso                                │
└─────────────────────────────────────────────────┘
```

### 7.2 Fases detalladas

#### Fase 1: Pre-validación

| Paso | Acción | Comando de referencia |
|------|--------|-----------------------|
| 1.1 | Verificar directorio fuente | `[ -d "pre-proyecto/wa-slim" ] && echo "EXISTE"` |
| 1.2 | Verificar archivos a desplegar | `ls -la pre-proyecto/wa-slim/public/` |
| 1.3 | Verificar composer.json | `[ -f "pre-proyecto/wa-slim/composer.json" ]` |
| 1.4 | Verificar variable de entorno FTP | `[ -n "$CONTRASENYA_FTP_WA" ] && echo "OK"` |

#### Fase 2: Preparación del paquete

| Paso | Acción | Comando de referencia |
|------|--------|-----------------------|
| 2.1 | Instalar dependencias | `cd pre-proyecto/wa-slim && composer install --no-dev --optimize-autoloader` |
| 2.2 | Verificar autoload | `[ -f "pre-proyecto/wa-slim/vendor/autoload.php" ]` |
| 2.3 | Medir tamaño | `du -sh pre-proyecto/wa-slim/` |

#### Fase 3: Transferencia FTP

| Paso | Acción | Comando de referencia |
|------|--------|-----------------------|
| 3.1 | Instalar lftp si falta | `which lftp || sudo apt-get install -y lftp` |
| 3.2 | Subir archivos | `cd pre-proyecto/wa-slim && lftp -e "open ftp.bee-viva.es; user ftp-wa@levantecofem.es $CONTRASENYA_FTP_WA; cd /home/beevivac/stg2.cofemlevante.es; mirror --reverse --delete ./ wa-slim/; bye"` |

#### Fase 4: Verificación post-despliegue

| Paso | Acción | Comando de referencia |
|------|--------|-----------------------|
| 4.1 | Verificar HTTP 200 | `curl -s -o /dev/null -w "%{http_code}" https://stg2.cofemlevante.es/wa-slim/public/` |
| 4.2 | Verificar contenido | `curl -s https://stg2.cofemlevante.es/wa-slim/public/` |
| 4.3 | Verificar archivos remotos | `lftp -e "open ftp.bee-viva.es; user ftp-wa@levantecofem.es $CONTRASENYA_FTP_WA; ls -la /home/beevivac/stg2.cofemlevante.es/wa-slim/; bye"` |

#### Fase 5: Reporte

El agente debe devolver un resumen estructurado como:

```
✅ Despliegue completado
━━━━━━━━━━━━━━━━━━━━━━━━━
📦 Origen:  pre-proyecto/wa-slim/ (3.2 MB)
🎯 Destino: /home/beevivac/stg2.cofemlevante.es/wa-slim/
📡 Cliente: lftp

📋 Archivos transferidos:
  - public/index.php
  - vendor/ (18 subdirectorios, 142 archivos)
  - composer.json
  - composer.lock

✅ Verificación:
  - HTTP 200: ✅ (1.2s)
  - Contenido "Hola mundo": ✅
  - Archivos remotos coinciden: ✅

➡️ Siguiente paso: Probar en navegador https://stg2.cofemlevante.es/wa-slim/public/
```

---

## 8. Validaciones previas al despliegue

| Validación | Condición | Error si falla |
|------------|-----------|----------------|
| Directorio fuente existe | `pre-proyecto/wa-slim/` es un directorio | ❌ El directorio fuente no existe. Ejecuta primero la instalación de Slim. |
| Hay archivos que desplegar | El directorio no está vacío | ❌ No hay archivos para desplegar. ¿Has creado el proyecto Slim? |
| autoload existe | `vendor/autoload.php` existe | ❌ No se encontró vendor/autoload.php. Ejecuta `composer install` primero. |
| Variable de entorno FTP | `$CONTRASENYA_FTP_WA` no está vacía | ❌ La variable CONTRASENYA_FTP_WA no está definida. Verifica GitHub Codespaces Secrets. |
| Conexión FTP alcanzable | `ftp.bee-viva.es:21` responde | ❌ No se puede conectar al servidor FTP. Verifica conectividad de red. |

---

## 9. Verificaciones posteriores al despliegue

| Verificación | Método | Criterio de éxito |
|-------------|--------|-------------------|
| Código HTTP | `curl -s -o /dev/null -w "%{http_code}" <URL>` | 200 OK |
| Contenido esperado | `curl -s <URL> \| grep "Hola mundo"` | El contenido incluye "Hola mundo" |
| Archivos remotos | `lftp -e "ls -la <path>; bye"` | Coinciden en cantidad con origen |
| Tiempo de respuesta | `curl -w "%{time_total}" <URL>` | < 2 segundos |
| Sin errores en respuesta | `curl -v <URL> 2>&1 \| grep -i "error"` | Sin errores |

---

## 10. Gestión segura de credenciales

### 10.1 Principios

| Principio | Aplicación |
|-----------|------------|
| No guardar en archivos | Las contraseñas nunca se escriben en archivos del proyecto |
| No exponer en logs | Los logs del agente ocultan las credenciales |
| No exponer en mensajes | Los mensajes al usuario nunca muestran contraseñas |
| Fuente única | `CONTRASENYA_FTP_WA` es la única fuente de la contraseña |

### 10.2 Flujo de obtención

```
Variable de entorno ($CONTRASENYA_FTP_WA)
  └── Inyectada por GitHub Codespaces desde
       └── GitHub Repository Secrets
            └── Configurada manualmente por el equipo
```

### 10.3 Uso en comandos

```bash
# Correcto: la variable se pasa al comando pero no se loguea
lftp -e "user ftp-wa@levantecofem.es $CONTRASENYA_FTP_WA"

# Incorrecto: la contraseña quedaría en el historial o logs
lftp -u ftp-wa@levantecofem.es,mi-contraseña-en-claro ftp.bee-viva.es
```

### 10.4 Precauciones adicionales

- El agente no debe hacer `echo $CONTRASENYA_FTP_WA`
- El agente no debe escribir la contraseña en ningún archivo
- El agente no debe pasar la contraseña como argumento de línea de comandos visible en `ps`

---

## 11. Gestión de errores y mensajes esperados

### 11.1 Categorías de error

| Categoría | Código | Mensaje para el usuario | Acción recomendada |
|-----------|--------|-------------------------|-------------------|
| **Pre-validación** | E001 | ❌ Directorio `pre-proyecto/wa-slim/` no encontrado. | Crea el proyecto Slim con `composer require slim/slim slim/psr7` |
| **Pre-validación** | E002 | ❌ No hay archivos para desplegar en `pre-proyecto/wa-slim/public/`. | Verifica que el front controller existe. |
| **Pre-validación** | E003 | ❌ No se encontró `vendor/autoload.php`. | Ejecuta `composer install --no-dev --optimize-autoloader` en `pre-proyecto/wa-slim/` |
| **Pre-validación** | E004 | ❌ Variable de entorno `CONTRASENYA_FTP_WA` no definida. | Verifica que el GitHub Secret está configurado en Settings > Codespaces > Secrets |
| **Preparación** | E005 | ❌ `composer install` falló. | Revisa el mensaje de error de Composer. Puede ser un problema de dependencias. |
| **Preparación** | E006 | ⚠️ `lftp` no está instalado. Instalando... | (Instalación automática) |
| **Preparación** | E007 | ❌ No se pudo instalar `lftp`. | Instala manualmente: `sudo apt-get install -y lftp` |
| **Conexión FTP** | E010 | ❌ No se puede conectar a `ftp.bee-viva.es:21`. | Verifica conectividad de red o si el servidor está bloqueando la IP del Codespace. |
| **Conexión FTP** | E011 | ❌ Autenticación FTP fallida. | Verifica que las credenciales en GitHub Secrets son correctas. |
| **Conexión FTP** | E012 | ❌ Directorio remoto `/home/beevivac/stg2.cofemlevante.es/` no existe. | Verifica con el equipo que el directorio WA sigue siendo correcto. |
| **Transferencia** | E020 | ❌ Error durante `mirror --reverse`. | Reintenta el despliegue. Si persiste, verifica permisos en el servidor. |
| **Verificación** | E030 | ❌ HTTP 404 después del despliegue. | Verifica la ruta pública. Puede necesitar `.htaccess`. |
| **Verificación** | E031 | ❌ Contenido inesperado en la respuesta. | Posible problema con el front controller o vendor corrupto. |
| **Verificación** | E032 | ❌ Tiempo de respuesta superior a 2 segundos. | El servidor puede estar lento o el paquete es demasiado grande. |

### 11.2 Formato de mensaje de error

```
❌ [E010] Error de conexión FTP
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Detalle:   No se puede conectar a ftp.bee-viva.es:21
Causa:     El servidor FTP no responde o el firewall bloquea la conexión
Acción:    1. Verifica que el servidor FTP está operativo
           2. Comprueba que tu IP no está bloqueada
           3. Prueba con: nc -zv ftp.bee-viva.es 21
```

### 11.3 Formato de mensaje de éxito

```
✅ Despliegue completado con éxito
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📦 Paquete:   pre-proyecto/wa-slim/ (3.2 MB)
🎯 Destino:   /home/beevivac/stg2.cofemlevante.es/wa-slim/
📋 Archivos:  142 archivos en 18 directorios
✅ HTTP 200:  https://stg2.cofemlevante.es/wa-slim/public/ (1.2s)
```

---

## 12. Archivos o configuración necesarios

### 12.1 Archivos a crear

| Archivo | Propósito | Estado |
|---------|-----------|--------|
| `.opencode/agents/ftp-deployer.md` | Definición del agente OpenCode | Pendiente de creación |
| `pre-proyecto/wa-slim/deploy.sh` | Script bash de despliegue (opcional) | Pendiente de creación |

### 12.2 Archivos existentes requeridos

| Archivo | Propósito |
|---------|-----------|
| `pre-proyecto/wa-slim/composer.json` | Definición de dependencias del proyecto |
| `pre-proyecto/wa-slim/composer.lock` | Bloqueo de versiones |
| `pre-proyecto/wa-slim/public/index.php` | Front controller de Slim |
| `pre-proyecto/wa-slim/vendor/autoload.php` | Autoload de Composer (generado) |

### 12.3 Variables de entorno requeridas

| Variable | Propósito | Origen |
|----------|-----------|--------|
| `CONTRASENYA_FTP_WA` | Contraseña FTP para WA | GitHub Codespaces Secret |

### 12.4 Configuración en `opencode.json`

El agente se registraría añadiendo esta sección al `opencode.json` raíz:

```json
{
  "agent": {
    "ftp-deployer": {
      "description": "Despliega archivos de la WA por FTP al servidor compartido con verificación posterior",
      "mode": "subagent",
      "temperature": 0.1,
      "permission": {
        "bash": "allow",
        "read": "allow",
        "glob": "allow",
        "grep": "allow",
        "edit": "deny",
        "webfetch": "deny",
        "task": "deny",
        "skill": "ask"
      }
    }
  }
}
```

---

## 13. Limitaciones conocidas

| Limitación | Descripción | Mitigación | Severidad |
|------------|-------------|------------|-----------|
| **FTP sin encriptación** | FTP básico no cifra credenciales ni datos en tránsito | Usar FTPS explícito (puerto 21 con TLS). Verificar que el servidor lo soporta. | Alta |
| **Sin rollback automático** | Si el despliegue falla a mitad, no hay mecanismo de reversión | El flag `--delete` de lftp sincroniza. Un fallo parcial puede dejarlo inconsistente. Mantener copia local de seguridad. | Media |
| **Sin diff previo** | No se comparan archivos locales vs remotos antes de subir | `lftp mirror` ya sincroniza solo archivos modificados. La primera vez sube todo. | Baja |
| **Dependencia de lftp** | lftp debe estar instalado en el Codespace | Instalación automática en el flujo | Baja |
| **Sin soporte SFTP** | El hosting compartido no proporciona SSH/SFTP | No hay alternativa. FTP/FTPS es el único método. | Alta |
| **Sin notificaciones externas** | El agente no envía notificaciones (Slack, email, etc.) | El resultado se muestra en la respuesta del agente. Para automatización futura. | Baja |
| **Modo headless limitado** | `opencode run` puede no interactuar correctamente con subagentes | Probar antes en producción. Alternativa: script bash directo. | Media |

---

## 14. Preguntas o decisiones pendientes

| # | Pregunta | Depende de | Impacto |
|---|----------|------------|---------|
| 1 | 🔄 **Confirmar dominio público definitivo de la WA** | Equipo del proyecto | La URL de verificación post-despliegue |
| 2 | 🔄 **Verificar que el servidor FTPS (TLS) funciona correctamente** | Prueba de conectividad | Determina si usamos FTP plano o FTPS explícito |
| 3 | 🔄 **Confirmar que `lftp` con FTPS explícito funciona contra `ftp.bee-viva.es`** | Prueba de conectividad | Podría requerir flags adicionales (`--ssl`, `--ssl-reqd`, etc.) |
| 4 | 🔄 **Decidir si el agente debe soportar despliegue parcial (solo carpeta `public/`)** | Necesidad futura | Impacta la complejidad del prompt |
| 5 | 🔄 **Decidir si se crea también `deploy.sh` como script independiente invocable por el agente** | Preferencia del equipo | El agente puede ejecutar comandos directamente sin script |

---

## Anexo A: Comandos de instalación y prueba del agente

### A.1 Crear el agente

```bash
# Desde la raíz del proyecto
mkdir -p .opencode/agents

# El agente se define en:
# .opencode/agents/ftp-deployer.md
```

### A.2 Verificar que el agente está disponible

Dentro del TUI de OpenCode, escribir `@` y verificar que `ftp-deployer` aparece en la lista de subagentes.

### A.3 Probar invocación

```bash
@ftp-deployer verifica que el entorno de despliegue está listo
```

### A.4 Probar despliegue real (solo después de tener Slim instalado)

```bash
@ftp-deployer despliega la WA completa
```

---

## Anexo B: Referencias

| Documento | Ruta |
|-----------|------|
| Documentación oficial de OpenCode (Agentes) | https://opencode.ai/docs/agents |
| Documentación oficial de OpenCode (Permisos) | https://opencode.ai/docs/permissions |
| Documentación oficial de OpenCode (Skills) | https://opencode.ai/docs/skills |
| Plan de Implantación Etapa 1 | `pre-proyecto/implantacion/Etapa01_Slim-Despliegue-FTP.md` |
| Decisiones de Implantación | `pre-proyecto/implantacion/00-decisiones-generales-implantacion.md` |
| Skill Context7 | `.skills/context7/SKILL.md` |
| lftp documentation | https://lftp.yar.ru/ |

---

*Documento generado el 28 de abril de 2026*  
*Pre-proyecto — Web-App de Automatización WooCommerce*
