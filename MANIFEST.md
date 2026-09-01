# Config Manifest

Portable source for my agent setup across machines.

## Installs

- Claude Code agents: `agents/` -> `~/.claude/agents/`
- Claude Code commands: `commands/` -> `~/.claude/commands/`
- Claude Code skills: `skills/` -> `~/.claude/skills/`
- Claude hooks: `hooks/*.sh` -> `~/.claude/hooks/`
- Claude global instructions: `configs/CLAUDE.md` -> `~/.claude/CLAUDE.md`
- Claude settings/hooks reference: `configs/claude-settings.json` -> `~/.claude/settings.json`
- Claude MCP registry: `configs/claude-mcp.json` -> merged into `~/.claude.json#mcpServers`
- Claude helper docs: `configs/common-sdd.md`, `configs/engram-protocol.md`, `configs/context7.md` -> `~/.claude/`
- CodeGraph helper: `scripts/codegraph-health.sh` -> `~/.local/bin/codegraph-health`
- OpenCode config: `opencode/` -> `~/.config/opencode/`

## Not Included

- Secrets: `GITHUB_TOKEN`, Linear auth, Claude cloud connector auth
- Runtime data: Claude history, project transcripts, paste cache, jobs, stats
- Dependency caches: `node_modules`, plugin caches, OpenCode sessions/logs
- Machine-specific cloud connectors: disconnect/connect at `https://claude.ai/customize/connectors`

## Required Commands

- `claude`
- `opencode`
- `node` and `npm`/`npx`
- `engram`
- `codegraph`
- `openspec`

## Helper Scripts

- `codegraph-health`: shared CodeGraph health/maintenance helper for Claude Code and OpenCode agents.

## Expected MCPs

- `context7`: `npx -y @upstash/context7-mcp`
- `codegraph`: `codegraph serve --mcp`
- `engram`: `engram mcp`
- `filesystem`: `npx -y @modelcontextprotocol/server-filesystem /home/andrex/dev /home/andrex/laburo/`
- `github`: `npx -y @modelcontextprotocol/server-github` with `GITHUB_TOKEN`
- `linear-server`: `https://mcp.linear.app/mcp`
- `caveman`: OpenCode local MCP when installed

## Refresh

Run `./scripts/refresh-from-local.sh` on the source machine after changing live config.
Review diff before committing.
