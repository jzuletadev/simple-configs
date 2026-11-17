# Map: what goes where

Claude is used in three places, and each one reads its configuration from a different spot. Understanding this is 80% of the work.

## The three places

- **claude.ai (chat)**: the web, the Chat tab of the desktop app and the mobile app. It is the same chat everywhere.
- **Cowork**: a desktop app tab for long tasks on folders of your PC. It runs in an isolated virtual machine.
- **Claude Code**: the coding agent. You use it in the terminal (`claude`) or in the Code tab of the desktop app. Both read the same configuration (`~/.claude`).

## What works where

| Piece | Chat | Cowork | Claude Code |
| :- | :- | :- | :- |
| Personal preferences (claude.ai > Settings) | Yes | Yes | No |
| claude.ai Projects | Yes | No | No |
| Skills | Yes | Yes | Yes |
| Plugin commands | Yes (as a skill) | Yes | Yes |
| Connectors (MCP) | Yes | Yes | Yes |
| Agents | No | Yes | Yes |
| Hooks | No | Yes | Yes |
| CLAUDE.md and settings.json | No | No | Yes |

## Where each thing comes from

- **Your account**: what you add in claude.ai > Customize (skills, plugins, connectors) is saved to your account. It shows up in chat, in Cowork and in Claude Code on any machine where you sign in.
- **Your machine**: what lives in `~/.claude` (CLAUDE.md, settings.json, plugins installed by command) exists only on that PC. That is why this repo has scripts to copy it.
- **Each repo**: the root `CLAUDE.md` and `.claude/settings.json` travel with the project in git.

## This repo's strategy

- The `jzuletadev-core` plugin is installed **once from claude.ai**. That way its skills reach the chat, its agents and hooks reach Cowork, and all of it reaches Claude Code on every machine.
- `global/` is copied **on every machine** by the `claude` setup module. It holds your personal Claude Code rules and the third-party plugins that are only useful for coding.
- `project-template/` is copied **into every new repo**.
- `claude-ai/preferences.md` is pasted **once** into claude.ai.

## Why not put everything in one place

- A plugin cannot ship your global CLAUDE.md or your settings.json. Those only exist in Claude Code.
- Plugins installed by command in Claude Code are not uploaded to your account: they stay on that machine.
- Claude Code does not read the claude.ai preferences. That is why your rules appear twice: in `claude-ai/preferences.md` and in `global/CLAUDE.md`.
