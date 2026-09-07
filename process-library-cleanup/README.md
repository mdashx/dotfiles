# Process Library Cleanup

This directory is the orchestration workspace for cleaning up reusable agent,
prompt, specification, research, and execution-process material into the
`~/dotfiles` repository.

It is a project workspace, not the final library.

The intended final library shape is:

```text
~/dotfiles/
  agents/
  prompts/
  practices/
  templates/
  examples/
  research/
```

## Operating Model

Use this workspace as a repository-resident state machine:

```text
PLAN.md                 semantic goal and execution phases
STATE.md                resumable cursor
ACCEPTANCE-MATRIX.md    proof obligations
DECISIONS.md            durable cleanup decisions
tickets/                bounded work contracts
subagents/              scoped packets for delegated workers
```

The cleanup should preserve existing material and boundaries. Do not turn
project-specific examples into universal guidance unless a reusable pattern is
already visible in the source files.

## Resume Rule

To resume this project:

1. Read `PLAN.md`.
2. Read `STATE.md`.
3. Read the active ticket named in `STATE.md`.
4. Use subagent packets only for independent inventory or review tasks.
5. Update the ticket, acceptance matrix, decision log, and state together.
