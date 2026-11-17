# Claude Code

Claude Code reads its configuration at two levels: your user (applies to every project) and each repo.

## Paths

| What | Windows | Ubuntu / Arch |
| :- | :- | :- |
| User folder | `$HOME\.claude\` | `~/.claude/` |
| Personal rules | `$HOME\.claude\CLAUDE.md` | `~/.claude/CLAUDE.md` |
| Personal settings | `$HOME\.claude\settings.json` | `~/.claude/settings.json` |
| Repo rules | `CLAUDE.md` at the root | same |
| Repo settings (committed) | `.claude\settings.json` | `.claude/settings.json` |
| Local settings (not committed) | `.claude\settings.local.json` | `.claude/settings.local.json` |

Precedence: repo settings.local > repo settings > user settings. The most specific wins.

## Installing the global configuration

The `claude` setup module installs Claude Code and then runs `claude-configs/scripts/install`:

### Windows (PowerShell)

```powershell
cd $HOME\simple-configs
powershell -ExecutionPolicy Bypass -File .\setup.ps1 claude
```

### Ubuntu and Arch (common)

```bash
cd ~/simple-configs
bash setup.sh claude
```

To only copy the configuration again (no installs), run the script directly:

```powershell
powershell -ExecutionPolicy Bypass -File "$HOME\simple-configs\claude-configs\scripts\install.ps1"
```

```bash
bash ~/simple-configs/claude-configs/scripts/install.sh
```

The install script does three things:

- Copies `global/CLAUDE.md` and `global/settings.json` to your `.claude` folder, with a `.bak-DATE` backup if you already had something.
- Installs this machine's third-party plugins (Ponytail and modern-web-guidance).
- Warns you if Node.js or Claude Code is missing.

You can run it as often as you like: plugins that are already installed are left as they are.

## What each global file contains

`CLAUDE.md`: your personal rules (Spanish replies, format, PowerShell by default, evidence before saying something is done, how decisions are made and recorded, turning review findings into prevention, never commit unless asked, when to use each agent).

`settings.json`:

- `model: sonnet`: default model. Opus is only used by the architect agent or when you switch with `/model`.
- `outputStyle: Concise`: short answers.
- `permissions.ask`: Claude must ask before every `git commit` and `git push`, as a safety net for the no-commit rule.
- `permissions.deny`: Claude never reads `.env` or `secrets/`.
- `extraKnownMarketplaces` and `enabledPlugins`: declare Ponytail and modern-web-guidance as active. The script downloads them; the settings record which ones belong.

## jzuletadev-core plugin in Claude Code

If you already installed it from claude.ai, Claude Code downloads it on its own when you sign in with the same account. If it doesn't appear, inside Claude Code:

```
/reload-plugins
```

On a machine where you don't want to use your account (for example a shared computer), install it directly, one line per message:

```
/plugin marketplace add jzuletadev/simple-configs
```

```
/plugin install jzuletadev-core@jzuletadev-configs
```

## What each plugin piece does

- Agents: Claude uses them when the task matches their description, or when you ask ("use the developer to..."). Each one runs with its own model and its own context:
  - explorer (haiku): finds and summarizes code; read-only.
  - architect (opus): compares options and plans large or hard-to-undo changes; doesn't write code.
  - developer (sonnet): implements a defined task with its tests. Several can work in parallel on tasks that touch different files.
  - tester (sonnet): checks the acceptance criteria, adds missing tests and runs the suite; only edits tests.
  - reviewer (sonnet): reviews the diff by severity and proposes how to prevent repeated problems; read-only.
  - docs-writer (sonnet): documentation and reports.
- document-style skill: loads automatically when producing deliverable documents.
- Commands (none of them commits; you do):
  - `/jzuletadev-core:decision`: options, recommendation and, once you choose, a record in `docs/decisions/`.
  - `/jzuletadev-core:verify`: quality gate with evidence (tester, then reviewer) and a ready / not ready verdict.
  - `/jzuletadev-core:retro`: turns review findings, bugs and your corrections into rules, tests or review-checklist lines.
  - `/jzuletadev-core:commit`: drafts the commit message.
- Hook: every time Claude edits a file, `format.js` formats it with Prettier, only if the repo has Prettier installed. It is written in Node so it works the same on all 3 systems.

## Workflow

- Small, clear change: Claude does it directly and runs the relevant check.
- Feature or unclear bug: explorer → architect (only if large or hard to undo) → developer → `/jzuletadev-core:verify` → fix what blocks → `/jzuletadev-core:commit` → you commit.
- After a bad review or a bug that got through: `/jzuletadev-core:retro`, so the lesson becomes a rule, a test or a checklist line and the next task starts better.

## Useful commands inside Claude Code

| Command | What it does |
| :- | :- |
| `/init` | Generates a CLAUDE.md for the current repo |
| `/agents` | View and edit agents |
| `/hooks` | View active hooks |
| `/plugin` | View, enable and disable plugins |
| `/context` | See how much context each thing uses |
| `/model` | Switch model for the session |
| `/config` | Settings such as output style and verbose |

## Adding something for one machine only

Don't touch the repo files. Create `settings.local.json` in the project, or edit `~/.claude/settings.json` knowing the next install will replace it (a backup is kept).

## Troubleshooting

- `install.ps1 cannot be loaded because running scripts is disabled`: use the command with `-ExecutionPolicy Bypass` exactly as above.
- `install.sh: $'\r': command not found`: the file got Windows line endings. Run `sed -i 's/\r$//' ~/simple-configs/claude-configs/scripts/*.sh`. The repo's `.gitattributes` prevents this on fresh clones.
- Agents don't appear in `/agents`: the plugin is not active. Check `/plugin` and run `/reload-plugins`.
- The hook doesn't format: check that the repo has Prettier (`npm install -D prettier`) and that `node` is on the PATH.
- Settings with an error: invalid JSON makes Claude Code ignore the file. Validate it with `node -e "JSON.parse(require('fs').readFileSync(process.argv[1]))" PATH\settings.json`.
