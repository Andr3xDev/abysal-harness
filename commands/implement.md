---
description: Implement a planned change — TDD loop with test-writer, implementer, and code-reviewer
---

Activate IMPLEMENT MODE for: $ARGUMENTS

Follow the orchestrator's implement mode workflow:
1. Detect working directory and project context
2. Check SDD gate: verify spec exists for this change. If not → ask to run /plan first
3. Delegate: test-writer (red) → implementer (green) → code-reviewer → iterate if BLOCKERs
4. After all tasks complete: delegate to sdd-verify
5. Present verification report to human

If "$ARGUMENTS" references a specific task or subset, implement only those.
