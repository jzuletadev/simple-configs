# Desktop app and Cowork

The desktop app has three tabs: Chat, Cowork and Code. It is available on Windows and on Ubuntu/Debian (beta). There is no official version for Arch (see [01-install](01-install.md)).

## Chat tab

It is claude.ai. It uses your account's preferences, skills, plugins and connectors. Nothing extra to configure.

## Cowork tab

For long tasks on files of your PC: organizing folders, producing documents from several files, researching and leaving the result in a folder.

What Cowork loads:

- Skills, commands, agents and connectors from your account's plugins (jzuletadev-core included).
- The folders you connect to it. It can only read and write inside those folders.

How to use it well:

1. Install `jzuletadev-core` from claude.ai (see [02-claude-ai](02-claude-ai.md)). There is no other step: Cowork loads it when the next task starts.
2. When you create a task, connect only the folder for that work (for example the project folder), not your whole disk.
3. To run a plugin command type `/jzuletadev-core:commit` or the skill you need.

What Cowork does not read: your `~/.claude/CLAUDE.md` or your `~/.claude/settings.json`. Those rules are only for Claude Code. If you want Cowork to follow them, they must be in your claude.ai preferences or inside the plugin (the no-commit rule is in both).

## Code tab

It is Claude Code with a graphical interface: parallel sessions, visual review of changes and an integrated terminal. It uses the same configuration as `claude` in the terminal (`~/.claude` and the repo's `.claude` folder). Everything in [04-claude-code](04-claude-code.md) applies here too.

## Troubleshooting

- A new plugin doesn't appear in Cowork: plugins load when a new task starts, not in one that is already running.
- Cowork on Ubuntu doesn't start: check that your user is in the kvm group (`groups` must show `kvm`) and that virtualization is enabled in the BIOS.
- The Code tab doesn't see my third-party plugins: plugins installed by command are stored per machine; run the `claude` setup module on that PC.
