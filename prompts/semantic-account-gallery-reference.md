# Semantic Account Gallery Reference Prompt

Use when a project needs to make a complex, source-grounded model intelligible
to developers through research and lightweight interactive examples.

The Semantic Account Gallery is a local reference for the desired *approach and
outcomes*, not its orchestration mechanics. Read only the parts relevant to the
new project:

```text
/home/raddev/rad-nlp-developer-experience/research/dx-transformation-ui/
/home/raddev/rad-nlp-semantic-model-ui-lab/research/semantic-model-ui-lab/
```

Start with:

- `SEMANTIC-ACCOUNT-GALLERY-CONCEPTUAL-SPEC.md`
- `TREATMENT-MATRIX.md`
- `FIXTURE-DOSSIER.md`
- `METRIC-CATALOGUE.md`
- `gallery/`
- the parent project’s `SYNTHESIS.md`, `DIRECTIONS.md`, and handoffs when the
  research rationale is relevant.

Do not copy its tickets, queue, state files, branch conventions, or other
orchestration details unless the new project independently calls for them.

```text
Use the local Semantic Account Gallery as a reference for this project.

Before acting, read these reusable context documents:

- `~/dotfiles/practices/concept-design.md`
- `~/dotfiles/practices/technical-illustration.md`
- `~/dotfiles/practices/conversation-to-spec-fieldstones.md`

First, understand the target project's actual source material, domain model,
developer audience, and safety boundaries. Then use the reference project as a
conceptual and product-design precedent, adapting it rather than copying it.

The big ideas to carry forward are:

1. Separate the fixed authoritative source from the model constructed from it.
   The source remains recoverable evidence. The model becomes more articulated
   through added typed structure, relationships, alternatives, and constraints.

2. Treat the UI as a projection of a model, not as a visualization of runtime
   steps or a certainty ladder. A later view can expose richer structure while
   preserving uncertainty, partiality, disagreement, or unavailable material.

3. Measure the shape of the represented model honestly. Useful measures may
   describe added structure, evidence reach, named relatedness, alternative
   branching, mapping breadth, or constraint footprint. Each measure needs a
   clear scope and an explicit statement of what it does not mean.

4. Do not turn structural measures into confidence, quality, completeness,
   importance, truth, progress, or domain-specific certainty scores unless the
   underlying system actually defines and supports that claim.

5. Keep typed statuses and alternatives visible. Candidate, accepted,
   rejected, unresolved, diagnostic, unavailable, and not-run states are
   distinct facts, not colours on one ordinal scale.

6. Make provenance an explicit, inspectable relationship. Visual proximity,
   graph geometry, ordering, size, colour, or animation must not silently
   claim evidence, identity, causality, probability, or ranking.

7. Explore a real design space rather than polishing the first plausible
   layout. Create meaningfully different UI/UX hypotheses, state the human
   question each tests, and identify the false inference each must resist.

8. When comparing UI directions, hold the underlying model constant. One
   compact, richly structured mock model can let many treatments be compared
   fairly, because differences in understanding can be attributed to the UI
   rather than changed facts or invented metrics.

9. Let each implementation focus on its UI/UX thesis: the first screen, the
   object of attention, information hierarchy, direct manipulation,
   progressive disclosure, orientation recovery, and the moment of insight.
   Do not make every treatment re-explain or redesign the foundational model.

10. Design phone/tablet-first when direct exploration benefits from it. Use the
    limited screen as a forcing function for one clear primary object, compact
    context, deliberate disclosure, and recoverable navigation—not merely as a
    desktop layout shrunk onto a phone.

Produce the smallest useful set of durable outputs for the target project:

- a concise conceptual contract naming the shared source, model, projection,
  relation, status, measure, and safety distinctions;
- a design-space catalogue of genuinely different UI/UX directions, each with
  a question, hypothesis, tradeoff, and misleading implication to test;
- a compact fixture/model dossier and metric definitions when interactive
  comparisons are useful;
- lightweight runnable examples that share the same fixture whenever the goal
  is to compare explanatory treatments; and
- a short synthesis that distinguishes verified evidence, inference, hypothesis,
  unresolved questions, and decisions.

Do not assume the target is clinical, linguistic, or staged like R0–R5. Carry
forward the underlying distinctions, then discover the target project's own
objects, accumulations, measures, and explanatory boundaries from its actual
sources.

Begin by reporting: (a) which local reference artifacts you inspected, (b) the
target project's analogous source/model/projection distinction, (c) the design
questions worth exploring, and (d) the smallest credible outcome set. Do not
implement or rewrite the target project until the requested scope authorizes it.
```
