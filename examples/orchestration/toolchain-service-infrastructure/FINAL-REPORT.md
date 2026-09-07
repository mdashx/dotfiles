# Toolchain Service Infrastructure — Experiment Report

**Completed:** 2026-09-07
**Scope:** local research-tool service plumbing and Toolchain Debug UI only

## Outcome

The proposed topology is supported for this bounded research experiment:

```text
browser / application caller
           │
           ▼
Go hub + Toolchain UI :8170
       │               │
       ▼               ▼
Python service :8171   SWI-Prolog service :8172
Stanza                 CoNLL-U inspection
Grew / UCxn            RadLex runtime bundle
MoCCA
FrameNet
```

All three boundaries are supervised user services and bind only to
`127.0.0.1`. The Python boundary privately owns `grewpy_backend`; systemd owns
the complete process group. The Go hub owns allowlisted routing, deadline and
identity enforcement, durable evaluations, and the server-rendered UI. It is
not an operating-system supervisor.

`make -C infrastructure verify` passed from a fully stopped service state on
2026-09-07. It used the already installed local artifacts and required no
network access.

## Evidence summary

- Stanza, Grew, UCxn, MoCCA, FrameNet, CoNLL-U/Prolog, and RadLex each passed
  100 sequential and 32 concurrent resident calls with deterministic results.
- Malformed, empty, oversized, unknown, unavailable, and expired-deadline
  paths retain structured distinctions at the relevant boundaries.
- The five-cycle forced-failure profile passed for each bare service with
  canonical-equivalent recovery. Clean stop left no Grew child.
- Go routed all eleven named endpoint forms, rejected arbitrary operations,
  validated the pinned contract/resource identities, and reconnected after a
  bare service restarted.
- The final full evaluation persisted ten passing verifications and twelve
  digest-checked artifacts. The exact
  `Existential-CopPred-ThereExpl` anchor and
  `2:Existential-CopPred-ThereExpl.Pivot` element survived every HTTP and
  serialization seam.
- Completed records are read-only and stable across hub restart. Partial
  records are not presented as history; changed identities make old evidence
  stale.
- The semantic UI, stable concept/history/artifact routes, no-JavaScript
  document, CSRF/origin protection, operation allowlist, duplicate behavior,
  and one-active-evaluation bound all passed.

## Observed operating profile

These measurements describe this machine and test corpus, not service-level
objectives:

| Observation | Result |
|---|---:|
| Python process-tree RSS in final direct smokes | about 1.17–1.22 GiB |
| Supervised Python cgroup, current / peak | 917 MB / 939 MB |
| Supervised Prolog cgroup, current / peak | 277 MB / 278 MB |
| Supervised Go hub, current / peak | 8.7 MB / 9.3 MB |
| Python cold readiness after supervised start | about 5 seconds |
| RadLex/Prolog cold readiness after supervised start | about 25 seconds |
| Go hub process startup | under 1 second once dependencies were ready |
| Final ten-check evaluation wall time | about 0.35 seconds |
| Final evaluation retained payload | 12 artifacts, 22,789 bytes |

The final evaluation recorded approximately 139 ms for Stanza, 46 ms for the
Grew canary, 59 ms for UCxn, 42 ms for MoCCA, 2 ms for the cached FrameNet
frame lookup, and 2–3 ms for each Prolog/RadLex lookup. Grew/UCxn execution is
serialized inside the single Python worker; Stanza has a one-active-operation
semaphore; the complete-resource dictionaries are read-only; Prolog uses eight
HTTP workers. The full-evaluation coordinator admits one active run and makes
additional attempts explicit conflicts.

## Decision disposition

The experiment supports the Go hub, capability-oriented versioned HTTP/JSON,
one Python plus one Prolog bare-service boundary, user systemd supervision,
single Python model residency, server-rendered semantic UI, JSON inventory,
and file-backed immutable completed evaluations. No observed behavior required
splitting the Python service during this smoke profile.

This is evidence for retaining the topology as the next research baseline. It
is not production approval. Before production use, load limits, authentication
for non-loopback deployment, upgrade/migration policy, service-level targets,
and longer-duration resource behavior would need separate decisions and tests.

## Claim boundary

This work does not implement the radiology application specification, its IR,
clinical semantics, transcript interpretation, diagnosis, or correctness
criteria. Passing infrastructure readiness says that the selected research
machinery can be called stably and interoperates on the declared fixtures. It
does not make a clinical or application-validity claim.
