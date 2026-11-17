# Shared helpers for the Linux setup modules (Ubuntu/Debian and Arch).
# Source this file from a module; do not run it directly.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

info() { printf '\033[1;36m==>\033[0m %s\n' "$*"; }
ok()   { printf '\033[1;32m  ok\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m  !!\033[0m %s\n' "$*" >&2; }
die()  { printf '\033[1;31m ERR\033[0m %s\n' "$*" >&2; exit 1; }

has() { command -v "$1" >/dev/null 2>&1; }

# ask VAR "Prompt" [default] -> empty answer takes the default
ask() {
  local __var=$1 __prompt=$2 __default=${3:-} __reply
  if [ -n "$__default" ]; then
    read -r -p "$__prompt [$__default]: " __reply
  else
    read -r -p "$__prompt: " __reply
  fi
  printf -v "$__var" '%s' "${__reply:-$__default}"
}

# ask_required VAR "Prompt" [default] -> repeats until the answer is not empty
ask_required() {
  while true; do
    ask "$@"
    [ -n "${!1}" ] && return 0
    warn "A value is required."
  done
}

# ask_secret VAR "Prompt" -> hidden input, asked twice to avoid typos
ask_secret() {
  local __var=$1 __prompt=$2 __a __b
  while true; do
    read -r -s -p "$__prompt: " __a; echo
    read -r -s -p "Repeat $__prompt: " __b; echo
    if [ -z "$__a" ]; then warn "A value is required."
    elif [ "$__a" != "$__b" ]; then warn "Values do not match."
    else printf -v "$__var" '%s' "$__a"; return 0
    fi
  done
}

# confirm "Question" [y|n] -> default answer is y unless "n" is passed
confirm() {
  local __default=${2:-y} __hint="[Y/n]" __reply
  [ "$__default" = n ] && __hint="[y/N]"
  read -r -p "$1 $__hint " __reply
  [[ ${__reply:-$__default} =~ ^[Yy] ]]
}

copy_to_clipboard() {
  if has wl-copy; then wl-copy
  elif has xclip; then xclip -selection clipboard
  elif has xsel; then xsel --clipboard --input
  else return 1
  fi
}

# --- Package management ---------------------------------------------------

detect_distro() {
  [ -r /etc/os-release ] || die "Cannot read /etc/os-release."
  # shellcheck disable=SC1091
  . /etc/os-release
  case " ${ID:-} ${ID_LIKE:-} " in
    *" arch "*) DISTRO=arch ;;
    *" ubuntu "* | *" debian "*) DISTRO=ubuntu ;;
    *) die "Unsupported distro '${ID:-unknown}'. Only Ubuntu/Debian and Arch are supported." ;;
  esac
}

APT_REFRESHED=0
apt_refresh() {
  sudo apt-get update
  APT_REFRESHED=1
}

pkg_install() {
  case $DISTRO in
    ubuntu)
      [ "$APT_REFRESHED" = 1 ] || apt_refresh
      sudo DEBIAN_FRONTEND=noninteractive apt-get install -y "$@"
      ;;
    arch) sudo pacman -S --needed --noconfirm "$@" ;;
  esac
}

pkg_upgrade() {
  case $DISTRO in
    ubuntu) apt_refresh && sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -y ;;
    arch) sudo pacman -Syu --noconfirm ;;
  esac
}

# AUR helper (Arch only). Uses yay-bin so nothing has to compile.
ensure_yay() {
  has yay && return 0
  info "Installing yay (AUR helper)"
  pkg_install git base-devel
  local tmp
  tmp=$(mktemp -d)
  git clone --depth 1 https://aur.archlinux.org/yay-bin.git "$tmp/yay-bin"
  (cd "$tmp/yay-bin" && makepkg -si --noconfirm)
  rm -rf "$tmp"
}

# --- Shell integration ----------------------------------------------------

# Makes ~/.bashrc and ~/.zshrc load config/shell/common.sh from this repo.
add_shell_snippet() {
  local snippet="$REPO_ROOT/config/shell/common.sh" rc
  [ -f "$HOME/.bashrc" ] || touch "$HOME/.bashrc"
  for rc in "$HOME/.bashrc" "$HOME/.zshrc"; do
    [ -f "$rc" ] || continue
    grep -qF '# simple-configs' "$rc" && continue
    printf '\n[ -f "%s" ] && . "%s"  # simple-configs\n' "$snippet" "$snippet" >>"$rc"
    ok "Shell hook added to $rc"
  done
}

[ "$(id -u)" -ne 0 ] || die "Run as your normal user; the scripts call sudo when needed."
detect_distro
