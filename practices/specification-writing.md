# Specification Writing

Source pattern: `agents/specification-writing.md`.

## Purpose

Write technical specifications that preserve decisions, distinctions, evidence,
and unresolved questions while compressing the conversation or investigation
that produced them.

## Governing Principle

```text
Preserve the decisions, distinctions, evidence, and unresolved questions.
Compress the conversation.
```

## Standard Shape

Use four top-level sections unless the subject demands otherwise:

1. Vision
2. Technical Introduction
3. Survey of Decisions and Translation Rules
4. Reference Appendices

## Decision Sections

For each important design or translation decision, prefer this order:

1. Upstream meaning.
2. Model interpretation.
3. Translation or design decision.
4. Concrete source-to-target example.
5. Formal translation rule.
6. Entails / does not entail.
7. Implementation obligations.
8. Open questions.

## Evidence

When the specification depends on an existing codebase, ontology, protocol,
schema, or data format, inspect the source and describe what it actually
contains. Do not substitute what the general standard could express for what
the project source actually uses.

Use `templates/specification.md` for the fillable shape.
