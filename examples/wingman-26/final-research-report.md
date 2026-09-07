# Wingman 26 Final Research Report

## Executive conclusion

Research is complete for the requested host-side swap plan. The two priority replacements can be introduced without redesigning RADPAIR’s work-item, signing/publishing, iframe, browser-audio, LiveKit, or generic session plumbing.

| Replacement | Host entry seam | Host rejoin / exit seam |
|---|---|---|
| Wingman reporting / semantic workspace | Workspace render in `frontend/src/pages/reports/[id].js`, currently `ReportDetailsPage` | Existing process/save/sign contracts; sign remains `POST /reports/<report_id>/sign` |
| STT recognizer | Worker provider selection around `build_stt_for_room` | Existing generic worker stream → frontend `{ transcription, isFinal }` callback |

This is a perimeter plan only. It does not select or design the replacement UI, ontology, model, prompt strategy, recognizer, or provider.

## Evidence and confidence

Source-level traces were completed from canonical revisions:

- backend: `0914694d28ffb5635fdf9385d4d6db875c239996`;
- frontend: `fee46ae1a035e44957bb8fddc0a2233fdaf32e16`;
- backend STT worker: `f2015d3d50e5dd4435388a254610921d4121fd8f`.

Confidence is high for the two host seams, their preserved infrastructure, rollback points, and contract categories. It is medium for deployment-specific timing, destination-specific operations, and replacement-specific compatibility adapters. Those questions do not alter either seam.

## A. Reporting / semantic-workspace corridor

### Entry seam and ownership

Keep `pages/reports/[id].js` as host. It resolves report identity, retrieves the report, resolves organization settings, hydrates report/editor-operation state, handles takeover and error behavior, and currently dynamically renders `ReportDetailsPage` (`src/pages/reports/[id].js:23-172`). Select legacy or Wingman at that render point with a replacement-specific host flag.

Keep `HeadlessApp` host-owned. It manages iframe authentication, report-ID navigation, headless mode/style, theme messages, and parent-event queueing (`src/components/pages/HeadlessApp.jsx`).

### Exit/rejoin seam and required contract

Keep `POST /v2/reports/processing/process/<report_id>` as the host processing contract. It builds explicit `ReportProcessingContext` (organization/user identity, ownership enforcement, request/background state, session ID), reads structured `transcript.textVersion`, executes its current processing flow, persists `report.final_report`, and supports both normal and SSE paths (`backend/app/routes/v2/report_processing.py:1494-1515,1921-2420`).

The replacement adapter must preserve:

- report identity, study, template, language, user/org context, settings, preferences, rules, transcript, report state, and editor-operation context;
- process request/response, error, persistence, reload, and SSE behavior;
- semantic fixtures: dictated findings, measurements, comparisons, negatives, laterality, recommendations, and contradiction handling;
- rendering fixtures: required sections, ordering, and report representation;
- assertion → interpretation → transcript/correction → audio provenance links where available.

Current templates/rules/preferences split into semantic correctness, rendering policy, host policy, and legacy prompt/provider mechanics. The replacement is not required to reproduce the legacy internal stage/prompt graph; it is required to preserve the observable outcomes at the host boundary.

### Preserved systems

Preserve authorization, work-item loading, study/template setup, stores, iframe/headless integration, save/sign/publish, immutable signed-report records, reporting events, webhooks/socket delivery, and lifecycle state. Do not let Wingman bypass `POST /reports/<report_id>/sign`.

The current sign path validates editable state, serializes plain/HTML/RTF representations and metadata in the frontend, then the backend validates status/permissions/required data, commits lifecycle state, optionally writes immutable signed records, emits events, and publishes (`ReportDetailsPage.jsx:976-1065,1876-1902`; `app/routes/reports.py:787-833`; `app/services/reporting_service/service.py:452-540`).

### Coexistence, rollback, and migration

1. Add one host-level Wingman workspace/process selection flag. Legacy stays default; target a controlled cohort explicitly.
2. Keep both paths live and log the selected path at open/process boundaries.
3. Validate open/refetch and process/save without sign for the initial cohort.
4. Enable signing only after contract, semantic, provenance, and event parity pass.
5. Roll back by disabling selection before process/sign side effects. Preserve report/transcript/provenance records for replay.
6. Make legacy removal a separate later decision.

### Required acceptance checks and measurements

- route open, org-settings readiness, ownership/takeover, refetch, iframe/headless events;
- process request/response/SSE/error compatibility and persisted-report reload;
- semantic and rendering golden fixtures;
- provenance traversal and non-destructive correction history;
- save, preliminary/final/addendum signing, scheduled publish/cancel, signed records, and outbound-event parity;
- flag-on/flag-off rollback before sign.

Measure processing latency, stream time-to-first-output, completion/error rate, semantic regression rate, provenance completeness, save/sign failures, and event/webhook parity.

## B. STT recognition pipeline

### Entry seam and ownership

Select the recognizer/provider around `build_stt_for_room` in `backend-stt-worker/src/agent.py`. The generic worker parses room metadata, builds `AgentSession(stt=..., vad=...)`, handles recording control and flushes, and consumes stream events (`agent.py:651-816`). Provider-specific recognition and finalization are contained in `src/stt_fireworks.py:141-251,757-912`.

Keep browser recording, LiveKit, recording-session control, ACK gating, VAD/turn detection, generic worker lifecycle, and page insertion outside the replacement.

### Exit/rejoin seam and required contract

The frontend hook exposes `{ transcription, isFinal }` and gates delivery on the matching recording-session ACK (`useLiveKitSpeechToText.ts:30-100,198-285`). The replacement must emit the same generic stream behavior.

Preserve:

- recording session identity, START/STOP control, matching SESSION_ACK, stale-session rejection;
- audio format/rate expectations, VAD boundaries, ordered interim/final events, section context, command/content ordering, short utterances, reconnect/error behavior, and flush/finalization;
- approximately 400–550 ms end-of-speech-to-final target;
- audio identity, timestamps, raw recognition, word/segment timing, confidence/candidates when available, and correction provenance.

The critical bounded risk is a late-final race: frontend stop closes the session gate while the worker may still flush a final. `ReportDetailsPage` contains an interim fallback and queue drain, but live/replay testing must prove last-final delivery.

### Coexistence, rollback, and migration

1. Add selection through the existing provider/configuration pattern, with legacy default.
2. Record provider choice per recording session.
3. Run replay fixtures, then constrained live cohorts with PHI-safe telemetry.
4. Roll back at provider/session selection; do not alter browser/LiveKit/session protocol to roll back.
5. Expand only after ordering, stop/final, short-utterance, latency, reconnect, and provenance checks pass.

### Required acceptance checks and measurements

- ACK gate and stale-session behavior;
- interim/final ordering, short commands/content, section and command ordering;
- stop flush, late final, reconnect, provider failure/fallback;
- frontend transcript insertion and dictation queue behavior;
- provenance completeness and timing distributions.

Measure final-latency percentiles, interim cadence, final-drop rate, ACK failures, reconnects, recognition error categories, command-order errors, and missing provenance.

## Cross-replacement dependencies

Both swaps require non-destructive provenance. STT must preserve enough identity and timing to associate later semantic assertions with transcript and audio evidence. Reporting must retain those links through editing, processing, save, and sign.

Their rollback controls are independent: reporting at workspace/process selection, STT at provider/session selection. Neither requires changing signing/publishing, iframe transport, browser recording, or LiveKit.

## Decisions, alternatives, and remaining questions

Settled decisions are recorded in `05-decisions.md`: route-level workspace selection, process-context/rejoin preservation, and recognizer substitution behind the worker stream contract. Rejected first cuts are full iframe-shell replacement, full report-lifecycle replacement, browser/LiveKit transport replacement, and sign/publish redesign; each broadens the host perimeter without improving the identified seam.

Implementation-time questions: final flag names/cohort dimensions, replacement-specific SSE/response mapping, the complete golden-fixture corpus and clinical review owner, deployed late-final timing, provider metadata availability, and destination-specific monitoring thresholds. None can materially move the selected entry or rejoin seam.

## Recommended handoff

For reporting: make a minimal host spike that selects an alternate workspace at `pages/reports/[id].js`, supplies existing report/context, and proves process/save/refetch/rollback before sign.

For STT: make a minimal provider-adapter spike behind `build_stt_for_room`, proving ACK, interim/final, stop/flush, command ordering, provenance, and rollback while leaving browser/LiveKit/session plumbing unchanged.

The research phase stops here. Further work is replacement design, implementation, and validation rather than boundary discovery.
