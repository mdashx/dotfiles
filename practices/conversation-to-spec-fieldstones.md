# Conversation-To-Spec Fieldstones

Source pattern: `agents/conversation-to-spec-fieldstone.md`.

## Purpose

Preserve the small number of durable design facts discovered during a long
technical conversation so they can later support a specification.

The purpose is not note-taking. The conversation remains focused on solving the
problem at hand.

## Fieldstone Rule

```text
Collect only what may help construct the eventual specification.
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

When writing the final specification, reconstruct the document from the
fieldstones rather than from the chronology of the conversation.
