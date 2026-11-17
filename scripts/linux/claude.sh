#!/usr/bin/env bash
# Claude Code, optional desktop app (Ubuntu only) and the configs in claude-configs/.
. "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

export PATH="$HOME/.local/bin:$PATH"

if has claude; then
  ok "Claude Code already installed ($(claude --version))"
else
  info "Installing Claude Code"
  pkg_install curl git
  curl -fsSL https://claude.ai/install.sh | bash
fi
add_shell_snippet

if [ "$DISTRO" = ubuntu ] && ! dpkg -s claude-desktop >/dev/null 2>&1 && confirm "Install the Claude desktop app (official beta)?" n; then
  sudo curl -fsSLo /usr/share/keyrings/claude-desktop-archive-keyring.asc https://downloads.claude.ai/claude-desktop/key.asc
  echo "deb [signed-by=/usr/share/keyrings/claude-desktop-archive-keyring.asc] https://downloads.claude.ai/claude-desktop/apt/stable stable main" |
    sudo tee /etc/apt/sources.list.d/claude-desktop.list >/dev/null
  apt_refresh
  pkg_install claude-desktop
  if confirm "Enable Cowork (adds you to the kvm group)?" n; then
    sudo usermod -aG kvm "$(id -un)"
    warn "Log out and back in for Cowork to work."
  fi
elif [ "$DISTRO" = arch ]; then
  info "No official desktop app for Arch: use claude.ai in the browser and 'claude' in the terminal."
fi

bash "$REPO_ROOT/claude-configs/scripts/install.sh"
