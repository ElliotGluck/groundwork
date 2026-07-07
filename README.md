# Groundwork

**A grounded operating system for AI coding agents** — Claude Code, Codex CLI, OpenCode, Cursor, and
any harness that reads the universal [SKILL.md](https://agentskills.io) / AGENTS.md standards.

Groundwork runs your agent as a **grounded orchestrator**: it plans in flat phases sized by *logical
commitments* (not vibes), delegates implementation to scoped sub-agents with grounded briefs,
supervises and verifies every return, keeps its context clean — and refuses, at every level, to
invent facts, skip tasks it doesn't understand, or abandon achievable work over one blocker.

→ Full overview, design rationale, and benchmarks: **[OVERVIEW.md](OVERVIEW.md)**

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/ElliotGluck/groundwork/main/setup/install.sh | bash
```

Interactive — pick your editor:

```
1) Claude Code   (full plugin: skills + commands + worker/verifier agents + CLAUDE.md)
2) Codex CLI     (skills + global AGENTS.md)
3) OpenCode      (skills + AGENTS.md)
4) Cursor        (project-level skills + AGENTS.md)
5) Agent-agnostic (.agents/skills + ~/AGENTS.md)
6) All of the above
```

Non-interactive: `./setup/install.sh --agent claude|codex|opencode|cursor|agnostic|all`.
Safe to re-run (managed sentinel blocks update in place; your own config content is never touched).
`--dry-run` previews; `--uninstall` reverts. macOS / Linux / WSL.

## What's inside

```
groundwork/
├── skills/                          # universal SKILL.md format — portable across agents
│   ├── grounded-coding/             #   orchestrator/PM profile (the core)
│   └── experimental-reasoning/      #   opt-in aggressive reasoning mode
├── setup/
│   ├── install.sh                   # interactive multi-harness installer
│   ├── global-CLAUDE.md             # always-on contract (Claude Code flavor)
│   └── global-AGENTS.md             # always-on contract (harness-neutral flavor)
├── commands/                        # Claude Code slash commands
│   ├── debug.md  architect.md  review.md  scope.md  flatten-plan.md  ground-check.md
├── agents/                          # Claude Code subagents
│   ├── coding-worker.md             #   scoped implementation worker
│   └── verifier.md                  #   independent read-only verifier
├── .claude-plugin/plugin.json       # Claude Code plugin manifest
└── OVERVIEW.md                      # full overview, why it exists, benchmarks
```

## The short version of the philosophy

1. **Measure by logical commitments** — size, simplicity, and decomposition all derive from the
   conditions a task must satisfy, never from file counts or how big it feels.
2. **Occam with a floor** — simplest solution that satisfies *every* commitment; "do nothing" is
   disqualified, not clever.
3. **Judgment gates** — Chesterton's Fence (don't skip what you can't explain), baby/bathwater
   (don't abandon achievable work over one blocker), investigate-before-flag, simplify-before-defer.
4. **Orchestrate, don't grind** — flat phased plans, parallel independent phases, scoped workers with
   grounded briefs, every return verified, trivial edits done directly.
5. **Grounding above everything** — no invented APIs or facts; verified vs. assumed stays visible;
   gaps reported, not filled; time claims from `git log`, not vibes.

## Compatibility

| Harness | Skills | Always-on contract | Commands | Worker/verifier agents |
| --- | --- | --- | --- | --- |
| Claude Code | ✅ | ✅ CLAUDE.md | ✅ | ✅ |
| Codex CLI | ✅ | ✅ AGENTS.md | behaviors via AGENTS.md | brief-encoded |
| OpenCode | ✅ | ✅ AGENTS.md | behaviors via AGENTS.md | brief-encoded |
| Cursor | ✅ (project) | ✅ AGENTS.md (project) | behaviors via AGENTS.md | brief-encoded |
| Other SKILL.md agents | ✅ | manual placement | behaviors via AGENTS.md | brief-encoded |

Groundwork is prompt-layer guidance, not enforcement — see [OVERVIEW.md](OVERVIEW.md#honest-limits).

## License

MIT.
