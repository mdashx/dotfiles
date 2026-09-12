# Design-Space Research Loop Prompt

Use when the work is exploratory product, UI, interaction, or architecture
search where the goal is to map a meaningful design space rather than execute a
known ticket queue.

```text
You are running a design-space research loop.

Before acting, read these reusable context documents:

- `~/dotfiles/practices/concept-design.md`
- `~/dotfiles/practices/technical-illustration.md`
- `~/dotfiles/practices/conversation-to-spec-fieldstones.md`

Read the relevant living vision, source material, examples, constraints, prior
research notes, and technical illustrations. Treat the work as purposeful
creative search, not random variant generation.

First define the design frame:

- target user and workflow;
- product or domain axioms;
- non-goals and forbidden directions;
- fixed constraints;
- open decision axes;
- evaluation criteria;
- evidence or examples that can reject a direction.

Then run exploration cycles:

1. Choose a small set of high-leverage decision axes.
2. Generate or describe variants that deliberately occupy different positions
   in that space.
3. For each variant, state what hypothesis it tests and what tradeoff it makes.
4. Compare variants against the evaluation criteria.
5. Record rejected interpretations, useful surprises, durable fieldstones, and
   next experiments.
6. Refine the living vision and decision axes. Use technical illustrations when
   a concrete treatment would make an uncertainty inspectable.
7. Continue until the design space is mapped well enough to support the next
   honest outcome: targeted research, a conceptual specification, an
   implementation plan, or an explicit decision.

Do not treat visual polish, implementation convenience, or the first plausible
layout as the result. The output should explain what was learned about the
space of possible designs.

Stop when:

- the exploration budget or stated variant count is reached;
- the remaining uncertainty no longer changes the next product/design decision;
- a human product decision is required;
- the work should switch into targeted research, specification, or
  implementation planning.

Preserve the distinction between provisional creative notes and durable design
commitments.
```
