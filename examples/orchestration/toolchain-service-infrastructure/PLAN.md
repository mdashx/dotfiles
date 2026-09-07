# Toolchain Service Infrastructure — Proposed Orchestration Plan

**Status:** Adopted for infrastructure experiment
**Adopted:** 2026-09-07 by explicit human instruction
**Project prefix:** `TSI`
**Existing prerequisite:** `make -C setup verify`
**Candidate final gate:** `make -C infrastructure verify`

## 1. Vision

This project would determine whether the installed research tools can operate as stable, long-lived services callable through a Go hub, and would expose the resulting operational evidence through the Toolchain Debug UI.

The governing principle is:

> Validate resident behavior and service boundaries before investing in application semantics or production infrastructure.

The existing `setup/` project proves cold behavior:

```text
installed artifact → direct command → meaningful output
```

This proposed project proves resident service behavior:

```text
supervised service
      → stable callable contract
      → repeated useful work
      → bounded failure
      → restart recovery
      → Go-hub orchestration
      → inspectable UI evidence
```

It is a toolchain infrastructure experiment, not the radiology transcript interpreter implementation plan.

### 1.1 In scope

- long-lived service wrappers around the already installed tools and resources;
- direct health, identity, capability, and error contracts;
- repeated-call, concurrency, timeout, shutdown, and restart testing;
- lightweight configuration management for the local service topology;
- a Go hub that calls the services and records version-bound evaluations;
- the server-rendered Toolchain Debug UI;
- service-level and hub-level heavy smoke tests; and
- durable evidence sufficient to decide whether the topology should be retained.

### 1.2 Out of scope

- radiology mentions, constructs, referents, frames, grounding policy, or semantic IR;
- clinical correctness or application validation;
- arbitrary remote code, Grew rule, filesystem, or Prolog query execution;
- public network exposure, authentication, multi-user tenancy, or production deployment;
- Kubernetes, cloud infrastructure, service discovery platforms, or generalized plugin systems;
- modifying the semantics of Stanza, UCxn, Grew, MoCCA, FrameNet, SWI-Prolog, or RadLex;
- replacing `setup/` installation and cold verification; and
- extracting a separate repository before the service evidence justifies it.

### 1.3 Approval boundary

This plan became active on 2026-09-07 by explicit human instruction to execute it.

Before adoption:

- every ticket remains `planned`;
- `STATE.md` has no active ticket;
- proposed decisions remain unaccepted;
- no `infrastructure/` implementation directory is implied; and
- no `GO` instruction should start execution.

Adoption identified this plan by context. `TSI-000` is active and execution follows `GO.md`.

## 2. Empirical Baseline

The plan begins from evidence already established by `setup/` on 2026-09-07:

| Component | Existing cold evidence | Resident-service question |
|---|---|---|
| Stanza 1.14.0 | parses 10 documents / 12 trees / 125 tokens into valid CoNLL-U | can the model remain loaded and produce stable results repeatedly? |
| Grew 1.21.0 | performs a real graph mutation | can a caller use the backend repeatedly without leaked corpus state or deadlock? |
| UCxn pinned source | official adapter annotates 500 EWT sentences | can rules remain available behind a bounded named operation? |
| MoCCA DB 1.0 | validates and queries 1,278 nodes / 3,049 edges | can the graph be loaded once and queried deterministically? |
| FrameNet 1.7 | reconciles complete local indexes and files | can indexes be built once and served through stable lookups? |
| SWI-Prolog 9.2.9 | passes three CoNLL-U transport tests | can a long-lived Prolog server answer bounded operations concurrently? |
| RadLex generated bundle | passes six fresh-process consumer tests | can the bundle remain loaded and expose exact ontology queries without RDF runtime state? |
| Assembly | exact UCxn anchor and pivot survive Stanza → Grew/UCxn → Prolog | can the same artifact cross service and Go-hub boundaries? |

The prerequisite gate is:

```sh
make -C setup verify
```

No service result can repair or substitute for a failing setup obligation. Cold and resident verification remain separate evidence layers.

## 3. Candidate Architecture

### 3.1 Logical topology

The initial candidate uses two bare capability services behind one Go hub:

```text
browser or application
          │
          ▼
┌──────────────────────────────────────────────────────────────┐
│ Go hub                                                       │
│ capability routing · deadlines · evaluation/evidence records │
│ server-rendered Toolchain UI                                 │
└───────────────────────┬───────────────────────┬──────────────┘
                        │ HTTP/JSON             │ HTTP/JSON
                        ▼                       ▼
         ┌──────────────────────────┐   ┌──────────────────────┐
         │ Python linguistics       │   │ SWI-Prolog service   │
         │ service                  │   │                      │
         │                          │   │ CoNLL-U inspection   │
         │ Stanza                   │   │ RadLex bundle/query  │
         │ UCxn adapter             │   │                      │
         │ MoCCA                    │   └──────────────────────┘
         │ FrameNet                 │
         └─────────────┬────────────┘
                       │ private grewpy protocol
                       ▼
                grewpy_backend
                supervised child
```

This grouping is provisional. The public unit is a Capability and its Endpoint, not the deployment topology. Stanza can later be separated from UCxn/Grew without changing the Go-facing operation contract.

### 3.2 Why Grew remains behind Python initially

The installed `grewpy` package starts `grewpy_backend` as an OCaml child, reads its ephemeral loopback port, communicates through a private length-prefixed JSON socket protocol, and ties backend lifetime to the Python caller PID.

The experiment therefore treats the backend as an implementation detail of the Python Service:

- the Python service owns its lifecycle;
- the supervisor kills the complete process group;
- Grew operations are bounded and serialized initially;
- corpus and GRS indexes never cross the public service boundary; and
- readiness includes an actual backend canary, not only a process check.

Direct Go implementation of the grewpy private protocol is outside the initial plan.

### 3.3 Service is not Component

The conceptual mapping is:

```text
Component provides Capability
Service hosts Component
Endpoint exposes Capability
Service Instance realizes Service
Go hub invokes Endpoint
Evaluation records the resulting Evidence
```

Several Components may live in one process without losing separate identities, versions, health evidence, capability checks, or UI entries.

## 4. Candidate Service Contract

### 4.1 Protocol

The planning assumption is versioned HTTP/1.1 with JSON documents over fixed loopback addresses.

HTTP/JSON is preferred for this experiment because Go, Python, and SWI-Prolog can all implement it directly; requests remain inspectable with ordinary tools; and contract fixtures do not require a language-specific RPC runtime.

Only the Go hub is intended to expose a browser-facing port. Bare services bind to `127.0.0.1` and are not remotely reachable.

### 4.2 Common endpoints

Every bare service exposes:

```text
GET /livez
GET /readyz
GET /v1/manifest
```

`/livez` proves only that the request loop responds.

`/readyz` proves that required resident resources are loaded and a cheap real operation succeeds.

`/v1/manifest` reports:

```text
service identity
contract version
build/source identity
process start time
hosted component identities
exposed capabilities and endpoint versions
resource digests or revisions
current readiness
```

### 4.3 Candidate Python operations

```text
POST /v1/stanza/parse
POST /v1/grew/transform
POST /v1/ucxn/annotate
POST /v1/mocca/search
GET  /v1/mocca/concepts/{id}
GET  /v1/framenet/frames/{name}
POST /v1/framenet/lexical-units/search
```

The initial Grew and UCxn endpoints accept named, locally configured rule sets. They do not accept arbitrary paths or unconstrained executable rule text.

### 4.4 Candidate Prolog operations

```text
POST /v1/conllu/inspect
POST /v1/radlex/ground
GET  /v1/radlex/classes/{rid}
GET  /v1/radlex/classes/{rid}/context
```

The service exposes named ontology and transport operations. It does not expose a generic endpoint that executes arbitrary Prolog text.

### 4.5 Request and result rules

Every request carries or receives a request ID and is governed by an explicit body-size limit and deadline.

Every successful result contains or references:

```text
contract version
request ID
capability identity
component and resource identities
result
measurements
diagnostics, if any
duration
```

Every error is a structured document with a stable kind, phase, message, retryability, and request ID. Language stack traces remain subordinate evidence and are never the only error contract.

Public results are self-contained or refer to durable artifacts owned by the Go hub. A service must not return an in-memory Grew corpus index, Python object identity, Prolog engine handle, PID, or other token whose meaning disappears on restart.

## 5. Process and Configuration Management

### 5.1 Candidate supervisor

The initial assumption is user-level systemd because the current target is one Linux research machine with local venv, opam, model, XML, graph, and Prolog artifacts.

Candidate units:

```text
radnlp-linguistics.service
radnlp-prolog.service
radnlp-toolchain-hub.service
```

The supervisor owns process lifetime. The Go hub owns capability routing, deadlines, evaluations, and user-visible availability. The Go process does not become a general process supervisor.

Unit behavior should include:

- explicit working directory and environment file;
- fixed loopback listen address;
- `Restart=on-failure` with bounded restart delay;
- bounded start and stop timeouts;
- `KillMode=control-group` for the Python-owned Grew child;
- predictable stdout/stderr capture; and
- no enablement at login unless an accepted decision requests it.

If the machine cannot reliably run user-level systemd, `TSI-000` records evidence and proposes a replacement rather than silently changing the topology.

### 5.2 Service inventory

A single human-readable inventory is the candidate source of operational configuration:

```text
service identity
command and arguments
working directory
environment file
listen address
readiness URL
startup deadline
hosted components
exposed capabilities
resource paths and identities
dependencies
```

Secrets are outside the inventory. File paths and environment variable names may be recorded; credential contents may not.

The same inventory should drive or validate systemd units, Go routing configuration, doctor checks, and UI service identity. Configuration must not be independently duplicated in four forms without a reconciliation test.

### 5.3 Concurrency assumptions

The first Python Service runs one application worker to avoid accidental duplication of Stanza models and Grew backend state.

It uses bounded per-capability concurrency:

- Grew/UCxn operations are serialized initially;
- Stanza concurrency is measured before increasing above one active inference;
- MoCCA and FrameNet read-only queries may run concurrently after tests establish safety; and
- excess requests wait in a bounded queue or receive a structured busy response.

The Prolog HTTP service may use SWI-Prolog's threaded server, but every exposed operation receives a query time limit and remains read-only during this infrastructure phase.

## 6. Go Hub and Evaluation Records

The Go hub is an explicit assumption supplied for this plan.

It is responsible for:

- mapping Capability identities to configured Endpoints;
- enforcing deadlines, body limits, and correlation IDs;
- translating transport failures into structured Diagnostics;
- executing cross-service pipelines;
- retaining input and output Artifacts with digests;
- creating immutable, version-bound Evaluation and Verification records;
- deriving readiness from required verifications; and
- serving the Toolchain Debug UI and its browser-facing operations.

The hub does not reinterpret linguistic or ontology results. For example, it may record and route CoNLL-U, but it does not become a second dependency parser or Prolog reasoner.

### 6.1 Candidate durable record layout

The first implementation may use append-only JSON and artifact files rather than introduce a database:

```text
infrastructure/var/
  evaluations/
    {evaluation-id}/
      evaluation.json
      verifications/
        {verification-id}.json
      artifacts/
        {artifact-id}/
          metadata.json
          content
```

`infrastructure/var/` is runtime state and must be ignored by version control. Test fixtures and expected results live separately in source control.

An evaluation binds evidence to:

```text
toolchain declaration
service manifests
component/resource identities
environment identity
contract versions
verification definitions
artifacts and digests
times and outcomes
```

The filesystem format is a provisional implementation choice. Tickets may replace it only through an explicit decision preserving stable conceptual identities and tests.

## 7. Toolchain Debug UI

The Go hub serves the first UI with `html/template`, semantic HTML, and a small static stylesheet. A separate JavaScript application is not required.

### 7.1 Initial routes

```text
GET  /toolchains/{toolchain-id}
GET  /toolchains/{toolchain-id}/evaluations/{evaluation-id}
GET  /toolchains/{toolchain-id}/components/{component-id}
GET  /toolchains/{toolchain-id}/services/{service-id}
GET  /toolchains/{toolchain-id}/capabilities/{capability-id}
GET  /toolchains/{toolchain-id}/seams/{seam-id}
GET  /toolchains/{toolchain-id}/verifications/{verification-id}
GET  /toolchains/{toolchain-id}/artifacts/{artifact-id}
```

The first UI slice is read-only and renders fixture evaluation records before it can initiate work.

### 7.2 Page narrative

The principal page presents:

1. toolchain identity and claim boundary;
2. resident Service readiness and hosted Components;
3. exact component and resource identities;
4. the executable artifact path;
5. required and optional Capability and Seam verifications;
6. structured Diagnostics and stale evidence;
7. direct links to commands, results, and retained Artifacts; and
8. the derivation of overall readiness.

The page distinguishes:

```text
component installed
service reachable
service ready
capability verified directly
capability verified through Go
cross-service seam verified
```

None implies the next.

### 7.3 Operations and progress

After the read-only UI passes semantic DOM acceptance, a later ticket may add explicit operations:

```text
Run verification {id}
Run failed required verifications
Start full service evaluation
```

Forms post to the Go hub. The browser never calls bare services directly.

The returned run receives a stable URL. Server-sent events may progressively report state changes, while ordinary refresh continues to show the complete current state without JavaScript.

Service start, stop, enable, disable, and arbitrary command controls are excluded from the first UI.

### 7.4 UI authority

The UI implementation is governed by:

- `research/ui-specifications/Debug Interface Design Philosophy _ Draft Specification.md`; and
- `research/ui-specifications/Toolchain Debug UI Design Specification.md`.

Both remain research drafts. Conflicts discovered during implementation require a proposed decision; implementation convenience does not silently rewrite the UI concepts.

## 8. Verification Strategy

### 8.1 Concentric gates

Verification expands in this order:

```text
existing cold component smoke
        ↓
direct resident endpoint contract
        ↓
repeated and concurrent endpoint use
        ↓
supervisor stop/restart recovery
        ↓
Go-hub capability call
        ↓
cross-service artifact transport
        ↓
evaluation/evidence persistence
        ↓
semantic-DOM UI acceptance
        ↓
offline final verification
```

### 8.2 Heavy resident smoke profile

The initial heavy profile is intentionally stronger than one successful request:

- 100 sequential representative calls per resident capability family;
- a burst of 32 calls with concurrency up to 8, subject to each service's declared queue policy;
- exact or canonical-equivalent results for deterministic fixtures;
- structured rejection of malformed and oversized inputs;
- deadline enforcement with subsequent service health preserved;
- five supervised kill/restart cycles per bare service;
- readiness restored within the service's declared startup deadline;
- no orphan `grewpy_backend` after stopping the Python unit; and
- no stale in-memory handle required to reproduce a successful request after restart.

Resource observations include startup time, warm latency distribution, maximum resident memory, post-warm memory trend, queue time, error counts, and restart time. These are recorded as evidence before performance budgets are treated as durable requirements.

### 8.3 Memory-growth provisional check

For the research gate, the harness compares resident memory after warm-up with the final request window. Growth greater than the larger of 20% or 256 MiB is reported as a failed stability check unless a recorded decision explains a bounded cache and supplies repeatable evidence that it plateaus.

This threshold is a planning assumption, not a product capacity commitment.

### 8.4 Assembly service smoke

The end-to-end service smoke transports one existing neutral fixture:

```text
text
  → Go hub
  → Stanza endpoint
  → CoNLL-U artifact
  → UCxn/Grew endpoint
  → annotated CoNLL-U artifact
  → Prolog inspection endpoint
  → exact anchor/pivot assertion
  → immutable Evaluation
  → Toolchain UI explanation
```

The smoke proves service and artifact seams. It introduces no radiology interpretation semantics.

### 8.5 Restart smoke

For each bare service, the harness:

1. establishes readiness and a successful canary result;
2. terminates the supervised main process ungracefully;
3. observes temporary unavailability through Go;
4. waits for supervisor restart and full readiness;
5. repeats the canary with canonical-equivalent output;
6. verifies that Go recorded the outage and recovery as evidence; and
7. verifies that no invalid prior in-memory identity was required.

## 9. Candidate Implementation Layout

If adopted, tickets create a top-level implementation directory resembling:

```text
infrastructure/
  README.md
  Makefile
  config/
    services.yaml
    environment.example
  contracts/
    common.schema.json
    manifest.schema.json
    error.schema.json
    operations/
  hub/
    cmd/
    internal/
    web/
  linguistics-service/
  prolog-service/
  systemd/
  smoke/
  fixtures/
  scripts/
  var/                    # ignored runtime state
```

The exact internal source layout may change within tickets. The stable boundaries are the operator commands, endpoint contracts, evidence model, and acceptance obligations.

## 10. Milestones and Ticket Queue

| Milestone | Purpose | Ticket | Gate |
|---|---|---|---|
| M0 — Adoption and foundation | establish authority, preserve cold baseline, create implementation/operator skeleton | `TSI-000` | `make -C infrastructure doctor orchestration` |
| M1 — Contracts | define common identity, health, result, artifact, and error contracts | `TSI-001` | `make -C infrastructure test-contracts` |
| M2 — Python resident tools | validate Stanza, then UCxn/Grew, then MoCCA/FrameNet in resident mode | `TSI-002`–`TSI-004` | direct Python service heavy smoke |
| M3 — Prolog resident tools | validate SWI-Prolog transport and RadLex queries in resident mode | `TSI-005` | direct Prolog service heavy smoke |
| M4 — Supervision | install candidate local configuration and prove lifecycle/restart behavior | `TSI-006` | `make -C infrastructure smoke-supervision` |
| M5 — Go hub and seams | route typed capabilities, persist evidence, and prove assembled transport | `TSI-007`–`TSI-008` | `make -C infrastructure smoke-hub smoke-assembly` |
| M6 — Toolchain UI | render evaluations, evidence, diagnostics, and explicit run operations | `TSI-009`–`TSI-010` | `make -C infrastructure test-ui` |
| M7 — Reliability handoff | run heavy resident, restart, offline, and clean final gates | `TSI-011` | `make -C infrastructure verify` |

Only one ticket may be `in_progress`. Tickets are dependency ordered, and every completed ticket records executable evidence.

## 11. Candidate Operator Interface

The stable operator surface is proposed as:

```sh
make -C infrastructure doctor
make -C infrastructure orchestration
make -C infrastructure test-contracts
make -C infrastructure test
make -C infrastructure start
make -C infrastructure status
make -C infrastructure smoke-services
make -C infrastructure smoke-supervision
make -C infrastructure smoke-hub
make -C infrastructure smoke-assembly
make -C infrastructure test-ui
make -C infrastructure stop
make -C infrastructure verify
```

`start` and `stop` affect only the explicitly named project units. `verify` uses installed local artifacts and performs no downloads.

## 12. Definition of Done

If adopted, the project is complete only when:

- the existing setup final gate still passes;
- every TSI ticket is complete with recorded evidence;
- every required acceptance row is passed;
- each bare service survives the heavy resident profile;
- supervisor stop, failure, and restart behavior is demonstrated;
- Go can invoke every required capability and the assembled path;
- evaluation records bind claims to exact service/component identities and artifacts;
- the UI explains service, capability, seam, outcome, and evidence distinctions through semantic HTML;
- final verification runs without network access; and
- `make -C infrastructure verify` succeeds from a stopped-service baseline and leaves the declared final service state documented.

Completion would establish only that the infrastructure experiment succeeded. Promotion to a separate repository, production deployment, or use by the radiology application requires a later explicit decision.
