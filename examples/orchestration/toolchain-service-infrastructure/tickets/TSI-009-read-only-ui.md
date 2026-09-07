---
id: TSI-009
title: Render the read-only Toolchain Debug UI
status: complete
milestone: M6
depends_on: [TSI-008]
plan_refs: ["§7.1", "§7.2", "§7.4"]
acceptance: [A-12, A-13]
verification: make -C infrastructure test-ui
---

# Objective

Render fixture and real Evaluation records as a domain-first, evidence-centered, semantic HTML document served by Go.

# Work

- Implement stable Toolchain, Evaluation, Service, Component, Capability, Seam, Verification, Diagnostic, and Artifact routes.
- Render the readiness explanation, service/component relationships, executable path, knowledge-resource capabilities, verification ledger, evidence margin, and scope boundary.
- Add raw evidence disclosure and artifact download with identity, media type, size, and digest.
- Preserve exact state distinctions and stable semantic IDs/data attributes.
- Add the minimal Basic Web Theme-derived stylesheet.
- Create DOM, route, no-JavaScript, keyboard, and accessible-name tests.

# Acceptance

- The current setup and resident-service evidence can be understood without reading raw logs.
- Service readiness is not confused with component installation or capability verification.
- Every readiness clause links to supporting current evidence.
- Essential navigation and disclosure work without JavaScript.
- The UI makes no radiology interpretation or clinical correctness claim.

# Evidence

- `make -C infrastructure test-ui` passed on 2026-09-07.
- The server-rendered document exposes Toolchain, Evaluation, Service, Component, Capability, Seam, Verification, Evidence, and Artifact concepts with stable IDs and relations.
- Stable current, historical evaluation, component, capability, seam, verification, and digest-checked raw-artifact routes returned useful HTML/evidence; invalid identities returned 404.
- The essential document uses native navigation/disclosure/operation controls, has no client JavaScript, and explicitly limits its claim to infrastructure readiness rather than radiology or clinical correctness.
