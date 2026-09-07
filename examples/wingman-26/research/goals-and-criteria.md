# Goals and Success Criteria

## Final research goal

Stop when there is high confidence in a final report specifying how the two highest-priority replacement programs can be introduced into RADPAIR:

1. the Wingman reporting / semantic-workspace corridor;
2. the speech-to-text recognition pipeline.

The final report must specify the host-side replacement plan: entry and exit seams, required context, observable contracts, preserved infrastructure, feature-flag strategy, migration order, tests, measurements, risks, and remaining assumptions.

The research must **not** design the internal replacements. It should define the perimeter into which they can be swapped, not decide the ontology implementation, model architecture, recognizer implementation, UI details, prompt strategy, or other internals of the replacement systems.

The research is complete when the remaining unknowns cannot materially change those host-side swap plans, or are explicitly identified as implementation-time concerns outside this research goal.

## G1 — Establish the meaning model

Define the concepts, relations, states, and transitions Wingman must preserve:

- evidence;
- interpretation;
- assertion/report;
- entities and identity;
- findings and relationships;
- ambiguity and contradiction;
- provenance;
- user confirmation;
- semantic validation.

Success: the model is precise enough to guide product behavior and distinguish semantic state from rendered prose.

## G2 — Find coarse replacement boundaries

Identify viable seams for:

- frontend workspace selection;
- backend interpretation/report generation;
- STT recognition;
- report signing and external integration re-entry.

Success: each candidate has an entry seam, exit seam, required context, bypassed legacy systems, flag locations, rollback behavior, risks, and contract tests.

## G3 — Establish correctness and provenance

Preserve the chain from final report assertion to interpretation, transcript, and audio evidence.

Success: no proposed design silently destroys source evidence, correction history, or the ability to explain a report assertion.

## G4 — Freeze host behavior

Trace enough current behavior to protect work-item opening, STT delivery, report generation, signing, integration, and configuration effects.

Success: representative contract fixtures and regression scenarios exist or are explicitly queued.

## G5 — Surface risks and contradictions

Find latency, dependency amplification, external-call, workflow, correctness, usability, and migration risks early.

Success: important risks are represented as decisions, experiments, or explicit accepted unknowns.

## Research completion threshold

Research for a boundary is sufficient when the observable contract is known, ownership is separated, alternatives have been compared, correctness requirements are preserved, unknowns are named, and implementation can begin without inventing major semantics invisibly.
