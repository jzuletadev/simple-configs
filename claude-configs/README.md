# claude-configs

Claude setup for every machine. Nothing here is custom-built: agents, skills, hooks, settings and MCP servers come from [claude-code-templates](https://docs.aitmpl.com) and are installed into `~/.claude` (`$HOME\.claude` on Windows), so they apply to every project.

## Install

Through the setup menu (it also installs Claude Code):

```powershell
.\setup.ps1 claude
```

```bash
bash setup.sh claude
```

Or only the components, once Node.js and Python are installed:

```powershell
.\claude-configs\scripts\install.ps1
```

```bash
bash claude-configs/scripts/install.sh
```

Rerunning is safe: files from the templates are replaced with the current version, your other files are kept. Open a new terminal afterwards and run `claude`.

## What the installer does

1. Copies `global/CLAUDE.md` and `global/settings.json` to `~/.claude` (with a `*.bak-<timestamp>` backup) if those files exist in this folder. Today there are none; add them to share personal rules across machines.
2. Runs `npx claude-code-templates --directory ~ --yes` with the lists in `components.txt`. Agents, skills and hook scripts go to `~/.claude/agents`, `skills` and `hooks`; hooks and settings are merged into `~/.claude/settings.local.json`; MCP servers into `~/.mcp.json`.
3. Runs `scripts/fix-hook-paths.js`: the templates write hook commands such as `python .claude/hooks/x.py`, relative to the project, which fail outside `~`. It rewrites them to absolute paths.

If Node.js is missing, step 2 and 3 are skipped with a warning (`setup.ps1 node`). The Python hooks need `python` on the PATH (`setup.ps1 python`).

## Change what gets installed

Edit `components.txt` (one line per type, comma-separated `category/name`; browse names at [aitmpl.com](https://aitmpl.com)) and rerun the installer. Removing a name does not uninstall it: delete the file from `~/.claude` too.

## claude.ai

`claude-ai/` holds text to paste by hand: `preferences.md` into Settings > Profile and `project-instructions.md` into each Project. Claude Code reads `~/.claude/CLAUDE.md` instead; keep the personal rules in both places in sync.

## Known issues

- The `filesystem` and `markitdown` MCP servers can fail to connect (`CONNECTION_CLOSED`). `markitdown` needs `uv`/`uvx` (`setup.ps1 python`); check them with `claude mcp list`.
- Settings from different templates are merged by the CLI, so later installs can override earlier ones. Review `~/.claude/settings.local.json` after changing `components.txt`.
