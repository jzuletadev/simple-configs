---
description: Compares options for a technical decision and records the chosen one in docs/decisions/. It never commits.
argument-hint: "[decision to make]"
---

Decision to make: $ARGUMENTS

1. If the decision is not clear from the text above and the conversation, ask one question to define it and stop.
2. Use the architect agent to analyze it against the repo and the existing records in `docs/decisions/`.
3. Show the context, 2 or 3 options with pros, cons and risks, the recommendation and what evidence would change it. If an earlier record already covers this decision, say so.
4. Ask which option to record. Don't create files until the user answers.
5. Write `docs/decisions/NNNN-short-title.md` (next free 4-digit number) with a title and these sections: Status (accepted), Date, Context, Options considered, Decision, Consequences, Revisit when (the signal that should reopen it). If it replaces an earlier record, change that record's status to "superseded by NNNN".
6. Don't run `git commit` or `git push`.
