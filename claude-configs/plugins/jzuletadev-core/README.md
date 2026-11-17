# jzuletadev-core

Plugin for Claude (chat, Cowork and Claude Code) built around one loop: decide with evidence, build in small steps, verify the result, and turn every review into a lesson the next task uses.

## Agents

| Agent | Model | Role | Edits files |
| :- | :- | :- | :- |
| `explorer` | haiku | Finds and summarizes code | No |
| `architect` | opus | Compares options, plans large or hard-to-undo changes, drafts decision records | No |
| `developer` | sonnet | Implements a defined task with its tests; several can work in parallel on independent tasks | Yes |
| `tester` | sonnet | Checks the acceptance criteria, adds missing tests, runs the suite | Tests only |
| `reviewer` | sonnet | Reviews the diff by severity and proposes how to prevent repeated problems | No |
| `docs-writer` | sonnet | READMEs, technical docs and reports | Yes |

## Commands

- `/jzuletadev-core:decision`: compares options for a decision and, once you choose, records it in `docs/decisions/`.
- `/jzuletadev-core:verify`: quality gate for the current changes (tester, then reviewer) with a ready / not ready verdict and evidence.
- `/jzuletadev-core:retro`: reviews how a piece of work went and proposes improvements to rules, checklists, tests or this plugin.
- `/jzuletadev-core:commit`: drafts a Conventional Commits message in English from the staged changes.

None of them commits; you do.

## Other pieces

- Skill `document-style`: format, academic tone and a final check against the brief for deliverable documents (written in Spanish).
- PostToolUse hook: formats every file Claude edits with Prettier, only if the project has Prettier installed. Needs Node.js on the PATH.

## Workflow

1. Plan: explorer to understand the code; architect or `/decision` only for large or hard-to-undo changes. Define the acceptance criteria.
2. Do: developer implements, with tests.
3. Check: `/verify` runs the tester and the reviewer; fix what blocks.
4. Act: after a bad review or a bug that got through, `/retro` turns the lesson into a rule, a test or a review-checklist line.
5. `/commit` drafts the message; you commit.

## Install

In Claude Code:

```
/plugin marketplace add jzuletadev/simple-configs
```

```
/plugin install jzuletadev-core@jzuletadev-configs
```

In claude.ai: Customize > Plugins > Add > Add marketplace > `jzuletadev/simple-configs`.
