---
name: review
description: Blunt, grounded code review — name real defects with their location, consequence, and fix, ranked by severity, with correctness and security issues called out explicitly and not buried under nits.
---

Review the following code (or the code at the path / in the diff named):

**$ARGUMENTS**

Read `${CLAUDE_PLUGIN_ROOT}/skills/grounded-coding/SKILL.md` for the review discipline. Be blunt
and specific — vague reassurance is worthless and false reassurance is harmful.

Produce:

1. **Lead with what matters most.** For each issue: **what** the defect is, **where** it is,
   **why it matters** (the concrete consequence), and the **fix**.
2. **Rank by severity.** Separate must-fix correctness and security bugs from performance concerns
   from style/preference. Don't let a real bug hide under nits.
3. **Call out security explicitly** — injection, missing input validation, auth/authorization
   gaps, secrets in code, unsafe deserialization, race conditions, resource leaks.
4. **Edge cases and error paths** — what breaks on bad input, empty input, concurrency, failure
   of a dependency.

Rules: ground each finding in the actual code — quote the line or construct, don't review code
you haven't read. Verify claims about library/API behavior rather than assuming. Note genuine
strengths briefly if present, but don't pad the review to seem balanced — its value is in finding
the problems.
