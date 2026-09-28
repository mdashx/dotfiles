# Jackson, "Concept Design Moves" (NFM 2022) — distilled

Daniel Jackson, MIT. 19pp. Companion to *The Essence of Software*
(Princeton, 2021), which the paper cites as the fuller treatment. This
note carries the load-bearing content; read the PDF for the worked
product examples.

Downloaded 2026-09-28 from
`https://people.csail.mit.edu/dnj/publications/nfm-design-moves-22.pdf`.

## The thesis

Great designs are rarely inventions; they are skilled adaptations of
precedent. Expertise can be codified as (a) standard solutions, (b)
**design moves** — a standard transformation from one solution to
another, and (c) methods for identifying and applying them. Software has
plenty of (a) and almost no (b); refactoring is the notable exception,
and it operates only *after* behaviour has been fixed.

Jackson reserves **software design** for the shaping of behaviour and
**software engineering** for structuring its implementation, and argues
our field over-attends the second. Quoting Brooks: "The essence of a
software entity is a construct of interlocking concepts… the hard part is
the specification, design, and testing of this conceptual construct, not
the labor of representing it."

## A concept has FOUR parts, not three

```
concept Label [Item]
purpose
    classify items into overlapping categories
state
    labels: Item -> set Label
actions
    add_label (i: Item, l: Label)
        i.labels += l
    remove_label (i: Item, l: Label)
        i.labels -= l
    find (ls: set Label): set Item
        return {i: Item | ls in i.labels}
operational principle
    if add_label (i, l) and no remove_label (i, l),
       find (l) returns items including i
    if no add_label (i, l), then find (l) returns items not including i
```

**The operational principle is "one or more scenarios that demonstrate
how the concept fulfills its purpose."** It is per-concept, it is a
narrative over that concept's own actions, and it is deliberately *not*
exhaustive — Jackson notes the Label OP above says nothing about
`clear_labels` or about multi-label `find`, on purpose. It exists "to
explain the basic operation of the concept and not all the details."

A second example, showing the temporal shape an OP often takes:

```
concept Todo
operational principle
    following add_task (t), t is in pending until complete_task (t),
    after which t is in done
```

Concepts are **parameterized** (`Label [Item]`) and instantiated against
another concept's type (`Label [Todo.Task]`). This is how a concept is
reused across applications without depending on any of them.

Notation is Alloy plus a C-style update operator (`+=`, `-=`, `:=`) with
implicit frame conditions. Action preconditions appear as bare formulas
in the body (e.g. `t in pending` in `complete_task`). This is markedly
more compact than a Z operation schema for simple state updates.

## Concept independence — two named properties

1. **Self-contained** — behaviour is defined without reference to other
   concepts. Concepts do not "use" each other the way modules or
   microservices do. Label relies on nothing about items except that they
   exist and can be distinguished.
2. **Purposive** — each brings a benefit definable and evaluable without
   reference to another.

Self-containment also demands *end-to-end* functionality: Label includes
`find`, not merely `add_label`/`remove_label`. A concept that stores
something without offering the use it exists for is not self-contained.

Not every increment of function can be a concept. That restrictiveness is
the point: it keeps the user's mental model composed of independently
intelligible parts, and lets the same concept be reused across systems.

## Synchronization — and why it is a transaction

Concepts compose by running **in parallel**, synchronizing actions.
Procedure call is explicitly rejected as the composition mechanism.

```
app todo-with-labels
include
    Todo
    Label [Todo.Task]
sync Todo.add_task (t)
    Label.add_label (t, PENDING)
sync Todo.complete_task (t)
    Label.remove_label (t, PENDING)
```

Form: "when action A1 happens in C1, action A2 happens in C2." One action
may trigger any number of others, and syncs may be conditioned on state.

Two properties that are easy to miss and are the formally interesting
part:

- **A concept can refuse an action.** If it does, any synchronization
  that would have led to that action is blocked *in its entirety*. A
  synchronization is a transaction; execution is all-or-nothing.
- **Composition is conjunction of specifications.** Borrowed from CSP: if
  `S(C)` is the set of permitted action histories, then `C1 || C2`
  conforms to both `S(C1)` and `S(C2)`. Synchronization can only
  *restrict* which actions happen — never cause a concept to do something
  it would otherwise disallow. Without this, a concept embedded in an app
  could behave unfamiliarly, destroying the user's ability to understand
  it as a separable unit.

Jackson also notes what *not* to bother specifying: UI-imposed orderings
(which actions a page happens to offer) are rarely fundamental and are
better handled in wireframing than written as synchronizations.

## The six moves — three dual pairs

Each pair trades property P against P'. A move one way buys P at the cost
of P'; its dual buys P'.

| Pair | Trade-off | Mechanical analogue |
| --- | --- | --- |
| **Split / Merge** | flexibility ↔ simplicity and directness | Photocopy split into Print + Scan; flashlight merging Flashlight + Battery + Charger |
| **Unify / Specialize** | generality ↔ specificity | adjustable wrench replacing a set; macro lens specialized for close-ups |
| **Tighten / Loosen** | automation ↔ control | aircraft toilet light locked to the door; dimmer decoupled from the on/off switch |

Software examples Jackson gives: **Split** — Fullscreen slowly emerging
as a concept of its own in Keynote, completed when Zoom presenting
demanded presenting without fullscreen. **Merge** — Yellkey fusing
ShortURL and Expiry so tightly they have no independent existence, which
is what lets a short URL be a common word. **Unify** — MIT Moira reusing
one `List` concept for mailing lists and admin groups; elegant, but
admits cyclic ownership and lists nobody can edit. **Specialize** —
Lightroom keeping Rating, Flag and ColorLabel as three concepts for one
scenario. **Tighten** — Hugo's `date` metadata field doing double duty as
publication schedule. **Loosen** — ProCamera giving Focus and Exposure
independent target points.

Note the honesty in each: Jackson states the cost of every move he
praises. Unification in Moira creates cycles; tightening in Hugo permits
broken links. A move is a trade, never a free improvement.

## Why this matters for how we write specs

Three consequences worth carrying into `../concept-design.md` and
`../specification-writing.md`:

1. **An OP is a buildability test.** You cannot write a scenario
   demonstrating a concept fulfilling its purpose if nothing in the
   system performs the actions. Requiring an OP per concept catches
   specified-but-unbuilt state in a way a state schema does not.
2. **A concept with no actions may not be a concept.** If the honest
   answer to "what actions does this have?" is "none," it is likely the
   *state* of some other concept rather than a concept in its own right.
3. **Moves give a vocabulary for revision.** "We should merge these two"
   or "this wants loosening" is more actionable, and more reviewable,
   than "this feels wrong."
