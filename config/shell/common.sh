# Loaded from ~/.bashrc and ~/.zshrc (hook added by setup.sh).
# Put your aliases and shell tweaks here; `git pull` brings them to every machine.

# User-level binaries (Claude Code, uv, pip --user)
case ":$PATH:" in *":$HOME/.local/bin:"*) ;; *) PATH="$HOME/.local/bin:$PATH" ;; esac

# fnm (Node version manager): its installer uses one of these folders
for __fnm_dir in "${XDG_DATA_HOME:-$HOME/.local/share}/fnm" "$HOME/.fnm"; do
  if [ -d "$__fnm_dir" ]; then
    case ":$PATH:" in *":$__fnm_dir:"*) ;; *) PATH="$__fnm_dir:$PATH" ;; esac
  fi
done
unset __fnm_dir
export PATH

if command -v fnm >/dev/null 2>&1; then
  if [ -n "${ZSH_VERSION:-}" ]; then
    eval "$(fnm env --use-on-cd --shell zsh)"
  else
    eval "$(fnm env --use-on-cd --shell bash)"
  fi
fi

# Aliases
alias ll='ls -alF'
alias la='ls -A'
alias gs='git status'
alias dcu='docker compose up -d'
alias dcd='docker compose down'
alias dcl='docker compose logs -f'
