#!/usr/bin/env bash
# Python 3 with pip and venv, plus optional uv.
. "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

info "Installing Python"
case $DISTRO in
  ubuntu) pkg_install python3 python3-pip python3-venv python-is-python3 ;;
  arch) pkg_install python python-pip ;;
esac
ok "$(python3 --version)"

if has uv; then
  ok "uv already installed"
elif confirm "Install uv (fast package/venv manager, also installs other Python versions)?"; then
  pkg_install curl
  # UV_NO_MODIFY_PATH: ~/.local/bin is already added by the repo's shell snippet.
  curl -LsSf https://astral.sh/uv/install.sh | env UV_NO_MODIFY_PATH=1 sh
  add_shell_snippet
fi

ok "Python setup done. Use a venv per project: python -m venv .venv"
