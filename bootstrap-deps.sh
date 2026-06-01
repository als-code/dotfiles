#!/usr/bin/env bash
# Dependencias del entorno (Oh My Bash, agnoster, Hack, …)
# Llamado desde install.sh; también: ./bootstrap-deps.sh

set -euo pipefail

OSH_DIR="${OSH:-$HOME/.oh-my-bash}"
OMB_INSTALL_URL="https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh"

_run_sudo() {
  if [ "$(id -u)" -eq 0 ]; then
    "$@"
  elif command -v sudo &>/dev/null; then
    sudo "$@"
  else
    echo "  (necesitas sudo para: $*)"
    return 1
  fi
}

_apt_install() {
  local pkg="$1"
  if ! command -v apt-get &>/dev/null; then
    echo "  $pkg: instálalo manualmente (solo apt detectado en bootstrap)"
    return 1
  fi
  _run_sudo apt-get update -qq
  _run_sudo apt-get install -y "$pkg"
}

ensure_oh_my_bash() {
  if [ -f "$OSH_DIR/oh-my-bash.sh" ]; then
    echo "  Oh My Bash: ya en $OSH_DIR"
    return 0
  fi
  echo "  Oh My Bash: instalando en $OSH_DIR …"
  if ! command -v curl &>/dev/null && ! command -v wget &>/dev/null; then
    echo "  Instala curl o wget y vuelve a ejecutar ./install.sh"
    return 1
  fi
  local installer
  installer="$(mktemp)"
  if command -v curl &>/dev/null; then
    curl -fsSL "$OMB_INSTALL_URL" -o "$installer"
  else
    wget -qO "$installer" "$OMB_INSTALL_URL"
  fi
  bash "$installer" --unattended
  rm -f "$installer"
}

ensure_agnoster_theme() {
  local theme="$OSH_DIR/themes/agnoster/agnoster.theme.sh"
  if [ -f "$theme" ]; then
    echo "  Tema agnoster: OK ($theme)"
    return 0
  fi
  echo "  Tema agnoster: no encontrado tras instalar Oh My Bash"
  echo "  Comprueba OSH_THEME=agnoster en bash/bashrc"
  return 1
}

ensure_hack_font() {
  if fc-list 2>/dev/null | grep -qiE '[:/]Hack[^a-zA-Z]'; then
    echo "  Fuente Hack: ya disponible"
    return 0
  fi
  echo "  Fuente Hack: instalando (fonts-hack) …"
  _apt_install fonts-hack || true
  if fc-list 2>/dev/null | grep -qiE '[:/]Hack[^a-zA-Z]'; then
    echo "  Fuente Hack: instalada"
  else
    echo "  Fuente Hack: https://sourcefoundry.org/hack/"
  fi
}

ensure_powerline_symbols() {
  # Iconos del prompt agnoster (separado de Hack en Konsole)
  if fc-list 2>/dev/null | grep -qi powerline; then
    echo "  Símbolos Powerline: ya disponibles"
    return 0
  fi
  echo "  Símbolos Powerline: instalando (fonts-powerline) …"
  _apt_install fonts-powerline || true
}

bootstrap_deps() {
  echo "Dependencias:"
  ensure_oh_my_bash
  ensure_agnoster_theme
  ensure_hack_font
  ensure_powerline_symbols
  echo
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  bootstrap_deps
fi
