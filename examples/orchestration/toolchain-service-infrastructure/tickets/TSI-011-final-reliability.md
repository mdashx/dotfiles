---
id: TSI-011
title: Complete reliability evidence and handoff
status: complete
milestone: M7
depends_on: [TSI-010]
plan_refs: ["§8", "§11", "§12"]
acceptance: [A-15, A-16]
verification: make -C infrastructure verify
---

# Objective

Run the full resident-service experiment, reconcile all evidence, and leave a reproducible basis for accepting, revising, or rejecting the infrastructure topology.

# Work

- Run the complete sequential, concurrent, malformed-input, deadline, memory, stop, crash, restart, hub, assembly, evidence, and UI profiles.
- Run final verification from stopped services using only installed local artifacts.
- Reconcile every ticket and acceptance row with named evidence.
- Document measured startup, latency, memory, queue, restart, and artifact behavior.
- Document service operation, troubleshooting, clean stop, configuration, and evidence locations.
- Record which proposed decisions were supported, revised, or rejected.
- State explicitly what the experiment does not establish.

# Acceptance

- `make -C infrastructure verify` passes without network access.
- All tickets and required acceptance rows are complete and consistent.
- No project service or child remains unintentionally orphaned after the declared final state.
- The final report makes service-topology evidence inspectable rather than converting it directly into production approval.
- No application IR, radiology semantics, or clinical behavior was introduced.

# Evidence

- `make -C infrastructure verify` passed from fully stopped project services on 2026-09-07 using installed local artifacts and no network access.
- Every direct resident capability repeated 100 sequential plus 32 concurrent calls with its malformed-input, deadline, deterministic-output, and applicable memory/orphan checks; all hub, assembly, evidence, UI, and operation gates then passed.
- Earlier supervision evidence forced five failures per bare service and recovered canonical-equivalently on every cycle.
- The supervised final state is three active loopback-only user services; each unit is linked for explicit operation and not enabled at login.
- Measurements, topology disposition, operational limits, evidence locations, troubleshooting, and the non-application claim boundary are recorded in `../FINAL-REPORT.md` and `../../../infrastructure/README.md`.
