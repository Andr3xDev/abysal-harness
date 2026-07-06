---
description: Debug an error, failing test, or production issue
---

Activate DEBUG MODE for: $ARGUMENTS

Follow the orchestrator's debug mode workflow:
1. Detect working directory and project context
2. Search Engram for prior occurrences of this error
3. Delegate to debugger with:
   - Error context from "$ARGUMENTS" (stack trace, error message, reproduction steps)
   - AUTH: diagnose-only (default). Add AUTH: apply-fix only if the user explicitly says "fix it"
4. Present root cause analysis and proposed fix
5. If AUTH was apply-fix: run sdd-verify after the fix

If "$ARGUMENTS" is a stack trace, pass it verbatim to the debugger.
