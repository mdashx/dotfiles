# Process Library Cleanup Migration

Date: 2026-09-07

## Summary

Created a reusable process-library structure in `~/dotfiles` and populated it
from existing agent, research, specification, orchestration, and project
artifacts.

The cleanup preserved the distinction between standing instructions and
content:

```text
agents/     scenario instructions
prompts/    mid-conversation frames
practices/  reusable methods
templates/  fillable artifact shapes
examples/   project-derived reference artifacts
research/   provisional notes and policies
```

## Created

```text
prompts/
practices/
templates/
examples/
process-library-cleanup/
```

## Promoted As Practices

Created compact practice files for:

- conversation-to-spec fieldstones;
- specification writing;
- research program orchestration;
- research-agent orchestration;
- practice distillation;
- artifact generation methodology;
- feature-flagged adapter rollout.

Copied mature reusable essays into `practices/`:

- repository-resident agent orchestration;
- structured LLM interface;
- debug interface design.

## Promoted As Templates

Added templates for:

- fieldstones;
- research observations;
- decision records and decision notes;
- research packets;
- research session handoffs;
- research frontier and action queues;
- research inventory files;
- example workbenches;
- corpus manifests;
- specifications;
- implementation plans;
- coding-agent tickets;
- repository-resident orchestration artifacts.

## Added Prompts

Added prompt frames for:

- conversation-to-spec fieldstone capture;
- specification writing from fieldstones;
- research packet assignment;
- practice distillation;
- repository-resident orchestration setup.

## Copied Examples

Copied selected examples from:

- `wingman-26/research/`;
- `rad-nlp/research/`;
- `principlelabs67-workbench/ovation-workflows/research/`.

Source provenance is recorded in `examples/SOURCES.md`.

## Left Project-Local

Most project-specific research content, source data, generated corpora, binary
documents, source checkouts, and domain primers remain in their original
projects.

The cleanup copied only selected reference artifacts and did not move source
project files.

## Existing User Change Preserved

`agents/specification-writing.md` had an uncommitted modification before this
cleanup began. It was not rewritten or reverted.

## Provisional / Next Pass

Review in the next weekly or biweekly distillation pass:

- whether `research/repository-resident-agent-orchestration.md` should remain
  duplicated now that a copy exists in `practices/`;
- whether `agents/specification-writing.md` should be shortened now that
  `practices/specification-writing.md` and `templates/specification.md` exist;
- whether a separate `agents/research-orchestration.md` is useful, or whether
  the practice and prompt are enough;
- whether to extract more from the RadLex prompt provenance appendix;
- whether to add more Principle Labs template-backed artifact examples.
