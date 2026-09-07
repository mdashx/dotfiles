# Toolchain Service Infrastructure — Execution State

Last updated: 2026-09-07

## Current position

- Phase: Complete — infrastructure experiment validated
- Active ticket: `none`
- Status: `complete`
- Next ticket: `none`
- Final gate: `make -C infrastructure verify` passed 2026-09-07

## Authority state

The plan was explicitly adopted on 2026-09-07. Execution is authorized within its infrastructure scope; the radiology application remains outside scope.

## Current facts

- `make -C setup verify` passed on 2026-09-07 for all ten setup obligations.
- The original setup harness proves direct cold execution; the completed infrastructure gate now separately proves resident service behavior.
- The human supplied Go as the assumed hub runtime for planning.
- The service grouping, HTTP contracts, supervisor, storage format, and UI implementation choices were accepted for and supported by this bounded experiment; they are not production approval.
- The Toolchain Debug UI specification is a research draft and has been updated to distinguish Component, Service, Endpoint, and Service Instance.

## Resume procedure

1. Read `FINAL-REPORT.md` for the measured disposition and limitations.
2. Operate the stack with `make -C infrastructure start|status|stop`.
3. Open `http://127.0.0.1:8170/toolchains/rad-nlp-research` for current evidence.
4. Treat future application implementation as a separate plan and claim boundary.

## Blockers

None.

## Latest evidence

- `make -C setup verify` passed all ten cold setup gates on 2026-09-07.
- `make -C infrastructure doctor orchestration` passed the foundation gate.
- `make -C infrastructure test-contracts` passed in Python, Go, SWI-Prolog, and `jq`.
- Resident Stanza passed 100 sequential and 32 concurrent deterministic parse calls with bounded memory.
- Resident Grew and UCxn each passed 100 sequential and 32 concurrent calls with corpus cleanup and no orphan backend.
- Resident MoCCA and FrameNet each passed 100 sequential and 32 concurrent deterministic complete-resource queries.
- Resident SWI-Prolog and RadLex each passed 100 sequential and 32 concurrent named-operation calls while preserving the ontology/application boundary.
- User systemd supervision passed start/stop and five forced-failure recovery cycles for each bare service without orphaning the private Grew backend.
- The supervised Go hub routed every named capability, enforced pinned identities and allowlisting, and reconnected after a bare-service restart.
- A durable ten-verification evaluation preserved the exact assembly anchor/pivot and twelve content-addressed artifacts across hub restart.
- The semantic server-rendered UI and its stable toolchain, evaluation, concept, verification, and artifact routes passed without client JavaScript.
- The bounded UI operation surface passed CSRF, origin, allowlist, duplicate, stable-result, refresh, and one-active-evaluation tests.
- The complete offline gate passed from fully stopped services and left the three supervised loopback services ready with an evidence-backed UI.
- Existing acceptance evidence is recorded in `../../setup/ACCEPTANCE-MATRIX.md` and `../../setup/STATE.md`.
- The installed grewpy implementation was inspected: it owns a loopback `grewpy_backend` child tied to the Python caller PID and uses ephemeral in-memory indexes.
