# Technical Illustration

Source pattern: Principle Labs documents originally named `Technical Preview`.

## Purpose

A technical illustration makes a possible system concrete enough to inspect,
criticize, compare, or test without committing the project to that design.

It sits inside the vision-and-research loop. It can expose an architecture,
interface, data model, protocol, runtime sequence, UI, deployment shape, or
representative vertical slice. Its job is to improve understanding and reveal
decisions or research questions.

## Status

A technical illustration is explicitly provisional. Technology names,
components, interfaces, and examples are hypotheses or shorthand unless the
document identifies an already accepted constraint.

The document should say what it is illustrating and what remains undecided. It
must not use specification language to make accidental commitments.

## Useful Contents

Use only the sections that help the illustration:

- goal or question being explored;
- current vision and fixed constraints;
- core idea;
- proposed concepts or structure;
- representative interface, data shape, or sequence;
- UI or output sketch;
- configuration and integration assumptions;
- why the direction is attractive;
- tradeoffs, failure modes, and rejected alternatives;
- open questions and required evidence;
- what adopting the illustration would commit the project to.

An illustration may be prose, diagrams, examples, code sketches, a runnable
prototype, or a combination. Prefer the smallest artifact that makes the
uncertain design inspectable.

## Relationship to Concept Design

Concept design can organize an illustration around candidate purposes, state,
actions, and synchronization. Those concepts remain provisional until research
and design decisions stabilize them.

## Outcomes

After review, an illustration may be:

- refined in another iteration;
- rejected with the useful evidence preserved;
- used to update the living vision;
- converted into a targeted research question;
- accepted as input to a conceptual specification;
- sufficient, with other evidence, to support an implementation plan.

The illustration itself does not silently become normative.
