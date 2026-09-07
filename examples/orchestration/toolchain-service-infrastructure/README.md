# Toolchain Service Infrastructure

**Status:** Research orchestration proposal — unapproved

This directory proposes a bounded infrastructure project for testing the `rad-nlp` research tools as long-lived, callable services behind a Go hub and exposing their evidence through the Toolchain Debug UI.

The directory is an orchestration package, not an implementation. Its presence under `research/` does not authorize installation, process creation, service enablement, or application work.

If explicitly adopted, the package supplies:

- `PLAN.md` — candidate architecture, sequencing, verification, and definition of done;
- `GO.md` — continuous-execution protocol, inactive until adoption;
- `STATE.md` — resumable project cursor;
- `ACCEPTANCE-MATRIX.md` — global proof obligations;
- `DECISIONS.md` — proposed assumptions and later accepted decisions; and
- `tickets/` — dependency-ordered vertical work contracts.

The proposed implementation target is a future top-level `infrastructure/` directory. The existing `setup/` project remains the authority for cold installation and heavy smoke verification.
