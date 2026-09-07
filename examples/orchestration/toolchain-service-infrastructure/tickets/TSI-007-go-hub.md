---
id: TSI-007
title: Route typed capabilities through the Go hub
status: complete
milestone: M5
depends_on: [TSI-006]
plan_refs: ["§4", "§6"]
acceptance: [A-09]
verification: make -C infrastructure smoke-hub
---

# Objective

Create the Go hub as the single caller-facing boundary for service capabilities, identity validation, timeouts, and diagnostics.

# Work

- Implement configuration loading and capability-to-endpoint routing.
- Create typed clients for common service contracts and every required Python/Prolog operation.
- Propagate correlation IDs and deadlines and enforce body/result limits.
- Validate manifests and contract compatibility before declaring an endpoint ready.
- Translate unreachable, not-ready, busy, timeout, protocol, and component errors without collapsing them.
- Add aggregate health and machine-readable toolchain status endpoints.

# Acceptance

- Go successfully invokes every required direct capability and validates returned identities.
- Contract mismatch and stale resource identity prevent a false-ready state.
- Transport failures, timeouts, malformed service replies, and not-ready services produce distinct structured Diagnostics.
- The browser/application-facing surface cannot address arbitrary internal URLs or operations.
- Restarting a bare service does not require restarting Go after readiness returns.

# Evidence

- `make -C infrastructure smoke-hub` passed on 2026-09-07.
- The hub routed all eleven named endpoint forms across the two services, propagated request identities and deadlines, validated result envelopes and pinned component identities, and preserved structured service failures.
- Unit tests reject contract and component-identity drift; the public mux rejected an arbitrary operation.
- Restarting the linguistics service did not restart Go, and the next hub call succeeded once service readiness returned.
