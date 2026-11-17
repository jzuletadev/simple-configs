# Maintenance and troubleshooting

## Publishing

The marketplace is the simple-configs repo itself (`jzuletadev/simple-configs`, file `.claude-plugin/marketplace.json` at its root). If the repo is public, anyone can install your plugin. If it is private, claude.ai needs access through the Claude GitHub App.

## Workflow to change something

1. Edit the file in the repo (never directly in `~/.claude`).
2. If you touched the plugin, bump `version` in `claude-configs/plugins/jzuletadev-core/.claude-plugin/plugin.json` (for example 2.1.0 → 2.2.0).
3. Commit and push (you do this yourself; Claude never commits unless you ask).
4. Apply the changes everywhere:
   - claude.ai and Cowork: updates on its own if Sync automatically is on; otherwise Check for updates.
   - Claude Code: `/reload-plugins` or restart `claude`.
   - If you touched `global/`: `git pull` and run the `claude` module again on each machine.

## Updating another machine

### Windows (PowerShell)

```powershell
cd $HOME\simple-configs
git pull
powershell -ExecutionPolicy Bypass -File .\claude-configs\scripts\install.ps1
```

### Ubuntu and Arch (common)

```bash
cd ~/simple-configs
git pull
bash claude-configs/scripts/install.sh
```

## Adding a new agent

1. Create `claude-configs/plugins/jzuletadev-core/agents/NAME.md` with this header:

```markdown
---
name: NAME
description: When to use it, in one clear line. Claude decides based on this.
tools: Read, Grep, Glob
model: haiku
---

Agent instructions.
```

2. Pick the model: `haiku` to search or summarize, `sonnet` to write code, test or review, `opus` only for design and decisions.
3. Give it only the tools it needs. An agent that doesn't edit gets no `Write` or `Edit`.
4. Add it to the agent lists in the plugin README, [04-claude-code](04-claude-code.md) and `global/CLAUDE.md`.

When `/jzuletadev-core:retro` proposes a change to an agent, a command or the global rules, make it here in the repo and follow the workflow above, so every machine gets the improvement.

## Adding a new skill

1. Create `claude-configs/plugins/jzuletadev-core/skills/NAME/SKILL.md` with `name` and `description` in the header.
2. The `description` is what makes it trigger on its own: write when to use it, not what it is.
3. If it needs supporting files (templates, examples), put them in the same folder.

## Restoring a backup

The install scripts save `CLAUDE.md.bak-DATE` and `settings.json.bak-DATE` in your `.claude` folder. To go back, rename the backup to the original name.

## General troubleshooting

- I don't know what is loaded: inside Claude Code run `/context`, `/plugin` and `/agents`.
- Claude answers differently in the chat and in Claude Code: the chat reads the claude.ai preferences; Claude Code reads `~/.claude/CLAUDE.md`. Check that both say the same.
- The plugin appears twice in Claude Code: you installed it through your account and also by command. Remove the command one with `/plugin` and keep the synced one.
- Everything feels slow or the context runs out quickly: disable plugins and connectors you aren't using.
