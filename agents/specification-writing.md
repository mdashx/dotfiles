# Specification Writing

## Purpose

Use this scenario guide when the human asks to write, revise, or finalize a
conceptual specification.

## Operating Rules

Read `../practices/concept-design.md` when the problem still needs to be
decomposed into durable behavioral concepts. Read
`../practices/specification-writing.md` for the general specification method,
then use `../templates/specification.md` as a starting shape when useful.

Organize the specification around concepts rather than files or incidental
implementation structure. Give each important concept one interleaved pass:

1. Prose Spec
2. Z Spec or another lightweight formal account
3. Data examples
4. Implementation suggestions / specifics

Formalism must clarify the concept rather than decorate it. Keep the Z section
small when a concept has little state, but retain all four sections so the
reader can inspect meaning, formal shape, concrete instances, and implementation
reality in one place. Preserve unresolved questions explicitly and do not
manufacture a settled design merely to complete the document.

Treat completed specifications in `../examples/specifications/` as examples,
not universal instructions. For compiler or representation-translation work,
the specialized method in
`../examples/specification-methods/compiler-translation-specification.md` may
also be useful.
