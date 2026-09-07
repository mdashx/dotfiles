# Research Workspace

This directory collects the external knowledge, empirical evidence, and implementation research needed to build the radiology transcript interpretation system.

The project-level conceptual specification is at `../RADIOLOGY-TRANSCRIPT-INTERPRETATION-CONCEPTUAL-SPEC.md`. This directory supports that specification; it is not a substitute for the conceptual model.

## Research model

Each external resource should move through this sequence:

```text
source
  -> pinned local artifact
  -> source-specific notes
  -> inventory and provenance
  -> comparison and decisions
```

Keep upstream artifacts separate from our interpretations. Record versions, URLs, checksums, licenses, and authority boundaries in `inventory/`. Put cross-cutting design conclusions in `decisions/`.

## Directory map

| Directory | Purpose |
| --- | --- |
| `radlex/` | RadLex ontology and grounding research |
| `universal-dependencies/` | Dependency syntax, relation inventory, parser behavior, and samples |
| `ucxn/` | UCxn specifications, annotation schema, examples, and papers |
| `mocca/` | MoCCA concept-network research and examples |
| `framenet/` | Frames, frame elements, lexical units, and examples |
| `construction-grammar/` | Construction Grammar papers and working notes |
| `radiology-corpus/` | Public, synthetic, or explicitly de-identified reports and annotations |
| `report-generation/` | Domain, pipeline, AST, rendering, template, prompt, and validation research for downstream report generation |
| `implementation-prior-art/` | Existing systems and implementation/runtime research |
| `radlex-compiler/` | Sister-project documentation and integration boundary |
| `chatgpt/` | Mirrored project research and prior design documents from the authorized Google Drive folder |
| `toolchain-service-infrastructure/` | Unapproved orchestration proposal for long-lived tool services, a Go hub, and the Toolchain UI |
| `ui-specifications/` | Shared debug-interface philosophy and separate application UI drafts |
| `inventory/` | External resources, versions, licensing, authority, and open questions |
| `decisions/` | Settled decisions, rejected interpretations, and durable research fieldstones |

## Conventions

- Preserve source wording and structure in imported artifacts.
- Add provenance beside every downloaded or copied resource.
- Do not place credentials, patient data, or unreviewed private reports in this tree.
- Use `notes/` for interpretation and `inventory/` for source facts.
- Mark hypotheses as provisional until supported by source evidence or an explicit decision.
- Prefer small, linkable notes over one undifferentiated research journal.

## Current anchors

- `radlex/RadLex.owl` is RadLex 4.3; see `radlex/SOURCE.md`.
- The transcript interpretation specification is at the project root.
- The first cross-cutting research concern is grounding while preserving source fidelity and avoiding ontology-created referents.
- See `inventory/manual-acquisition.md` for resources that require your account, authorization, or license review.

## Download policy

Public specifications, open data, public source repositories, and openly accessible papers may be downloaded with provenance. Restricted papers, gated datasets, licensed clinical corpora, and resources requiring an account must be acquired manually by the project owner. Do not bypass access controls or redistribute downloaded material without reviewing its terms.
