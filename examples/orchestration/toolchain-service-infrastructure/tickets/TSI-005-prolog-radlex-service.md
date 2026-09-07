---
id: TSI-005
title: Prove resident Prolog and RadLex operation
status: complete
milestone: M3
depends_on: [TSI-001]
plan_refs: ["§3.1", "§4.2", "§4.4", "§5.3", "§8.2"]
acceptance: [A-07]
verification: make -C infrastructure smoke-prolog-service smoke-radlex-service
---

# Objective

Keep SWI-Prolog and the generated RadLex bundle resident behind named HTTP operations while preserving the ontology/application boundary.

# Work

- Create a bounded SWI-Prolog HTTP server with health, readiness, and manifest endpoints.
- Load the generated RadLex bundle once without loading an RDF runtime.
- Expose CoNLL-U inspection, exact lexical grounding, class identity, superclass context, and class-level existential context operations.
- Apply per-query time limits, body limits, structured errors, and read-only request isolation.
- Reuse the compiler's acceptance examples and negative boundary assertions.
- Exercise repeated, concurrent, malformed-input, timeout, and restart-independent queries.

# Acceptance

- All existing Prolog transport and six RadLex consumer-boundary examples pass through resident endpoints.
- The manifest reports exact SWI and bundle identities.
- No endpoint accepts arbitrary Prolog source or creates transcript/application individuals.
- The heavy resident profile completes without cross-request assertion leakage.
- A timed-out or malformed query does not compromise subsequent readiness.

# Evidence

- `make -C infrastructure smoke-prolog-service smoke-radlex-service` passed on 2026-09-07.
- CoNLL-U transport and RadLex each passed 100 sequential and 32 concurrent resident requests with stable canonical results.
- The service validates the exact documented bundle export set, absence of an RDF runtime, and absence of application/transcript constructors before it becomes ready.
- Exact right-kidney grounding, source URI, kidney superclass, class-level containment context, empty results, unknown classes, malformed JSON, deadlines, and post-error readiness were exercised through named HTTP operations.
