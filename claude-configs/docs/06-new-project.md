# New project

Every repo gets its own `CLAUDE.md` and `.claude/settings.json`. This is what improves results the most: Claude stops guessing the stack and the commands.

## Copy the template

Go to the root of the repo and run the script for your system. It never overwrites existing files.

### Windows (PowerShell)

```powershell
powershell -ExecutionPolicy Bypass -File "$HOME\simple-configs\claude-configs\scripts\new-project.ps1"
```

### Ubuntu and Arch (common)

```bash
bash ~/simple-configs/claude-configs/scripts/new-project.sh
```

## Fill in the CLAUDE.md

Quick option: open Claude Code in the repo and let it fill it in.

```bash
claude
```

Inside Claude Code:

```
/init
```

Then review it and keep only what is useful: stack, commands to run and test, structure, conventions, definition of done, review checklist and what must not be touched. Short is better; a long CLAUDE.md spends context on every message.

## Quality loop in each project

Three parts of the template make results checkable and improve them over time:

- Definition of done: what must be true before Claude calls a task finished. `/jzuletadev-core:verify` checks it with evidence.
- Review checklist: project-specific checks the reviewer applies. It starts almost empty; `/jzuletadev-core:retro` proposes a new line each time a review or a bug shows a mistake that can happen again.
- `docs/decisions/`: `/jzuletadev-core:decision` records significant decisions there, so later changes don't undo them by accident.

## What `.claude/settings.json` includes

- `allow`: Claude can run `npm run`, `npm test`, `git status`, `git diff` and `git log` without asking every time.
- `deny`: it never reads `.env`.

Add the project's own permissions here, for example `"Bash(docker compose *)"` if you use Docker.

## Shared repos

- Commit `CLAUDE.md`, `.claude/settings.json` and `docs/decisions/` to the repo: everyone who uses Claude Code gets the same context, checklist and decisions.
- Anything of yours you don't want to share goes in `.claude/settings.local.json` or `CLAUDE.local.md` (both are in `.gitignore`).

## Troubleshooting

- Claude ignores the CLAUDE.md: it must be at the root of the repo (where you run `claude`), with that exact name.
- It keeps asking permission for `npm run dev`: check that the JSON is valid and that the rule matches the command (`Bash(npm run *)`).
