---
name: flatten-plan
description: Repair a plan that has fractured into a deep nested tree (e.g. tasks like G9 or 4b.3c). Collapse it back into a flat, shallow, actionable plan — preserving completed work and all genuine remaining tasks, discarding only the nesting and bookkeeping — then resume executing.
---

Repair the current plan, which has become over-nested and fractured (deep sub-sub-tasks, nested
numbering like `G9` / `4b.3c`). Target: a flat, shallow plan you can just execute.

Optional focus / context: **$ARGUMENTS**

Read `${CLAUDE_PLUGIN_ROOT}/skills/grounded-coding/SKILL.md` (the "keep plans flat and shallow" rule),
then:

1. **Take inventory of the real state.** From the existing fractured plan, extract two lists: what is
   genuinely **done** (don't redo it) and what genuinely **remains**. Pull the actual work out of the
   tree; ignore the hierarchy and the numbering.
2. **Understand each remaining item before touching it.** Before you merge, drop, or reorder anything,
   make sure you know what it's *for* (Chesterton's Fence). A task buried three levels deep may still
   be load-bearing — collapsing the tree must not silently discard a real task. If you can't explain
   why a remaining item exists, keep it and investigate, don't delete it.
3. **Rebuild flat.** Re-express the remaining work as a single flat list of a handful of concrete
   steps — one level of breakdown, two at most for a genuinely large step, and **no nested numbering
   scheme**. Merge fragments that are really one action; break a big task *sideways* into independent
   chunks (some of which you may hand to sub-agents), not *downward* into finer subtasks. Preserve
   real dependencies and ordering.
4. **Don't lose achievable work.** If part is blocked, keep the unblocked items in the flat plan and
   note the blocked one with why (don't drop the whole thing over one blocker).
5. **State the flattened plan briefly, then resume.** Show the short done/remaining lists and the new
   flat plan in a line or two, then get back to executing — don't linger polishing the outline.

The output is a simpler plan and continued progress, not a bigger planning document.
