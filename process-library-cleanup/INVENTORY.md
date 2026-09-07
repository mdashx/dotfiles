# Process Library Cleanup Inventory

Generated during `PLC-001` on 2026-09-07.

This inventory classifies existing reusable process material. It is a planning
artifact for cleanup, not a claim that every candidate must be promoted.

## Classification Key

```text
keep      remains in its current final-library location
move      relocate the file because it is already reusable as-is
copy      preserve source file and add a reusable example or companion
split     preserve source file, extract a reusable practice/template/prompt
leave     keep project-local; no final-library action now
archive   remove from active consideration, preserving if needed
```

## Dotfiles

| Path | Current role | Recommended destination | Action | Reason | Confidence |
| --- | --- | --- | --- | --- | --- |
| `dotfiles/agents/README.md` | Agent instruction routing index | `agents/README.md` | keep | Already serves as the scenario router for standing agent guidance. | high |
| `dotfiles/agents/design-conversation.md` | Scenario instruction | `agents/design-conversation.md` | keep | Clear agent behavior guidance for exploratory design work. | high |
| `dotfiles/agents/operational-execution.md` | Scenario instruction | `agents/operational-execution.md` | keep | Clear agent behavior guidance for bounded operational work. | high |
| `dotfiles/agents/plan-execution.md` | Scenario instruction | `agents/plan-execution.md` | keep | Clear agent behavior guidance for executing existing plans. | high |
| `dotfiles/agents/identifier-resolution.md` | Scenario instruction | `agents/identifier-resolution.md` | keep | Clear guidance for approximate dictated identifiers. | high |
| `dotfiles/agents/working-profile-tom-hyndman.md` | Working-profile instruction | `agents/working-profile-tom-hyndman.md` | keep | Useful standing orientation for substantive design and modeling conversations. | high |
| `dotfiles/agents/conversation-to-spec-fieldstone.md` | Conversation-to-spec agent workflow | `agents/` plus `prompts/` and `templates/fieldstone.md` | split | It is usable as scenario instruction, but also contains a reusable fieldstone capture prompt and template. | high |
| `dotfiles/agents/specification-writing.md` | Specification-writing method and scenario instruction | `agents/` plus `practices/specification-writing.md` and `templates/specification.md` | split | It is detailed enough to act as both agent guidance and human-readable practice; preserve current file and extract companions. | high |
| `dotfiles/research/repository-resident-agent-orchestration.md` | Mature orchestration methodology note | `practices/repository-resident-agent-orchestration.md` | copy | Broadly reusable practice already expressed as a general method. Leave research note unless later retired. | high |
| `dotfiles/research/new-machine-tooling-policy.md` | Machine setup policy | `research/` | keep | Useful dotfiles research/policy note, but not part of the process-library cleanup. | high |
| `dotfiles/research/workbench-basic-tools.md` | Workbench tooling note | `research/` | keep | Tooling note, not reusable process-library material. | high |

## Wingman 26 Research

| Path | Current role | Recommended destination | Action | Reason | Confidence |
| --- | --- | --- | --- | --- | --- |
| `wingman-26/research/README.md` | Project-local research workspace router | `practices/research-program-orchestration.md` | split | Strong reusable workspace pattern, but links are Wingman-specific. | high |
| `wingman-26/research/00-research-program.md` | Research operating method | `practices/research-program-orchestration.md` | split | Contains reusable loop, evidence vocabulary, decision threshold, and research discipline. | high |
| `wingman-26/research/01-goals-and-criteria.md` | Project-specific success criteria | `examples/wingman-26/research/goals-and-criteria.md` | copy | Useful example of bounded research criteria; not universal as written. | medium |
| `wingman-26/research/02-research-frontier.md` | Frontier queue | `templates/research-frontier.md` and example copy | split | Reusable unresolved-question ledger shape; entries are project-specific. | high |
| `wingman-26/research/03-observations.md` | Canonical observation ledger | `examples/wingman-26/research/observation-ledger.md` | copy | Demonstrates compact evidence-backed observations. | high |
| `wingman-26/research/04-fieldstones.md` | Durable findings ledger | `examples/wingman-26/research/fieldstone-ledger.md` | copy | Demonstrates fieldstone practice and attribution. | high |
| `wingman-26/research/05-decisions.md` | Decision queue and records | `examples/wingman-26/research/decision-ledger.md` | copy | Useful completed decision-ledger example; decisions remain project-local. | high |
| `wingman-26/research/06-actions.md` | Research action queue | `templates/research-action-queue.md` and example copy | split | Reusable action-ledger shape. | high |
| `wingman-26/research/07-orchestration.md` | Research-agent orchestration protocol | `practices/research-agent-orchestration.md` and possibly `agents/research-orchestration.md` | split | Reusable roles, worker isolation, packet lifecycle, promotion rules, and stop conditions. | high |
| `wingman-26/research/08-final-research-report.md` | Completed final report | `examples/wingman-26/final-research-report.md`; possible `templates/final-research-report.md` | split | Strong example and reusable final-report shape. | high |
| `wingman-26/research/09-adapter-implementation-plan.md` | Adapter rollout plan | `practices/feature-flagged-adapter-rollout.md`; optional example | split | Reusable rollout pattern with feature flags, kill switch, dark launch, and parity gates. | high |
| `wingman-26/research/templates/*.md` | Fillable research templates | `templates/` | copy | Direct reusable templates for observation, fieldstone, decision, packet, and handoff. | high |
| `wingman-26/research/inbox/PKT-RF-*/{packet,observations,handoff}.md` | Completed packet examples | `examples/wingman-26/research-packets/` | copy | Demonstrates packetized research and evidence submissions. Select representative examples. | high |
| `wingman-26/research/Wingman 26 - Codebase Mapping Research Program.md` | Long-form research vision and method | `practices/replacement-boundary-research.md`; `templates/surface-record.md` | split | Reusable replacement-boundary survey and surface-record method. | high |
| `wingman-26/research/Wingman 26 - Product Vision.md` | Product vision source document | project-local | leave | Product/domain content, not process-library guidance. | high |
| `wingman-26/research/implementation/**` | Project staging/checklists | examples selectively | copy | Good project examples, but implementation targets are project-specific. | medium |

## rad-nlp Research

| Path | Current role | Recommended destination | Action | Reason | Confidence |
| --- | --- | --- | --- | --- | --- |
| `rad-nlp/research/README.md` | Research workspace operating model | `examples/research-workspace/rad-nlp/README.md` | copy | Strong example of source/provenance/notes/decisions boundaries. | high |
| `rad-nlp/research/inventory/{authority-map,external-resources,manual-acquisition,licensing,versions}.md` | Provenance and source inventory set | `templates/research/` plus example copies | split | Clear reusable skeletons; concrete rows are project evidence. | high |
| `rad-nlp/research/inventory/open-questions.md` | Research question queue | `templates/research/open-questions.md` | copy | Simple reusable unresolved-question template. | high |
| `rad-nlp/research/decisions/README.md` | Decision-note convention | `templates/decision-note.md` | copy | Defines reusable decision-note fields. | high |
| `rad-nlp/research/report-generation/README.md` | Subprogram research boundary | `examples/research-program/report-generation/README.md` | copy | Good example of separating semantic evidence, AST, rendering, prompts, and validation. | medium |
| `rad-nlp/research/report-generation/notes/*.md` | Research notes, inventory, and positions | `examples/research-notes/` and `examples/design-position/` | copy | Useful examples of evidence-backed notes and provisional fieldstones. | medium |
| `rad-nlp/research/report-generation/examples/README.md` | Example-workbench contract | `templates/research/example-workbench.md` | copy | Strong reusable expected-example shape. | high |
| `rad-nlp/research/radiology-corpus/generated/{README,MANIFEST}.md` | Corpus provenance and manifest | `templates/research/corpus-manifest.md` | split | Reusable manifest shape; data remains project-local. | high |
| `rad-nlp/research/chatgpt/STRUCTURED-LLM-INTERFACE-MANIFESTO.md` | General LLM architecture practice | `practices/structured-llm-interface.md` | copy | Broadly reusable: compile before LLM, constrain during, validate after. | high |
| `rad-nlp/research/chatgpt/RADLEX-PROLOG-COMPILER-SPEC-FINAL.md` | Completed spec with provenance appendix | `examples/prompt-provenance/radlex-compiler.md` and spec example | split | Strong example of prompt/design provenance and specification style. | high |
| `rad-nlp/research/chatgpt/APE-REVERSE-SPECIFICATION-AND-POSTMORTEM.md` | Reverse-spec/postmortem prior-art study | `examples/reverse-specification/ape-postmortem.md` | copy | Strong example of reverse-engineering prior art into lessons and fieldstones. | high |
| `rad-nlp/research/chatgpt/{CONSTRUCTION-GRAMMAR-PRIMER,MOCCA-*,UCXN-*}.md` | Domain research primers | project-local | leave | Mostly radiology/NLP content. | medium |
| `rad-nlp/research/ui-specifications/Debug Interface Design Philosophy _ Draft Specification.md` | General debug-interface practice | `practices/debug-interface-design.md` | copy | Broad reusable UI/debug method. | high |
| `rad-nlp/research/ui-specifications/*.md` | Completed UI specifications | `examples/ui-specifications/` | copy | Good examples of normative UI specs. | high |
| `rad-nlp/research/ui-specifications/README.md` | UI-spec routing and version requirement | `templates/ui-specification.md` | split | Reusable identity/versioning requirement; document list is project-local. | high |
| `rad-nlp/research/radlex-compiler/GO.md` | Continuous execution protocol | `examples/orchestration/radlex-compiler/GO.md` | copy | Completed example of resumable ticket-driven execution. | high |
| `rad-nlp/research/radlex-compiler/orchestration/{ACCEPTANCE-MATRIX,DECISIONS}.md` | Acceptance and decision artifacts | `examples/orchestration/radlex-compiler/` | copy | Strong completed examples of proof obligations and decisions. | high |
| `rad-nlp/research/toolchain-service-infrastructure/{README,GO,PLAN,STATE,ACCEPTANCE-MATRIX,DECISIONS,tickets,FINAL-REPORT}.md` | Repository-resident orchestration package | `examples/orchestration/toolchain-service-infrastructure/`; `templates/orchestration/` | split | Best exemplar of the PLAN/STATE/ACCEPTANCE/DECISIONS/tickets/final-report workflow. | high |
| `rad-nlp/research/implementation-prior-art/**`, `framenet/data/**`, source checkouts, PDFs, OWL/XML/TSV/JSONL | External source material/data | project-local research archive | leave | Not reusable process material; keep with provenance and licenses. | high |

## Principle Labs Workbench Research

| Path | Current role | Recommended destination | Action | Reason | Confidence |
| --- | --- | --- | --- | --- | --- |
| `principlelabs67-workbench/{marketing-services,ovation-workflows}/research/artifact-methodology.md` | Artifact-production methodology | `practices/artifact-generation-methodology.md` plus example | split | Reusable inputs/method/outputs/service-dependency pattern; artifact names are project-specific. | high |
| `principlelabs67-workbench/{marketing-services,ovation-workflows}/research/technical-preview.md` | Technical preview | `examples/technical-previews/modular-artifact-generation-system.md` | copy | Good lightweight architecture-preview example. | high |
| `principlelabs67-workbench/{marketing-services,ovation-workflows}/research/technical-preview-z-spec.md` | Z-style formal sketch | `examples/specifications/z-spec-sketch-modular-artifacts.md` | copy | Useful formal-spec example; project-bound. | medium |
| `principlelabs67-workbench/{marketing-services,ovation-workflows}/research/SPEC.md` | Completed interleaved technical spec | `examples/specifications/modular-artifact-generation-system/SPEC.md`; `templates/spec-interleaved.md` | split | Strong prose/formal/data/reference spec shape. | high |
| `principlelabs67-workbench/{marketing-services,ovation-workflows}/research/IMPLEMENTATION-PLAN.md` | Completed implementation plan | `examples/implementation-plans/modular-artifact-generation-system.md`; `templates/implementation-plan.md` | split | Reusable plan pattern with boundaries, examples, specifics, and milestone. | high |
| `principlelabs67-workbench/{marketing-services,ovation-workflows}/research/TICKET.md` | Coding-agent implementation ticket | `templates/coding-agent-ticket.md`; optional prompt | split | Reusable assignment structure with project-specific body. | high |
| `principlelabs67-workbench/{marketing-services,ovation-workflows}/research/templates/artifact-outputs-map.md.j2` | Artifact/output/data manifest template | `templates/artifact-output-map.md` plus example | split | Clear reusable artifact-output mapping pattern. | high |
| `principlelabs67-workbench/{marketing-services,ovation-workflows}/research/templates/*` | Product deliverable templates and previews | `examples/modular-artifact-generator/` | copy | Useful example of a template-backed artifact system, but too domain-specific for canonical templates. | medium |
| `principlelabs67-workbench/ovation-workflows/research/DISCUSSION-REPORT.md` | Synthesized discussion report | `examples/discussion-reports/modular-artifact-generation-system.md` | copy | Example of turning conversation/research into architecture report. | high |
| `principlelabs67-workbench/ovation-workflows/research/conversation-export.md` | Conversation transcript/export | `examples/conversation-exports/modular-artifact-generation-system.md` | copy | Useful provenance example; not reusable instruction. | medium |

## Promotion Priorities

1. Create final-library skeleton and READMEs.
2. Copy direct templates from Wingman and derive orchestration templates from the current cleanup workspace plus rad-nlp exemplars.
3. Promote mature practices from existing general documents: repository-resident orchestration, research orchestration, fieldstones, specification writing, practice distillation.
4. Add a small prompt library for mid-conversation use.
5. Copy a deliberately small set of examples that demonstrate the patterns without turning projects into dotfiles archives.
