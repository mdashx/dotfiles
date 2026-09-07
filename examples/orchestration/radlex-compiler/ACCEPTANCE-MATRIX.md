# Acceptance Matrix

This matrix connects normative obligations to implementation tickets and executable evidence. `passed` requires a named passing test or reproducibility artifact; prose confidence is insufficient.

| ID | Obligation | Spec reference | Ticket | Status | Evidence |
|---|---|---|---|---|---|
| A-01 | Load the pinned RadLex source and report its identity | §2.1, §2.4 | RPL-000, RPL-002 | passed | `make doctor`; `make inventory` reports pinned byte-level SHA-256 and 772,209 triples |
| A-02 | Inventory every meaningful exercised source construct | §2.1, §2.6 | RPL-002 | passed | `make inventory`: all shapes/counts pass; 46,900 named + 52 anonymous class nodes reconciled; 18 RDF/RDFS/OWL predicates classified |
| A-03 | Preserve classes, RIDs, and exact URIs | §3.1, invariant 12 | RPL-003, RPL-004 | passed | exact identity fixtures and corpus check: 46,900 named classes with `class_uri/2` recovery |
| A-04 | Preserve named class inclusion | §3.2 | RPL-004 | passed | exact directed fixture plus 46,900-edge corpus check and `rid29662 → rid205` spot check |
| A-05 | Preserve existential restrictions without witnesses | §3.3, invariants 1–5 | RPL-005 | passed | positive/malformed/no-witness fixtures plus exact 83,161-fact corpus check |
| A-06 | Preserve relation vocabulary and specialization | §3.6 | RPL-006 | passed | fixture plus exact 52-relation/12-subproperty corpus tables with URI recovery |
| A-07 | Preserve inverse metadata without reversing existential restrictions | §3.7, invariant 9 | RPL-006 | passed | exact 19-pair corpus table, source-direction provenance, and non-reversal fixture |
| A-08 | Preserve partial-function declarations exactly | §3.9, invariant 10 | RPL-006 | passed | corpus asserts exactly `segment_of` and `tributary_of` |
| A-09 | Preserve domain/range implications as inspectable class expressions | §3.4 | RPL-007 | passed | golden fixtures plus exact 50-domain/52-range corpus check with provenance |
| A-10 | Preserve unions as canonical disjunctions | §3.5, invariant 8 | RPL-007 | passed | canonical/non-projection/list-error fixtures plus all 52 corpus unions |
| A-11 | Preserve lexical/documentary strings exactly | §3.11, invariant 11 | RPL-008 | passed | Unicode/multilingual/datatype/duplicate fixtures plus exact kidney corpus queries and provenance equality |
| A-12 | Handle unused `Term_type` schema narrowly and explicitly | §3.12 | RPL-009 | passed | four-value schema/corpus test plus populated and nearby-equivalence rejection |
| A-13 | Validate punning assumption and reject material individual semantics | §3.8 | RPL-010 | passed | 24,092-class/self-type + 83,161 mirrored-relation corpus audit and material negative |
| A-14 | Reject every unsupported source shape explicitly | invariant 2, §2.6 | RPL-010 | passed | structured restriction/list/property/equivalence matrix plus unclassified-triple hard failure |
| A-15 | Account for every supported source axiom | invariant 2, §2.6 | RPL-010, RPL-011 | passed | 772,209 source dispositions plus zero-orphan audit of 436,914 emitted targets |
| A-16 | Trace every emitted axiom to source identity or specified inference | invariant 6 | RPL-003–RPL-011 | passed | 436,914 origins; zero orphan/invalid/missing identities across all 21 predicates |
| A-17 | Generate byte-identical output from identical inputs | invariant 12, §2.6 | RPL-012 | passed | two clean builds produce the identical five-file SHA-256 manifest recorded in RPL-012 |
| A-18 | Produce the complete runtime-independent Prolog bundle | §1.2, §2.4 | RPL-012 | passed | `make build`; fresh RDF-free SWI process loads all modules and passes representative core/lexicon/provenance queries before install |
| A-19 | Support representative grounding and ontology queries without populating transcript objects | §3.10; consumer §3.8 | RPL-013 | passed | `make acceptance`: six fresh-bundle tests cover exact grounding, superclass/existential context, exact exports, and absence of RDF/application constructors |
| A-20 | Document performance, packaging, and downstream loading | implementation plan M6 | RPL-014 | passed | `RELEASE.md` records measured clean-build/load/query performance, exact source/artifact manifests, packaging/licensing boundary, diagnostics, public predicates, and upgrade workflow; clean `make verify` passes |
