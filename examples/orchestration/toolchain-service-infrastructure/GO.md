# Toolchain Service Infrastructure — Continuous Execution Protocol

**Status:** Active — plan adopted 2026-09-07

The existence of this file is not authorization to execute the plan. An instruction to work generally in `rad-nlp`, inspect the research, or implement the radiology application does not activate this project.

After explicit adoption:

1. Read `PLAN.md`, `STATE.md`, `DECISIONS.md`, and `ACCEPTANCE-MATRIX.md`.
2. Confirm that `STATE.md` records the project as adopted.
3. Resume its active ticket, or select the lowest-numbered ready ticket whose dependencies are complete.
4. Read the ticket's cited plan and UI-specification sections plus any accepted decisions it names.
5. Establish the ticket baseline using its verification command or the nearest narrower implemented gate.
6. Implement the complete vertical service slice.
7. Run verification from narrowest contract tests through the ticket gate and required regressions.
8. Record changed files, commands, outcomes, measurements, artifacts, and deviations in the ticket.
9. Mark a ticket complete only after its verification passes and evidence is recorded.
10. Update the ticket, `STATE.md`, and affected acceptance rows together.
11. Continue immediately through the next ready ticket unless a stop condition applies.

## State machine

```text
planned → ready → in_progress → complete
                    └────────→ blocked
```

Only one ticket may be `in_progress`.

`blocked` is reserved for an unavailable external input, unsafe operation, or material decision not covered by the adopted plan. A failed test, crashed service, memory-growth finding, or incorrect response remains active engineering work.

## Decision discipline

- The assumptions in `DECISIONS.md` remain proposed until adoption explicitly accepts them or a ticket records an accepted replacement.
- Small implementation choices may be made inside a ticket if they preserve contracts and plan boundaries.
- Changes to service grouping, public endpoints, state semantics, supervision, artifact identity, or UI concepts require an appended decision record.
- Empirical service behavior outranks a convenience assumption. Preserve the evidence and revise the proposal explicitly.

## Verification order

```text
fixture/unit
  → endpoint contract
  → direct resident heavy smoke
  → supervision/restart
  → Go-hub integration
  → assembled service path
  → UI semantic DOM
  → offline final gate
```

## Stop conditions

Execution stops only when:

1. every required ticket and acceptance obligation passes and the final gate succeeds;
2. an external requirement or material unapproved decision prevents safe progress; or
3. continuing would be destructive, unsafe, or outside the adopted scope.

When blocked, record the exact condition, evidence, attempted safe alternatives, and first required resumption action in `STATE.md`.
