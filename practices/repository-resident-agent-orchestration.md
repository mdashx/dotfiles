# Repository-Resident Agent Orchestration

## Purpose

This note describes a lightweight orchestration system for sustained coding-agent work. The model was recovered from the completed RadLex Prolog compiler project, where a normative specification, an implementation plan, a dependency-ordered ticket queue, a resumable state record, an acceptance matrix, and executable verification gates worked together to carry the project to completion.

The system is best understood as a repository-resident, evidence-carrying state machine. It is not merely a project plan or task list. It separates meaning, work decomposition, execution state, implementation decisions, and proof of completion into distinct artifacts.

The governing principle is:

> A work item advances only when its executable verification passes and its evidence is recorded; the repository must always contain enough state for another agent to resume without reconstructing the project from conversation history.

## System Overview

```text
Normative specification
"What must the system mean?"
          │
          ▼
Implementation plan
"What architecture and sequence will realize it?"
          │
          ▼
Ticket dependency graph
"What is the next bounded vertical slice?"
          │
          │ interpreted by the execution protocol
          ▼
One active ticket
          │
          ├── implementation
          ├── narrow tests
          ├── integration or corpus evidence
          └── regression gates
          │
          ▼
Completion record
          │
          ├── updates the resumable state
          └── discharges acceptance obligations
          │
          ▼
Final verification gate
"Is the entire project demonstrably complete?"
```

## Orchestration Artifacts

The model uses several small artifacts with deliberately different responsibilities.

| Artifact | Responsibility |
| --- | --- |
| Agent guide | Defines authority order, project laws, and execution discipline. |
| Continuous-execution protocol | Defines how an agent selects, executes, verifies, records, and advances work. |
| Normative specification | Defines the required meaning and externally observable behavior of the system. |
| Implementation plan | Converts the specification into concrete architecture, milestones, and sequencing. |
| Ticket queue | Contains dependency-ordered contracts for bounded vertical slices. |
| Execution-state record | Acts as the durable program counter: current phase, active ticket, next action, blockers, and latest evidence. |
| Decision log | Records durable implementation choices that refine, but do not silently rewrite, the specification. |
| Acceptance matrix | Maps global specification obligations to tickets and named executable evidence. |
| Stable operator interface | Exposes prerequisite, test, build, acceptance, and final-verification commands. |
| Orchestration checker | Verifies structural consistency among tickets, statuses, dependencies, acceptance references, and the active cursor. |

This separation prevents one document from simultaneously pretending to be the source of semantic authority, the work queue, the execution log, and the definition of done.

## Formal Model

Let:

```text
T = set of tickets
A = set of acceptance obligations
depends ⊆ T × T
status : T → {planned, ready, in_progress, blocked, complete}
covers ⊆ T × A
```

The central invariants are:

```text
|{t ∈ T | status(t) = in_progress}| ≤ 1

status(t) = in_progress
    ⇒ state.active_ticket = t

status(t) = complete
    ⇒ verification(t) passed
       ∧ completion_evidence(t) recorded

status(t) ∈ {ready, in_progress, complete}
    ⇒ every dependency of t is complete
```

Project completion is stronger than the completion of its final ticket:

```text
Complete(Project) ⇔
    every required ticket is complete
    ∧ every acceptance obligation is passed
    ∧ the final verification gate succeeds
```

## Ticket State Machine

```text
planned → ready → in_progress → complete
                    └─────────→ blocked
```

- `planned` means that one or more dependencies remain incomplete.
- `ready` means that dependencies are satisfied and work can begin.
- `in_progress` identifies the sole active work item.
- `complete` means that verification passed and evidence was recorded.
- `blocked` is reserved for an unavailable external input or a material decision that cannot be made safely from existing authority and evidence.

An ordinary test failure is not a blocker. It is evidence that the active ticket still contains work.

## Continuous Execution Protocol

The agent acts as the workflow engine:

```text
read authority and resumable state
        ↓
resume the active ticket, or select the lowest-numbered ready ticket
        ↓
read its cited specification and accepted decisions
        ↓
establish a test or verification baseline
        ↓
implement the complete vertical slice
        ↓
verify from narrowest to broadest
        ↓
record files, commands, results, evidence, and deviations
        ↓
update ticket + state + acceptance matrix together
        ↓
select the next ready ticket and continue
```

The protocol stops only when the project is complete, an external requirement genuinely prevents progress, or continuing would be unsafe.

## Ticket Contract

A ticket contains machine-readable control fields and a human-readable work contract. A typical header is:

```yaml
id: PROJECT-NNN
title: Short imperative title
status: planned | ready | in_progress | blocked | complete
milestone: M0–Mn
depends_on: [PROJECT-NNN]
spec_refs: ["§x.y"]
acceptance: [A-NN]
verification: make target-or-exact-command
```

The body states:

- the objective;
- the bounded work required;
- acceptance conditions;
- the verification command;
- and, after completion, the evidence produced.

Before a ticket becomes `complete`, its completion record should identify:

- files changed;
- verification commands and their outcomes;
- acceptance evidence;
- decisions or deviations;
- and the next ticket made ready.

The ticket's status is authoritative for that work item. The execution-state record is a resumable cursor and must agree with it.

## Vertical Semantic Slices

Tickets should not normally be horizontal tasks such as "implement the parser module" or "add the validation package." A useful ticket crosses the complete behavioral boundary for one small semantic form:

```text
source fixture
    → input loader
    → intermediate representation
    → normalization
    → validation
    → emitted result
    → provenance
```

For example, a compiler ticket for one source construct should prove all of the following together:

- the supported source shape is recognized;
- malformed variations produce structured diagnostics;
- the normalized output has the required canonical form;
- the complete transformation retains provenance;
- representative real-corpus examples agree with fixture behavior;
- and explicitly prohibited inferences or side effects do not occur.

This makes every completed ticket a usable increment and reduces the risk of building disconnected layers that have never worked together.

## Verification Hierarchy

Verification expands confidence concentrically:

```text
fixture or unit test
        ↓
ticket-specific integration test
        ↓
complete fixture suite
        ↓
real-corpus or real-input accounting
        ↓
consumer-boundary acceptance
        ↓
clean final verification
```

The stable operator interface should name these gates explicitly. A representative interface is:

```text
doctor         verify prerequisites and pinned inputs
orchestration  check workflow-state consistency
test           run fixture and unit tests
inventory      validate the real source/input boundary
build          produce complete artifacts
acceptance     test the consumer-facing boundary
verify         run every required final gate
```

The exact commands may differ by project, but their meanings should remain stable while the implementation evolves.

## Acceptance as Proof Obligations

Tickets describe work. Acceptance rows describe global obligations. These are related but not identical.

An acceptance matrix should record:

```text
obligation
    ↔ normative specification reference
    ↔ implementing ticket or tickets
    ↔ status
    ↔ named executable evidence
```

A row becomes `passed` only when a test, reproducibility artifact, corpus measurement, or similarly inspectable result supports it. Prose confidence is not evidence.

This allows one ticket to discharge several obligations and one cross-cutting obligation to be supported by several tickets.

## Decision Handling

The orchestration model distinguishes three kinds of change:

1. Small implementation choices can be made within a ticket when they preserve the governing semantics.
2. Durable choices affecting interfaces, canonical representations, determinism, or downstream use belong in the decision log.
3. Discoveries that contradict the normative specification or empirical source inventory require evidence and an explicit reconciliation decision.

Accepted decision records are append-only. They are not silently rewritten to make the design history appear more linear than it was.

## Resumability

The execution-state record is intentionally small. It answers:

```text
Where are we?
What is active?
What happens next?
What is blocking progress?
What evidence was most recently established?
```

Detailed history remains in tickets, tests, commits, decisions, and acceptance records. The state file contains only the information needed to resume execution correctly.

This division allows an agent to recover after losing conversational context. It should not need to rediscover completed work or infer the active task from recent file timestamps.

## Repository as Workflow Database

The deeper abstraction is:

```text
Tickets       = workflow nodes
Front matter  = machine-readable control state
State record  = resumable cursor
Protocol      = transition algorithm
Decision log  = semantic change ledger
Acceptance    = proof-obligation ledger
Build targets = executable observations
Tests         = evidence
Version control = history and synchronization
```

The repository is therefore both the implementation workspace and the durable orchestration database. No separate workflow service is required.

## Strengths

- The project can resume without relying on conversation history.
- Semantic authority is separated from implementation sequencing.
- Work is bounded without becoming disconnected from end-to-end behavior.
- Every completion claim points to executable evidence.
- Negative requirements can be tested explicitly.
- Decisions made during implementation remain visible.
- Stable commands provide a small interface for humans, agents, and CI.
- The final definition of done is stronger than "all tickets are closed."

## Limitations and Appropriate Scope

This is deliberately a lightweight formal workflow.

- Its Markdown state is primarily maintained by agents or humans; a checker can validate consistency but cannot prove that narrative evidence is truthful.
- Simple front-matter parsing works best when the project defines and preserves a narrow metadata dialect.
- It assumes one active ticket. Projects requiring substantial parallel work need explicit ownership and merge semantics.
- It is most effective when requirements can be connected to deterministic tests, corpus measurements, or inspectable artifacts.
- It should not grow into a general workflow platform unless actual project evidence demands that complexity.

Within those limits, the system provides a strong balance: the conceptual model is explicit enough to be executable, while the mechanism remains ordinary files, commands, tests, and version control.
