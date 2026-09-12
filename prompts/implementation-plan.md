# Implementation Plan Prompt

Use when the target is clear enough to translate into ordered, verifiable work.

```text
Write an implementation plan from the accepted source documents, evidence, and
decisions.

Before acting, read these reusable context documents:

- `~/dotfiles/practices/implementation-planning.md`
- `~/dotfiles/templates/implementation-plan.md`
- `~/dotfiles/practices/repository-resident-agent-orchestration.md`

Name the source artifacts and distinguish settled design from remaining
questions. Do not introduce new product behavior silently; return material
design uncertainty to research, technical illustration, or specification.

Organize the plan into ordered phases or vertical slices. For each slice give
its objective, dependencies, implementation scope, observable acceptance
behavior, verification evidence, and any condition that would require renewed
design work.

Include the current baseline, constraints, integration or migration concerns,
the first meaningful milestone, the overall completion predicate, and any
human gates. Make the result suitable for repository-resident orchestration if
the work requires sustained execution.
```
