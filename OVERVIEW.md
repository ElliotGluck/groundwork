# Groundwork

**A grounded operating system for AI coding agents.**
Works with Claude Code, Codex CLI, OpenCode, Cursor, and any agent that reads the universal
SKILL.md / AGENTS.md standards.

Repo: `github.com/ElliotGluck/groundwork` · License: MIT

```bash
curl -fsSL https://raw.githubusercontent.com/ElliotGluck/groundwork/main/setup/install.sh | bash
```

---

## What it is

Groundwork turns a coding agent into a **grounded orchestrator**: a project manager that plans in
flat phases, delegates implementation to scoped sub-agents with grounded briefs, supervises and
verifies what comes back, and keeps its main context clean — while refusing, at every level, to
invent facts, skip tasks it doesn't understand, or abandon achievable work.

It's not a model, a wrapper, or a service. It's a set of carefully-worded skills, an always-on
operating contract, and (in Claude Code) commands and worker/verifier agents — plain markdown that
installs into your agent's standard directories and travels with the open SKILL.md standard across
tools.

## The core ideas

**Measure by logical commitments.** Size, simplicity, and decomposition all use one currency: the
discrete conditions a task must satisfy — not files touched, lines written, or how big it feels.
Surface metrics inflate; commitments don't. A change across forty files that satisfies one condition
is *small*. This single substrate drives the sizing, the phasing, and the solution choice.

**Occam's razor with a floor.** Among solutions that satisfy *every* commitment, prefer the one
resting on the fewest assumptions. The floor matters: "do nothing" makes zero assumptions but
satisfies zero commitments — it's disqualified, not "simplest." Same for any under-solution that
quietly drops an edge case to look lean.

**Judgment gates against the classic agent failures:**
- **Chesterton's Fence** — never skip a planned task you can't explain the purpose of. Not
  understanding why a step exists is disqualifying, not permission.
- **Baby / bathwater** — one blocked piece never justifies abandoning the achievable work around it.
  Isolate the blocker, finish what's independent, report the boundary precisely.
- **Investigate before you flag** — no raising suspected problems the agent never actually checked.
  Look first; surface only what survives, with evidence.
- **Simplify before you defer** — before asking the user anything, restate the question plainly;
  most of the time the plain version answers itself.

**Orchestrator / worker split.** The main agent acts as PM: flat phased plans derived from the
commitment seams, parallel dispatch of independent phases, sequential for dependencies, distinct
file ownership per worker, and every return treated as a claim to verify — with an independent
fresh-context verifier for high-stakes results. Trivial edits it just does itself; ceremony is not
the point.

**Grounding above everything.** No invented APIs, functions, citations, or figures. Verified vs.
assumed stays visible. Gaps get reported, not filled with plausible fabrication. Time claims come
from `git log`, not vibes. Confidence to *act* is never license to *assert*.

## Features

| Component | What it does | Harness support |
| --- | --- | --- |
| `grounded-coding` skill | The orchestrator/PM profile: commitment-based sizing, flat phasing, delegation, supervision, the gates | All SKILL.md agents |
| `experimental-reasoning` skill | Opt-in aggressive mode: narrated hypothesis-killing, maximal autonomy, structural root-cause fixes | All SKILL.md agents |
| Operating contract | Always-on grounding + gates + orchestrator posture | CLAUDE.md (Claude Code) / AGENTS.md (Codex, OpenCode, Cursor, others) |
| Slash commands | `/debug` `/architect` `/review` `/scope` `/flatten-plan` `/ground-check` | Claude Code (behaviors encoded harness-neutrally in AGENTS.md for others) |
| `coding-worker` agent | Scoped implementation worker: strict file-lane discipline, prove-it-works, concise returns | Claude Code |
| `verifier` agent | Independent, read-only fresh-context verification of high-stakes output | Claude Code |
| Interactive installer | One-liner install with editor selection; idempotent managed blocks; safe re-runs and uninstall | macOS / Linux / WSL |

## Why I built it

I kept hitting the same failure modes across coding agents, regardless of how capable the underlying
model was:

- **Confident fabrication** — invented APIs, hallucinated citations, "this works" with no evidence.
  The most dangerous output an agent produces is a fluent claim that turns out to be made up.
- **Speculation instead of investigation** — raising worries about problems it never actually
  looked into, burning tokens and attention on back-and-forth over phantom issues.
- **Scope theater** — negotiating a big task's boundaries at length, then one-shotting the whole
  thing anyway. Or the inverse: fracturing every project into `G9` and `4b.3c` sub-sub-plans until
  the agent is managing an outline instead of shipping.
- **Quiet task-skipping** — deciding a step is "too complex for what it's worth" without knowing why
  the step was there, or abandoning an entire migration because one piece was blocked.
- **All-or-nothing laziness dressed up as judgment** — including the degenerate Occam move where
  "the simplest solution" becomes doing nothing at all.

Groundwork is the accumulated set of counter-disciplines to those failures, refined iteratively
against real agent behavior and grounded in documented prompt-engineering practice — not a
reconstruction of any model's internals. Every rule in it exists because an agent actually failed
that way. When the universal SKILL.md standard emerged, it made sense to ship the whole system in a
form any agent can use.

## Benchmarks

<!-- BENCHMARK RESULTS: fill in as runs complete. Suggested comparisons:
     baseline agent vs. agent+groundwork on the same task set. Suggested metrics:
     task completion rate, tests-passing rate, fabricated-API incidents, unnecessary
     user questions per task, tokens per completed task, plan depth / fragmentation,
     tasks silently skipped, verification claims that held up on audit. -->

| Benchmark | Baseline | With Groundwork | Delta |
| --- | --- | --- | --- |
| _TBD_ | _TBD_ | _TBD_ | _TBD_ |

*Results pending — this section will be populated with reproducible task-set comparisons.*

## Install

**Interactive (recommended):**
```bash
curl -fsSL https://raw.githubusercontent.com/ElliotGluck/groundwork/main/setup/install.sh | bash
```
Pick your editor from the menu (Claude Code / Codex CLI / OpenCode / Cursor / agent-agnostic / all).

**Non-interactive:**
```bash
git clone https://github.com/ElliotGluck/groundwork && cd groundwork
./setup/install.sh --agent claude     # or codex | opencode | cursor | agnostic | all
```

Safe to re-run: the operating contract lives between sentinel markers and updates in place; your own
CLAUDE.md / AGENTS.md content is never touched. `--dry-run` previews, `--uninstall` reverts.

## Honest limits

Groundwork is prompt-layer guidance, not enforcement — it steers strongly but a model can still
deviate; hard guarantees need harness-level hooks. Commands and worker/verifier agents are Claude
Code-specific today (other harnesses get the skills and the contract, with the same behaviors encoded
as named methodologies). And the experimental profile trades tokens for depth by design — measure it
on your workload before adopting it.
