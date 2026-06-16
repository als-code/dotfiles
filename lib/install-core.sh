# Lógica compartida de instalación (install.sh, als-install.sh)
# shellcheck shell=bash

set -euo pipefail

_LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES="${DOTFILES:-$(cd "$_LIB_DIR/.." && pwd)}"

SKIP_DEPS=false

show_install_help() {
  local script="$1"
  local generic="${2:-false}"
  echo "Uso: $script [opciones]"
  echo "  Por defecto instala dependencias (OMB, OMZ, agnoster, Hack, nala, …) y enlaza dotfiles."
  echo
  echo "Opciones:"
  echo "  --no-deps     Solo symlinks, sin bootstrap-deps"
  echo "  --deps-only   Solo dependencias, sin symlinks"
  if [ "$generic" = true ]; then
    echo "  --git-name N  Nombre para git user.name (sin TTY interactivo)"
    echo "  --git-email E Email para git user.email (sin TTY interactivo)"
    echo
    echo "Variables de entorno: GIT_USER_NAME, GIT_USER_EMAIL"
  fi
  echo "  -h, --help    Esta ayuda"
}

parse_install_args() {
  local script="${1:-install.sh}"
  local generic="${2:-false}"
  shift 2 || true

  for arg in "$@"; do
    case "$arg" in
      --no-deps) SKIP_DEPS=true ;;
      --deps-only)
        # shellcheck source=bootstrap-deps.sh
        source "$DOTFILES/bootstrap-deps.sh"
        bootstrap_deps
        exit 0
        ;;
      -h|--help)
        show_install_help "$script" "$generic"
        exit 0
        ;;
      --git-name|--git-email)
        echo "Opción $arg: úsala antes de otras flags o ejecuta $script --help"
        exit 1
        ;;
      *)
        echo "Opción desconocida: $arg ($script --help)"
        exit 1
        ;;
    esac
  done
}

link() {
  local src="$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  ln -sfn "$src" "$dst"
  echo "  $dst -> $src"
}

link_dir() {
  local src="$1" dst="$2"
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    echo "  quitando $dst (directorio antiguo)"
    rm -rf "$dst"
  fi
  link "$src" "$dst"
}

_trim() {
  local s="$1"
  s="${s#"${s%%[![:space:]]*}"}"
  s="${s%"${s##*[![:space:]]}"}"
  printf '%s' "$s"
}

prompt_git_identity() {
  GIT_NAME="$(_trim "${GIT_NAME:-${GIT_USER_NAME:-}}")"
  GIT_EMAIL="$(_trim "${GIT_EMAIL:-${GIT_USER_EMAIL:-}}")"

  if [ -n "$GIT_NAME" ] && [ -n "$GIT_EMAIL" ]; then
    return 0
  fi

  if [ ! -t 0 ]; then
    echo "Sin TTY interactivo: indica --git-name y --git-email (o GIT_USER_NAME / GIT_USER_EMAIL)."
    exit 1
  fi

  echo "Git (identidad de commits; no guarda tokens ni credenciales):"
  while [ -z "${GIT_NAME:-}" ]; do
    read -rp "  user.name: " GIT_NAME
    GIT_NAME="$(_trim "$GIT_NAME")"
    [ -n "$GIT_NAME" ] || echo "  El nombre no puede estar vacío."
  done

  while [ -z "${GIT_EMAIL:-}" ] || [[ "$GIT_EMAIL" != *@* ]]; do
    read -rp "  user.email: " GIT_EMAIL
    GIT_EMAIL="$(_trim "$GIT_EMAIL")"
    [ -n "$GIT_EMAIL" ] && [[ "$GIT_EMAIL" == *@* ]] || echo "  Introduce un email válido."
  done
}

install_git_config_repo() {
  link "$DOTFILES/git/gitconfig" "$HOME/.gitconfig"
}

install_git_config_generated() {
  local name="$1" email="$2"
  local dest="$HOME/.gitconfig"

  if [ -e "$dest" ] || [ -L "$dest" ]; then
    echo "  quitando $dest"
    rm -f "$dest"
  fi

  {
    echo "# ~/.gitconfig — generado por ./install.sh"
    echo
    echo "[user]"
    printf '\tname = %s\n' "$name"
    printf '\temail = %s\n' "$email"
    echo
    cat "$DOTFILES/git/gitconfig.base"
  } >"$dest"

  echo "  $dest (generado: $name <$email>)"
}

run_install() {
  local git_mode="$1"
  local git_name="${2:-}"
  local git_email="${3:-}"
  local footer="${4:-}"

  echo "Instalando dotfiles desde $DOTFILES"
  echo

  if ! $SKIP_DEPS; then
    # shellcheck source=bootstrap-deps.sh
    source "$DOTFILES/bootstrap-deps.sh"
    bootstrap_deps
  fi

  echo "Bash:"
  link "$DOTFILES/bash/bashrc" "$HOME/.bashrc"
  link "$DOTFILES/bash/bash_aliases" "$HOME/.bash_aliases"

  echo
  echo "Zsh:"
  link "$DOTFILES/zsh/zshrc" "$HOME/.zshrc"
  # shellcheck source=bootstrap-deps.sh
  source "$DOTFILES/bootstrap-deps.sh"
  ensure_default_shell_zsh

  echo
  echo "Git:"
  case "$git_mode" in
    repo) install_git_config_repo ;;
    generated) install_git_config_generated "$git_name" "$git_email" ;;
    *)
      echo "  modo git desconocido: $git_mode"
      exit 1
      ;;
  esac

  echo
  echo "Fastfetch:"
  link_dir "$DOTFILES/fastfetch" "$HOME/.config/fastfetch"

  echo
  echo "Konsole:"
  mkdir -p "$HOME/.local/share/konsole"
  for f in "$DOTFILES"/konsole/*; do
    [ -e "$f" ] || continue
    [ "$(basename "$f")" = "konsolerc" ] && continue
    link "$f" "$HOME/.local/share/konsole/$(basename "$f")"
  done
  link "$DOTFILES/konsole/konsolerc" "$HOME/.config/konsolerc"

  echo
  echo "Listo. Abre una terminal nueva (shell por defecto: zsh) o ejecuta: exec zsh"
  echo "Konsole: perfil por defecto «Ale»."
  if [ -n "$footer" ]; then
    echo "$footer"
  fi
}
