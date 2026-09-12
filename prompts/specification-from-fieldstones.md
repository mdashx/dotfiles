# Specification From Fieldstones Prompt

Use when accumulated fieldstones, source evidence, and accepted decisions are
stable enough to support a conceptual specification.

```text
Write a concise technical specification from the accumulated fieldstones,
source evidence, and accepted decisions.

Before acting, read these reusable context documents:

- `~/dotfiles/practices/concept-design.md`
- `~/dotfiles/practices/specification-writing.md`
- `~/dotfiles/templates/specification.md`

Do not recreate the conversation as a transcript.

Preserve:

- settled decisions as normative specification text;
- unresolved decisions as explicit open questions;
- empirical source facts that justify the design;
- formal rules and examples that clarify translation or architecture;
- important human-led corrections and pivots in provenance, if requested.

Begin with a concise intent and organize the specification around durable
behavioral concepts rather than files or conversation chronology.

For each important concept, provide one complete interleaved pass:

1. Prose Spec — purpose, state, actions, ownership, exclusions, and relations.
2. Z Spec or another lightweight formal account — shape, transitions,
   constraints, and invariants where formalism adds precision.
3. Data examples — realistic instances, events, requests, outputs, or flows.
4. Implementation suggestions / specifics — enforcement, authority,
   persistence, failure behavior, and integration constraints without turning
   the specification into an execution schedule.

State cross-concept synchronization and open questions explicitly. Use the
Principle Labs specification-writing practice as the method; do not import the
specialized compiler/translation format unless the subject requires it.
```
