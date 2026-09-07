---
id: TSI-001
title: Define the common service and evidence contracts
status: complete
milestone: M1
depends_on: [TSI-000]
plan_refs: ["§3.3", "§4", "§6.1"]
acceptance: [A-03]
verification: make -C infrastructure test-contracts
---

# Objective

Define the smallest versioned contract shared by Go, Python, Prolog, fixtures, verification records, and the UI.

# Work

- Define stable identifiers for Service, Service Instance, Component, Capability, Endpoint, Artifact, Verification, Evaluation, Evidence, and Diagnostic.
- Define liveness, readiness, manifest, success, error, and artifact metadata JSON schemas.
- Specify HTTP status, request ID, deadline, input-size, retryability, and content-type behavior.
- Create deterministic positive and negative contract fixtures.
- Implement schema/conformance checks usable by every runtime.
- Prohibit ephemeral process and backend handles from public results.

# Acceptance

- Valid fixtures pass in the contract test harness.
- Missing fields, unknown contract versions, malformed JSON, oversized bodies, and invalid state combinations fail with expected diagnostics.
- Go, Python, and SWI-Prolog can each read or emit representative documents without losing identifiers or false/empty/unknown distinctions.
- The contract contains no arbitrary code execution operation.

# Completion evidence

- Added v1 JSON schemas for manifests, capability results, structured errors, and immutable evaluations.
- Added deterministic positive fixtures and a negative ephemeral-handle fixture.
- Added dependency-free Python checks, Go tests, SWI-Prolog fixture parsing, and `jq` validation.
- `make -C infrastructure test-contracts` passed on 2026-09-07 and preserved false and empty values across all three runtimes.
