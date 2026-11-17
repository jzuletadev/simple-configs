#!/usr/bin/env bash
# Node.js through fnm (same version manager as on Windows).
. "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

export PATH="${XDG_DATA_HOME:-$HOME/.local/share}/fnm:$HOME/.fnm:$PATH"

if has fnm; then
  ok "fnm already installed"
else
  info "Installing fnm"
  pkg_install curl unzip
  # --skip-shell: the repo's shell snippet loads fnm instead of editing rc files.
  curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell
fi

add_shell_snippet
eval "$(fnm env --shell bash)"

ask NODE_VERSION "Node version to install ('lts' or a major like 22)" "lts"
if [ "$NODE_VERSION" = lts ]; then
  fnm install --lts
  fnm default lts-latest
else
  fnm install "$NODE_VERSION"
  fnm default "$NODE_VERSION"
fi
eval "$(fnm env --shell bash)"
ok "node $(node -v), npm $(npm -v)"

ask GLOBALS "Global npm packages to install (space separated, Enter to skip)"
if [ -n "$GLOBALS" ]; then
  # shellcheck disable=SC2086
  npm install -g $GLOBALS
fi

ok "Node setup done. Open a new terminal to load fnm."
