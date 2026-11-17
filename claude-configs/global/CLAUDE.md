# Global rules (apply to every project)

## Communication

- Reply in Spanish and address me as "tú".
- Short bullets in natural language; little bold and few sections.
- Give me one recommendation, not a list of options. Only when the decision is mine (cost, security, hard to undo), show up to 3 options with their trade-offs and mark the one you recommend.

## Commands

- Default to Windows 11 with PowerShell unless I say Ubuntu, Arch or WSL.
- Commands ready to copy and paste, without prompt prefixes.

## Code

- Before creating something new, check whether the repo already has something reusable.
- Don't add dependencies without asking me.
- Small, focused changes; don't rewrite whole files when an edit is enough. Stay inside the task: mention unrelated problems instead of fixing them.
- Never read or print `.env` files or secrets.

## Quality of results

- Before a non-trivial task, define how it will be checked: acceptance criteria and the tests or commands that prove them.
- Don't say something is done without evidence: run the tests, build and linter that apply and report the result. If something could not be verified, say what and why.
- Report failures as they are, with the relevant output. Never weaken, skip or delete a test to make it pass.
- If the cause of a bug is unclear, find it before changing code; don't stack guesses.

## Decisions

- Base decisions on what the code, the docs and the test results show; label assumptions as such.
- When we make a significant decision (architecture, dependencies, data model, public APIs), offer to record it with `/decision` in `docs/decisions/`.
- If a request contradicts a recorded decision or the project's CLAUDE.md, point it out before continuing.

## Review and continuous improvement

- After a non-trivial change, run the reviewer agent and fix critical and high findings before reporting.
- When a review, a failed check or a correction from me shows a mistake that can happen again, propose how to prevent it: a test, a lint rule or a line in the project's review checklist. Apply it only after I approve.
- After a bad review or a bug that got through, suggest running `/retro`.

## Git

- Never run `git commit` or `git push` unless I explicitly ask for it in that message. Finishing a task, a clean review, `/verify` or `/commit` are not permission: leave the changes uncommitted and tell me they are ready.
- Commit messages in English, Conventional Commits format.

## Agents (jzuletadev-core plugin)

- Small, clear changes: do them directly and run the relevant check.
- Larger work: explorer to understand the code, architect first if it is large or hard to undo, developer to implement (one per independent task, in parallel only when they touch different files), then `/verify` (tester and reviewer) before reporting.
- docs-writer for documentation; apply the document-style skill to deliverable documents.
