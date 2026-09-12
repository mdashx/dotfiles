# Markdown Process System Conceptual Specification

## Purpose

This specification defines the system of Markdown files used to coordinate
agents, conversations, research, implementation loops, and reusable process
knowledge across development projects.

The goal is not to make Markdown a workflow engine by itself. The goal is to
make a repository contain enough explicit meaning, state, evidence, and
authority that a coding or research agent can resume useful work without
recovering intent from chat history.

## Core Idea

The system is a lightweight, repository-resident knowledge and workflow model.

```text
human intent
  -> prompt or scenario instruction
  -> project workspace
  -> durable state + bounded work
  -> evidence-bearing outputs
  -> reusable process material, when warranted
```

Markdown files are the durable interface between human judgment, agent
execution, project facts, and future reuse.

## Ontology

### Artifact Kinds

- **Agent instruction:** standing scenario guidance an agent should obey when
  routed to it.
- **Prompt:** an invokable mid-conversation frame for starting or steering a
  session.
- **Practice:** a reusable method, rationale, or judgment rule.
- **Template:** a blank or lightly parameterized artifact shape.
- **Example:** a completed project artifact copied as a reference, not as
  universal guidance.
- **Research note:** provisional material that may later be promoted.
- **Vision:** a living account of purpose, priorities, boundaries, and the
  questions currently shaping a project.
- **Technical illustration:** a concrete but non-normative treatment used to
  inspect a possible architecture, interaction, interface, or system shape.
- **Conceptual specification:** a normative contract organized around durable
  behavioral concepts, their state, actions, ownership, and synchronization.
- **Plan:** a decomposition of a goal into phases, work units, and completion
  criteria.
- **State:** a durable cursor naming current phase, active work, next action,
  blockers, and latest evidence.
- **Ticket:** a bounded work contract with verification and completion
  evidence.
- **Decision record:** an append-only commitment or rejected alternative.
- **Acceptance matrix:** proof obligations mapped to evidence.
- **Packet:** a bounded research assignment with scope, evidence standard, and
  stopping condition.
- **Fieldstone:** a durable design fact or constraint collected before a final
  specification exists.

### Actors

- **Human:** supplies intent, product judgment, authority boundaries, and final
  decisions that cannot be inferred safely.
- **Coordinator:** owns canonical state, work selection, promotion, and
  consistency.
- **Source-writing implementation agent:** changes product files under the
  active ticket and records verification evidence.
- **Research worker:** investigates one bounded packet and writes only within
  its assigned scope.
- **Synthesizer:** promotes supported observations into fieldstones, decisions,
  follow-up questions, or final reports.

## Relations

```text
routes_to(prompt, practice | workspace | agent_instruction)
instantiates(project_workspace, practice)
uses(project_workspace, template)
derives_from(example, project_artifact)
refines(research | technical_illustration, vision)
tests(technical_illustration, design_hypothesis)
grounds(conceptual_specification, vision | evidence | decision)
records(state, active_work)
depends_on(ticket, ticket)
covers(ticket, acceptance_obligation)
supports(evidence, observation | decision | acceptance_obligation)
promotes(observation, fieldstone | decision | action | frontier_question)
supports(fieldstone, vision | technical_illustration | research | conceptual_specification | plan)
translates(plan, sufficiently_clear_target)
```

## Workflow Families

### Vision, Research, and Technical Illustration

```text
vision ↔ research ↔ technical illustrations
                    │
                    ├─ targeted research
                    ├─ conceptual specification
                    └─ implementation plan
```

This is the default convergence loop while the problem, evidence, or design is
still forming. Fieldstones preserve durable facts without forcing a particular
next document. The vision remains editable as research and illustrations
clarify it.

The loop exits honestly according to the remaining uncertainty:

- begin targeted research when a bounded evidence gap controls the decision;
- write a conceptual specification when the behavioral contract is stable and
  benefits from a normative account;
- write an implementation plan directly when the target is already clear
  enough and a separate specification would not improve execution.

### Continuous Research

```text
goal
  -> frontier question
  -> bounded packet
  -> evidence
  -> observation / fieldstone / decision candidate
  -> updated frontier
```

This loop is appropriate when the objective is to reduce uncertainty, map a
codebase or domain, or produce a final research report. It may use parallel
workers, but canonical ledgers are updated by the coordinator.

### Design-Space Search

```text
vision + constraints
  -> decision axes
  -> purposeful variants / technical illustrations
  -> comparison and rejection
  -> fieldstones + refined vision
  -> targeted research | conceptual specification | implementation plan
```

This loop is appropriate for UI, interaction, product, and architecture
exploration where several plausible shapes must be explored before a target can
be specified.

### Repository-Resident Implementation

```text
accepted target
  -> plan
  -> tickets
  -> one active ticket
  -> implementation
  -> verification
  -> evidence
  -> next ticket
  -> final gate
```

This loop is appropriate once work can be divided into verifiable vertical
slices. The accepted target may be grounded in a conceptual specification or
directly in a sufficiently clear vision and research record. The agent acts as
the workflow engine, but the repository owns the state.

### Practice Distillation

```text
recent work
  -> inventory
  -> classification
  -> promote | copy | split | leave
  -> updated process library
```

This loop keeps reusable methods current without converting every successful
project artifact into standing instruction.

## State Machines

### Ticket State

```text
planned -> ready -> in_progress -> complete
                      `-> awaiting_human_gate
                      `-> blocked
```

### Research Packet State

```text
READY
  -> CLAIMED
  -> INVESTIGATING
  -> SUBMITTED
  -> SYNTHESIS
       -> MORE_RESEARCH
       -> EXPERIMENT_REQUIRED
       -> DECISION_READY
       -> CLOSED
       -> DEFERRED
```

### Process Material State

```text
project-local
  -> candidate
  -> classified
  -> promoted | copied_as_example | split | left_project_local | archived
```

## Invariants

```text
standing_instruction(a) => a lives in agents/ or project-local AGENTS.md
prompt(p) => p is invokable content, not automatically obeyed
practice(x) => x explains method; it is not a blank artifact
template(t) => t is sparse and fillable
example(e) => source(e) is recorded and e is not universal guidance
research_note(n) => n may be provisional and may contain unresolved ideas
technical_illustration(i) => i is concrete and explicitly non_normative
conceptual_specification(s) => each concept in concepts(s) has prose, formal account, data examples, and implementation specifics
implementation_plan(p) => p cites accepted sources and does not silently add design
```

For implementation orchestration:

```text
|{t | status(t) = in_progress}| <= 1
state.active_ticket = t <=> status(t) = in_progress
status(t) = complete => verification(t) passed and evidence(t) recorded
```

For research orchestration:

```text
promoted(observation) => evidence exists or confidence is explicitly limited
worker(packet) => writes only inside packet scope
canonical_ledger_update => coordinator or synthesis pass
```

For distillation:

```text
promote(x) => reusable_across_projects(x)
copy_as_example(x) => project_specific(x) and demonstrates_reusable_pattern(x)
leave_project_local(x) => tied_to_project_authority_or_context(x)
```

## Stop Conditions

A continuous loop should continue until its own completion predicate is true.
It should not stop merely because a chat response, cycle, worker batch, ticket,
commit, or milestone completed.

Valid stop conditions are:

- the project or research completion predicate is satisfied;
- an explicit human gate is active;
- a genuine external blocker prevents meaningful progress after safe local
  alternatives are exhausted;
- continuing would be destructive, externally consequential, unsafe, or outside
  scope;
- a declared resource budget is reached and a resumable handoff is written.

## Folder Semantics

```text
agents/     locally maintained scenario instructions
prompts/    reusable conversation frames and startup prompts
practices/  reusable methods and judgment rules
templates/  fillable artifact skeletons
examples/   completed reference artifacts with provenance
research/   provisional notes, policies, and conceptual specs
```

The same idea may appear in more than one form. For example, repository-resident
orchestration can have:

- a prompt to start a new workspace;
- a practice explaining why the workflow works;
- templates for PLAN.md, STATE.md, tickets, and acceptance matrices;
- examples copied from completed projects;
- project-local AGENTS.md or GO.md files that agents obey only in that project.

## Design Principles

1. Preserve artifact boundaries.
2. Make state explicit and resumable.
3. Treat evidence as stronger than prose confidence.
4. Let locally authored or explicitly adopted project instructions extend the
   machine policy; do not inherit upstream directives accidentally.
5. Promote only reusable process material.
6. Prefer bounded packets and vertical slices over vague work streams.
7. Let vision, research, and technical illustration iterate; distinguish the
   point where work becomes normative specification or executable planning.
8. Encode stop conditions and human gates explicitly.
9. Let examples teach without becoming universal rules.
10. Keep the library small enough that routing remains cheaper than rereading
    the whole history.

## Current Gaps

- The prompt library now distinguishes implementation, research, and
  design-space loops, but project examples should continue to test whether the
  prompts are strong enough in real use.
- Some practices have rich examples but sparse templates. Future distillation
  passes should promote only the template fields that recur across projects.
- The boundary among a living vision, technical illustration, conceptual spec,
  practice, and agent instruction should remain intentionally guarded; this
  document defines the system, but it should not become a standing instruction
  dump.
