---
id: PLC-006
title: Finalize routing and migration record
status: complete
phase: Phase 7
depends_on: [PLC-005]
acceptance: [A-008]
verification: "test -f process-library-cleanup/MIGRATION.md"
---

# PLC-006: Finalize Routing And Migration Record

## Objective

Make the cleanup understandable to future agents and record the pass.

## Required Work

- Update README routing where needed.
- Create `process-library-cleanup/MIGRATION.md`.
- Record what moved, what was copied, what stayed project-local, what remains
  provisional, and what should be reviewed in the next distillation pass.

## Completion Evidence

Updated:

```text
README.md
agents/README.md
research/README.md
```

Created:

```text
process-library-cleanup/MIGRATION.md
```

Verification passed:

```sh
test -f process-library-cleanup/MIGRATION.md
```

Acceptance discharged: `A-008`.

Project status: complete.
