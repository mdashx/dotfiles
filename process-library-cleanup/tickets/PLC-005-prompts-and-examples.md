---
id: PLC-005
title: Separate prompts and examples
status: complete
phase: Phases 5-6
depends_on: [PLC-004]
acceptance: [A-006, A-007]
verification: "test -d prompts && test -d examples"
---

# PLC-005: Separate Prompts And Examples

## Objective

Create reusable mid-conversation prompts and copy selected completed artifacts
as examples.

## Required Work

- Add prompt files only where existing material has a direct conversational use.
- Copy project-specific files into `examples/` only when they demonstrate a
  reusable pattern.
- Preserve source provenance for copied examples.

## Completion Evidence

Created:

```text
prompts/
examples/
examples/SOURCES.md
```

Verification passed:

```sh
test -d prompts && test -d examples
```

Acceptance discharged: `A-006`, `A-007`.

Next ticket: `PLC-006`.
