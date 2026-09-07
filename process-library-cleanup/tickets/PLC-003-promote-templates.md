---
id: PLC-003
title: Promote reusable templates
status: complete
phase: Phase 3
depends_on: [PLC-002]
acceptance: [A-004]
verification: "test -d templates && find templates -maxdepth 1 -type f | grep -q ."
---

# PLC-003: Promote Reusable Templates

## Objective

Copy or lightly generalize existing artifact skeletons into `templates/`.

## Candidate Templates

```text
fieldstone
research packet
observation
decision
session handoff
ticket
acceptance matrix row
execution state
```

## Constraint

Preserve source provenance. Do not overfit a project-specific artifact into a
universal template.

## Completion Evidence

Created reusable templates under:

```text
templates/
templates/research/
templates/orchestration/
```

Verification passed:

```sh
test -d templates && find templates -maxdepth 1 -type f | grep -q .
```

Acceptance discharged: `A-004`.

Next ticket: `PLC-004`.
