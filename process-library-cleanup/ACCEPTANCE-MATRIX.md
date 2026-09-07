# Acceptance Matrix

| ID | Obligation | Status | Evidence |
| --- | --- | --- | --- |
| A-001 | The cleanup has a durable orchestration workspace with plan, state, tickets, decisions, and acceptance obligations. | passed | `PLAN.md`, `STATE.md`, `ACCEPTANCE-MATRIX.md`, `DECISIONS.md`, ticket files, subagent guide; foundation verification passed |
| A-002 | Candidate reusable process files are inventoried with role, destination, action, reason, and confidence. | passed | `process-library-cleanup/INVENTORY.md`; subagent inventories for Wingman, rad-nlp, and Principle Labs research |
| A-003 | Final library directories exist with lightweight routing READMEs where needed. | passed | `prompts/README.md`, `practices/README.md`, `templates/README.md`, `examples/README.md`; skeleton verification passed |
| A-004 | Clear reusable templates are promoted without losing source provenance. | passed | `templates/` direct and derived templates; each new template records source pattern |
| A-005 | Reusable practices are promoted separately from agent instructions and prompts. | passed | `practices/` files; standing `agents/` files preserved |
| A-006 | Mid-conversation prompt files are separated from standing agent guidance. | passed | `prompts/` files and `prompts/README.md` |
| A-007 | Project-specific examples are copied only as examples and retain provenance. | passed | `examples/` files and `examples/SOURCES.md` |
| A-008 | The cleanup records unresolved questions and provisional material for the next distillation pass. | passed | `process-library-cleanup/MIGRATION.md` |
