---
id: TSI-000
title: Establish the infrastructure project foundation
status: complete
milestone: M0
depends_on: []
plan_refs: ["§1", "§2", "§9", "§11"]
acceptance: [A-01, A-02]
verification: make -C infrastructure doctor orchestration
---

# Objective

After explicit adoption, create the bounded implementation project without changing tool versions or introducing application semantics.

# Work

- Record adoption and accepted/replaced planning assumptions.
- Create the candidate `infrastructure/` source layout and ignored runtime-state boundary.
- Add the stable Make operator skeleton.
- Implement prerequisite checks for Go, Python environment, opam/Grew, SWI-Prolog, pinned resources, loopback ports, and user-level supervision.
- Re-run and record the complete existing setup gate.
- Implement an orchestration checker for ticket IDs, dependencies, statuses, acceptance references, and the state cursor.

# Acceptance

- `make -C setup verify` still passes without downloads.
- `make -C infrastructure doctor` reports exact prerequisite and resource identities.
- `make -C infrastructure orchestration` validates this package after its adoption state is updated.
- No service is enabled or started by the foundation target.
- No radiology application concepts or semantics are introduced.

# Completion evidence

- Created the project-scoped `infrastructure/` operator and configuration skeleton.
- Added exact runtime/resource preflight and orchestration consistency checks.
- `make -C setup verify` passed all ten cold setup obligations on 2026-09-07.
- `make -C infrastructure doctor orchestration` passed with Go 1.24.4, Python 3.13.5, SWI-Prolog 9.2.9, user systemd, and installed local resources.
- No service was started or enabled by the foundation gate.
