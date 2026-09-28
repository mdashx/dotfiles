# Concept Design

Source: Principle Labs `Concept Design Guide`, authored by mdashx and drafted
with Claude. Intellectual foundation: Daniel Jackson, *The Essence of
Software*.

## Purpose

Concept design decomposes a software problem into small, durable behavioral
units that can be understood independently. It helps describe what a system
means before its meaning is obscured by files, frameworks, services, or
deployment topology.

## A Concept

A concept has three primary parts:

- **Purpose** — why it exists, in one sentence.
- **State** — what it remembers.
- **Actions** — what can be done to it and how its state changes.

A concept is not a file, class, service, table, or module. It is a durable idea
that should remain recognizable if the system is rebuilt with different
implementation machinery.

For example, a `Comment` concept may exist to let people annotate content. It
remembers comments, their text, and their targets. Its actions include adding,
reading, and deleting comments.

## Decomposing a Problem

Begin with the behavior people or neighboring systems need, not the current
code organization.

For each candidate concept, ask:

1. What independent purpose justifies its existence?
2. What state must it own to fulfill that purpose?
3. What actions establish, observe, or change that state?
4. What must always be true before and after those actions?
5. Which responsibilities belong to adjacent concepts instead?
6. Can this concept be understood without importing the rest of the system?

Split a concept when its state or actions serve unrelated purposes. Combine
candidates when neither has an intelligible independent purpose.

## Composition and Synchronization

Individual concepts should remain small. Much of a system's essential
complexity lives in their composition.

An operational principle explains how actions belonging to different concepts
must synchronize. For example, deleting a document may require removing or
detaching comments that target it. The document and comment concepts remain
independent; the synchronization expresses the product-level behavior that
connects them.

For each synchronization, identify:

- the initiating action;
- participating concepts;
- required ordering or atomicity;
- authority over the decision;
- failure and partial-state behavior;
- the invariant preserved by the synchronization.

Do not hide cross-concept behavior inside an implementation component and then
mistake that component for the concept.

## Lightweight Z Notation

Z notation can make state, operations, and invariants precise without turning
the specification into an academic exercise.

Useful vocabulary includes:

| Symbol | Meaning |
| --- | --- |
| `ℕ` | natural number |
| `𝔹` | boolean |
| `seq CHAR` | string |
| `ℙ X` | set of `X` |
| `X → Y` | total function from `X` to `Y` |
| `X ↦ Y` | maplet |
| `dom f` | domain of function `f` |
| `ran f` | range of function `f` |
| `Δ` | operation changes state |
| `Ξ` | operation leaves state unchanged |
| `::=` | closed enumeration |

A state schema describes what the concept remembers:

```text
Comment
  comments: ℙ COMMENTID
  text:     COMMENTID → seq CHAR
  target:   COMMENTID → DOCID
where
  dom text   = comments
  dom target = comments
```

An operation schema describes an action and its state transition:

```text
AddComment
  ΔComment
  id?:   COMMENTID
  body?: seq CHAR
  doc?:  DOCID
where
  id? ∉ comments
  comments' = comments ∪ {id?}
  text'     = text ∪ {id? ↦ body?}
  target'   = target ∪ {id? ↦ doc?}
```

Cross-concept operational principles may be stated as invariants:

```text
∀ d: DOCID • d ∉ activeDocs ⇒ {c: comments | target c = d} = ∅
```

Formal sections should be readable quickly and precise enough to support
reasoning, critique, and implementation. A growing or awkward schema often
indicates that the concept needs to be split or renamed.

## Relationship to Project Artifacts

Concept design is a method used throughout research and design; it is not a
mandatory document stage.

Concepts may first appear as hypotheses in a living vision, research note, or
technical illustration. Iteration may refine, combine, split, or reject them.
Once sufficiently stable, they can organize a conceptual specification. If the
problem is already well understood, they may instead provide enough structure
to write an implementation plan directly.

```text
vision ↔ research ↔ technical illustrations
                    │
                    ├─ targeted research
                    ├─ conceptual specification
                    └─ implementation plan
                              │
                              └─ orchestration
```

The vision remains a living statement while material questions are being
resolved. Technical illustrations are concrete but provisional. A
specification records the accepted conceptual contract. An implementation plan
translates a sufficiently clear target into buildable, verifiable work.

## Relationship to Specification Style

Concept design identifies the durable behavioral units. The Principle Labs
specification style then gives each accepted concept one complete pass:

1. prose for meaning and relationships;
2. lightweight formalism for shape and invariants;
3. examples that make instances and behavior concrete;
4. implementation specifics that make boundaries and enforcement real.

See `specification-writing.md` for that authoring method.

## Reference

- Daniel Jackson, *The Essence of Software* (Princeton University Press,
  2021).
