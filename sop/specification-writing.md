# Writing a Specification

A specification is an **exploratory design document**. It says what we
currently understand a thing to be, clearly enough to reason about,
argue with, and build from if it survives.

It is not a contract. It does not bind an implementation, and it is not
obliged to stay true — a later pass down a different branch may replace
it, and several never become anything at all. That is the lab working.
What a specification owes is that a reader finishes it with the right
model in their head.

## When to write one

When enough fieldstones have accumulated that the shape is stable, and
you can say what the thing is without hedging every sentence. If purpose,
concepts, or boundaries are still moving, keep walking around the topic —
a premature specification freezes a guess and makes it look decided.

You are out of the lab entirely when you know enough to write an
implementation plan. That is a different document with a different job.

## Open with intent

A short, declarative account:

- what is being specified
- what is deliberately outside it
- the main conceptual idea
- the principal source of truth
- what actually enforces the important behaviour

For agent and LLM systems, separate behaviour enforced by code, state,
wiring, or process boundaries from behaviour merely requested in a
prompt. They fail differently.

## Organize around concepts

Primary sections are concepts — durable behavioural units, in the sense
of `concept-design.md`. Not files, not services, not framework
components, not deployment machinery.

This is the default rather than a law. Some subjects are not
concept-shaped, and forcing them is worse than a plain account. But start
here, and have a reason when you do something else.

## Each concept gets four things

In this order, once:

**What it is.** Purpose, the state it owns, the actions that change that
state, and its **operational principle** — the scenario showing the
concept fulfilling its purpose. What it explicitly does *not* own, and
how it relates to its neighbours.

**Its shape, formally.** Lightweight Z. State, invariants, and the
transitions that carry a real precondition. Keep it small; if the formal
account grows out of proportion to the prose, the concept is doing too
much.

**Instances.** Realistic examples — data, events, requests, state
transitions. Expose defaults, boundaries, and failure cases rather than
the happy path. Examples are part of the specification, not decoration.

**What it would mean to build.** The implementation reality the design
has to respect: ownership and process boundaries, persistence, failure
behaviour, integration constraints, and anything that must be enforced
by structure rather than remembered. This is not a schedule and not a
plan. It is the part of reality that constrains the design.

**Do not label these sections.** A heading reading *Prose Spec* tells a
reader nothing they could not see by looking. Prose is recognisable as
prose; a schema is recognisable as a schema. The four parts are an
authoring discipline — check that all four are present before you call it
done — not a rendering instruction.

The interleaving is the point. A reader should finish one concept before
meeting the next, rather than assembling it from four scattered sections.

## Cross-concept material

Synchronization and global invariants get stated explicitly, in one
place, rather than assigned vaguely to "the system". A synchronization is
a transaction — a concept may refuse an action, and that blocks the whole
thing.

Where misunderstanding is likely, say both what the contract entails and
what it does not. This earns its space for identity, authority,
inference, optional state, and anything lossy.

## Open questions

Uncertainty gets its own section. Never disguise it as normative prose.

A useful open question names what is unresolved, why it matters, the
candidate answers, and what evidence or decision would settle it. An open
question is not a defect in an exploratory document — it is the document
being honest about where the lab still is.

## Writing it for a human

The failure mode is not vagueness. It is accumulation. A document that
records everything is unreadable, and an unreadable specification has
failed at its only job.

**Present tense, no dates.** Write what is true. `(corrected 2026-09-28)`
belongs in a commit message, which already records when and by whom.

**No internal codes.** `DRE-016` or `WE-008` is a citation a reader
cannot resolve. If something matters, say it.

**No preamble.** A revision log at the top pushes the content down the
page. If a reader must scroll past the document's autobiography to reach
its first idea, the document has been organized for its author.

**State things; do not defend them.** "a real X, not a Y", "deliberately,
not an oversight", "honestly scoped" — this is arguing with an imagined
critic. Say what is true and stop.

**Emphasis is a budget.** When one line in ten is bold, nothing is
emphasized.

**Do not quote the conversation.** `(human, this session)` cites a
transcript the reader has never seen. Attribution belongs with the
fieldstones.

**Be shorter than the conversation that produced it.** Substantially.
Reconstruct from the fieldstones rather than replaying the chronology.

## Before calling it done

- Intent and boundary are clear.
- Primary sections are durable concepts.
- Every concept has all four parts, including an operational principle.
- Ownership, state, actions and synchronization are intelligible.
- Examples make it concrete.
- Invariants and failure behaviour are explicit.
- Open questions are visible.
- Implementation material constrains rather than schedules.
- A reader can get through it without meeting a date, a code, or an
  argument with someone who is not there.

## Related

`fieldstone-method.md` for the material this is built from.
`concept-design.md` for what a concept is and how to test one.
