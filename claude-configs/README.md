# Claude configs

My Claude setup in one place: plugin (agents, skill, command, hook), personal Claude Code settings, project template and claude.ai texts. It works on Windows (PowerShell), Ubuntu and Arch.

## What's here

- `plugins/jzuletadev-core/`: my plugin. 6 agents (explorer, architect, developer, tester, reviewer, docs-writer), the document-style skill, the `/decision`, `/verify`, `/retro` and `/commit` commands (none of them commits) and a Prettier format hook. See its [README](plugins/jzuletadev-core/README.md) for the workflow.
- `../.claude-plugin/marketplace.json`: at the root of simple-configs. It turns the repo into the marketplace `jzuletadev/simple-configs`, so the plugin can be installed from claude.ai or Claude Code.
- `global/`: my personal Claude Code `CLAUDE.md` and `settings.json` (they go to `~/.claude`).
- `project-template/`: base `CLAUDE.md` and `.claude/settings.json` for every new repo.
- `claude-ai/`: texts to paste into claude.ai (preferences and Project instructions).
- `scripts/`: install (global config + third-party plugins) and new-project, for PowerShell and bash.
- `docs/`: the guides.

## Index

- [Map: what goes where](docs/00-map.md)
- [Installing Claude Code and the desktop app](docs/01-install.md)
- [claude.ai (web, desktop and mobile)](docs/02-claude-ai.md)
- [Desktop app and Cowork](docs/03-desktop-cowork.md)
- [Claude Code](docs/04-claude-code.md)
- [Plugins](docs/05-plugins.md)
- [New project](docs/06-new-project.md)
- [Maintenance and troubleshooting](docs/07-maintenance.md)

## Quick start on a new machine

1. From the root of simple-configs run the `claude` module: `.\setup.ps1 claude` on Windows or `bash setup.sh claude` on Linux. It installs Claude Code and copies `global/` to `~/.claude` ([04-claude-code](docs/04-claude-code.md)).
2. In claude.ai add the marketplace `jzuletadev/simple-configs` and install `jzuletadev-core` ([02-claude-ai](docs/02-claude-ai.md)). This is done once per account, not per machine.

If you only want the plugin in Claude Code, inside `claude` (one line per message):

```
/plugin marketplace add jzuletadev/simple-configs
```

```
/plugin install jzuletadev-core@jzuletadev-configs
```

## Conventions

- Commands are ready to copy and paste, without prompt prefixes.
- Commands starting with `/` are typed inside Claude Code, not in the terminal.
- "Linux (common)" means it applies the same on Ubuntu and Arch.
- `~/.claude` on Linux is `$HOME\.claude` in PowerShell (`C:\Users\YOUR-USER\.claude`).
