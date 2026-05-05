is_installed() {
  [ -f "$HOME/.ssh/key.OpenSSH.txt" ]
}

name() {
  echo "ssh — Configuracion SSH"
}

description() {
  echo "Claves OpenSSH para conexiones seguras"
}
