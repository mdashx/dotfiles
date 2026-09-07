# Research Program Orchestration

Source pattern: `wingman-26/research/00-research-program.md`.

## Purpose

Run an open-ended research program with bounded outputs. The goal is to expose
evidence, uncertainty, contradictions, and next actions without pretending to
understand everything before moving forward.

## Operating Loop

```text
goal
  -> frontier question
  -> bounded investigation
  -> observation with evidence
  -> fieldstone, decision candidate, or follow-up
  -> decision / experiment / more research
  -> updated frontier
```

## Evidence Vocabulary

- **VERIFIED** - directly established from current code, configuration, tests,
  logs, source documents, or repeatable experiments.
- **INFERRED** - strongly suggested by evidence but not traced or tested
  end-to-end.
- **HYPOTHESIS** - a candidate explanation or architecture to investigate.
- **UNKNOWN** - evidence is insufficient.

Do not silently promote an inference or hypothesis into a fact.

## Research Packet Standard

Every bounded investigation should identify:

- objective and question;
- scope and starting evidence;
- method;
- required output;
- evidence standard;
- stopping condition;
- follow-up triggers.

The stopping condition is not "understand everything." It is that the contract,
boundary, uncertainty, and next action are explicit enough to continue safely.
