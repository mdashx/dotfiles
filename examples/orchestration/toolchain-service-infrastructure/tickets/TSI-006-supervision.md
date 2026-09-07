---
id: TSI-006
title: Prove declarative service supervision
status: complete
milestone: M4
depends_on: [TSI-004, TSI-005]
plan_refs: ["§5", "§8.5"]
acceptance: [A-08]
verification: make -C infrastructure smoke-supervision
---

# Objective

Make resident service lifecycle repeatable and observable without turning the Go hub into an operating-system process supervisor.

# Work

- Finalize the service inventory and validate it against service manifests and runtime configuration.
- Add project-scoped user systemd units for Python and Prolog; add the Go unit when its executable exists.
- Implement explicit install, start, status, restart, stop, and uninstall procedures that affect only project units.
- Configure loopback binding, working directories, environment files, restart policy, timeouts, and process-group cleanup.
- Test graceful stop, forced failure, automatic restart, readiness recovery, and log retrieval.
- Keep enable-at-login outside the default operation.

# Acceptance

- Starting from stopped units produces ready services within declared deadlines.
- Stop leaves no project service or grewpy child running.
- Five forced-failure cycles per bare service recover automatically with canonical-equivalent canary results.
- The service inventory, systemd units, doctor checks, and manifests reconcile.
- Commands do not affect unrelated user or system services.

# Evidence

- `make -C infrastructure smoke-supervision` passed on 2026-09-07.
- User-level systemd started both bare services from stopped, recovered each from five forced `SIGKILL` cycles with canonical-equivalent results, stopped them without a residual Grew child, and brought them cleanly back to readiness.
- The checked-in inventory, fixed loopback launchers, service manifests, and three project-scoped unit identities reconcile.
- Units are linked and started explicitly but are not enabled at login.
