#!/usr/bin/env bash
# Dependencias del entorno (OMB, OMZ, agnoster, plugins zsh, Hack, …)
# Llamado desde install.sh; también: ./bootstrap-deps.sh

set -euo pipefail

OSH_DIR="${OSH:-$HOME/.oh-my-bash}"
OMB_INSTALL_URL="https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh"

ZSH_DIR="${ZSH:-$HOME/.oh-my-zsh}"
OMZ_INSTALL_URL="https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"
ZSH_CUSTOM="${ZSH_CUSTOM:-$ZSH_DIR/custom}"
ZSH_SYNTAX_HIGHLIGHTING_REPO="https://github.com/zsh-users/zsh-syntax-highlighting.git"
ZSH_AUTOSUGGESTIONS_REPO="https://github.com/zsh-users/zsh-autosuggestions.git"

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

ensure_zsh() {
  if command -v zsh &>/dev/null; then
    echo "  zsh: $(command -v zsh) ($(zsh --version 2>/dev/null | head -1))"
    return 0
  fi
  echo "  zsh: instalando …"
  _apt_install zsh || true
  command -v zsh &>/dev/null
}

ensure_oh_my_zsh() {
  if [ -f "$ZSH_DIR/oh-my-zsh.sh" ]; then
    echo "  Oh My Zsh: ya en $ZSH_DIR"
    return 0
  fi
  echo "  Oh My Zsh: instalando en $ZSH_DIR …"
  if ! command -v curl &>/dev/null && ! command -v wget &>/dev/null; then
    echo "  Instala curl o wget y vuelve a ejecutar ./install.sh"
    return 1
  fi
  local installer
  installer="$(mktemp)"
  if command -v curl &>/dev/null; then
    curl -fsSL "$OMZ_INSTALL_URL" -o "$installer"
  else
    wget -qO "$installer" "$OMZ_INSTALL_URL"
  fi
  RUNZSH=no CHSH=no sh "$installer" --unattended
  rm -f "$installer"
}

_ensure_omz_plugin() {
  local name="$1" repo="$2" marker="$3"
  if [ -f "$marker" ]; then
    echo "  Plugin $name: OK"
    return 0
  fi
  echo "  Plugin $name: clonando en $ZSH_CUSTOM/plugins/$name …"
  mkdir -p "$ZSH_CUSTOM/plugins"
  git clone --depth=1 "$repo" "$ZSH_CUSTOM/plugins/$name"
}

ensure_zsh_syntax_highlighting() {
  _ensure_omz_plugin zsh-syntax-highlighting "$ZSH_SYNTAX_HIGHLIGHTING_REPO" \
    "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
}

ensure_zsh_autosuggestions() {
  _ensure_omz_plugin zsh-autosuggestions "$ZSH_AUTOSUGGESTIONS_REPO" \
    "$ZSH_CUSTOM/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh"
}

ensure_omz_agnoster_theme() {
  local theme="$ZSH_DIR/themes/agnoster.zsh-theme"
  if [ -f "$theme" ]; then
    echo "  Tema agnoster (zsh): OK"
    return 0
  fi
  echo "  Tema agnoster (zsh): no encontrado tras instalar Oh My Zsh"
  return 1
}

ensure_default_shell_zsh() {
  local zsh_path current user
  if ! command -v zsh &>/dev/null; then
    echo "  Shell por defecto: zsh no instalado (omitiendo chsh)"
    return 0
  fi
  zsh_path="$(command -v zsh)"
  user="$(id -un)"
  current="$(getent passwd "$user" 2>/dev/null | cut -d: -f7)"
  if [ "$current" = "$zsh_path" ]; then
    echo "  Shell por defecto: ya es zsh ($zsh_path)"
    return 0
  fi
  if [ -f /etc/shells ] && ! grep -qxF "$zsh_path" /etc/shells; then
    echo "  Shell por defecto: $zsh_path no está en /etc/shells"
    echo "  Ejecuta manualmente: chsh -s $zsh_path"
    return 0
  fi

  echo "  Shell por defecto: cambiando a $zsh_path …"

  # usermod con sudo no pide contraseña de usuario si sudo ya está autorizado
  if command -v usermod &>/dev/null && sudo -n true 2>/dev/null; then
    if sudo usermod -s "$zsh_path" "$user"; then
      echo "  Shell por defecto: zsh (abre una terminal nueva o reinicia sesión)"
      return 0
    fi
  fi

  # chsh pide la contraseña del usuario (PAM); no redirigir stderr o parece colgado
  if [ ! -t 0 ]; then
    echo "  Shell por defecto: omitido (sin TTY interactivo)"
    echo "  Ejecuta manualmente: chsh -s $zsh_path"
    return 0
  fi

  echo "  Introduce tu contraseña de usuario si se solicita:"
  if chsh -s "$zsh_path"; then
    current="$(getent passwd "$user" 2>/dev/null | cut -d: -f7)"
    if [ "$current" = "$zsh_path" ]; then
      echo "  Shell por defecto: zsh (abre una terminal nueva o reinicia sesión)"
    else
      echo "  Shell por defecto: chsh terminó pero el shell sigue siendo $current"
    fi
  else
    echo "  Shell por defecto: chsh cancelado o fallido"
    echo "  Ejecuta manualmente: chsh -s $zsh_path"
  fi
}

bootstrap_deps() {
  echo "Dependencias:"
  ensure_oh_my_bash
  ensure_agnoster_theme
  ensure_zsh
  ensure_oh_my_zsh
  ensure_omz_agnoster_theme
  ensure_zsh_syntax_highlighting
  ensure_zsh_autosuggestions
  ensure_hack_font
  ensure_powerline_symbols
  echo
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  bootstrap_deps
fi
