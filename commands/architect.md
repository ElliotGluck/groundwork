---
name: architect
description: Make a software architecture or technical design decision with explicit trade-off analysis — lay out the viable options, evaluate them against real criteria including non-functional ones, and recommend with reasons and risks.
---

Work through this architecture / design decision:

**$ARGUMENTS**

Read `${CLAUDE_PLUGIN_ROOT}/skills/grounded-coding/SKILL.md` for the full design discipline, then:

1. **Restate the decision and surface assumptions.** What's actually being decided, and what are
   you assuming about scale, load, constraints, team, and requirements? Flag the assumptions worth
   confirming before building on them.
2. **Lay out at least two viable options** (more if warranted). Don't present one path as the
   answer — make the choice visible.
3. **Evaluate each against explicit criteria**, including the non-functional ones that get
   skipped: performance, security, reliability, maintainability, testability, operational
   complexity, cost, team familiarity, and behavior under failure and scale.
4. **State what you're optimizing for** and what each option trades away.
5. **Recommend** clearly, with reasons. Name the **main risk** and the condition that would change
   the recommendation.

Rules: ground any claim about how a tool/framework behaves in reality — verify rather than relying
on possibly-stale memory, and don't invent capabilities. Call out the unglamorous concerns (auth,
validation, error handling, failure modes) even if not asked. If a stated requirement seems
contradictory or based on a false premise, say so — *after* confirming it against the code, not as
a speculative worry. **Be decisive about scope:** make a clear recommendation and state your
assumptions rather than bouncing scope questions back; ask only the one question that would
genuinely change the design and that you can't resolve yourself.
