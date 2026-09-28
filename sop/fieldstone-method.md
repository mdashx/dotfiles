# Fieldstone Method

Walk around a topic, learn everything you can about it, and collect the few
durable facts worth carrying forward — so they are available later, when
you start designing something or take on the next problem.

The collecting is the point. The conversation happening now is not the
deliverable, and the fieldstones are not notes about it.

## The metaphor

Clearing a New England field turns up stones. Farmers piled them at the
field's edge and built walls when there were enough. They did not quarry
stone to a specification; they built from what the work turned up.

Gerald Weinberg took this as a method for writing. It transfers directly
to design work, and five of its moves matter here.

**Gather before you know what you are building.** The pile precedes the
wall. You are not collecting evidence for a document you have already
decided to write.

**Keep the pile.** A stone that goes unused is not waste. It is
inventory, and it may be the first stone of a wall you have not thought
of yet.

**Do not force a stone that does not fit.** Put it back for another wall.
Forcing it damages both the wall and the stone — in practice, a fieldstone
bent to fit an argument stops being a record of what you actually found.

**Start where the energy is.** Build from the stone you find most
interesting rather than from the beginning. Interest is a reliable signal
that a stone has weight.

**The wall follows the stones.** You build with what the work turned up,
not with what you wish it had.

## When you are doing this

Any long exploratory pass over a topic: a design conversation, a research
iteration, reading through an unfamiliar codebase, a session that ends
with a handoff. The method is not specific to conversation — it has
already been retargeted at code.

You are doing this whenever the honest answer to "what is the artifact
here?" is "we do not know yet."

## What a fieldstone is

Something discovered while moving through the work, kept because it has
enough weight, shape, or usefulness to belong in something later built or
decided. Usually one of:

- a governing design principle
- a decision that materially changes the architecture
- a distinction between concepts that must not be conflated
- an invariant
- an important rejected interpretation, and why it was rejected
- a translation rule, fixed vocabulary, or mapping
- an empirical fact established against the source system
- an unresolved question that must be settled before implementation
- a concise example that clarified the model
- a short quote capturing a conceptual pivot
- a moment where someone pushed back and redirected the design

## How to recognize one

The reliable pattern:

```
proposal
   ↓
pushback or clarification
   ↓
precise distinction
   ↓
empirical or formal check
   ↓
invariant, rule, or architectural decision
```

When a conversation runs that sequence, the distinction that comes out of
it is almost always a strong fieldstone. Watch for the shape rather than
trying to judge importance in the moment.

## The record

Keep it small. One file per stone.

```text
Fieldstone <id> — <short title>

  Topic:
  Status:        settled | provisional | open
  Contribution:  human-led | assistant-led | joint | source-derived
  Summary:
  Formal form or example, if useful:
  Short verbatim quote, only if the exact wording matters:
  Why it matters:
```

Substance goes in the summary. A quote is for colour and provenance —
prefer a sentence or a phrase, and only when the wording itself carries
something a paraphrase would lose.

## Attribution

If someone corrects an assumption, introduces a distinction, narrows
scope, identifies a pitfall, proposes a representation that turns out to
matter, or changes the direction of the design, record that contribution
as theirs.

Do not smooth a real correction into "we decided." The attribution is
part of the fact: knowing a distinction came from pushback tells a later
reader something about how much it cost to find.

## What the pile supports

When the work converges, review what has accumulated and ask what it
actually supports. The honest next artifact may be a refined vision,
another technical illustration, a targeted research project, a concept
specification, or nothing yet.

Do not assume the pile is short of a specification just because it is
large. Several piles never become walls, and that is the method working.

If a concept specification is warranted, the concept-spec SOP owns how to
write one. Reconstruct it from the fieldstones rather than from the
chronology of the conversation, and expect it to be substantially more
concise than the conversation that produced it.

## What this is not

- Not a transcript. Do not preserve every exchange.
- Not a filing system. Do not atomize every thought.
- Not note-taking. You are not a clerk, and the ledger stays secondary,
  compact, and quiet while the real work continues.
- Not a reason to stop solving the problem in front of you.
- Not the specification. Do not start writing one while you are still
  walking around the topic.

## Source

Gerald M. Weinberg, *Weinberg on Writing: The Fieldstone Method*
(Dorset House, 2005). See `../practices/literature/weinberg-fieldstone.md`.
