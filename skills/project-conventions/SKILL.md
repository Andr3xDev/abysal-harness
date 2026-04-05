---
name: sainapsis-conventions
description: >
  Unified entry point for all Sainapsis project conventions. Activates when
  writing, reviewing, or refactoring code that falls under any registered
  convention (testing, logging, etc.). Routes to the specific convention
  skill and enforces its rules. Extensible — new conventions are added as
  subdirectories with their own SKILL.md.
---

# Sainapsis Conventions

Single entry point for every coding convention used at Sainapsis.
Each convention lives in its own subdirectory and is self-contained.

---

## Scope

Covers **all** project-level conventions registered below.
Does NOT cover tooling setup, CI/CD config, or infrastructure — only code-level patterns and practices.

---

## Registered Conventions

| Convention | Directory | Trigger |
|---|---|---|
| **Pytest** | `pytest/` | Writing or refactoring Python tests (fixtures, mocking, parametrize, markers) |
| **Logging** | `logging-like-a-pro/` | Adding, reviewing, or refactoring logging in any Python application |

---

## Behavior

1. Identify which convention(s) apply to the current task.
2. Load the corresponding `SKILL.md` from the subdirectory.
3. Follow the rules defined there — they are authoritative for their domain.
4. If multiple conventions apply (e.g., logging inside a test), apply all relevant ones without conflict. If rules conflict, ask the user.

---

## Adding a New Convention

1. Create a new subdirectory under `project-conventions/` with a descriptive kebab-case name.
2. Add a `SKILL.md` with at minimum a frontmatter `name` and `description`.
3. Add the convention to the **Registered Conventions** table above.
4. Supporting files (examples, references) go in the same subdirectory.

---

## Constraints

- Do not invent conventions — only enforce what is explicitly documented in a registered subdirectory.
- Do not merge or flatten convention files into this root skill — each convention stays self-contained.
- If a task doesn't match any registered convention, say so and proceed without imposing rules.
