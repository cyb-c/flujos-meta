#!/bin/bash

SCRIPTS_SH_DIR="$(cd "$(dirname "$0")" && pwd)"

source "$SCRIPTS_SH_DIR/shared/utils.sh"

header "Instalador de scripts-sh"

while true; do
  ARTEFACTOS=()
  for d in "$SCRIPTS_SH_DIR/artefactos"/*/; do
    [ -d "$d" ] || continue
    name="$(basename "$d")"
    ARTEFACTOS+=("$name")
  done

  menu_title "Selecciona un artefacto:"
  for i in "${!ARTEFACTOS[@]}"; do
    artefacto="${ARTEFACTOS[$i]}"
    source "$SCRIPTS_SH_DIR/artefactos/$artefacto/check.sh"
    menu_option "$((i+1))" "$(name) — $(description)"
  done
  echo
  menu_option "d" "Borrar carpeta scripts-sh/ (finalizar)"
  menu_option "s" "Salir"
  echo
  read -p "Opcion: " OPT

  if [[ "$OPT" == "s" ]]; then
    info "Hasta luego"
    exit 0
  fi

  if [[ "$OPT" == "d" ]]; then
    if confirm "Eliminar la carpeta $SCRIPTS_SH_DIR permanentemente?"; then
      rm -rf "$SCRIPTS_SH_DIR"
      success "Carpeta scripts-sh eliminada"
      log "scripts-sh eliminada"
    fi
    exit 0
  fi

  IDX=$((OPT - 1))
  if [ "$IDX" -lt 0 ] || [ "$IDX" -ge "${#ARTEFACTOS[@]}" ]; then
    warn "Opcion invalida"
    continue
  fi

  ARTEFACTO="${ARTEFACTOS[$IDX]}"
  ART_DIR="$SCRIPTS_SH_DIR/artefactos/$ARTEFACTO"

  source "$ART_DIR/check.sh"

  header "$(name)"

  if is_installed; then
    info "El artefacto '$(name)' ya esta instalado"

    preview_output=$(bash "$ART_DIR/uninstall.sh" --preview 2>/dev/null)
    if [ -n "$preview_output" ]; then
      echo
      echo -e "${YELLOW}Preview de desinstalacion:${RESET}"
      echo "$preview_output"
    fi

    if confirm "Deseas desinstalarlo?"; then
      bash "$ART_DIR/uninstall.sh" --exec
      success "Artefacto '$(name)' desinstalado"
      log "Desinstalado: $(name)"
    elif confirm "Deseas reinstalarlo?"; then
      bash "$ART_DIR/uninstall.sh" --exec
      bash "$ART_DIR/install.sh"
      success "Artefacto '$(name)' reinstalado"
      log "Reinstalado: $(name)"
    fi
  else
    info "El artefacto '$(name)' no esta instalado"
    if confirm "Deseas instalarlo?"; then
      bash "$ART_DIR/install.sh"
      success "Artefacto '$(name)' instalado"
      log "Instalado: $(name)"
    fi
  fi

  echo
  read -p "Presiona Enter para volver al menu..."
done
