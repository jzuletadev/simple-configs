# Loaded from ~/.bashrc and ~/.zshrc (hook added by setup.sh).
# Put your aliases and shell tweaks here; `git pull` brings them to every machine.
# Must work in bash and zsh, and never fail when a tool is missing.

# --- PATH (always) ---------------------------------------------------------
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

# Everything below is for interactive shells only.
case $- in *i*) ;; *) return 0 2>/dev/null || true ;; esac

# --- Environment -----------------------------------------------------------
if [ -z "${EDITOR:-}" ]; then
  for __ed in nano vim vi; do
    if command -v "$__ed" >/dev/null 2>&1; then export EDITOR="$__ed"; break; fi
  done
  unset __ed
fi

# --- History ---------------------------------------------------------------
if [ -n "${BASH_VERSION:-}" ]; then
  HISTSIZE=10000
  HISTFILESIZE=20000
  HISTCONTROL=ignoreboth:erasedups
  shopt -s histappend checkwinsize cdspell 2>/dev/null
elif [ -n "${ZSH_VERSION:-}" ]; then
  HISTSIZE=10000
  SAVEHIST=20000
  setopt HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE SHARE_HISTORY 2>/dev/null
fi

# --- Tools -----------------------------------------------------------------
if command -v fnm >/dev/null 2>&1; then
  if [ -n "${ZSH_VERSION:-}" ]; then
    eval "$(fnm env --use-on-cd --shell zsh)"
  else
    eval "$(fnm env --use-on-cd --shell bash)"
  fi
fi

# zoxide: smarter cd (use `z folder`); starship: prompt (zsh with oh-my-zsh keeps its theme otherwise)
if [ -n "${ZSH_VERSION:-}" ]; then __sh=zsh; else __sh=bash; fi
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init "$__sh")"
command -v starship >/dev/null 2>&1 && eval "$(starship init "$__sh")"
unset __sh

# Ubuntu ships bat and fd under other names
command -v batcat >/dev/null 2>&1 && ! command -v bat >/dev/null 2>&1 && alias bat='batcat'
command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1 && alias fd='fdfind'

# --- Navigation and files --------------------------------------------------
if ls --color=auto >/dev/null 2>&1; then alias ls='ls --color=auto'; fi
alias ll='ls -alF'
alias la='ls -A'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias grep='grep --color=auto'
alias reload='exec "${SHELL:-bash}" -l'

mkcd() { mkdir -p -- "$1" && cd -- "$1"; }

# Lists listening TCP/UDP ports with their process
ports() { ss -tulpn 2>/dev/null || sudo ss -tulpn; }

# Extracts almost any archive: extract file.tar.gz
extract() {
  [ -f "${1:-}" ] || { echo "usage: extract <archive>" >&2; return 1; }
  case "$1" in
    *.tar.gz|*.tgz)   tar xzf "$1" ;;
    *.tar.bz2|*.tbz2) tar xjf "$1" ;;
    *.tar.xz)         tar xJf "$1" ;;
    *.tar)            tar xf "$1" ;;
    *.zip)            unzip "$1" ;;
    *.gz)             gunzip "$1" ;;
    *.7z)             7z x "$1" ;;
    *) echo "extract: unknown format: $1" >&2; return 1 ;;
  esac
}

# Updates the system with the package manager of this distro
update() {
  if command -v apt-get >/dev/null 2>&1; then
    sudo apt-get update && sudo apt-get upgrade -y
  elif command -v pacman >/dev/null 2>&1; then
    sudo pacman -Syu
  else
    echo "update: no supported package manager found" >&2; return 1
  fi
}

# --- Git (oh-my-zsh already defines many of these; the same meaning is fine) --
alias gs='git status -sb'
alias ga='git add'
alias gaa='git add -A'
alias gd='git diff'
alias gds='git diff --staged'
alias gcmsg='git commit -m'
alias gpl='git pull --ff-only'
alias gps='git push'
alias glg='git log --oneline --graph --decorate -n 20'
alias gsw='git switch'
alias gb='git branch'

# --- Docker ----------------------------------------------------------------
alias dcu='docker compose up -d'
alias dcd='docker compose down'
alias dcl='docker compose logs -f'
alias dcr='docker compose restart'
alias dps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
