#!/bin/bash

preview() {
  echo "Archivos que se eliminaran:"
  for f in key.OpenSSH.txt OpenSSH_sin_passphrase.txt; do
    [ -f "$HOME/.ssh/$f" ] && echo "  - $HOME/.ssh/$f"
  done
}

exec_uninstall() {
  rm -f "$HOME/.ssh/key.OpenSSH.txt" "$HOME/.ssh/OpenSSH_sin_passphrase.txt"
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
