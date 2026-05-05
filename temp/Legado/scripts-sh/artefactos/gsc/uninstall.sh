#!/bin/bash

preview() {
  echo "Archivos que se eliminaran:"
  [ -f "$HOME/scripts/git-smart-commit.sh" ] && echo "  - $HOME/scripts/git-smart-commit.sh"
  echo "  - Funcion 'gsc' en archivo RC del shell"
}

exec_uninstall() {
  rm -f "$HOME/scripts/git-smart-commit.sh"

  SHELL_RC="$HOME/.bashrc"
  [ -n "$ZSH_VERSION" ] && SHELL_RC="$HOME/.zshrc"

  sed -i '/^# Git Smart Commit$/,/^}$/d' "$SHELL_RC"
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
