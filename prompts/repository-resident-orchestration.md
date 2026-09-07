# Repository-Resident Orchestration Prompt

Use when starting a sustained implementation or cleanup effort that must be
resumable across agents and context loss.

```text
Create a repository-resident orchestration workspace for this effort.

Separate:

- PLAN.md: semantic goal, scope, phases, completion criteria;
- STATE.md: durable cursor and next action;
- ACCEPTANCE-MATRIX.md: proof obligations and evidence;
- DECISIONS.md: durable decisions;
- tickets/: bounded work contracts;
- subagents/: packet definitions, if delegation is useful.

The repository should contain enough state for another agent to resume without
reconstructing the project from conversation history.

A ticket becomes complete only when its verification passes and completion
evidence is recorded.
```
