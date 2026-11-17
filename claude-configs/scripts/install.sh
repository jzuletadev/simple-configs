#!/usr/bin/env bash
# Installs the global Claude Code configuration (Ubuntu / Arch).
# Copies global/CLAUDE.md and global/settings.json to ~/.claude.
# Existing files are backed up with a timestamp before being replaced.

set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEST="$HOME/.claude"
STAMP="$(date +%Y%m%d-%H%M%S)"

mkdir -p "$DEST"

for file in CLAUDE.md settings.json; do
  target="$DEST/$file"
  if [ -f "$target" ]; then
    cp "$target" "$target.bak-$STAMP"
    echo "Backup    $target.bak-$STAMP"
  fi
  cp "$REPO/global/$file" "$target"
  echo "Installed $target"
done

command -v node >/dev/null 2>&1 || echo "WARNING: Node.js is not on the PATH. Hooks and some plugins need it (run: bash setup.sh node)."

# Third-party plugins for this machine: "marketplace-repo plugin@marketplace"
PLUGINS=(
  "DietrichGebert/ponytail ponytail@ponytail"
  "GoogleChrome/modern-web-guidance modern-web-guidance@googlechrome"
)

if command -v claude >/dev/null 2>&1; then
  for entry in "${PLUGINS[@]}"; do
    read -r market plugin <<<"$entry"
    echo "Plugin    $plugin"
    claude plugin marketplace add "$market" >/dev/null 2>&1 || echo "WARNING: could not add the marketplace $market"
    claude plugin install "$plugin" >/dev/null 2>&1 || echo "WARNING: could not install $plugin"
  done
else
  echo "WARNING: the claude command was not found. Install Claude Code (bash setup.sh claude) and run this script again."
fi

echo ""
echo "Done. Open a new terminal and run: claude"
