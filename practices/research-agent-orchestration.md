# Research-Agent Orchestration

Source pattern: `wingman-26/research/07-orchestration.md`.

## Purpose

Coordinate parallel or repeated research work without losing evidence,
promoting unsupported claims, or allowing workers to rewrite canonical state.

## Roles

- **Coordinator:** owns durable program state, selects frontier items, creates
  packets, validates submissions, promotes accepted observations, updates
  decisions/actions, and creates the next frontier.
- **Research worker:** investigates one packet within scope and records
  evidence, confidence, unknowns, contradictions, and follow-up work.
- **Synthesizer:** reviews submissions and identifies fieldstones, decision
  candidates, contradictions, duplicate observations, and new frontier items.
- **Decision pass:** compares alternatives against explicit criteria and
  records commitments as pending, provisional, settled, deferred, rejected, or
  obsolete.

## Worker Isolation

Workers write only inside their assigned packet directory:

```text
inbox/<packet-id>/
    packet.md
    observations.md
    handoff.md
    artifacts/
```

Canonical ledgers are updated by the coordinator or synthesis pass.

## Packet Lifecycle

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

## Promotion Rule

Promote observations only when they have concrete source references or
repeatable experiments. Promote fieldstones only when they are durable enough
to guide later design or specification work.
