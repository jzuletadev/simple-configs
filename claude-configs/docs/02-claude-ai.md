# claude.ai (web, desktop and mobile)

All of this is configured **once per account**. It is the same on Windows, Ubuntu and Arch because it lives in the cloud, not on your PC.

## 1. Personal preferences

Rules Claude follows in all your chats (and in Cowork).

1. Open claude.ai > Settings > Profile.
2. In the personal preferences field, paste the block from [claude-ai/preferences.md](../claude-ai/preferences.md).
3. Save.

## 2. Memory and chat search

In Settings, make sure these are on:

- "Generate memory from chat history": Claude remembers facts about you across chats.
- "Search and reference chats": Claude can search previous conversations.

## 3. jzuletadev-core plugin (the most important part)

Installed here, it reaches the chat, Cowork and Claude Code on all your machines.

1. Make sure simple-configs is pushed to GitHub (the marketplace file is at its root).
2. In claude.ai go to Customize > Plugins.
3. Choose Add > Add marketplace and type `jzuletadev/simple-configs`.
4. If the repo is private, accept connecting GitHub and install the Claude GitHub App on that repo.
5. Find `jzuletadev-core` in the list and click Add.
6. Turn on Sync automatically so every `git push` is picked up.

In the chat you get the document-style skill and the plugin commands (as skills). Agents and the hook show up greyed out because they don't run in the chat; they do in Cowork and Claude Code.

## 4. Connectors

In Customize > Connectors, connect only what you really use (for example GitHub or Google Drive). Each connector adds tools to the context, so fewer is better.

## 5. One Project per area of work

A Project groups chats, files and instructions on one topic.

1. Create a Project per product, client, course or large piece of work.
2. Paste the template from [claude-ai/project-instructions.md](../claude-ai/project-instructions.md) into its instructions and fill in the brackets.
3. Upload the brief, the requirements or rubric, and the reference material. Claude checks every deliverable against them before handing it over.

## Using it

- Type `/` in the chat to see your skills and commands. The plugin's ones appear as `jzuletadev-core:...`.
- You don't need to call the skill by hand: if you ask for a report, Claude loads it on its own.

## Troubleshooting

- The plugin doesn't appear in Discover: go to Customize > Plugins > Your plugins; plugins from your own marketplaces show up there.
- I changed the repo and nothing updates: in the marketplace click Check for updates.
- I had a standalone style skill and now there are two: delete the standalone one in Customize > Skills and keep the plugin's.
- After updating to plugin 2.0 the old Spanish names (explorador, estilo-documentos...) still show: click Check for updates; the agents and the skill were renamed to English.
