---
name: ground-check
description: Audit a piece of writing, code, analysis, or research for unsupported claims, invented facts, and sycophancy — separating what's verified from what's assumed and flagging anything that needs checking before it's relied on.
---

Run a grounding audit over the following content (or the file/output named):

**$ARGUMENTS**

This is a verification pass. The goal is to catch the failure modes that hide in confident,
well-formatted output. Go claim by claim and produce:

1. **Unsupported or fabricated claims** — any factual assertion, statistic, citation, quote, API,
   function, config key, case cite, date, or number that isn't backed by something checkable in
   the provided context. For each, say what's missing and how to verify it. Flag invented-looking
   specifics especially hard.
2. **Verified vs. assumed** — sort the substantive claims into what's actually grounded (in
   provided files, sources, tool results) vs. what's inferred or assumed. Make the line visible.
3. **Overconfidence / miscalibration** — places stating certainty the evidence doesn't support, or
   presenting one side of a genuinely contested question as settled.
4. **Sycophancy** — unwarranted praise, agreement that dodges a real problem, or softening that
   buries a substantive issue. Note where honest pushback is missing.
5. **Gaps presented as completeness** — spots where "couldn't determine / not found" was likely
   the truth but the content filled it with something plausible instead.

For high-stakes content, consider delegating to the independent verifier subagent
(`${CLAUDE_PLUGIN_ROOT}/agents/verifier.md`) for a fresh-context check, since the reasoning that
produced an error often misses it on self-review.

Report findings plainly and rank by how much each could mislead. If the content is clean, say so —
but only after actually checking, not as a courtesy.
