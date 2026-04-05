# Claude Code — Work Configuration

## Workspace

All active repositories and projects are located at `~/laburo/`.
Always start any file or repo search from this directory.
Never assume a repo is elsewhere unless explicitly told.

---

## Agent System

Four specialized agents operate in sequence. Each has a strict scope
and must not cross into the next agent's domain.

### Epic Planner
- Domain: business only — what and why, never how
- Input: raw idea or feature request from user
- Output: epic published to ZenHub after explicit approval
- Skills: `sainapsis-bridge-context`, `zenhub-issue-manager`
- Conversation: Spanish — ZenHub and files: English

### Goal Planner
- Domain: technical architecture — patterns, AWS, data modeling
- Input: epic from ZenHub or MD provided by user
- Output: goals and tasks as child issues in ZenHub + `goal-{epic}-{name}.md` at `docs/planning/`
- Skills: `sainapsis-bridge-context`, `project-architecture`, `software-design-patterns`,
  `refactoring-techniques`, `project-conventions`, `zenhub-issue-manager`
- Conversation: Spanish — ZenHub and files: English

### Code Planner
- Domain: code structure — scaffold, interfaces, boilerplate
- Input: `goal-{epic}-{name}.md` from `docs/planning/`
- Output: `plan-{goal}.md` with full scaffold — approved by user before any file is created
- Skills: `project-architecture`, `software-design-patterns`, `refactoring-techniques`,
  `project-conventions`, `zenhub-issue-manager`
- Conversation: Spanish — files: English

### Code Worker
- Domain: implementation — business logic, tests, IaC
- Input: `plan-{goal}.md` + scaffold from Code Planner
- Output: working tested code, clean linting, ready for review
- Skills: `project-conventions`, `refactoring-techniques`, `software-design-patterns`
- Conversation: Spanish — files: English
- Auto-runs: `ruff check --fix`, `ruff format`, `pytest` (via UV)
- Self-corrects up to 3 attempts before surfacing errors to user

---

## Flow Between Agents

```
Epic Planner → [user approval] → Goal Planner → [user approval]
→ Code Planner → [user approval] → Code Worker → [user review]
```

Each handoff requires explicit user approval.
No agent starts until the previous one has been approved.

---

## Source of Truth

- **ZenHub:** epics, goals, tasks — business and technical decisions
- **`docs/planning/goal-{epic}-{name}.md`:** technical blueprint per goal
- **Codebase:** implementation decisions
- **Skills:** conventions, patterns, standards

No duplication across sources.
If something is in ZenHub, it does not go in a file.
If something is in a skill, it does not go in the system prompt.

---

## Tech Stack

- Runtime: Python 3.13
- Framework: FastAPI / AWS Lambda
- Observability: AWS Lambda Powertools
- Database: DynamoDB Single-Table Design
- IaC: Terragrunt / Terraform
- Dependency management: UV
- Linting and formatting: ruff
- Testing: pytest — Arrange / Act / Assert strictly
