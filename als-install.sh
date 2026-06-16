#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/install-core.sh
source "$DOTFILES/lib/install-core.sh"

parse_install_args "$0" false "$@"

run_install repo "" "" "Git: als-code + email noreply de GitHub (git/gitconfig del repo)."
