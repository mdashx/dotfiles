# Conversation Fieldstones

Source pattern: `agents/conversation-to-spec-fieldstone.md`.

## Purpose

Preserve the small number of durable design facts discovered during a long
research or technical conversation so they can support later understanding and
decisions.

The purpose is not note-taking. The conversation remains focused on solving the
problem at hand.

## Fieldstone Rule

```text
Collect only what may help clarify a later artifact or decision.
```

A fieldstone may be:

- a governing design principle;
- a decision that changes architecture;
- a distinction that must not be conflated;
- an invariant;
- an important rejected interpretation;
- a translation rule;
- an empirical source fact;
- an unresolved question;
- a concise example that clarified the model;
- a human-led correction or design pivot.

## Attribution

When the human corrects an assumption, introduces a distinction, narrows scope,
or redirects the design, preserve that contribution explicitly as human-led.

Use `templates/fieldstone.md` for the artifact shape.

## Later Use

Fieldstones may refine the living vision, motivate another technical
illustration, define a targeted research project, support a conceptual
specification, or justify an implementation plan.

When constructing any later artifact, organize it around the problem rather
than the chronology of the conversation. Do not assume that every fieldstone
belongs in a specification or that a specification is the required outcome.
