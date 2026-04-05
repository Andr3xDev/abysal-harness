---
name: {skill-name-kebab-case}
description: >
  One dense paragraph. Covers: what the skill does, when to trigger it,
  what keywords or conditions activate it, and what it produces.
  Written for the agent's routing logic — be specific, not generic.
---

# {Skill Title}

One line: what this skill governs and why it exists as a separate skill.

---

## Scope

What this skill covers.
What it explicitly does NOT cover (avoid overlap with other skills).

---

## Preconditions

What must exist or be defined before this skill activates.
If preconditions are not met, the agent states what is missing and waits.

---

## MCP Dependencies

Only if this skill requires external tool connections.

- **{MCP Name}** — what it's used for
- If unavailable: what the fallback behavior is

Omit this section if no MCPs are needed.

---

## Behavior

Step-by-step instructions. Declarative and unambiguous.
No "try to" or "consider" — only "do" or "do not".

Use numbered steps when order matters.
Use bullet points when order doesn't matter.

---

## Output Format

Exact structure this skill produces.
Include filename convention if it generates a file: `{type}-{name}.md`
Include a minimal example if the format is non-obvious.

```
{Template or example here}
```

---

## Control Points

Explicit moments where the agent pauses and waits for human confirmation
before continuing. Be specific about what triggers the pause.

- After {action}: show {artifact} and wait for approval before {next action}
- If {condition}: stop, state the issue, do not proceed

---

## Constraints

- Do not {X}
- Do not decide {Y} — that is upstream responsibility
- If {edge case}: {exact behavior}
