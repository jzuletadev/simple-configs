#!/usr/bin/env bash
# Copies the project template into the current folder (Ubuntu / Arch).
# Usage: from the root of your repo, run this script by its full path.
# Never overwrites files that already exist.

set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEMPLATE="$REPO/project-template"
HERE="$(pwd)"

mkdir -p "$HERE/.claude"

for rel in CLAUDE.md .claude/settings.json; do
  if [ -e "$HERE/$rel" ]; then
    echo "Already exists, left as is: $rel"
  else
    cp "$TEMPLATE/$rel" "$HERE/$rel"
    echo "Created: $rel"
  fi
done

LINE=".claude/settings.local.json"
if ! grep -qxF "$LINE" "$HERE/.gitignore" 2>/dev/null; then
  echo "$LINE" >>"$HERE/.gitignore"
  echo "Added to .gitignore: $LINE"
fi

echo ""
echo "Fill in CLAUDE.md for this project (or run /init inside claude)."
