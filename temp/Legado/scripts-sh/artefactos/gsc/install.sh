#!/bin/bash

SCRIPTS_SH_DIR="$(cd "$(dirname "$0")/../.." && pwd)"

main() {
  mkdir -p "$HOME/scripts"
  cp "$SCRIPTS_SH_DIR/artefactos/gsc/git-smart-commit.sh" "$HOME/scripts/git-smart-commit.sh"
  chmod +x "$HOME/scripts/git-smart-commit.sh"

  SHELL_RC="$HOME/.bashrc"
  [ -n "$ZSH_VERSION" ] && SHELL_RC="$HOME/.zshrc"

  if ! grep -q "^[[:space:]]*gsc()[[:space:]]*{" "$SHELL_RC" 2>/dev/null; then
    cat << 'EOF' >> "$SHELL_RC"

# Git Smart Commit
gsc() {
  ~/scripts/git-smart-commit.sh "$@"
}
EOF
  fi
}

main

echo
echo "Recarga tu shell con: source $SHELL_RC"
echo "Usa: gsc"
echo "O con push: gsc --P"
