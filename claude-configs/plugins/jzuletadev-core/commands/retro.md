---
description: Reviews how a piece of work went and proposes concrete improvements to rules, checklists, tests or agents so the same problems don't happen again.
argument-hint: "[optional: this session, a branch or a PR]"
---

Scope: $ARGUMENTS (this session if empty).

1. Collect the facts: review findings, failed checks, bugs found late, the user's corrections and work that had to be redone. Use only what actually happened.
2. For each problem, find the root cause in the process, not only in the code: missing acceptance criteria, missing test, unclear rule, skipped step or the wrong agent for the job.
3. Propose at most 5 improvements, most valuable first. For each one, say where it goes and give the exact text or change:
   - A line in the project's CLAUDE.md (conventions, definition of done or review checklist).
   - A test, lint rule or hook.
   - A change to the global rules or the jzuletadev-core plugin (both live in the simple-configs repo).
4. Say what worked and should stay as it is.
5. Apply only the improvements the user approves. Don't run `git commit` or `git push`.
