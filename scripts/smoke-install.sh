#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WORK="$(mktemp -d)"
trap 'rm -rf -- "$WORK"' EXIT
HOME="$WORK/home"
export HOME

mkdir -p "$HOME/.claude"/{agents,commands,skills,hooks,rules} "$HOME/.config/opencode"
printf 'old\n' > "$HOME/.claude/agents/stale.md"
printf '{"other":{"keep":true},"mcpServers":{"existing":{"command":"keep"}}}\n' > "$HOME/.claude.json"
"$ROOT/scripts/install.sh"

node - "$HOME" "$ROOT" <<'NODE'
const fs = require('fs');
const [home, root] = process.argv.slice(2);
for (const file of [
  `${home}/.claude/settings.json`, `${home}/.claude.json`,
  `${home}/.config/opencode/opencode.json`, `${home}/.config/opencode/tui.json`,
  `${home}/.config/opencode/package.json`, `${home}/.config/opencode/package-lock.json`,
]) JSON.parse(fs.readFileSync(file, 'utf8'));
const config = JSON.parse(fs.readFileSync(`${home}/.claude.json`, 'utf8'));
if (!config.other?.keep || !config.mcpServers.existing || !config.mcpServers.github) process.exit(1);
if (JSON.stringify(config.mcpServers.github) !== JSON.stringify(JSON.parse(fs.readFileSync(`${root}/configs/claude-mcp.json`, 'utf8')).github)) process.exit(1);
NODE

if command -v opencode >/dev/null 2>&1; then
  opencode debug config >/dev/null
  opencode mcp list >/dev/null
else
  echo 'SKIP: opencode unavailable; resolved config and MCP list not checked'
fi
if command -v claude >/dev/null 2>&1; then
  claude mcp list >/dev/null
else
  echo 'SKIP: claude unavailable; MCP list not checked'
fi

REPO="$WORK/repo"
mkdir -p "$REPO"
tar --exclude='./.git' -C "$ROOT" -cf - . | tar -C "$REPO" -xf -
printf 'stale\n' > "$REPO/agents/stale.md"
mkdir -p "$HOME/.claude/agents" "$HOME/.claude/commands" "$HOME/.claude/skills" "$HOME/.claude/hooks" "$HOME/.claude/rules" "$HOME/.config/opencode/sessions"
printf 'new\n' > "$HOME/.claude/agents/current.md"
printf 'new\n' > "$HOME/.claude/commands/current.md"
printf 'new\n' > "$HOME/.claude/skills/current.md"
printf '# local\n' > "$HOME/.claude/CLAUDE.md"
printf '{}\n' > "$HOME/.claude/settings.json"
printf 'local\n' > "$HOME/.claude/common-sdd.md"
printf 'local\n' > "$HOME/.claude/engram-protocol.md"
printf 'local\n' > "$HOME/.claude/rules/context7.md"
printf '{"local":true}\n' > "$HOME/.config/opencode/opencode.json"
for path in node_modules sessions cache logs projects paste-cache jobs statsig ide shell-snapshots backups plugins/cache; do
  mkdir -p "$HOME/.config/opencode/$path"
  printf 'transient\n' > "$HOME/.config/opencode/$path/skip"
done
printf 'secret\n' > "$HOME/.config/opencode/.env"
printf 'secret\n' > "$HOME/.config/opencode/private.key"
printf 'secret\n' > "$HOME/.config/opencode/auth.json"
"$REPO/scripts/refresh-from-local.sh"
STAMP="$(basename "$(ls -d "$REPO/.refresh-backups"/*)")"
[ -f "$REPO/.refresh-backups/$STAMP/opencode/package.json" ]
[ -f "$REPO/agents/current.md" ]
[ ! -e "$REPO/agents/stale.md" ]
for path in node_modules sessions cache logs projects paste-cache jobs statsig ide shell-snapshots backups plugins/cache .env private.key; do
  [ ! -e "$REPO/opencode/$path" ]
done
[ ! -e "$REPO/opencode/auth.json" ]
"$REPO/scripts/refresh-from-local.sh" --restore "$STAMP"
[ -f "$REPO/opencode/package.json" ]
"$REPO/scripts/refresh-from-local.sh" --clean-backups
[ ! -e "$REPO/.refresh-backups" ]
echo 'smoke passed'
