---
id: PLC-004
title: Promote reusable practices
status: complete
phase: Phase 4
depends_on: [PLC-002, PLC-003]
acceptance: [A-005]
verification: "test -d practices && find practices -maxdepth 1 -type f | grep -q ."
---

# PLC-004: Promote Reusable Practices

## Objective

Move or copy already-visible reusable methods into `practices/`.

## Candidate Practices

```text
practice distillation cycle
research program orchestration
repository-resident agent orchestration
specification-writing practice
conversation-to-spec fieldstone practice
```

## Constraint

Do not remove standing instructions from `agents/` when they are still useful as
scenario guidance. Use companion practice files when the same idea has both an
instruction form and a human-readable method form.

## Completion Evidence

Created and promoted practice files under:

```text
practices/
```

Verification passed:

```sh
test -d practices && find practices -maxdepth 1 -type f | grep -q .
```

Acceptance discharged: `A-005`.

Next ticket: `PLC-005`.
