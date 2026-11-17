#!/usr/bin/env bash
# zsh + oh-my-zsh + plugins, and the repo's shared aliases for bash and zsh.
. "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

if confirm "Install zsh with oh-my-zsh?"; then
  pkg_install zsh git curl

  if [ -d "$HOME/.oh-my-zsh" ]; then
    ok "oh-my-zsh already installed"
  else
    info "Installing oh-my-zsh (an existing ~/.zshrc is backed up as ~/.zshrc.pre-oh-my-zsh)"
    RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  fi

  custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"
  for plugin in zsh-autosuggestions zsh-syntax-highlighting; do
    if [ -d "$custom/$plugin" ]; then
      ok "$plugin already present"
    else
      git clone --depth 1 "https://github.com/zsh-users/$plugin" "$custom/$plugin"
    fi
  done

  sed -i 's/^plugins=(.*)$/plugins=(git docker zsh-autosuggestions zsh-syntax-highlighting)/' "$HOME/.zshrc"
  ok "Plugins enabled in ~/.zshrc"

  if [ "$(basename "${SHELL:-}")" != zsh ] && confirm "Make zsh your default shell?"; then
    chsh -s "$(command -v zsh)"
    warn "Log out and back in for the new shell to apply."
  fi
fi

add_shell_snippet
ok "Shell setup done. Edit config/shell/common.sh to add aliases."
