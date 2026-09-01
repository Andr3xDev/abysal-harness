---
name: skill-registry
description: "Trigger: update skills, skill registry, refresh skills, after skill changes. Index available skills by trigger and path."
license: MIT
metadata:
  author: custom
  version: "1.0"
---

## Activation Contract

Use this skill after installing, removing, creating, moving, or renaming skills.
Also use when the orchestrator needs a fresh skill index for delegation.

## Hard Rules

- The registry is an INDEX, not a compiler. SKILL.md remains the source of truth.
- Pass exact skill paths to subagents — never generated summaries.
- Always write the registry file regardless of persistence mode.
- Save to Engram as `topic_key: skill-registry` when available.
- Skip `_shared` directory entries — those are conventions, not skills.
- Deduplicate by skill name, preferring project-level skills over global.

## Decision Gates

| Situation | Action |
|---|---|
| Same skill exists globally and in project | Keep the project-level skill |
| No skills found | Write an empty registry so agents stop searching blindly |
| Orchestrator will delegate work | Select matching registry rows and pass SKILL.md paths |
| Skill modified or added | Re-run this skill to refresh the index |

## Execution Steps

1. Scan skill directories for `*/SKILL.md`:
   - `~/.claude/skills/` (global)
   - `{project}/.claude/skills/` (project-level, if exists)
2. Read frontmatter only — extract `name` and `description` trigger text.
3. Write `.claude/skill-registry.md` with:
   ```
   # Skill Registry
   
   | Skill | Trigger | Scope | Path |
   |-------|---------|-------|------|
   | context-compact | compact, clear, context reset | global | ~/.claude/skills/context-compact.md |
   | event-schema | domain event, event schema | global | ~/.claude/skills/event-schema.md |
   ```
4. Persist to Engram:
   ```
   title: "skill-registry"
   topic_key: "skill-registry"
   type: "config"
   content: {registry markdown}
   ```
5. Return registry path, skill count, and cache status.

## Output Contract

Return:
- Registry file path
- Number of indexed skills
- Any skipped or duplicate skills
