#!/usr/bin/env bash
# Installs the Claude Code configuration (Ubuntu / Arch).
# 1. Copies global/ files to ~/.claude, if the repo has any (existing files are backed up).
# 2. Installs the agents, skills, hooks, settings and MCP servers listed in
#    components.txt into ~/.claude with claude-code-templates.
# 3. Makes the installed hook commands use absolute paths.

set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEST="$HOME/.claude"
STAMP="$(date +%Y%m%d-%H%M%S)"

mkdir -p "$DEST"

for file in CLAUDE.md settings.json; do
  [ -f "$REPO/global/$file" ] || continue
  target="$DEST/$file"
  if [ -f "$target" ]; then
    cp "$target" "$target.bak-$STAMP"
    echo "Backup    $target.bak-$STAMP"
  fi
  cp "$REPO/global/$file" "$target"
  echo "Installed $target"
done

if ! command -v node >/dev/null 2>&1 || ! command -v npx >/dev/null 2>&1; then
  echo "WARNING: Node.js is not on the PATH; skipping agents, skills, hooks and MCP servers (run: bash setup.sh node)." >&2
  exit 0
fi
command -v python >/dev/null 2>&1 || echo "WARNING: 'python' is not on the PATH; the Python hooks will fail (run: bash setup.sh python)." >&2

# Build the claude-code-templates arguments from components.txt.
args=()
while IFS='=' read -r kind list; do
  case "$kind" in
    agent|skill|hook|setting|mcp) args+=("--$kind" "$list") ;;
  esac
done < <(grep -E '^(agent|skill|hook|setting|mcp)=' "$REPO/components.txt")

echo "Installing components into $DEST (claude-code-templates)"
# Home is the target directory, so everything lands in ~/.claude. --yes keeps it
# non-interactive; hooks and settings then go to ~/.claude/settings.local.json.
if npx --yes claude-code-templates@latest --directory "$HOME" --yes "${args[@]}"; then
  node "$REPO/scripts/fix-hook-paths.js" || echo "WARNING: could not fix hook paths." >&2
else
  echo "WARNING: claude-code-templates failed; rerun this module to retry." >&2
fi

echo ""
echo "Done. Open a new terminal and run: claude"
