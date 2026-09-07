# Report Generation Research

This directory is the research boundary for transforming validated radiology
semantics into a report.

Report generation is downstream of transcript interpretation, but its research
is expected to reveal missing distinctions in the interpreter's semantic IR and
in the domain ontology. Those findings must become explicit upstream proposals;
the generation process must not silently invent missing clinical meaning.

## Conceptual boundary

```text
validated semantic evidence
  -> report content selection
  -> document planning
  -> report abstract syntax tree
  -> surface realization
  -> rendered report
  -> validation
```

The following representations must remain distinct:

- source-grounded semantic evidence;
- selected report content and communicative obligations;
- the report's structural and rhetorical AST;
- rendered language produced by templates or an LLM.

Prompts and templates are candidate realization mechanisms. They are not the
canonical report model or the specification of report meaning.

## Research tracks

Initial research should determine:

1. what information a radiology report must, may, and must not communicate;
2. which report genres, sections, and reporting contexts affect those rules;
3. the stages between semantic evidence and final language;
4. the node types, relations, and invariants of a report AST;
5. how templates and prompts realize that AST;
6. how completeness, fidelity, contradiction, uncertainty, and unsupported
   assertions are validated;
7. which discoveries require refinement of the NLP semantic contract or the
   ontology.

## Directory map

| Directory | Purpose |
| --- | --- |
| `sources/` | External standards, reporting authorities, papers, and provenance records |
| `notes/` | Source-specific analysis and provisional domain modeling |
| `examples/` | Reviewed semantic-input, report-plan, AST, and rendered-report examples |

Durable conclusions that affect more than report generation belong in
`../decisions/`. Future normative specifications should live at the project
root beside the transcript interpretation specifications. Executable report
generation code will receive its own top-level subsystem when its contracts are
ready to implement.

## Current status

The first empirical inventory is recorded in
[`notes/2026-09-07-radpair-resource-inventory.md`](notes/2026-09-07-radpair-resource-inventory.md).
The position and design exploration for replacing LLM-primary study selection
is in
[`notes/2026-09-07-why-study-selection-should-not-be-llm-primary.md`](notes/2026-09-07-why-study-selection-should-not-be-llm-primary.md).
The descriptive post-mortem of the concepts that make up a report is in
[`REVERSE-REPORT-CONCEPTUAL-SPEC.md`](REVERSE-REPORT-CONCEPTUAL-SPEC.md).
It covers the backend resource model and runtime, committed seed/configuration
inputs, the `radpair_dev_backup.dump` extraction, and adjacent template
conversion/engine repositories. No report-generation architecture, AST,
template language, prompt design, or rendering technology has been selected.
