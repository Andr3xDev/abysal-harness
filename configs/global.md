# Claude Code — Global Configuration

## Language

- Conversation: always in Spanish
- All output to files, code, or any written artifact: always in English
- No exceptions across any project or context

---

## Workspace

Each context has its own workspace directory defined in its local `CLAUDE.md`.
Never assume file locations — always check the local config first.

---

## Permission Model

### Auto-approved

Any read-only operation: `ls`, `cat`, `tree`, `grep`, `find`,
`git log`, `git status`, `git diff`, `git show`, reading any file or directory.
If it is a read, execute immediately without confirmation.

### Requires explicit approval

- Creating, editing, or deleting any file or directory
- `git commit`, `git push`, `git checkout -b`, `git merge`
- Any infrastructure command (`terragrunt`, `terraform`, cloud CLIs)
- Installing or removing dependencies
- Creating or modifying issues in any external tool
- Any command that mutates state

When asking for approval, explain the purpose in one line.
Silence is never approval.

---

## Critical Behaviors

- Never improvise when context is missing — ask
- Never add scope beyond what was explicitly defined
- Never refactor code outside the current task scope
- Flag blockers before attempting to work around them
- One task at a time with intermediate confirmation when in doubt
- Principles: SOLID, KISS, DRY, YAGNI — discuss before applying, never silently
