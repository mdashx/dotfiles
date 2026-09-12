# Specification Writing

Source: Principle Labs `Spec Style Guide`, authored by mdashx and drafted with
Claude. Canonical predecessor:
`mdashx/general-agent-harness/projects/spec-style-guide/SPEC-STYLE-GUIDE.md`.

## Purpose

This is the general Principle Labs method for writing architecture, harness,
transport, agent, and systems specifications. It balances conceptual clarity,
lightweight formal rigor, concrete examples, and implementation reality.

The specification is a durable contract. It should say what the system is,
what it is not, which concepts it contains, what each concept owns, and what
enforces the behavior in reality.

## Core Pattern

Start with a short intent, decompose the system into concepts rather than
files, and give each important concept one complete interleaved pass:

1. **Prose Spec**
2. **Z Spec** or another useful lightweight formal account
3. **Data examples**
4. **Implementation suggestions / specifics**

The interleaving is the point. A reader should understand one concept's
meaning, shape, instances, and implementation consequences before moving to
the next concept.

Formalism is not ceremonial. Every concept receives all four sections, but the
Z section should remain small when the concept has little state or only a
simple invariant. The structure is mandatory; verbosity is not.

## Before Writing

A specification is appropriate when the conceptual direction is stable enough
to state a contract. If the purpose, concepts, or major boundaries remain
materially uncertain, continue work in the vision, research, or technical
illustrations instead.

Inspect relevant source systems and prior research. Preserve established facts,
accepted decisions, important rejected interpretations, and genuinely open
questions. Compress the conversation rather than reproducing it.

Use `concept-design.md` when the problem still needs behavioral decomposition.

## Intent

Open with a short, declarative account that says:

- what is being built;
- what is deliberately outside the project;
- the main conceptual or architectural idea;
- the principal runtime boundary or source of truth;
- what enforces the important behavior.

For agent and LLM systems, explicitly distinguish behavior enforced by code,
state, wiring, process boundaries, or policy from behavior requested only in a
prompt.

## Conceptual Breakdown

Primary sections should name stable concepts such as `InputHub`, `Comment`,
`Session`, `EventLog`, `Transport`, or `OutputPublication`. Avoid organizing
the specification around helper functions, filenames, framework components,
or temporary deployment machinery.

Each concept should be small enough to understand in one pass and substantial
enough to have an independent purpose. State cross-concept synchronization and
global invariants explicitly rather than assigning them vaguely to the system.

## Prose Spec

The prose account explains meaning, responsibility, and relationships. It
should answer:

- What is this concept and why does it exist?
- What state or decisions does it own?
- What does it explicitly not own?
- Which actions or behavior belong to it?
- How does it relate to adjacent concepts?
- Which source is authoritative and which representations are derived?

Use direct ownership and enforcement language. For example:

> The registry owns the set of executable artifact modules. The browser does
> not infer available modules from presentation templates.

## Z Spec or Lightweight Formal Account

Use a compact formal description of the concept's state, actions, types,
constraints, invariants, or synchronization.

Useful forms include:

- Z-style state and operation schemas;
- relations and invariants;
- state machines;
- grammars;
- preconditions and postconditions;
- typed request, event, or data shapes.

Prefer readable Unicode notation. Keep the account small enough to compare
against the prose and examples. If formalization becomes disproportionate, the
concept may be doing too much.

## Data Examples

Place concrete examples immediately after the formal account. JSON is usually
appropriate, but events, commands, tables, protocols, UI states, or
source-to-target examples may fit the subject better.

Examples should be realistic and should expose meaningful defaults, overrides,
failure states, authority decisions, or boundary cases. They are part of the
specification, not decoration.

## Implementation Suggestions / Specifics

Ground the concept in implementation reality without turning the specification
into a file-by-file plan. Appropriate material includes:

- runtime ownership and process boundaries;
- startup and shutdown behavior;
- persistence and source-of-truth decisions;
- idempotency, retry, and failure behavior;
- security and safety boundaries;
- defaults, overrides, and resolved configuration;
- integration constraints;
- behavior that must be enforced rather than remembered.

These specifics constrain implementation. Ordered work, ticket decomposition,
and execution state belong in the implementation plan and orchestration
workspace.

## Invariants and Synchronization

State non-negotiable truths explicitly. Keep local invariants with the concept
they govern. Collect cross-cutting invariants or operational principles where
their composition can be reviewed as a whole.

When misunderstanding is likely, say both what the contract entails and what
it does not entail. This technique remains especially useful for identity,
authority, inference, optional state, and lossy translation.

## Open Questions

Do not disguise uncertainty as normative prose. A useful open question names:

- what is unresolved;
- why it matters;
- known constraints and candidate interpretations;
- what evidence or decision would resolve it.

A draft can retain explicit open questions. A specification is ready to govern
implementation only when remaining questions are deliberately deferred or no
longer change the proposed work.

## Closing Material

Close with whichever of these are useful:

- global invariants;
- a concise summary;
- acceptance conditions for the conceptual contract;
- the smallest meaningful implementation milestone;
- prior work and references;
- a compact, non-normative provenance account.

## What to Avoid

- Organizing concepts around files or framework accidents.
- Separating all prose from all formalism and examples.
- Formal notation without an explanatory purpose.
- Abstract schemas without concrete instances.
- Implementation notes without a conceptual model.
- Ambiguous ownership or source-of-truth language.
- Asking a model to remember behavior that runtime structure must enforce.
- Importing a specialized compiler format into unrelated specifications.
- Recreating a conversation transcript.

## Authoring Check

Before treating a conceptual specification as ready, check that:

- its intent and boundary are clear;
- its primary sections are durable concepts;
- each concept receives all four parts of the interleaved account;
- ownership, state, actions, and synchronization are intelligible;
- examples make the contract concrete;
- important invariants and failure behavior are explicit;
- open questions are visible;
- implementation specifics constrain rather than prematurely schedule work;
- prior evidence and references are identified.

Use `../templates/specification.md` as a starting shape. Completed artifacts in
`../examples/specifications/` show applications of the style; they are not the
authority for the method.
