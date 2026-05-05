#!/bin/bash

RESET='\033[0m'
BOLD='\033[1m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'

LOG_FILE="$HOME/scripts/scripts-sh.log"

info()    { echo -e "${BLUE}i${RESET} $1"; }
success() { echo -e "${GREEN}v${RESET} $1"; }
warn()    { echo -e "${YELLOW}!${RESET} $1"; }
error()   { echo -e "${RED}x${RESET} $1"; }
header()  { echo -e "\n${BOLD}${CYAN}--- $1 ---${RESET}\n"; }

log() {
  mkdir -p "$(dirname "$LOG_FILE")"
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

confirm() {
  read -p "$1 (y/n): " R
  [[ "$R" == "y" || "$R" == "Y" ]]
}

menu_title() {
  echo -e "\n${BOLD}${CYAN}$1${RESET}"
}

menu_option() {
  echo -e "  ${BOLD}$1)${RESET} $2"
}
