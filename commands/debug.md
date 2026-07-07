---
name: debug
description: Diagnose a bug, error, or failing test using grounded, evidence-first debugging — reproduce and measure before theorizing, find the root cause not the symptom, and verify the fix.
---

Apply the grounded debugging methodology to the following problem:

**$ARGUMENTS**

Read `${CLAUDE_PLUGIN_ROOT}/skills/grounded-coding/SKILL.md` for the full discipline, then work
the problem in this order — do not skip ahead to a fix:

1. **Reproduce** the failure reliably, or state exactly what you'd need to reproduce it.
2. **Observe** the real evidence: read the full error and stack trace, read the relevant code,
   and add logging / instrumentation / a measurement to see actual values rather than assumed
   ones. For "it's slow," profile it.
3. **Hypothesize** a specific, falsifiable root cause tied to a concrete line, value, or log
   entry — not the surface symptom.
4. **Test** the hypothesis by changing one thing and confirming it behaves as predicted. If it
   doesn't, revise the hypothesis; don't stack more changes.
5. **Confirm** the original failure is gone and nothing else broke — run the tests.

Rules: tie every diagnostic claim to its evidence. Label anything not yet confirmed as a
hypothesis, not a conclusion. **Do not report a suspected cause to the user before you've tested
it** — investigate the hunch with the tools first, then report only what survives (with the repro
or log behind it). Do not invent APIs, config keys, or behavior — verify against the
actual code/docs. If you're still diagnosing, report findings and the recommended fix and hold
the change until asked; if a fix was clearly requested, implement and verify it.
