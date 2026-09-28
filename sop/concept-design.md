# Concept Design

A concept is a small, durable unit of behaviour that can be understood on
its own. Concept design is how a pile of fieldstones becomes a set of
them.

This is not a procedure for inventing concepts from a blank page.
Concepts precipitate out of the material collected during a design
conversation — see `fieldstone-method.md`. By the time you are here, you
have candidates, and the work is deciding whether they are real and
writing them down.

## A concept has four parts

Purpose, state, actions, and an **operational principle**. All four, or
it is not yet a concept.

```text
Label [ITEM]

purpose
    classify items into overlapping categories

state
    labels: ITEM → ℙ LABEL

actions
    AddLabel
      ΔLabel
      i?: ITEM; l?: LABEL
      labels′ = labels ⊕ { i? ↦ labels(i?) ∪ {l?} }

    RemoveLabel
      ΔLabel
      i?: ITEM; l?: LABEL
      labels′ = labels ⊕ { i? ↦ labels(i?) \ {l?} }

    Find
      ΞLabel
      ls?: ℙ LABEL; items!: ℙ ITEM
      items! = { i: ITEM | ls? ⊆ labels(i) }

operational principle
    if AddLabel(i, l) and no RemoveLabel(i, l),
       then Find({l}) returns a set including i
    if no AddLabel(i, l),
       then Find({l}) returns a set not including i
```

Note the parameterization. `Label [ITEM]` relies on nothing about items
except that they exist and can be told apart, which is what lets the same
concept be reused in a different system.

## The operational principle

**One or more scenarios that demonstrate the concept fulfilling its
purpose.** A narrative over that concept's own actions.

It is deliberately incomplete. The Label principle above says nothing
about clearing all labels, or about what `Find` does with several labels
at once. It explains the basic operation, not the details.

Principles often take a temporal shape:

```text
Todo
operational principle
    following AddTask(t), t is in pending until CompleteTask(t),
    after which t is in done
```

Write it last, and treat difficulty writing it as information:

- **Cannot write one because there are no actions to narrate.** The
  candidate is probably state belonging to some other concept.
- **Cannot write one without describing another concept.** It is not
  self-contained. Either fold it in or find the missing action.
- **Can only write one in the future tense.** Nothing performs it yet.
  That is legitimate for an intended design, but say so — a specification
  should never leave a reader unable to tell whether a mechanism exists.

That last case is the cheap check that catches a document describing
machinery nobody wrote.

## Independence

Two properties, both required.

**Self-contained.** Behaviour is defined without reference to other
concepts. Concepts do not call each other. This also demands *end-to-end*
function: Label owns `Find`, not merely add and remove. A candidate that
stores something without offering the use it exists for is not
self-contained — it is half a concept.

**Purposive.** It brings a benefit statable and assessable without
reference to another concept. If you cannot say what is worse in a world
without it, without mentioning its neighbours, it is not purposive.

Not every increment of function can be a concept, and that restriction is
the point. It keeps the model composed of parts a reader can hold
separately.

## Testing a candidate

Ask in this order. The first failure is usually the real one.

1. What independent purpose justifies it? State it in one sentence
   without naming another concept.
2. What state must it own to serve that purpose?
3. What actions establish, observe, or change that state?
4. Can you write an operational principle over those actions?
5. Can it be understood without importing the rest of the system?
6. What here actually belongs to an adjacent concept?

**Split** a candidate when its state or actions serve unrelated purposes.
**Combine** candidates when neither has an intelligible purpose alone.

A schema that keeps growing, or that needs awkward qualification, is
usually telling you the concept is doing two jobs.

## Composing concepts

Concepts run in parallel and compose by **synchronizing actions**, not by
calling each other:

```text
app todo-with-labels
include
    Todo
    Label [Todo.TASK]
sync Todo.AddTask (t)
    Label.AddLabel (t, PENDING)
sync Todo.CompleteTask (t)
    Label.RemoveLabel (t, PENDING)
```

Two properties matter and are easy to miss:

**A synchronization is a transaction.** A concept may refuse an action.
If it does, the whole synchronization is blocked — all or nothing.

**Composition is conjunction of specifications.** If `S(C)` is the set of
histories a concept permits, then `C₁ ∥ C₂` conforms to both `S(C₁)` and
`S(C₂)`. Synchronizing can only *restrict* what happens; it can never
make a concept do something it would otherwise disallow. This is what
lets a reader understand a concept once and trust that understanding
everywhere it appears.

Do not write synchronizations for orderings the interface merely happens
to impose. Which actions a given page offers is a wireframing question.

## Revising a design

Six moves, in three dual pairs. Each trades one property for its
opposite, so each has a cost.

| Move | Buys | Costs |
| --- | --- | --- |
| **Split** a concept into several | flexibility | directness |
| **Merge** several into one | simplicity | flexibility |
| **Unify** variants into one general concept | generality | specificity |
| **Specialize** into distinct variants | specificity | generality |
| **Tighten** a synchronization | automation | control |
| **Loosen** a synchronization | control | automation |

Use them as vocabulary. "This wants loosening" is more reviewable than
"this feels wrong."

**Always name the cost.** Jackson does this for every move he praises:
unifying mailing lists with admin groups permits cyclic ownership and
lists nobody can edit; tightening a metadata field into a publication
schedule permits broken links. A move presented as a free improvement has
not been thought through.

## Notation

Lightweight Z. Enough vocabulary for most concepts:

| | |
| --- | --- |
| `ℕ` `𝔹` `seq CHAR` | natural, boolean, string |
| `ℙ X` | set of `X` |
| `X → Y` `X ↦ Y` | total function, maplet |
| `dom f` `ran f` | domain, range |
| `Δ` `Ξ` | operation changes / preserves state |
| `⊕` | function override |
| `::=` | closed enumeration |

Keep it small. Formalism is here to make the shape precise, not to
demonstrate rigour. A concept with little state gets a short schema, and
if the formal account grows out of proportion to the prose, the concept
is probably doing too much.

For a simple state update, a compact action body is often clearer than a
full operation schema — `i.labels += l` says as much as three lines of Z
and reads faster. Use the schema when the transition has a precondition
or an invariant worth stating.

## Common failures

- **Three parts instead of four.** The operational principle is the one
  that goes missing, because nothing else in the document depends on it.
- **A concept with no actions.** Usually state that belongs to a
  neighbour. Legitimate only when the producing action genuinely sits
  outside the boundary you are specifying — and then name the producer.
- **Organizing around files, services, or frameworks.** Those are
  implementation structure. A concept survives being rebuilt on different
  machinery.
- **Importing implementation.** Enforcement, persistence and failure
  behaviour are real, and they belong to the specification that contains
  the concept, not to the concept itself.

## Source

Daniel Jackson, *Concept Design Moves* (NFM 2022), and *The Essence of
Software* (Princeton, 2021). Distilled at
`../practices/literature/jackson-design-moves.md`, which carries the
worked product examples and the fuller account of synchronization.
