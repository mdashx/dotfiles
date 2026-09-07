# Implementation Decisions

This is the durable decision log for concrete choices not fully fixed by the normative compiler specification. New records are appended; accepted records are not silently rewritten.

## D-001 — Ontology/Application Interface Boundary

- Status: accepted
- Decision: The compiler emits ontology predicates only. It does not define `isa/2`/`instance_of/2` aliases or application-individual predicates. Consumer adapters own those interfaces and must not define reciprocal aliases.
- Reason: The primary consumer distinguishes abstract ontology knowledge from transcript referents and application facts.

## D-002 — Initial Bundle Contains Data, Not Executable Application Rules

- Status: accepted
- Decision: The required generated bundle contains class, relation, class-expression, lexical, identity, and provenance data. Executable application-facing domain/range and inverse adapters are deferred beyond compiler acceptance.
- Reason: This keeps policy and recursion outside generated source facts while preserving all ontology propositions.

## D-003 — Canonical Identity

- Status: accepted
- Decision: RID classes use lowercase `ridNNNNN`; relations use deterministic snake-case atoms. Exact upstream URIs are always recoverable through identity predicates. Collisions are compiler errors.

## D-004 — Canonical Union Terms

- Status: accepted
- Decision: A union is `union(Members)`, with members normalized, duplicate-free, and sorted by standard term order. Union membership never entails an individual member without additional evidence.

## D-005 — Provenance Cardinality

- Status: accepted
- Decision: `origin(TargetAxiom, SourceOrigin)` is one-to-many. If multiple source graph structures normalize to one target axiom, all distinct origins are retained. Blank-node/list source locations are represented by stable compiler-assigned source locators, not runtime RDF blank-node identifiers.

## D-006 — Reproducible Metadata

- Status: accepted
- Decision: Generated files contain compiler version, declared source version when known, and source SHA-256. Wall-clock timestamps are excluded from deterministic outputs.

## D-007 — Non-RID Root Class Identities

- Status: accepted
- Decision: The two observed named root classes
  `http://www.radlex.org/RID/RadLex_term` and
  `http://www.radlex.org/RID/Non-RadLex_term` compile respectively to
  `radlex_term` and `non_radlex_term`. Other non-RID named class URIs remain
  malformed supported identities. Exact URIs are retained through
  `class_uri/2`.
- Reason: The pinned graph contains 46,900 named classes: 46,898 RID classes
  and these two source-defined roots. The remaining 52 of the 46,952
  `owl:Class` nodes are anonymous union expressions and must not become named
  `class/1` facts.

## D-008 — Source-Preserving Lexical Qualifiers

- Status: accepted
- Decision: `label/4` and `acronym/3` carry the source language atom, `none`,
  or `datatype(Uri)` in their qualifier position. `definition/2`, `xref/2`,
  and `source/2` retain their specified query-friendly arities while their
  `origin/2` records retain the complete raw RDF literal, including its
  language/datatype. Other declared annotation properties compile to
  `annotation(Class,PropertyUri,Qualifier,Text)`. No matching-normalized key is
  part of source-preserving output. Declared annotation properties whose value
  is an IRI (the observed case is `Replaced_by`) compile to
  `annotation_resource(Class,PropertyUri,ObjectUri)`.
- Reason: This preserves exact source distinctions and the documented public
  predicates without treating documentary annotations as ontology logic.
