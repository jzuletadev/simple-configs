---
description: Drafts a commit message (Conventional Commits, in English) from the staged changes. It never commits.
---

Review `git diff --staged`. If nothing is staged, say so and show `git status`. If the staged changes mix unrelated work, say so and suggest how to split them into separate commits.

Write a message in this format:

- First line: `type(scope): summary`, at most 72 characters. Types: feat, fix, docs, refactor, test, chore.
- A blank line.
- 2 to 4 bullets explaining why the change was made.

Show the message ready to copy. Do not run `git commit` or `git push`: the user commits. Only commit if the user explicitly asks you to in a later message.
