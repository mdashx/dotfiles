# GO! — Continuous Execution Protocol

This file is the resumable operating procedure for implementing the RadLex Prolog compiler. An agent instructed to “GO” should continue through all ready tickets without asking for routine supervision.

## Execution Loop

1. Read `AGENTS.md`, `orchestration/STATE.md`, and `orchestration/ACCEPTANCE-MATRIX.md`.
2. If `STATE.md` names an active ticket, open it and resume it.
3. Otherwise, select the lowest-numbered ticket whose dependencies are complete and whose status is `ready` or `planned`.
4. Read the ticket's cited sections in the compiler specification and any accepted decision records it names.
5. Establish the baseline by running the ticket's verification command or the nearest available narrower test.
6. Implement the complete vertical slice described by the ticket.
7. Run the ticket verification, then relevant regression tests. Run broader verification at milestone gates.
8. Record in the ticket:
   - files changed;
   - commands run and their outcomes;
   - acceptance evidence;
   - any deviations or new decisions.
9. Mark the ticket `complete` only after all acceptance conditions pass.
10. Update `orchestration/STATE.md` and affected rows in `orchestration/ACCEPTANCE-MATRIX.md`.
11. Select the next ready ticket immediately and repeat.

## State Transitions

```text
planned → ready → in_progress → complete
                    └────────→ blocked
```

- `planned`: dependencies are not complete.
- `ready`: dependencies are complete and work can begin.
- `in_progress`: the ticket is the current unit of work.
- `complete`: verification passed and evidence is recorded.
- `blocked`: progress requires external input or a material semantic decision; the exact condition and attempted resolutions are recorded.

Only one ticket may be `in_progress` at a time.

## Test Hierarchy

Run tests from narrowest to broadest:

1. fixture/unit tests for the changed semantic shape;
2. ticket-specific integration tests;
3. full fixture suite with `make test`;
4. real-corpus checks when required by the ticket;
5. `make verify` at milestone gates and final completion.

A testable unit crosses the whole compiler boundary:

```text
source fixture → RDF graph → IR → normalization → validation → emitted term → provenance
```

## Decision Handling

- Small implementation choices may be made within a ticket when they preserve all stated semantics.
- Durable choices affecting interfaces, representations, determinism, or downstream use go in `orchestration/DECISIONS.md`.
- A discovery that contradicts the source inventory must produce evidence and a proposed decision before the plan is changed.
- Never reinterpret an unsupported shape merely to keep compilation moving.

## Stop Conditions

Continue until one of these conditions holds:

1. **Complete:** all required tickets and acceptance rows pass, and `make verify` succeeds.
2. **Externally blocked:** required source data, credentials, permissions, or a material human decision is unavailable after safe local alternatives are exhausted.
3. **Unsafe:** continuing would risk destructive or unauthorized changes.

When blocked, update `STATE.md` with the exact blocker, evidence, and the first command or decision needed to resume. A normal test failure is work to diagnose, not a reason to stop.
