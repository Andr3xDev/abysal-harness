---
description: Run blind dual adversarial review with two judges — for critical features
---

Activate JUDGMENT DAY for: $ARGUMENTS

Load the judgment-day skill from the skill registry.
Follow the protocol exactly:
1. Confirm target scope from "$ARGUMENTS"
2. Resolve skills from registry — inject into both judge prompts
3. Launch judge-a and judge-b in parallel with identical target
4. Synthesize into verdict table (confirmed, suspect, contradiction, INFO)
5. Present to human — ask before fixing
6. If fixes approved: delegate to implementer with AUTH: apply-fix
7. Re-judge after fixes — repeat until APPROVED or ESCALATED
