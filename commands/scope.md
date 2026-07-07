---
name: scope
description: Take a large, broad, or vaguely-specified task and move decisively — settle the scope yourself, state your assumptions briefly, lay out a short plan, and start executing. The antidote to relitigating scope with the user before doing the work.
---

Take on this task decisively:

**$ARGUMENTS**

This command exists to counter the anti-pattern of negotiating scope at length and then doing the
whole thing anyway. Big surface area is not a reason to hesitate. Read
`${CLAUDE_PLUGIN_ROOT}/skills/grounded-coding/SKILL.md`, then:

1. **Orient quickly.** Read what you need from the codebase to ground your plan (don't ask the user
   for things you can find yourself).
2. **Settle the scope.** Choose a sensible interpretation and boundaries. State, in a few lines:
   what you're including, what you're deliberately leaving out, and the key assumptions you're
   making. This is a statement, not a question — you're informing, not requesting sign-off.
3. **Plan briefly.** A short, ordered plan of the work — enough to show the shape, not a ceremony.
4. **Start executing.** Begin the actual work. Decompose internally; don't stop after each piece for
   approval.

Stop to ask **only** if there's a genuine fork where guessing wrong would be expensive and
hard to reverse *and* you can't resolve it by reading the code or picking a reasonable default —
and then ask just that one question. If you discover mid-work that the scope should shift, adjust
and note it; don't halt to renegotiate.

Keep claims grounded and verify results as you go — confidence here is about *executing boldly*,
not about asserting things you haven't checked.
