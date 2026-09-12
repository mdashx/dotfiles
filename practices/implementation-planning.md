# Implementation Planning

Source pattern: Principle Labs research implementation plans and completed
repository-resident orchestration programs.

## Purpose

An implementation plan translates a sufficiently clear target into ordered,
buildable, and verifiable work. It may follow a conceptual specification, or
it may follow directly from a clear vision and adequate research when a
separate specification would not improve the work.

The plan must identify its source artifacts and must not quietly introduce new
product or conceptual design. If implementation planning exposes a material
design uncertainty, return that question to research, technical illustration,
or specification work.

## Contents

A useful plan establishes:

- intent, scope, and non-goals;
- accepted source documents and decisions;
- current implementation baseline;
- architectural and operational constraints;
- implementation boundaries and ownership;
- ordered phases or vertical slices;
- dependencies and safe sequencing;
- observable acceptance criteria;
- verification commands or evidence;
- risks, migrations, rollout, and recovery where relevant;
- the first meaningful milestone;
- the completion predicate and any human gates.

## Work Slices

Prefer complete vertical slices that produce observable behavior over queues of
layer-specific activity. Each slice should name:

- its objective;
- dependencies;
- implementation scope;
- acceptance behavior;
- verification evidence;
- conditions that would send the work back to design or research.

Acceptance criteria should describe outcomes: a command succeeds, a request
has a defined response, a state transition preserves an invariant, a UI exposes
the specified behavior, or a failure is handled in a particular way.

## Relationship to Orchestration

The implementation plan defines the work and its completion conditions.
Repository-resident orchestration adds durable execution state, tickets,
decisions, acceptance evidence, and resumption mechanics.

Do not force every plan into orchestration. Use orchestration when the work is
long-running, multi-stage, delegated, interruption-prone, or requires durable
proof across agent sessions.
