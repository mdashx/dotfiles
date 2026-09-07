---
id: TSI-002
title: Prove resident Stanza operation
status: complete
milestone: M2
depends_on: [TSI-001]
plan_refs: ["§3.1", "§4.2", "§4.3", "§5.3", "§8.2"]
acceptance: [A-04]
verification: make -C infrastructure smoke-stanza-service
---

# Objective

Keep the installed Stanza model resident behind the Python service and demonstrate stable repeated parsing.

# Work

- Create the single-worker Python service shell with common health, readiness, and manifest endpoints.
- Load the pinned Stanza model once during controlled startup.
- Implement the versioned parse operation over bounded text input.
- Return valid CoNLL-U plus structured token/tree measurements and exact model/resource identities.
- Add bounded admission, deadline handling, and structured parse diagnostics.
- Exercise sequential, concurrent, malformed-input, timeout, and post-warm memory checks.

# Acceptance

- Readiness remains false until the model and a real parse canary succeed.
- The existing stress fixture produces structurally valid output equivalent to the cold smoke.
- The service completes 100 sequential calls and the declared 32-call concurrent burst without deadlock or identity drift.
- Malformed, empty, oversized, and expired requests preserve distinct outcomes.
- Memory behavior satisfies or explicitly evidence-revises the provisional research threshold.

# Completion evidence

- Added a single-worker resident Python HTTP service that loads the pinned CPU Stanza pipeline once and withholds readiness until a real parse canary passes.
- Added versioned manifest/result/error envelopes, body/deadline limits, bounded Stanza admission, and valid CoNLL-U serialization.
- `make -C infrastructure smoke-stanza-service` passed 100 sequential and 32 concurrent calls with one canonical output digest, distinct empty/malformed/oversized/deadline errors, and valid CoNLL-U.
- Warm/final resident memory was 1,203,188/1,227,288 KiB in the recorded acceptance run, within the research threshold.
