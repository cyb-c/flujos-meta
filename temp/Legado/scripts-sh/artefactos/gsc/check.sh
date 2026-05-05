is_installed() {
  [ -f "$HOME/scripts/git-smart-commit.sh" ]
}

name() {
  echo "gsc — git-smart-commit"
}

description() {
  echo "Comando 'gsc' para commits enriquecidos automaticos"
}
