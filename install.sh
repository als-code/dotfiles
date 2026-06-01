#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKIP_DEPS=false

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
      echo "Uso: $0 [--no-deps] [--deps-only]"
      echo "  Por defecto instala dependencias (OMB, OMZ, agnoster, Hack, …) y enlaza dotfiles."
      exit 0
      ;;
  esac
done

link() {
  local src="$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  ln -sfn "$src" "$dst"
  echo "  $dst -> $src"
}

# Sustituye un directorio existente (ln -sfn no lo reemplaza si dst/ ya es carpeta)
link_dir() {
  local src="$1" dst="$2"
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    echo "  quitando $dst (directorio antiguo)"
    rm -rf "$dst"
  fi
  link "$src" "$dst"
}

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
link "$DOTFILES/git/gitconfig" "$HOME/.gitconfig"

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
echo "Konsole: perfil por defecto «Ale». Git: als-code + email noreply de GitHub."
