---
id: TSI-008
title: Persist evaluations and prove the assembled service path
status: complete
milestone: M5
depends_on: [TSI-007]
plan_refs: ["§6.1", "§8.4"]
acceptance: [A-10, A-11]
verification: make -C infrastructure smoke-assembly test-evaluations
---

# Objective

Transport the existing assembly fixture through Go and the resident services while recording immutable, identity-bound evidence.

# Work

- Implement crash-safe creation of Evaluation, Verification, Artifact, Evidence, and Diagnostic records.
- Content-address artifact bodies and validate metadata/digest relationships.
- Orchestrate text → Stanza → CoNLL-U → UCxn/Grew → annotated CoNLL-U → Prolog inspection.
- Retain service manifests and exact inputs/outputs for every seam.
- Derive readiness from required current verification records.
- Add stale-evidence tests for changed component, resource, contract, and environment identities.

# Acceptance

- The exact existential anchor and pivot survive all HTTP and serialization seams.
- Every step and connector has a passing Verification with positive evidence.
- Re-reading an evaluation after service restart yields the same immutable history.
- Partial writes are rejected or recovered without presenting a complete evaluation.
- Changed identities make old evidence stale rather than rewriting history.

# Evidence

- `make -C infrastructure smoke-assembly test-evaluations` passed on 2026-09-07.
- One full evaluation persisted ten passing verifications and twelve content-addressed artifacts; its assembly record retained `Existential-CopPred-ThereExpl` and `2:Existential-CopPred-ThereExpl.Pivot` across every service seam.
- Completed evaluation metadata is read-only, digest-checked, unchanged across hub restart, and addressable by stable ID; incomplete directories are not presented as evaluation history.
- Unit evidence proves that a changed component identity makes prior evidence stale.
