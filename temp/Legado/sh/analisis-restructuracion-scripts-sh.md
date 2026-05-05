# Análisis: Restructuración de `scripts-sh/`

## Índice

1. [Estado Actual](#1-estado-actual)
2. [Lo Que Se Pide (punto x punto)](#2-lo-que-se-pide-punto-x-punto)
3. [Arquitectura Propuesta](#3-arquitectura-propuesta)
4. [Artefactos Identificados](#4-artefactos-identificados)
5. [Flujo del Nuevo `install.sh`](#5-flujo-del-nuevo-installsh)
6. [Otras Mejoras que Incluiría](#6-otras-mejoras-que-incluiría)
7. [Preguntas / Necesito Aclarar](#7-preguntas--necesito-aclarar)

---

## 1. Estado Actual

```
scripts-sh/
├── .ssh/
│   ├── key.OpenSSH.txt
│   └── OpenSSH_sin_passphrase.txt
├── git-smart-commit.sh        # Script que se instala como comando "gsc"
└── install-gsc.sh             # Instalador que copia git-smart-commit.sh + .ssh
```

- **Solo hay un instalador** (`install-gsc.sh`) que instala TODO (gsc + ssh) de golpe.
- **No hay opción de elegir** qué instalar: lo hace todo o nada.
- **No hay desinstalador**.
- **No está diseñado para escalar** (todo está en un solo archivo monolítico).

---

## 2. Lo Que Se Pide (punto x punto)

| # | Requisito | Interpretación |
|---|-----------|----------------|
| 1 | Leer archivo de instalación | ✅ Hecho — `install-gsc.sh` leído y analizado |
| 2 | Preguntar qué instalar de 2 opciones existentes | El instalador debe mostrar un menú con los artefactos disponibles (gsc y ssh) y dejar elegir |
| 3 | Cada vez que se ejecute preguntará qué instalar | No hay "modo silencioso" ni instalación automática; todo pasa por el menú interactivo |
| 4 | Si hay algo instalado, preguntar si se desinstala | Antes de reinstalar, detectar presencia y ofrecer desinstalación |
| 5 | Debe quedar abierto agregar más artefactos en el futuro | Arquitectura modular: cada artefacto en su propia carpeta con install/uninstall |
| 6 | El código de instalación será un archivo | Cada artefacto tendrá su propio archivo de instalación separado |
| 7 | Acciones de instalar/desinstalar en archivo aparte | Cada artefacto tendrá `install.sh` y `uninstall.sh` |
| 8 | ¿Qué otras mejoras incluirías? | Ver sección 6 |

---

## 3. Arquitectura Propuesta

```
scripts-sh/
├── install.sh                       # ✅ Orquestador principal (menú interactivo)
├── artefactos/                       # ✅ Carpeta de artefactos (fácil de extender)
│   ├── gsc/
│   │   ├── install.sh                # ✅ Instalación de gsc
│   │   └── uninstall.sh              # ✅ Desinstalación de gsc
│   └── ssh/
│       ├── install.sh                # ✅ Instalación de SSH
│       └── uninstall.sh              # ✅ Desinstalación de SSH
├── git-smart-commit.sh              # Artefacto gsc (el script en sí)
├── .ssh/                             # Artefacto ssh (ficheros de clave)
├── shared/                           # Utilidades compartidas (helpers)
│   └── utils.sh
└── README.md
```

---

## 4. Artefactos Identificados

### 4.1. `gsc` — git-smart-commit

| Acción | Descripción |
|--------|-------------|
| **Install** | Copia `git-smart-commit.sh` a `~/scripts/`, da permisos, añade función `gsc` al RC |
| **Uninstall** | Elimina `~/scripts/git-smart-commit.sh`, elimina función `gsc` del RC, limpia alias |

Detectable por: existencia de `~/scripts/git-smart-commit.sh`

### 4.2. `ssh` — Configuración SSH

| Acción | Descripción |
|--------|-------------|
| **Install** | Copia contenido de `.ssh/` a `~/.ssh/`, ajusta permisos |
| **Uninstall** | Elimina los ficheros instalados de `~/.ssh/` (los que vinieron del artefacto) |

Detectable por: existencia de `~/.ssh/key.OpenSSH.txt`

---

## 5. Flujo del Nuevo `install.sh`

```
1. Cargar shared/utils.sh
2. Escanear artefactos/ disponibles → mostrar menú numerado
3. Añadir opción "🗑️ Borrar carpeta scripts-sh/ (finalizar)"
4. Usuario elige un artefacto (o salir/borrar)
5. Llamar a is_installed() del artefacto para ver si ya está instalado
   ├── No instalado → preguntar "¿Instalar?" → ejecutar install.sh
   └── Instalado   → preguntar "¿Desinstalar?" (con preview de lo que se borrará)
                      ├── Sí → ejecutar uninstall.sh
                      └── No → preguntar "¿Reinstalar?" → ejecutar install.sh
6. Tras cada operación → escribir en ~/scripts/scripts-sh.log con timestamp
7. Loop: volver al menú principal
8. Opción "Borrar scripts-sh/" → rm -rf scripts-sh/  (el directorio temporal)
```

---

## 6. Otras Mejoras que Incluiría

1. ✅ **Helper de detección cross-artefacto** — función `is_installed()` que cada artefacto implementa, comprobando contra directorios finales del sistema (no contra registro, que es solo consultivo)
2. ✅ **Registro de instalación** — archivo `~/scripts/scripts-sh.log` con timestamp de cada acción (instalar/desinstalar). Solo consultivo; `is_installed()` no depende de él.
3. 🚫 ~~Modo no interactivo~~ — No aplica
4. ✅ **Confirmación de desinstalación** — mostrar qué se va a borrar antes de hacerlo
5. 🚫 ~~Backup pre-desinstalación~~ — No aplica
6. 🚫 ~~Dry-run~~ — No aplica
7. 🚫 ~~Validación de dependencias~~ — No aplica
8. ✅ **Colores y formato** — feedback visual claro (✅❌⚠️)
9. ✅ **Log de operaciones** — `~/scripts/scripts-sh.log` con timestamp de cada acción (unificado con el registro)
10. 🚫 ~~Compatibilidad multi-sistema~~ — Solo IDEs Linux

### Extra añadido por decisión del usuario

11. ✅ **Opción "Borrar scripts-sh/"** en el menú principal — elimina el directorio temporal `scripts-sh/` cuando el usuario termina

---

## 7. Decisiones Confirmadas por el Usuario

| Pregunta | Decisión |
|----------|----------|
| ¿2 artefactos: gsc y ssh? | ✅ Sí |
| ¿Nombre de la carpeta? | `artefactos/` (español) |
| ¿Registro de instalación? | No oculto: `~/scripts/scripts-sh.log` (solo consultivo) |
| ¿.ssh actuales? | Tal cual, sin refactorizar |
| ¿Helper is_installed()? | ✅ Sí, contra directorios finales |
| ¿Confirmación desinstalación con preview? | ✅ Sí |
| ¿Colores y formato? | ✅ Sí |
| ¿Log de operaciones? | ✅ Sí, en `~/scripts/scripts-sh.log` |
| ¿Borrar scripts-sh/ desde el menú? | ✅ Sí |
| Modo no interactivo, backup, dry-run, dependencias, multi-sistema | 🚫 No |

---

> **Decisión:** Esperar instrucciones para empezar a implementar.
