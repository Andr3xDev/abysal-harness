---

name: zenhub-issue-manager
description: >
  Compose and publish GitHub issues structured for ZenHub workflows — EPICs, GOALs, and TASKs —
  with standardized formatting and MCP execution. Trigger whenever the user or an agent wants to
  create, update, or link issues in ZenHub/GitHub. Activate on any mention of "issue", "epic",
  "goal", "task", "ticket", "ZenHub", or requests to plan, break down, or track work in a repository.
  Also trigger when managing labels, milestones, or parent-child relationships between issues.
  This skill handles the full lifecycle: composing the body with the correct structure per issue type,
  executing via ZenHub and GitHub MCPs, and linking to parent issues.

---

# ZenHub Issue Manager

Composes and publishes GitHub issues formatted for ZenHub. Covers three issue types — EPIC, GOAL,
and TASK — each with a distinct structure. Execution only: by the time this skill activates, the
content has already been discussed and approved.

---

## Scope

Covers: issue composition, creation, update, labeling, and parent-child linking in ZenHub/GitHub.
Does not cover: defining the content of epics or goals — that belongs to the Epic Planner and Goal Planner agents.

---

## Preconditions

- Content has been discussed and approved by the user before this skill executes
- Issue type is known (EPIC, GOAL, or TASK)
- Category prefix is known or will be asked

If either is missing, ask before composing anything.

---

## MCP Dependencies

- **ZenHub MCP** — create/update issues, manage epics, link parent-child relationships, generate ZenHub URLs
- **GitHub MCP** — fallback for issue operations and reference validation

If ZenHub MCP is unavailable: inform the user, generate the markdown anyway for manual use.
If GitHub MCP is unavailable: warn that references cannot be validated, proceed with provided information.

---

## Naming Convention

```
[{prefix}] {Title}
```

Prefix options: `Back`, `Infra`, `Web`, `Mobile`, `Back & Infra`.
Ask if not specified. Title must be action-oriented and describe the feature — not implementation details.

---

## Formatting Rules

Apply strictly to all generated content:

- No emojis anywhere in the body
- Headers start at `##` — the issue title is the implicit `#`
- No horizontal rules (`---`) — use `<br>` for visual separation between major sections
- No redundant labels — do not add a "Description" header or repeat the title in the body
- All issue content written in English regardless of conversation language

---

## Issue Structures

### EPIC

```markdown
{High-level description: what, why, and business value.
Sub-sections with ## or ### as needed. Focus on what and why, not how.}

<br>

## User Stories & Acceptance Criteria

### User Story 1
As a {Role}, I want to {Action} so that {Benefit}.

**Acceptance Criteria:**
- Given {precondition}, When {action}, Then {expected result}

{Repeat for each story}

<br>

## Edge Cases
- {Edge case: description and expected handling}

<br>

## Context
{Parent goals, related epics, dependencies, background.}
```

EPICs do not include technical sections — those belong in GOALs and TASKs.

### GOAL

```markdown
{Description: what this achieves and why it matters.}

<br>

## {Section Title}
{Content — API contracts, data models, architecture decisions, infrastructure needs,
dependencies, rollback plans, or anything relevant. Sections are defined by context,
there is no fixed list.}

{Repeat sections as needed}

<br>

## Edge Cases
- {Edge case}

<br>

## Context
{Parent epic, sibling goals, dependent tasks — using cross-reference format.}
```

### TASK

Same structure as GOAL. Difference is semantic: smaller scope, assignable to one person or sprint.

---

## Cross-Reference Format

When referencing another issue:

```markdown
[{owner}/{repo}#{number}](https://app.zenhub.com/workspaces/{workspace-id}/issues/gh/{owner}/{repo}/{number})
```

When the user mentions an issue by number or description, validate it via GitHub MCP before including the reference.

---

## Behavior

### Creating an issue

1. Confirm issue type — ask if not clear
2. Confirm prefix — ask if not specified
3. Validate any referenced issues via GitHub MCP
4. Compose the body following the structure for the issue type
5. **[STOP]** — show the composed body and wait for approval before publishing
6. Create via ZenHub MCP — fall back to GitHub MCP if unavailable
7. Apply labels, milestone, and metadata as specified
8. Link to parent epic or goal if specified
9. Confirm with the ZenHub URL

### Modifying an issue

1. Find the issue via GitHub MCP
2. Compose the updated content
3. **[STOP]** — show the changes and wait for approval before applying
4. Apply via ZenHub/GitHub MCP
5. Confirm with the issue URL

---

## Control Points

- After composing any issue body: show the full draft and wait for explicit approval before creating or updating
- After composing changes to an existing issue: show a diff or the new content and wait for approval
- If the prefix is not specified: ask before composing
- If a referenced issue cannot be validated: warn and wait for confirmation to proceed with unvalidated reference

---

## Constraints

- Do not create or update any issue without explicit approval
- Do not define or modify the content scope — only execute what was already approved
- Do not add sections not in the defined structure without flagging it first
- Do not assume silence is approval
- If ZenHub MCP fails: generate the markdown and inform the user — do not retry silently
