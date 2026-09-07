# Feature-Flagged Adapter Rollout

Source pattern: `wingman-26/research/09-adapter-implementation-plan.md`.

## Purpose

Introduce a replacement or adapter behind a reversible boundary while
preserving host infrastructure, rollback, and comparison against existing
behavior.

## Pattern

```text
existing host behavior
      |
      v
server-authoritative mode selection
      |
      +-- legacy path
      |
      +-- adapter path
              |
              v
       parity and correctness gates
```

## Required Controls

- a coarse feature flag or mode selector;
- a kill switch;
- dark-launch or shadow comparison when feasible;
- contract tests at the entry and exit boundaries;
- rollback instructions;
- evidence that host responsibilities remain separated from replacement
  internals.

## Decision Rule

Begin implementation when remaining uncertainty is explicit, bounded,
reversible or experimentally reducible, and protected by a contract or
correctness fixture.
