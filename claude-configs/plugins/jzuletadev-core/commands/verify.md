---
description: Quality gate for the current changes - checks the acceptance criteria with the tester and reviewer agents and gives a ready or not-ready verdict with evidence. It never commits.
argument-hint: "[optional: task or acceptance criteria]"
---

Task or criteria: $ARGUMENTS

1. Set the acceptance criteria from the text above, the conversation, the plan or the "Definition of done" in the project's CLAUDE.md. If there are none, derive them from the request and mark them as derived.
2. Use the tester agent to check each criterion and run the tests, build and linter.
3. Then use the reviewer agent on the diff, including the tests the tester added and the project's review checklist.
4. Report:
   - Criteria table: criterion, evidence (test or command), result.
   - Review findings by severity.
   - Verdict: ready, ready after fixes, or not ready, and the next step.
   - Prevention: lessons worth adding to the project's review checklist, if any.
5. Don't fix anything, commit or push unless the user asks.
