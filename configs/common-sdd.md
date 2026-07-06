# SDD Phase — Common Protocol

Boilerplate shared across all SDD phase agents.
Sub-agents MUST follow this alongside their phase-specific instructions.

---

## A. Executor boundary

Every SDD phase agent is an EXECUTOR, not an orchestrator.
Do the phase work yourself. Do NOT launch sub-agents, do NOT call the Task tool,
and do NOT bounce work back unless the phase explicitly says to stop and report a blocker.

---

## B. Skill loading

1. Check if the orchestrator injected a `## Skills to load before work` block in your
   delegation prompt. If yes, read those exact SKILL.md files before starting.
2. If no skills block was provided, proceed with your phase instructions only.
3. The orchestrator resolves skills — sub-agents do not self-discover.

---

## C. Artifact retrieval (Engram)

**CRITICAL**: `mem_search` returns 300-char PREVIEWS, not full content.
You MUST call `mem_get_observation(id)` for EVERY artifact you need.
Skipping this produces wrong output.

Run all searches in parallel, then all retrievals in parallel:

```
STEP 1 — SEARCH (get IDs):
  mem_search(query: "sdd/{change-name}/proposal") → save ID
  mem_search(query: "sdd/{change-name}/spec")     → save ID

STEP 2 — RETRIEVE FULL CONTENT (mandatory):
  mem_get_observation(id: {proposal_id})
  mem_get_observation(id: {spec_id})
```

Do NOT use search previews as source material.

---

## D. Artifact persistence

Every phase that produces an artifact MUST persist it.
Skipping this BREAKS the pipeline — downstream phases will not find your output.

```
mem_save(
  title:     "sdd/{change-name}/{artifact-type}",
  topic_key: "sdd/{change-name}/{artifact-type}",
  type:      "architecture",
  content:   "{your full artifact markdown}"
)
```

`topic_key` enables upserts — saving again with the same key updates, not duplicates.

### Artifact types

| Artifact | Produced by | Description |
|----------|-------------|-------------|
| explore | sdd-explore | Exploration analysis |
| proposal | sdd-propose | Change proposal |
| spec | sdd-spec | Delta specifications |
| design | sdd-design | Technical design |
| tasks | sdd-tasks | Task breakdown |
| apply-progress | implementer | Implementation progress |
| verify-report | sdd-verify | Verification report |
| archive-report | sdd-archive | Archive closure |
| state | orchestrator | DAG state for recovery |

---

## E. Return envelope

> **CRITICAL — Response ordering**: persist artifacts (mem_save) BEFORE your
> final text response. Your last output MUST be text, NOT a tool call.
> If you end with a tool call, the orchestrator receives only the tool result —
> your analysis is lost.

Every phase MUST return this structured envelope:

```
status: done | blocked | partial
executive_summary: 1-3 sentence summary of what was done
artifacts: list of artifact keys or paths written
next_recommended: next SDD phase to run, or "none"
risks: risks discovered, or "none"
```

Sub-agents must NOT call `mem_session_summary` — that's for the orchestrator only.

---

## F. PR review workload guard

SDD must protect reviewer cognitive load:

- Default PR review budget: **400 changed lines** (additions + deletions)
- `sdd-tasks` MUST forecast whether the planned work exceeds that budget
- If forecast is High: recommend splitting into chained work units
- Include in tasks.md: `PR size risk: Low | Medium | High`
- Each work unit must have: clear start, clear finish, autonomous scope, verification

---

## G. Persistence mode

The orchestrator may pass `artifact_store.mode`:

| Mode | Read from | Write to | Project files |
|------|-----------|----------|---------------|
| engram (default) | Engram | Engram | Never |
| openspec | Filesystem | Filesystem | Yes |
| hybrid | Both | Both | Yes |

- `engram` mode: upserts overwrite — no revision history. For iteration history use `openspec`.
- `openspec` mode: files in `openspec/changes/{change-name}/`. Git history provides audit trail.
- `hybrid` mode: both — Engram for recovery + files for team. Higher token cost.
- Default if not specified: `engram`
