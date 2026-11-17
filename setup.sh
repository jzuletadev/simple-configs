#!/usr/bin/env bash
# Interactive setup for Ubuntu/Debian and Arch.
#   bash setup.sh              -> menu
#   bash setup.sh git-ssh node -> run those modules directly
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODULES=(base git-ssh shell node python docker databases cloud claude)
DESCRIPTIONS=(
  "System update, essentials (git, curl, build tools), yay on Arch"
  "Git identity, SSH key, GitHub login/key upload, SSH host aliases"
  "zsh + oh-my-zsh + plugins, shared aliases from config/shell"
  "Node.js via fnm (LTS or chosen version), global npm packages"
  "Python 3 with pip/venv, optional uv"
  "Docker Engine + Compose, docker group"
  "MySQL / PostgreSQL / MongoDB containers with your passwords"
  "AWS, Google Cloud and Azure CLIs with login"
  "Claude Code, desktop app and claude-configs"
)

if [ "$(id -u)" -eq 0 ]; then
  echo "Run as your normal user; the scripts call sudo when needed." >&2
  exit 1
fi

selected=()
if [ $# -gt 0 ]; then
  selected=("$@")
else
  echo
  echo "simple-configs setup"
  echo
  for i in "${!MODULES[@]}"; do
    printf '  %d) %-10s %s\n' "$((i + 1))" "${MODULES[$i]}" "${DESCRIPTIONS[$i]}"
  done
  echo
  read -r -p "Modules to run (e.g. '1 2 4', 'all', Enter to quit): " answer
  [ -z "$answer" ] && exit 0
  if [ "$answer" = all ]; then
    selected=("${MODULES[@]}")
  else
    for n in $answer; do
      if [[ $n =~ ^[0-9]+$ ]] && [ "$n" -ge 1 ] && [ "$n" -le ${#MODULES[@]} ]; then
        selected+=("${MODULES[$((n - 1))]}")
      else
        echo "Ignoring '$n'" >&2
      fi
    done
  fi
fi

# Ask for the sudo password once up front.
sudo -v || exit 1

failed=()
for m in "${selected[@]}"; do
  script="$ROOT/scripts/linux/$m.sh"
  if [ ! -f "$script" ]; then
    echo "Unknown module: $m" >&2
    failed+=("$m")
    continue
  fi
  printf '\n\033[1;35m### %s\033[0m\n' "$m"
  bash "$script" || failed+=("$m")
done

echo
if [ ${#failed[@]} -eq 0 ]; then
  echo "All done. Open a new terminal to load the changes."
else
  echo "Finished with errors in: ${failed[*]}. Fix the issue and rerun: bash setup.sh ${failed[*]}"
  exit 1
fi
