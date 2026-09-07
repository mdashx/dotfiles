# Process Library Cleanup Orchestration Plan

## Purpose

Create a reusable best-practices library in `~/dotfiles` by organizing existing
agent guidance, prompts, practices, templates, examples, and research notes.

The source material comes from recent work activity already present on this
machine. The work should distill and relocate existing patterns, not invent a
new process language.

## Governing Principle

```text
Preserve existing practice boundaries; promote only reusable material.
```

## Target Library Shape

```text
~/dotfiles/
  agents/       scenario instructions an agent should obey
  prompts/      reusable conversational prompts and mid-session frames
  practices/    human-readable process methods and best-practice writeups
  templates/    fillable artifact skeletons
  examples/     completed reference artifacts from real projects
  research/     exploratory notes and not-yet-promoted policies
```

## Classification Rules

Use the smallest fitting category:

```text
agent instruction
    A scenario-specific rule an agent should follow.

prompt
    A reusable conversation frame used during a session.

practice
    A durable method or judgment rule, written for humans and agents.

template
    A blank or lightly parameterized artifact shape.

example
    A project-specific completed artifact that demonstrates a reusable pattern.

research
    A provisional note, policy, or investigation that should not yet be promoted.
```

If the boundary is unclear, leave the material in `research/` or copy it into
`examples/` rather than generalizing it.

## Source Areas

Initial source areas:

```text
~/dotfiles/agents/
~/dotfiles/research/
~/wingman-26/research/
~/rad-nlp/research/
~/principlelabs67-workbench/*/research/
```

Project-local files should usually remain project-local. Copy them into
`examples/` only when they illustrate a reusable pattern.

## Execution Phases

### Phase 0: Foundation

Create this orchestration workspace and record the plan, state, acceptance
obligations, and first tickets.

### Phase 1: Inventory

Build an inventory of candidate files with:

```text
path
current role
recommended destination
action: keep | move | copy | split | leave | archive
reason
confidence
```

### Phase 2: Skeleton

Create missing final-library directories and lightweight routing READMEs.

Do not rewrite existing `agents/` guidance except where a later ticket
explicitly calls for a narrow routing update.

### Phase 3: Template Promotion

Copy or lightly generalize clear templates from existing research artifacts.
Likely candidates include:

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

### Phase 4: Practice Promotion

Promote already-visible reusable methods into `practices/`, especially:

```text
practice distillation cycle
research program orchestration
repository-resident agent orchestration
specification-writing practice
conversation-to-spec fieldstone practice
```

Keep companion agent instructions in `agents/` when the same practice also has
an operational scenario form.

### Phase 5: Prompt Library

Create prompt files only where the existing material is meant to be invoked
inside a conversation rather than treated as standing instruction.

Prompt files should be concise and directly usable.

### Phase 6: Examples

Copy selected project-specific reference artifacts into `examples/` when they
demonstrate reusable patterns. Preserve source provenance in each example
directory.

### Phase 7: Routing And Cleanup Record

Update relevant README routing and write a migration note recording:

```text
what moved
what was copied
what stayed project-local
what remains provisional
what should be reviewed in the next distillation pass
```

## Subagent Strategy

Use subagents only for independent, bounded work. The coordinator owns the
canonical inventory, decisions, and final edits.

Good subagent tasks:

```text
inventory one source area
classify candidate files from one project
compare similar files for overlap
extract templates from one source directory
review routing README completeness
```

Avoid delegating:

```text
final classification decisions
edits to shared canonical files
large rewrites
promotion of project-specific content into universal practice
```

Subagents should write findings into `subagents/<packet-id>/` or return a
concise report. The coordinator promotes accepted material.

## Stop And Resume Protocol

At any stopping point:

1. Update `STATE.md`.
2. Mark the active ticket status accurately.
3. Record completed evidence in the active ticket.
4. Update `ACCEPTANCE-MATRIX.md` when an obligation is satisfied.
5. Add decisions to `DECISIONS.md` if the cleanup boundary changed.

The project is resumable when another agent can determine the next action from
`STATE.md` and the active ticket without reading the prior conversation.

## Completion Criteria

This project is complete when:

```text
1. reusable process files have obvious homes;
2. agent instructions, prompts, practices, templates, examples, and research are separated;
3. project examples remain distinguishable from general guidance;
4. README routing explains where future material belongs;
5. the migration note records what changed and what remains provisional;
6. no known duplicate or conflicting process file remains unclassified.
```
