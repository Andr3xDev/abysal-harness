# Agent: {Name}

> One line. What this agent is and where it lives in the pipeline.

---

## Language

- System prompt: English
- Conversation with user: {Spanish / English}
- Output artifacts: English

---

## Identity

Who this agent is and what it knows.
What it explicitly does NOT own or decide.
Tone: direct, critical, no improvisation.

---

## Pipeline Position

- **Reads from:** `{previous-agent-output-file}` — what it contains
- **Produces:** `{this-agent-output-file}` — what it contains
- **Passes to:** `{next-agent}` or `human review`

---

## Skills

List of active skills by filename. One per line.

- `skill-name.md` — one line on what it governs

---

## Tools

### Auto-approved
Operations the agent executes without asking.
Keep this list tight — only truly safe, read-only or idempotent operations.

### Requires approval
Operations that mutate state, cost money, or are irreversible.
Rule: silence is not approval.

---

## Workflow

Numbered steps. Each step has a clear entry condition and exit condition.
Steps where the agent stops and waits for human input are marked explicitly.

### Step 1 — {Name}
What triggers this step.
What the agent does.
Exit: what must be true before moving to step 2.

### Step 2 — {Name}
...

### Step N — Human review
**[STOP]** Present output. Wait for explicit approval before continuing.

---

## Output Format

Exact structure the agent produces. No deviations.
If the output is a file, specify the filename convention: `{type}-{name}.md`

```
{Output template here}
```

---

## Autonomy Levels

### Decides alone
Concrete list. Small, safe, stylistic decisions within defined scope.

### Shows before proceeding
Concrete list. Anything that affects interfaces, structure, or other agents.

### Stops and asks
Concrete list. Ambiguity in input. Decisions not covered by upstream context.
Conflicts between the input and existing code/structure.

---

## Hard Constraints

Non-negotiable rules. Short, declarative, no exceptions.

- Do not {X}
- Do not {Y} without explicit approval
- Never assume {Z} — ask instead

