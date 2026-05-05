# Guia de Uso — scripts-sh

## Que es

`scripts-sh/` es un instalador interactivo de artefactos utiles para el entorno de desarrollo local. Cada artefacto es un conjunto de scripts o configuraciones que se copian a directorios del usuario (`~/scripts/`, `~/.ssh/`, etc.).

## Como se usa

Desde la raiz del repositorio:

```bash
bash scripts-sh/install.sh
```

No requiere argumentos. Todo es interactivo.

## Menu principal

Al ejecutarlo aparece un menu con:

1. **Artefactos disponibles** — numerados (1, 2, 3...). Seleccionas uno para instalarlo o desinstalarlo.
2. **`d` — Borrar carpeta scripts-sh/** — elimina todo el directorio `scripts-sh/`. Es solo temporal.
3. **`s` — Salir** — cierra el instalador sin hacer nada.

## Flujo tipico

```
1. Ejecutas bash scripts-sh/install.sh
2. Ves la lista de artefactos
3. Seleccionas uno
4. Si NO esta instalado → te pregunta si quieres instalarlo
5. Si YA esta instalado → te pregunta si quieres desinstalarlo (con preview) o reinstalarlo
6. Confirmas con y/n
7. Vuelves al menu para seguir o eliges salir
```

## Artefactos

Cada repositorio puede incluir sus propios artefactos. Los que trae este son:

| Artefacto | Que instala | Donde |
|-----------|-------------|-------|
| **gsc** | Comando `gsc` para commits enriquecidos | `~/scripts/git-smart-commit.sh` + funcion en `.bashrc`/`.zshrc` |
| **ssh** | Claves OpenSSH | `~/.ssh/key.OpenSSH.txt` y `~/.ssh/OpenSSH_sin_passphrase.txt` |

## Log de operaciones

Cada instalacion o desinstalacion se registra en:

```
~/scripts/scripts-sh.log
```

Es solo consultivo. La deteccion de si algo esta instalado se hace comprobando los archivos destino reales, no el log.

## Notas

- El directorio `scripts-sh/` es temporal. Una vez instalado lo que necesites, el menu permite borrarlo con la opcion `d`.
- Si mas adelante necesitas hacer cambios, recreas el directorio, ejecutas `install.sh` de nuevo, haces lo que necesites y lo vuelves a borrar.
- El orquestador invoca los scripts con `bash`, por lo que **no requieren permisos de ejecucion** (`chmod +x`). Esto asegura que funcionen incluso en repositorios recien clonados donde los permisos no se conservan.
- **Despues de instalar `gsc`:** recarga tu shell con `source ~/.bashrc` (o abre una nueva terminal) para usar el comando `gsc`.
