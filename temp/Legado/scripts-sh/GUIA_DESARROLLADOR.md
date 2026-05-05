# Guia para Desarrollador — scripts-sh

## Arquitectura

```
scripts-sh/
├── install.sh                       ← Orquestador (menu interactivo)
├── shared/utils.sh                  ← Funciones compartidas (colores, log, confirm)
├── artefactos/                       ← Cada subcarpeta es un artefacto
│   ├── gsc/
│   │   ├── check.sh                 ← is_installed(), name(), description()
│   │   ├── install.sh               ← Instala el artefacto
│   │   ├── uninstall.sh             ← Desinstala el artefacto
│   │   └── ...                      ← Ficheros propios del artefacto
│   └── ssh/
│       ├── check.sh                 ← is_installed(), name(), description()
│       ├── install.sh               ← Instala el artefacto
│       ├── uninstall.sh             ← Desinstala el artefacto
│       └── ...                      ← Ficheros propios del artefacto
├── GUIA_USO.md                       ← Guia de uso para el usuario
└── GUIA_DESARROLLADOR.md            ← Esta guia
```

## Como funciona el orquestador (`install.sh`)

1. Escanea `artefactos/*/` automaticamente.
2. Para cada subcarpeta, carga `check.sh` para obtener `name()`, `description()` e `is_installed()`.
3. Muestra un menu numerado.
4. Segun lo que elija el usuario, llama a `install.sh` o `uninstall.sh` del artefacto correspondiente.
5. `uninstall.sh` acepta `--preview` (solo muestra) y `--exec` (ejecuta sin preguntar).
6. Invoca los scripts con `bash`, no con `./`. Esto evita depender de permisos de ejecucion.

## Como anadir un nuevo artefacto

Crea una carpeta en `artefactos/` con estos 3 archivos:

### 1. `check.sh`

Debe definir 3 funciones:

```bash
is_installed() {
  # Devuelve 0 si esta instalado, distinto de 0 si no
  [ -f "$HOME/scripts/mi-herramienta.sh" ]
}

name() {
  echo "mi-herramienta — Descripcion corta"
}

description() {
  echo "Texto explicativo de una linea"
}
```

### 2. `install.sh`

Script que instala el artefacto. Debe ser autocontenido:

```bash
#!/bin/bash
SCRIPTS_SH_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
# ... logica de instalacion ...
```

### 3. `uninstall.sh`

Script que desinstala el artefacto. Debe soportar `--preview` y `--exec`:

```bash
#!/bin/bash

preview() {
  echo "Archivos que se eliminaran:"
  [ -f "$HOME/scripts/mi-herramienta.sh" ] && echo "  - $HOME/scripts/mi-herramienta.sh"
}

exec_uninstall() {
  rm -f "$HOME/scripts/mi-herramienta.sh"
}

case "${1:-}" in
  --preview) preview ;;
  --exec) exec_uninstall ;;
  *)
    preview
    echo
    read -p "Proceder con la desinstalacion? (y/n): " R
    [[ "$R" == "y" || "$R" == "Y" ]] && exec_uninstall
    ;;
esac
```

### Opcional: ficheros propios del artefacto

Si el artefacto incluye scripts, claves, configuraciones, etc., se colocan dentro de su misma carpeta:

```
artefactos/mi-herramienta/
├── check.sh
├── install.sh
├── uninstall.sh
├── script-auxiliar.sh
└── config/
    └── plantilla.conf
```

## Como eliminar un artefacto

1. Elimina su carpeta: `rm -rf scripts-sh/artefactos/mi-herramienta/`
2. El orquestador ya no lo mostrara en el menu.

No necesita modificar ningun otro archivo.

## Convenciones

- `install.sh` y `uninstall.sh` deben tener shebang (`#!/bin/bash`) y ser autocontenidos.
- El orquestador los invoca con `bash`, no con `./`. No necesitan permiso de ejecucion.
- `check.sh` no necesita shebang, solo es legible (se carga con `source`).
- La variable `SCRIPTS_SH_DIR` apunta a la raiz de `scripts-sh/`. Usala para referenciar otros archivos.
- El log se escribe en `~/scripts/scripts-sh.log` usando la funcion `log()` de `shared/utils.sh`.
- El orquestador no modifica el log directamente; cada script puede usar `log()` si se necesita.
- Los nombres de carpeta de artefactos deben ser una sola palabra (sin espacios).

## Dependencias del sistema

`install.sh` asume:
- Bash
- `cp`, `mkdir`, `chmod`, `rm`, `sed`, `find` (comandos POSIX basicos)
- No requiere dependencias externas ni permisos especiales del sistema de archivos.
