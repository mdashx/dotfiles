---
id: TSI-004
title: Prove resident MoCCA and FrameNet queries
status: complete
milestone: M2
depends_on: [TSI-003]
plan_refs: ["§2", "§4.3", "§5.3", "§8.2"]
acceptance: [A-06]
verification: make -C infrastructure smoke-mocca-service smoke-framenet-service
---

# Objective

Load the complete pinned MoCCA and FrameNet resources once and expose representative read-only capabilities through the Python service.

# Work

- Reuse upstream MoCCA validation and parser behavior rather than inventing a second graph meaning.
- Build FrameNet indexes from the complete pinned XML during controlled startup.
- Add exact concept, closest-name, frame, frame-element, lexical-unit, and relation lookups sufficient for heavy smoke evidence.
- Include database version, source revision, resource counts, and FrameNet release identity in the service manifest.
- Bound query input and result size and return explicit no-match versus unavailable diagnostics.

# Acceptance

- Resident resource counts reconcile with the cold setup evidence.
- The MoCCA transitive-construction and FrameNet Medical_conditions/Patient/cancer.n queries pass repeatedly.
- One hundred sequential calls and the concurrent burst return deterministic results without mutation.
- Unknown concept/frame, malformed query, unavailable resource, and empty result remain distinguishable.
- Resource load failures keep readiness false and identify the failing resource.

# Evidence

- `make -C infrastructure smoke-mocca-service smoke-framenet-service` passed on 2026-09-07.
- MoCCA reconciled to 1,278 concepts and 3,049 relations; its transitive-construction query passed 100 sequential and 32 concurrent calls with one stable digest.
- FrameNet reconciled to 1,221 frames, 11,428 frame elements, 13,572 indexed lexical units, 2,070 frame relations, and 12,393 frame-element relations; Medical_conditions/Patient/cancer.n passed the same repeated profile.
- Empty queries, exact misses, unknown resources, readiness, bounded memory, and private grewpy_backend shutdown were exercised distinctly.
