# Plugins

Rule: few plugins, each with a clear purpose. Install one, use it for a few days and keep it only if it improves the results.

## Two ways to install

- **From claude.ai (Customize > Plugins)**: saved to your account and reaches the chat, Cowork and Claude Code on all your machines. Use it for jzuletadev-core.
- **From Claude Code (`/plugin install`)**: stays on that machine only. Use it for coding plugins. So you don't repeat them by hand on every PC, the install scripts install them and `global/settings.json` keeps them enabled.

## My plugin: jzuletadev-core

See [02-claude-ai](02-claude-ai.md) to install it and [04-claude-code](04-claude-code.md) for what each piece does.

## Third-party plugins I use

The install script from [04-claude-code](04-claude-code.md) installs them. To do it by hand, inside Claude Code, one line per message:

Ponytail (write less code, avoid over-engineering):

```
/plugin marketplace add DietrichGebert/ponytail
```
```
/plugin install ponytail@ponytail
```

modern-web-guidance (web best practices, from the Chrome team):

```
/plugin marketplace add GoogleChrome/modern-web-guidance
```
```
/plugin install modern-web-guidance@googlechrome
```

To add another third-party plugin to all your machines, add it to the `PLUGINS` list in `scripts/install.sh`, to `$plugins` in `scripts/install.ps1`, and to `enabledPlugins` in `global/settings.json`.

## Plugins I enable only when a project needs them

Google's EGM (design and review before coding; uses a lot of tokens, use it for large features):

```
/plugin marketplace add google/elephant-goldfish-model
```
```
/plugin install egm@egm
```

UI UX Pro Max (interface design; use the original from nextlevelbuilder):

```
/plugin marketplace add nextlevelbuilder/ui-ux-pro-max-skill
```
```
/plugin install ui-ux-pro-max@ui-ux-pro-max-skill
```

To enable them in one repo only, add them to that repo's `.claude/settings.json`, not the global one:

```json
{
  "enabledPlugins": {
    "egm@egm": true
  }
}
```

## The ones I left out and why

- claude-mem: it works, but it adds a background service and comes tied to a Solana token. A good CLAUDE.md covers almost everything.
- OmniRoute and Headroom: proxies to switch providers or compress tokens. Too much complexity for my use.
- stop-slop: designed for English prose; my Spanish deliverables use the document-style skill.

## Security

- A plugin can run commands on your PC with your permissions (hooks and agents). Review its repo before installing it.
- Claude Code shows a "Will install" section before installing. Read it.

## Adding a new plugin to this repo

1. Create `claude-configs/plugins/NAME/.claude-plugin/plugin.json` with `name`, `version` and `description`.
2. Add its folders (`agents/`, `skills/`, `commands/`, `hooks/`).
3. Register it in `.claude-plugin/marketplace.json` (repo root) under `plugins`, with `"source": "./claude-configs/plugins/NAME"`.
4. `git push`. claude.ai picks it up with Check for updates.
