---
id: TSI-003
title: Prove resident Grew and UCxn operation
status: complete
milestone: M2
depends_on: [TSI-002]
plan_refs: ["§3.2", "§4.3", "§5.3", "§8.2"]
acceptance: [A-05]
verification: make -C infrastructure smoke-grew-service smoke-ucxn-service
---

# Objective

Expose bounded Grew and UCxn capabilities through the Python service while preserving the installed caller-owned backend lifecycle.

# Work

- Initialize `grewpy_backend` as a private child and verify its exact version.
- Load named local smoke and official UCxn rule identities without accepting arbitrary paths or rule text.
- Implement graph-transform and UCxn-annotate operations over bounded CoNLL-U.
- Serialize backend operations initially and clean corpus/GRS state after requests.
- Report construction counts, artifact digests, rule identities, and structured Grew diagnostics.
- Test child exit, backend connection failure, request timeout, cleanup, and service recovery.

# Acceptance

- The isolated mutation still emits `Smoke=grew-ok` through the resident endpoint.
- The official UCxn fixture produces expected nonempty `Cxn` and `CxnElt` annotations repeatedly.
- The complete repeated/concurrent profile produces canonical-equivalent output without deadlock or unbounded backend state.
- Stopping the Python service leaves no orphan `grewpy_backend` process.
- Restart does not require a prior corpus, GRS, port, PID, or backend index supplied by a client.

# Completion evidence

- The Python service now owns one private `grewpy_backend`, caches named Grew/UCxn rules, serializes access, and cleans every request corpus.
- Public operations accept only named rule sets and return CoNLL-U rather than ephemeral backend handles.
- `make -C infrastructure smoke-grew-service` passed 100 sequential and 32 concurrent deterministic transformations with `Smoke=grew-ok` and flat process-tree RSS.
- `make -C infrastructure smoke-ucxn-service` passed 100 sequential and 32 concurrent official-rule annotations with the expected existential construction.
- Both smokes preserved readiness after negative/deadline cases and proved that Python shutdown leaves no backend child.
