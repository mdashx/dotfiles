# Fieldstone Ledger

Fieldstones are durable discoveries worth carrying into a future specification or architecture decision. They are not a transcript and should remain compact.

Use [`templates/fieldstone.md`](templates/fieldstone.md). Preserve whether the contribution was human-led, assistant-led, or joint.

## Entries

### FS-0001 — Meaning-first product direction

- **Status:** settled
- **Contribution:** human-led / source vision
- **Summary:** Wingman should expose an editable semantic interpretation rather than require the radiologist to repair prematurely generated prose.
- **Why it matters:** This governs the product boundary and prevents implementation from inheriting prose-first assumptions.

### FS-0002 — WorkItem, Interpretation, and Report are distinct concepts

- **Status:** provisional architectural distinction
- **Contribution:** joint / source research
- **Summary:** Existing `Report` behavior spans workflow container, semantic interpretation, and rendered report concerns; Wingman should separate these conceptually before deciding whether persistence changes are needed.
- **Why it matters:** It enables preservation of the host workflow while replacing the semantic/reporting corridor.

### FS-0003 — Research should search for coarse cuts

- **Status:** settled research principle
- **Contribution:** human-led / source research
- **Summary:** The primary question is what coherent subsystem can be replaced behind a small stable perimeter, not where legacy code can be incrementally cleaned up.
- **Why it matters:** It keeps research aligned with coexistence, rollback, and feature-flag goals.

### FS-0004 — The STT replacement boundary is behavioral

- **Status:** provisional
- **Contribution:** source-derived / joint
- **Summary:** STT substitution must preserve an ordered workflow protocol: session lifecycle, interim/final events, section-safe ordering, timing, and last-final delivery.
- **Why it matters:** A recognizer that improves transcription accuracy but violates workflow ordering is not a valid replacement.

### FS-0005 — Provenance crosses both replacement boundaries

- **Status:** settled as a research constraint
- **Contribution:** human-led / source vision
- **Summary:** Host-side swap plans must preserve a non-destructive path from report assertion to interpretation, transcript/correction, and audio evidence.
- **Why it matters:** Replacement boundaries cannot be evaluated solely as text-in/text-out APIs.

### FS-0006 — Source availability is itself a research dependency

- **Status:** settled
- **Contribution:** assistant-led from investigation
- **Summary:** Maintained architecture documents support hypotheses, but high-confidence function-level swap plans require the actual backend/frontend/worker source or authoritative runtime traces.
- **Why it matters:** It prevents documented paths from being misreported as verified implementation facts.
