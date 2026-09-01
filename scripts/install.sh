#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
STAMP="$(date +%Y%m%d-%H%M%S)"

backup() {
  local target="$1"
  if [ -e "$target" ] || [ -L "$target" ]; then
    mkdir -p "${target}.backups"
    mv "$target" "${target}.backups/${STAMP}"
  fi
}

install_dir() {
  local source="$1"
  local target="$2"
  mkdir -p "$target"
  cp -a "$source/." "$target/"
}

install_file() {
  local source="$1"
  local target="$2"
  mkdir -p "$(dirname "$target")"
  backup "$target"
  cp "$source" "$target"
}

backup "$HOME/.claude/agents"
backup "$HOME/.claude/commands"
backup "$HOME/.claude/skills"
backup "$HOME/.claude/hooks"
install_dir "$ROOT/agents" "$HOME/.claude/agents"
install_dir "$ROOT/commands" "$HOME/.claude/commands"
install_dir "$ROOT/skills" "$HOME/.claude/skills"
install_dir "$ROOT/hooks" "$HOME/.claude/hooks"
chmod +x "$HOME/.claude/hooks"/*.sh 2>/dev/null || true
install_file "$ROOT/configs/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
install_file "$ROOT/configs/claude-settings.json" "$HOME/.claude/settings.json"
install_file "$ROOT/configs/common-sdd.md" "$HOME/.claude/common-sdd.md"
install_file "$ROOT/configs/engram-protocol.md" "$HOME/.claude/engram-protocol.md"
mkdir -p "$HOME/.claude/rules"
install_file "$ROOT/configs/context7.md" "$HOME/.claude/rules/context7.md"
mkdir -p "$HOME/.local/bin"
install_file "$ROOT/scripts/codegraph-health.sh" "$HOME/.local/bin/codegraph-health"
chmod +x "$HOME/.local/bin/codegraph-health"

node - "$ROOT/configs/claude-mcp.json" "$HOME/.claude.json" <<'NODE'
const fs = require('fs');
const [source, target] = process.argv.slice(2);
const mcpServers = JSON.parse(fs.readFileSync(source, 'utf8'));
const config = fs.existsSync(target) ? JSON.parse(fs.readFileSync(target, 'utf8')) : {};
config.mcpServers = { ...(config.mcpServers || {}), ...mcpServers };
fs.writeFileSync(target, JSON.stringify(config, null, 2) + '\n');
NODE

backup "$HOME/.config/opencode"
mkdir -p "$HOME/.config/opencode"
tar \
  --exclude='./node_modules' \
  --exclude='./sessions' \
  --exclude='./cache' \
  --exclude='./logs' \
  -C "$ROOT/opencode" -cf - . | tar -C "$HOME/.config/opencode" -xf -

echo "installed code-agents config"
echo "next: set GITHUB_TOKEN, authenticate Linear/Claude connectors, ensure ~/.local/bin is in PATH, then run: claude doctor && opencode debug config"
