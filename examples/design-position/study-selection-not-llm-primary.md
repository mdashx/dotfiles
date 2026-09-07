# Why study selection should not be LLM-primary

**Date:** 2026-09-07
**Status:** research position and design exploration
**Scope:** selecting a RADPAIR `ReportStudy` from a dictated transcript or
study description.

## Thesis

RADPAIR currently asks an LLM to choose one exact `ReportStudy.name` from a
permission-scoped list. That is a poor primary abstraction for study
identification. It is wasteful because the model is repeatedly solving a
bounded catalog-resolution problem that can be made cheaper, faster, and more
observable. It is incorrect as a source of authority because the model's
output is an unsupported label: it does not expose which transcript evidence
established the study, which distinctions were unresolved, or why competing
catalog entries were rejected.

The intended replacement is not naïve string matching. It is a source-grounded
NLP/ontology resolver that extracts study-defining evidence, grounds that
evidence to domain concepts, maps it to the permitted study catalog, and
abstains when the evidence does not determine a unique study. An LLM can remain
useful as a fallback or ambiguity assistant, but it should not be the primary
authority.

## What the current RADPAIR implementation does

The relevant implementation is concentrated in:

- `backend/app/helpers/report_study_predictor.py`;
- `backend/app/helpers/intgt_reporting/study_extractor.py`;
- `backend/app/routes/reports.py` (`POST /predict/study`);
- `backend/db/models/report_study.py`;
- `backend/db/models/study_mapping.py` and
  `backend/app/services/study_mappings/`.

For a transcript, the predictor:

1. loads the studies the user/organization is allowed to use;
2. collapses duplicate names by user, cascaded organization, and system
   priority;
3. optionally narrows candidates by an explicit modality or by inspecting the
   transcript's first word for a modality prefix;
4. sends the transcript to an LLM with the candidate names in the prompt, or
   as an enum in a tool call;
5. lowercases the returned text and requires an exact catalog-name match;
6. applies a small hard-coded alias table if exact matching fails; and
7. retries configured models and sometimes retries without modality filtering.

Successful predictions are cached in Redis for seven days.

This is a constrained classifier, not a study ontology or a semantic
interpreter. The catalog is the guardrail; the LLM supplies an opaque choice.

## Why LLM-primary selection is wasteful

### It spends a generative model on a closed-world lookup

The output vocabulary is already known: it is the finite set of permitted
`ReportStudy` records. The model is not being asked to create a report or
interpret a genuinely open-ended clinical question. It is being asked to map
language to one of a known set of catalog entries.

That makes repeated prompt construction, model routing, retries, telemetry,
and seven-day prediction caching an expensive substitute for a reusable
normalization and resolution index.

### It duplicates work that belongs upstream

The transcript interpreter already has a direction toward linguistic analysis,
construction recognition, discourse referents, frames, ontology grounding,
provenance, and explicit ambiguity. Asking a second model to rediscover
modality and anatomy from the original string throws away those structured
results and creates two competing interpretations of the same source.

### It adds latency and operational failure modes

Study selection now depends on model availability, provider timeouts, model
configuration, prompt size, output formatting, and fallback behavior before
downstream template/rule selection can begin. A local resolver can handle the
common path without a network call and reserve model calls for genuinely
ambiguous cases.

### It scales poorly with catalog size

The candidate list is injected into the prompt or tool schema. As an
organization's study catalog grows, every prediction becomes a larger context
and a more difficult discrimination problem, even when the transcript contains
clear local evidence.

## Why it is incorrect as the primary authority

### The output lacks evidence and provenance

The result is a string and then an integer ID. There is no durable record of:

- the transcript spans that identified the modality or anatomy;
- the concepts used to normalize aliases;
- the constraints that eliminated alternatives;
- the confidence or margin between candidates; or
- the reason an ambiguity was ignored.

This violates the direction of the RAD-NLP interpretation model, where derived
objects retain source evidence, semantic derivations, ontology alignments, and
diagnostics.

### It can force a false unique answer

The tool schema requires one study from an enum. A transcript may mention only
“MRI” or “CT abdomen” while the catalog contains several protocol-specific
entries. The model is encouraged to choose rather than represent unresolved
information. A wrong study then silently selects the wrong template, rules,
impression family, or report structure.

### It confuses labels with concepts

`ReportStudy.name` is an application catalog label. It is not a stable medical
concept identifier. Two local labels may denote the same procedure, while one
label may hide distinctions that matter to reporting. An LLM can learn common
language associations but cannot make the catalog's conceptual identity
explicit unless the catalog itself is enriched.

### It has no principled contradiction behavior

A transcript can contain conflicting or revised study descriptions. The
current picker has no semantic rule for precedence, scope, negation, correction,
or uncertainty; it simply emits the model's preferred label.

### It makes correctness difficult to test

Exact-string accuracy alone cannot distinguish a lucky answer from a
source-grounded answer. Without evidence and candidate scores, failures are
hard to diagnose and model changes can alter behavior without exposing which
semantic boundary moved.

## What the NLP/ontology system could provide

The existing RAD-NLP direction already supplies the right conceptual pieces:

- linguistic spans and constructions;
- discourse referents and frames;
- RadLex grounding with source-backed candidates;
- explicit ambiguity and diagnostics;
- provenance for derived objects; and
- a rule/logic-oriented semantic layer.

The transcript interpreter's ontology boundary is important: RadLex grounding
may identify concepts mentioned by the transcript, but ontology knowledge must
not invent an unstated patient fact. The same rule should govern study
resolution. A catalog candidate may be supported by transcript evidence and
ontology constraints; it must not be selected merely because an ontology says
that a related procedure exists.

## Proposed study-resolution model

### 1. Define a study-description semantic object

Introduce a source-grounded intermediate object, conceptually:

```text
StudyDescription {
  modality: concept or unresolved
  anatomy: one or more grounded concepts
  procedure: concept or unresolved
  protocol: concept or unresolved
  contrast: value / polarity / unresolved
  laterality: value / unresolved
  body_region: concept or unresolved
  purpose: concept or unresolved
  evidence: source spans and derivations
  ambiguities: alternatives and diagnostics
}
```

The exact schema belongs in the interpreter work, not in a report-template
prompt. Each populated field must point back to transcript evidence and retain
its grounding status.

### 2. Enrich the report-study catalog

Each permitted `ReportStudy` should have a resolver-facing catalog projection:

```text
ReportStudyCatalogEntry {
  report_study_id
  canonical_label
  aliases
  modality concepts/codes
  anatomy concepts
  procedure/protocol concepts
  contrast constraints
  required features
  forbidden/conflicting features
  source and version
}
```

The existing `category`, `name`, and `variants` fields are useful beginnings,
but they are not enough to represent why two studies differ. Organization
study mappings should become explicit alias/source mappings into this catalog,
not the only place where local terminology is remembered.

### 3. Resolve by evidence and constraints

For each catalog entry, compute compatibility from extracted evidence:

```text
compatibility(entry, description) =
    required_features_satisfied
  ∧ no_explicit_conflict
  ∧ modality_compatible
  ∧ anatomy/procedure_compatible
  ∧ scope_allowed
```

A scoring layer may rank compatible candidates, but a score must not erase a
hard contradiction or manufacture missing evidence. The resolver should return
one of:

- `resolved(study_id, evidence, score)`;
- `ambiguous(candidates, distinguishing_features)`;
- `unresolved(missing_or_unknown_features)`; or
- `invalid(conflicting_evidence)`.

Only `resolved` should automatically drive template and rule selection.

### 4. Keep the LLM in a subordinate role

The LLM can still help with:

- generating candidate aliases during catalog curation;
- interpreting an unusual local phrase when deterministic analysis abstains;
- ranking a small, already-compatible candidate set; or
- asking a clarifying question when a human workflow permits it.

Any LLM-produced feature or choice should enter the same evidence/validation
boundary as every other derived result. It should not bypass catalog
constraints or convert an ambiguity into an authoritative `study_id` without
recording that fact.

## Important design boundary: study identity versus findings

Study resolution should use the transcript's procedure/exam description, not
the presence of arbitrary findings. “There is a nodule” does not identify the
study. “CT chest with contrast” may. The interpreter must preserve this
distinction so that ontology grounding of findings does not accidentally drive
exam classification.

Likewise, mention of a study in clinical history, comparison text, or a
recommendation should not automatically become the current study. Discourse
role, temporal reference, and source field must be part of the evidence model.

## Evaluation plan

Build a held-out corpus from real and synthetic transcript metadata with:

- canonical `ReportStudy.id` labels;
- institution-specific source descriptions and aliases;
- ambiguous and underspecified examples;
- conflicting/revised study descriptions;
- multi-study transcripts;
- modality aliases and missing modality; and
- examples where findings must not determine study identity.

Compare three systems:

1. current LLM picker;
2. deterministic/catalog resolver; and
3. hybrid NLP resolver with LLM fallback.

Measure more than top-1 accuracy:

- exact study precision and recall;
- safe-abstention rate;
- false-unique rate;
- contradiction detection;
- evidence-span precision;
- calibration of confidence/margins;
- latency and cost;
- behavior under catalog growth; and
- stability across model/provider changes.

The most important safety metric is false-unique selection: confidently
choosing the wrong study is more damaging than returning an ambiguity that a
workflow can resolve.

## Incremental implementation path

1. Instrument the current predictor to retain transcript, candidate set,
   selected study, modality filter, alias use, model, and outcome.
2. Build a read-only catalog projection from existing `ReportStudy` rows,
   mappings, categories, variants, and templates.
3. Add deterministic modality and anatomy extraction using the RAD-NLP
   interpreter's source-backed outputs.
4. Implement candidate filtering and explicit abstention without changing
   assignment behavior.
5. Run the resolver beside the LLM picker and compare decisions and evidence.
6. Route only unresolved/ambiguous cases to the LLM, with its result validated
   against the same candidate set.
7. Replace automatic LLM assignment only after false-unique performance is
   demonstrated on the held-out corpus.

## Position

The current LLM picker is a useful baseline and fallback, but it is the wrong
place to anchor study identity. Study selection is a bounded, explainable
resolution problem. The RAD-NLP/ontology system can make it a typed,
source-grounded, ambiguity-preserving stage whose output is suitable for
downstream report generation. The LLM should assist that stage where language
is genuinely unresolved—not substitute for the semantic and catalog model.
