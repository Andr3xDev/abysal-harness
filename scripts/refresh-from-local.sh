#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

copy_dir() {
  local source="$1"
  local target="$2"
  mkdir -p "$target"
  tar \
    --exclude='./node_modules' \
    --exclude='./sessions' \
    --exclude='./cache' \
    --exclude='./logs' \
    --exclude='./projects' \
    --exclude='./paste-cache' \
    --exclude='./jobs' \
    --exclude='./statsig' \
    --exclude='./ide' \
    --exclude='./shell-snapshots' \
    --exclude='./backups' \
    --exclude='./plugins/cache' \
    -C "$source" -cf - . | tar -C "$target" -xf -
}

copy_dir "$HOME/.claude/agents" "$ROOT/agents"
copy_dir "$HOME/.claude/commands" "$ROOT/commands"
copy_dir "$HOME/.claude/skills" "$ROOT/skills"
copy_dir "$HOME/.claude/hooks" "$ROOT/hooks"
find "$ROOT/hooks" -type f ! -name '*.sh' -delete
cp "$HOME/.claude/CLAUDE.md" "$ROOT/configs/CLAUDE.md"
cp "$HOME/.claude/settings.json" "$ROOT/configs/claude-settings.json"
cp "$HOME/.claude/common-sdd.md" "$ROOT/configs/common-sdd.md"
cp "$HOME/.claude/engram-protocol.md" "$ROOT/configs/engram-protocol.md"
cp "$HOME/.claude/rules/context7.md" "$ROOT/configs/context7.md"
copy_dir "$HOME/.config/opencode" "$ROOT/opencode"

rm -f "$ROOT/opencode/.gitignore"
rm -f "$ROOT/opencode/bun.lock"
find "$ROOT" -name .DS_Store -delete

echo "refreshed code-agents from local config"
