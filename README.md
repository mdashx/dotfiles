# dotfiles
Keep it simple.

## Process Library

- `agents/` - scenario-specific instructions for coding agents.
- `prompts/` - reusable mid-conversation prompts.
- `practices/` - reusable process methods and best-practice writeups.
- `templates/` - fillable artifact skeletons.
- `examples/` - completed project artifacts copied as references.
- `research/` - provisional notes and policies that are not yet promoted.

## Research And Design Authoring

The default authoring model is iterative rather than a mandatory document
pipeline:

```text
vision ↔ research ↔ technical illustrations
                    │
                    ├─ targeted research
                    ├─ conceptual specification
                    └─ implementation plan → orchestration
```

Start with `agents/README.md` when routing an agent scenario. The relevant
scenario guide then points to the full method in `practices/`; use `templates/`
for a starting shape and `examples/` for completed reference artifacts.

The central authoring practices are:

- `practices/concept-design.md`
- `practices/technical-illustration.md`
- `practices/specification-writing.md`
- `practices/implementation-planning.md`
