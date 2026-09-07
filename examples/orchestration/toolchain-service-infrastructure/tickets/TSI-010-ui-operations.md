---
id: TSI-010
title: Add explicit verification operations and progress
status: complete
milestone: M6
depends_on: [TSI-009]
plan_refs: ["§7.3"]
acceptance: [A-14]
verification: make -C infrastructure test-ui-operations
---

# Objective

Allow the Toolchain UI to start named verification work through Go without becoming a generic service or process administration console.

# Work

- Add explicit forms for one verification, failed required verifications, and a complete evaluation.
- Show target, scope, identities, and procedure before submission.
- Give every run a stable URL and persistent state.
- Implement polling/refresh as the complete baseline and optional SSE as progressive enhancement.
- Enforce one active full evaluation and bounded per-capability work.
- Preserve CSRF protection and reject arbitrary command, path, endpoint, and rule input.

# Acceptance

- Each form initiates only its named allowlisted operation.
- Duplicate submission and concurrent-run behavior are explicit and tested.
- Disconnecting the browser does not lose or ambiguously complete a run.
- Refresh alone exposes complete current state; SSE does not own hidden truth.
- Service lifecycle controls and arbitrary execution remain absent.

# Evidence

- `make -C infrastructure test-ui-operations` passed on 2026-09-07.
- The UI rejected missing CSRF state, a cross-origin submission, and a non-allowlisted operation; the accepted full evaluation redirected to a stable persistent result URL.
- A duplicate form submission named the already-running evaluation, while twelve simultaneous API starts admitted exactly one and returned eleven explicit conflicts naming that same run.
- The completed result remained fully inspectable by ordinary refresh without JavaScript or a connected browser; no service lifecycle or generic command surface is present.
