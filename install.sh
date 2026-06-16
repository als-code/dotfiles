#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/install-core.sh
source "$DOTFILES/lib/install-core.sh"

GIT_NAME="${GIT_USER_NAME:-}"
GIT_EMAIL="${GIT_USER_EMAIL:-}"
INSTALL_ARGS=()

while [ $# -gt 0 ]; do
  case "$1" in
    --git-name)
      [ $# -ge 2 ] || { echo "Falta valor para --git-name"; exit 1; }
      GIT_NAME="$2"
      shift 2
      ;;
    --git-email)
      [ $# -ge 2 ] || { echo "Falta valor para --git-email"; exit 1; }
      GIT_EMAIL="$2"
      shift 2
      ;;
    *)
      INSTALL_ARGS+=("$1")
      shift
      ;;
  esac
done

parse_install_args "$0" true "${INSTALL_ARGS[@]}"

prompt_git_identity
run_install generated "$GIT_NAME" "$GIT_EMAIL" "Git: $GIT_NAME <$GIT_EMAIL>"
