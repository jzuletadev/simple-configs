# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

Personal machine setup for Windows (PowerShell), Ubuntu/Debian and Arch: interactive setup scripts, shell config loaded on every machine, quick-reference docs in `docs/`, and the Claude configuration in `claude-configs/`. There is no build or test suite.

## Working rules

- All repo content is in English. Some Claude rules intentionally make Claude *output* Spanish (chat replies, deliverable documents); keep that behavior when editing them.
- Keep the content neutral: no personal data or specific organizations (real names, IDs, schools, employers, locations, profession). Templates use placeholders. Exceptions: the `jzuletadev` handle in URLs and plugin/marketplace names, and the copyright line in `LICENSE`.
- Reply to the user in Spanish.
- Never run `git commit` or `git push` unless the user explicitly asks for it in that message.

## Setup scripts

- Entry points `setup.ps1` / `setup.sh` show a menu or take module names (`.\setup.ps1 git-ssh node`, `bash setup.sh git-ssh node`). Each module runs in isolation; a failure is reported and the rest continue.
- Every module exists twice with the same name and the same questions: `scripts/windows/<name>.ps1` and `scripts/linux/<name>.sh`. Change both together. A new module also has to be registered in both menus (`$modulesInfo` in `setup.ps1`, `MODULES` + `DESCRIPTIONS` in `setup.sh`), the README table and, if it needs reference material, a page in `docs/`.
- Modules load `scripts/lib/common.{ps1,sh}` and should use its helpers instead of raw calls: prompts (`Read-Value`/`ask`, `ask_required`, `Read-Secret`/`ask_secret`, `Confirm-Choice`/`confirm`), installs (`Install-WingetPackage`; `pkg_install`/`apt_refresh` with `$DISTRO` = `ubuntu` | `arch`; `ensure_yay`) and shell hooks (`Add-ProfileSnippet`/`add_shell_snippet`).
- Windows steps that need admin rights go through `Invoke-Elevated` (asks first, one UAC prompt, waits, returns `$true` on success) instead of telling the user to reopen the terminal as administrator. Verify the result afterwards (service status, `Test-Command`) when you can.
- Modules must be safe to rerun: check before installing, never overwrite user files, append to rc/profile files once (marker comment `# simple-configs`).
- Aliases and PATH tweaks belong in `config/powershell/profile.ps1` and `config/shell/common.sh` (sourced from the user's profile/rc files), not inside modules.
- PowerShell must run on Windows PowerShell 5.1 and PowerShell 7: ASCII only (5.1 reads BOM-less files as ANSI), no `&&`, `||` or ternary, and never redirect a native command's stderr while `$ErrorActionPreference = 'Stop'`; use `Invoke-Quiet { ... }` to get a silent exit code.
- Bash modules run under `set -euo pipefail`, refuse to run as root and call `sudo` themselves. Ubuntu-family support relies on `UBUNTU_CODENAME`/`ID_LIKE` from `/etc/os-release`.

Checks (no test suite; run what applies to the files you touched):

```bash
for f in setup.sh scripts/lib/*.sh scripts/linux/*.sh config/shell/*.sh claude-configs/scripts/*.sh; do bash -n "$f" || echo "FAIL $f"; done
```

```powershell
Get-ChildItem -Recurse -Filter *.ps1 | ForEach-Object { $e = $null; [void][System.Management.Automation.Language.Parser]::ParseFile($_.FullName, [ref]$null, [ref]$e); if ($e) { $_.FullName; $e } }
```

## claude-configs

Agents, skills, hooks, settings and MCP servers are not written here: they come from [claude-code-templates](https://docs.aitmpl.com) and are installed into `~/.claude`.

- `components.txt` is the single list (`agent=`, `skill=`, `hook=`, `setting=`, `mcp=`, comma-separated `category/name`). Both `claude-configs/scripts/install.{sh,ps1}` (called by the `claude` module) read it; never paste the list into a script.
- The installers run `npx claude-code-templates --directory ~ --yes`, so everything is user-level. Hook commands come out as relative `python .claude/hooks/x.py`, which breaks outside `~`; `scripts/fix-hook-paths.js` rewrites them to absolute paths afterwards. Keep that step if you change the install flow.
- Optional `global/CLAUDE.md` and `global/settings.json` are copied to `~/.claude` (with `*.bak-<timestamp>` backup) only when they exist.
- `claude-ai/`: text pasted by hand into claude.ai. Its personal rules mirror the user's `~/.claude/CLAUDE.md`; keep them in sync.

Changing the component set or the install flow means updating `claude-configs/README.md` and the `claude` row of the root README in the same change.

Line endings are enforced by `.gitattributes`: LF for `.sh`, `.md`, `.json`, `.js`; CRLF for `.ps1`.
