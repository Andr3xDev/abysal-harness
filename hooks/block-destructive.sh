#!/usr/bin/env bash
# PreToolUse hook — blocks destructive commands (mandaments #3, #4, #11)
# Exit 2 = block the tool call. Exit 0 = allow.

INPUT=$(cat)
CMD=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

if [ -z "$CMD" ]; then
  exit 0
fi

# Mandament #4: No destructive commands
if echo "$CMD" | grep -qEi 'rm -rf|DROP TABLE|DROP DATABASE|TRUNCATE|reset --hard'; then
  echo "BLOCKED: destructive command detected. Mandament #4 — no destructive commands without explicit AUTH." >&2
  exit 2
fi

# Mandament #11: No git commits, no git push
if echo "$CMD" | grep -qEi 'git commit|git push|git merge|git rebase|git reset'; then
  echo "BLOCKED: git history operation detected. Mandament #11 — human decides when to commit." >&2
  exit 2
fi

# Mandament #3: No force deletes
if echo "$CMD" | grep -qEi 'rm -f[^i]|rm [^-]*\*|shred|wipefs'; then
  echo "BLOCKED: file deletion detected. Mandament #3 — never delete without confirmation." >&2
  exit 2
fi

exit 0
