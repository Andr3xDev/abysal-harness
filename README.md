# code-agents

Personal Claude Code multi-agent harness — agents, commands, skills, hooks, and
config mirrored from `~/.claude`. Defines **how** the agents work; project-specific
context and specs live outside this repo (`~/dev/specter`).

## System overview

```
tech-orchestrator          strategist
  (decomposes, delegates)    (business/product discussion — no code)
        │
        ├── sdd-explore     → investigate before proposing
        ├── sdd-propose     → proposal.md
        ├── sdd-spec        → specs/spec.md (GIVEN/WHEN/THEN)
        ├── sdd-design      → design.md (ADR-lite)
        ├── sdd-tasks       → tasks.md (ordered, PR-size forecast)
        ├── test-writer     → failing tests (TDD red)
        ├── implementer     → minimal code to pass tests (TDD green)
        ├── code-reviewer   → spec/design/test conformance review
        ├── judge-a/judge-b → blind dual adversarial review (judgment-day)
        ├── debugger        → root cause + fix (per AUTH)
        └── sdd-verify → sdd-archive → PR description ready
```

The orchestrator never writes code directly — it delegates one task at a time
with a strict contract (`AGENT / TASK / CONTEXT / CONSTRAINTS / OUTPUT`), and
gates implementation on a complete spec (proposal + spec + design + tasks).

## Agents (`agents/`)

| Agent | Role |
|-------|------|
| `tech-orchestrator` | Entry point for any multi-step task. Decomposes, delegates, never codes. |
| `strategist` | Business-language discussion partner — epics/goals, no code, no delegation. |
| `sub-agents/sdd/*` | One agent per SDD phase: explore, propose, spec, design, tasks, verify, archive. |
| `sub-agents/tdd/test-writer` | Writes failing tests from specs (red phase). |
| `sub-agents/tdd/implementer` | Minimal implementation to turn tests green. |
| `sub-agents/review/code-reviewer` | Standard spec/design/test conformance review. |
| `sub-agents/review/judge-a`, `judge-b` | Blind parallel adversarial review for critical features. |
| `sub-agents/debug/debugger` | Root cause analysis; fixes only with explicit AUTH. |

Each SDD phase agent is an **executor**, not a sub-orchestrator: it does the
phase's work itself, never delegates further, and returns a structured
`status / executive_summary / artifacts / next_recommended / risks` envelope.

## Commands (`commands/`)

Slash-command entry points that route into the modes above: `/plan`,
`/implement`, `/explore`, `/debug`, `/review`, `/judgment-day`.

## Skills (`skills/`)

Reference material loaded on demand (not always-on context):

- `senior-architect/`, `software-design-patterns/`, `refactoring-techniques/` — architecture/design consultation
- `event-schema.md` — validate domain events are schema'd before implementation
- `context-compact.md` — preserve session state before `/compact` or `/clear`
- `judgment-day/` — blind dual-review protocol
- `find-docs.md`, `karpathy-guidelines.md` — library docs lookup, LLM-coding-mistake avoidance
- `skill-registry.md` — indexes skills by trigger phrase and path

## Configs (`configs/`)

Sanitized/generic versions of the global harness config (no user-specific
paths, tracker credentials, or personal notes — those live only in the
private `~/.claude/CLAUDE.md`):

- `generic-config.md` — engineering principles, agent commandments, delegation protocol
- `common-sdd.md` — shared executor-boundary protocol for all SDD phase agents
- `engram-protocol.md` — memory save/search triggers
- `mcp-servers.md` — MCP servers and plugins in use, no secrets

## MCP servers

| Server | Purpose |
|--------|---------|
| `engram` | Persistent memory across sessions (decisions, bugs, conventions) |
| `codegraph` | Symbol/call-graph index per project (`.codegraph/`) |
| `context7` | Up-to-date library/framework docs |
| `github` | Issues, PRs, repo search |
| `linear-server` | Linear issues/projects/initiatives |
| `filesystem` | Sandboxed filesystem access outside project root |
| `google-calendar` | Calendar read/write |

Full config (types, commands, plugin sources) in `configs/mcp-servers.md`.

## Hooks (`hooks/`)

| Hook | Trigger | Purpose |
|------|---------|---------|
| `block-destructive.sh` | PreToolUse (Bash) | Blocks destructive shell commands before execution |
| `stop-verify.sh` | Stop | Verifies work before letting the agent report done |
| `herdr-agent-state.sh` | SessionStart | Reports session state to `herdr` (external agent monitor) |
| `settings.json` | — | Full reference copy of live `~/.claude/settings.json` (hooks, permissions, plugins) |

## Memory system

- Episodic/semantic: [engram](https://github.com/Gentleman-Programming/engram) — MCP-backed persistent memory across sessions
- Structural: [codegraph](https://github.com/colbymchenry/codegraph) — per-project symbol/call-graph index (`.codegraph/`)
- Procedural: `skills/` — on-demand reference material
- Spec/change history: [OpenSpec](https://github.com/Fission-AI/openspec) convention, artifacts stored in `~/dev/specter/openspec/`

### Spec path convention

```
openspec/
├── config.yaml
├── changes/
│   ├── {project}/{change-name}/
│   │   ├── proposal.md
│   │   ├── design.md
│   │   ├── tasks.md
│   │   └── specs/spec.md
│   └── archive/{project}/{change-name}/   # closed changes
└── specs/{project}/{domain}/spec.md       # consolidated, updated on archive
```

`{project}` is the repo/service the change targets (e.g. `hyprland`, `nvim`,
`bridge-api`) — keeps unrelated projects from colliding under one flat
`changes/` directory.

## Communication/coding modes

Two independent, stackable plugin modes (default `full`, pinned in
`~/.config/{caveman,ponytail}/config.json`):

- **caveman** — governs *how the agent talks*: ultra-compressed prose, no filler
- **ponytail** — governs *how the agent codes*: YAGNI ladder, stdlib/native before custom, shortest working diff

See `configs/mcp-servers.md` for the full plugin/MCP list.
