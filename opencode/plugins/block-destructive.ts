import type { Plugin } from "@opencode-ai/plugin"

// Block-destructive OpenCode plugin — ports /home/andrex/.claude/hooks/block-destructive.sh.
//
// Claude Code's PreToolUse hook blocks by exiting with code 2. OpenCode's
// `tool.execute.before` hook has no documented `deny`/`output.error` field in its
// type signature (Promise<void>, output only exposes `args`) — there is no
// dedicated "denial" return value. The plugin marketplace convention (and the
// only mechanism consistent with the hook's void return type) is: throwing
// inside `tool.execute.before` aborts the tool call. This assumption could not
// be independently confirmed from source (opencode ships as a compiled binary,
// no server dispatch source found on this machine) — flagged for verification.
//
// Git history operations (commit/push/merge/rebase/reset) are NOT hard-blocked
// here. They are gated per-agent via native Opencode `bash` permission `"ask"`
// pattern rules in opencode.json (orchestrator, implementer), so the human
// confirms interactively each time — matching their preference that commits
// and pushes only happen on explicit order, without a blanket plugin veto.

const DESTRUCTIVE_PATTERN = /rm -rf|DROP TABLE|DROP DATABASE|TRUNCATE|reset --hard/i
const FORCE_DELETE_PATTERN = /rm -f[^i]|rm [^-]*\*|shred|wipefs/i

export const BlockDestructivePlugin: Plugin = async () => {
  return {
    "tool.execute.before": async (input, output) => {
      const tool = String(input?.tool ?? "").toLowerCase()
      if (tool !== "bash" && tool !== "shell") return

      const args = output?.args
      if (!args || typeof args !== "object") return

      const command = (args as Record<string, unknown>).command
      if (typeof command !== "string" || !command) return

      if (DESTRUCTIVE_PATTERN.test(command)) {
        throw new Error(
          "BLOCKED: destructive command detected. Mandament #4 — no destructive commands without explicit AUTH."
        )
      }

      if (FORCE_DELETE_PATTERN.test(command)) {
        throw new Error(
          "BLOCKED: file deletion detected. Mandament #3 — never delete without confirmation."
        )
      }
    },
  }
}
