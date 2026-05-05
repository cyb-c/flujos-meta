#!/bin/bash

SCRIPTS_SH_DIR="$(cd "$(dirname "$0")/../.." && pwd)"

main() {
  if [ -d "$SCRIPTS_SH_DIR/artefactos/ssh/.ssh" ]; then
    mkdir -p "$HOME/.ssh"
    cp -R "$SCRIPTS_SH_DIR/artefactos/ssh/.ssh/." "$HOME/.ssh/"
    chmod 700 "$HOME/.ssh"
    find "$HOME/.ssh" -type f -name "*.pub" -exec chmod 644 {} \;
    find "$HOME/.ssh" -type f ! -name "*.pub" -exec chmod 600 {} \;
  fi
}

main
