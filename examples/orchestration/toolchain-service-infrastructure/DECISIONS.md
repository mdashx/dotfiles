# Toolchain Service Infrastructure — Proposed Decisions

The entries below were accepted for this bounded infrastructure experiment by the explicit instruction to execute the plan. Evidence may still revise them through appended records.

## P-001 — Go hub

- Status: accepted for experiment
- Proposal: A Go server is the hub for bare tool services, application callers, evaluation records, and Toolchain UI routes.
- Reason: Directly supplied by the human for this planning exercise.

## P-002 — Capability-oriented contracts

- Status: accepted for experiment
- Proposal: Public contracts identify capabilities and endpoints independently of deployment grouping. A service may host several components without merging their identities.
- Reason: This permits the Python tools to begin together and split later without changing the conceptual API.

## P-003 — Two bare service boundaries

- Status: accepted for experiment
- Proposal: Begin with one Python linguistics service and one SWI-Prolog service. The Python service privately owns the installed `grewpy_backend` child.
- Reason: This groups resident state by runtime and follows grewpy's actual caller-owned backend lifecycle.
- Validation: Repeated-call, memory, concurrency, and restart evidence in `TSI-002`–`TSI-006`.

## P-004 — Loopback HTTP/JSON

- Status: accepted for experiment
- Proposal: Go, Python, and Prolog communicate through versioned HTTP/JSON on fixed loopback ports.
- Reason: All runtimes support it directly and the boundary is inspectable without language-specific RPC tooling.
- Validation: Contract fixtures, malformed-input tests, deadlines, and direct `curl`-level acceptance.

## P-005 — User-level systemd supervision

- Status: accepted for experiment
- Proposal: User-level systemd units own service lifecycles; the Go hub observes readiness and routes calls but does not supervise operating-system processes.
- Reason: The current target is one Linux research machine with native local resources.
- Validation: Environment preflight plus five kill/restart cycles and orphan-child checks.

## P-006 — One Python application worker

- Status: accepted for experiment
- Proposal: Begin with one Python application worker, serialize Grew/UCxn access, and bound other capability queues.
- Reason: Avoid duplicate Stanza models and conflicting global grewpy backend state until concurrency is measured.
- Validation: Sequential, concurrent, queue, latency, and resident-memory evidence.

## P-007 — Server-rendered UI

- Status: accepted for experiment
- Proposal: The Go hub renders semantic HTML using Go templates and a small stylesheet. JavaScript is optional and limited initially to server-sent progress enhancement.
- Reason: This directly supports the semantic DOM requirement and keeps one public web surface.
- Validation: no-JavaScript navigation, DOM contract tests, and accessibility checks.

## P-008 — File-backed immutable evaluation records

- Status: accepted for experiment
- Proposal: Begin with append-only JSON records and content-addressed artifact files under ignored runtime state rather than a database.
- Reason: It is sufficient to prove identities, evidence, history, and restart stability with little infrastructure.
- Validation: schema tests, crash-safe writes, immutable historical routes, and digest reconciliation.

## P-009 — Read-only UI before operations

- Status: accepted for experiment
- Proposal: Render stored fixture and live evaluation records before adding forms that start verification work. Service lifecycle controls remain outside the initial UI.
- Reason: It proves the information model before coupling the browser to execution.
- Validation: `TSI-009` must pass before `TSI-010` begins.

## D-010 — JSON service inventory

- Status: accepted for experiment
- Decision: Use `infrastructure/config/services.json` as the initial operational inventory rather than the illustrative YAML filename in the plan.
- Reason: JSON is readable directly by the Go standard library and `jq`, avoiding a configuration-parser dependency while the topology is still experimental.

## D-011 — Experiment disposition

- Status: supported as research baseline
- Decision: Retain the accepted two-bare-service topology, supervised Go hub, loopback HTTP/JSON contracts, server-rendered UI, and file-backed evaluation records as the next research baseline.
- Evidence: The full offline gate, repeated resident profiles, forced restarts, identity-drift tests, assembled transport, durable evidence, and UI acceptance all passed on 2026-09-07.
- Boundary: This disposition is not production approval and does not approve or implement any radiology application semantics.
