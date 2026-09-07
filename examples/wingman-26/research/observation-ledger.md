# Observation Ledger

Append observations here using [`templates/observation.md`](templates/observation.md). Prefer one claim per entry. Include concrete repository, file, symbol, route, event, field, test, or experiment references.

## Index

| ID | Topic | Status | Related frontier / decision |
|---|---|---|---|
| OBS-0001 | Source availability | VERIFIED | RF-001–RF-004 |
| OBS-0002 | Host context | VERIFIED | RF-001, DEC-0001 |
| OBS-0003 | STT event contract | VERIFIED | RF-002, DEC-0003 |
| OBS-0004 | STT stop/final risk | VERIFIED | RF-002, RF-006 |
| OBS-0005 | Report input contract | VERIFIED | RF-003, DEC-0002 |
| OBS-0006 | Report policy surface | VERIFIED | RF-003, RF-005 |
| OBS-0007 | Signing ownership | VERIFIED | RF-004 |
| OBS-0008 | Provenance minimum | VERIFIED | RF-006, DEC-0003 |
| OBS-0009 | Candidate reporting boundary | HYPOTHESIS | RF-007, DEC-0001/2 |
| OBS-0010 | Candidate STT boundary | HYPOTHESIS | RF-007, DEC-0003 |
| OBS-0011 | Frontend host/workspace seam | VERIFIED | RF-001, DEC-0001 |
| OBS-0012 | STT provider seam | VERIFIED | RF-002, DEC-0003 |
| OBS-0013 | Report processing rejoin contract | VERIFIED | RF-003, DEC-0002 |
| OBS-0014 | Sign/publish preservation boundary | VERIFIED | RF-004 |
| OBS-0015 | Rollout control surface | VERIFIED | RF-001, RF-002, RF-003 |

## Entries

<!-- Append entries below. -->

## OBS-0001 — Source availability limits current confidence

- **Status:** VERIFIED
- **Claim:** The local RADPAIR checkouts contain maintained documentation and research exports but not the backend, frontend, or STT source files named by the research program; some notes reference an unavailable `/home/easter/RADPAIR` checkout.
- **Evidence:** Local source inventory on 2026-09-07; packet submissions `PKT-RF-001` through `PKT-RF-004`.
- **Implication:** Exact function-level boundary claims remain pending source recovery or authoritative runtime traces.

## OBS-0002 — Work-item context is a host prerequisite

- **Status:** VERIFIED
- **Claim:** Study and template context are required for meaningful report creation/processing, and the existing Report lifecycle includes ownership, status, study, template, signing history, grouping, and publish scheduling.
- **Evidence:** `backend/research/report-processing-local-dev.md`; `seed-data-requirements.md`; `CONCEPT-NOTES.md`; Report Interpretation Disentanglement Map.
- **Implication:** Wingman must receive or resolve explicit host context; it cannot replace the work-item shell implicitly.

## OBS-0003 — STT is an ordered workflow protocol

- **Status:** VERIFIED
- **Claim:** The STT contract includes ordered interim/final events, session ACK gating, section-safe command/content ordering, predictable finalization, and last-final delivery.
- **Evidence:** `frontend/src/hooks/stt/useLiveKitSpeechToText/ARCHITECTURE.md`; `backend-stt-worker/AGENTS.md`; `stt-recording-boundaries/SKILL.md`.
- **Implication:** A recognizer swap must preserve more than text accuracy.

## OBS-0004 — Stop handling has a potential late-final loss edge

- **Status:** VERIFIED from maintained contract documentation
- **Claim:** The frontend closes transcript acceptance immediately on stop while the backend flushes pending state, so a late final may be dropped.
- **Evidence:** `stt-recording-boundaries/SKILL.md`, “Main Risk”; STT architecture stop flow.
- **Implication:** This must be a cross-repo contract fixture before selecting or swapping a recognizer.

## OBS-0005 — Report processing has a structured input contract

- **Status:** VERIFIED
- **Claim:** The processing route expects `transcript.textVersion`, not a raw transcript string, and depends on study/template context.
- **Evidence:** `backend/research/report-processing-local-dev.md`.
- **Implication:** Backend replacement selection needs a compatibility translation or preservation of this contract.

## OBS-0006 — Report generation combines semantic, rendering, and host policy

- **Status:** VERIFIED
- **Claim:** Current output is influenced by content-fidelity rules, templates, formatting rules, model/provider settings, organization settings, and user preferences.
- **Evidence:** `backend/research/db-text-export/*`; packet `PKT-RF-005`.
- **Implication:** The host-side contract must name policy inputs without reproducing the legacy prompt graph.

## OBS-0007 — Signing and publishing belong to the host lifecycle

- **Status:** VERIFIED
- **Claim:** Signing has distinct lifecycle states and deferred publishing behavior, and the research explicitly places signing/integration in host infrastructure.
- **Evidence:** `CONCEPT-NOTES.md`; Report Interpretation Disentanglement Map; Codebase Mapping Research Program.
- **Implication:** Wingman must rejoin before the existing sign/publish/integration boundary.

## OBS-0008 — Provenance must be non-destructive and cross-replacement

- **Status:** VERIFIED
- **Claim:** The required evidence chain is report assertion → interpretation → transcript/correction → audio, with source observations retained and STT timing/recognition metadata preserved where available.
- **Evidence:** Product Vision; Codebase Mapping Research Program; packet `PKT-RF-006`.
- **Implication:** Plain final-text-only interfaces are insufficient for the final swap plan.

## OBS-0009 — Reporting boundary hypothesis

- **Status:** HYPOTHESIS
- **Claim:** The strongest candidate is coarse frontend workspace selection plus a backend host adapter that supplies explicit context to a replaceable interpretation/reporting implementation.
- **Evidence:** Codebase Mapping Research Program; Report Interpretation Disentanglement Map; packet `PKT-RF-007`.
- **Confidence limitation:** Exact seams and side effects await source recovery.

## OBS-0010 — STT boundary hypothesis

- **Status:** HYPOTHESIS
- **Claim:** The strongest candidate is recognizer/provider substitution behind existing browser/LiveKit/session/VAD/control/event plumbing.
- **Evidence:** STT architecture; worker guidance; packet `PKT-RF-007`.
- **Confidence limitation:** Actual provider interface and deployed behavior await source recovery.

## OBS-0011 — Frontend host/workspace seam is already present

- **Status:** VERIFIED
- **Claim:** `pages/reports/[id].js` loads the report and organization settings, hydrates stores, handles ownership/takeover errors, and renders `ReportDetailsPage`; `HeadlessApp` separately handles iframe authentication, report-id navigation, headless styling, and queued parent messages.
- **Evidence:** frontend `src/pages/reports/[id].js:23-172`; `src/components/pages/HeadlessApp.jsx:51-430`; revision `fee46ae1a035e44957bb8fddc0a2233fdaf32e16`.
- **Implication:** The first replacement can be selected at the route’s workspace-render boundary while preserving host lifecycle and iframe shell behavior.

## OBS-0012 — STT provider seam is concrete

- **Status:** VERIFIED
- **Claim:** `agent.py` selects an STT implementation and supplies it to the generic `AgentSession` with VAD; provider stream and finalization behavior live in `stt_fireworks.py`; the frontend hook exposes a narrow transcription callback and gates events by session ACK.
- **Evidence:** backend-stt-worker `src/agent.py:651-816`, `src/stt_fireworks.py:141-251,757-912`; frontend `src/hooks/stt/useLiveKitSpeechToText/useLiveKitSpeechToText.ts:30-100,198-285`; revision `f2015d3d50e5dd4435388a254610921d4121fd8f` and frontend revision above.
- **Implication:** The second replacement can be specified as provider/recognizer substitution behind existing worker/session/VAD/control/event plumbing.

## OBS-0013 — Report processing has an explicit host rejoin contract

- **Status:** VERIFIED
- **Claim:** The process route constructs explicit user/org/request context, accepts structured transcript input, performs generation and verification, commits `report.final_report`, and returns report data plus processing metadata; SSE is a separate observable path.
- **Evidence:** backend `app/routes/v2/report_processing.py:1494-1515,1921-1936,1978-2022,2083-2165,2220-2420`; revision `0914694d28ffb5635fdf9385d4d6db875c239996`.
- **Implication:** The replacement plan should preserve route, context, response/SSE, persistence, and error contracts while leaving internal report-generation design out of scope.

## OBS-0014 — Sign/publish is downstream host infrastructure

- **Status:** VERIFIED
- **Claim:** The frontend passes rendered report representations and sign metadata to the sign route; the backend validates lifecycle/permissions/payload, commits status, optionally creates immutable signed records, emits events, and invokes publishing, including delayed publish scheduling.
- **Evidence:** frontend `src/components/pages/ReportDetailsPage.jsx:976-1065,1876-1902`; backend `app/routes/reports.py:787-833`, `app/services/reporting_service/service.py:452-540`, `db/models/signed_report.py:25-147`, `tests/test_worker/test_publish_report.py`; source revisions above.
- **Implication:** Neither replacement may bypass or absorb sign/publish side effects; rollback must happen before this boundary.

## OBS-0015 — Existing feature/config controls can carry rollout decisions

- **Status:** VERIFIED
- **Claim:** Frontend uses LaunchDarkly-backed `useFeatureFlag`; STT provider selection already resolves from feature flags, environment availability, and user preferences. This is an established control pattern, although no replacement-specific flag exists yet.
- **Evidence:** frontend `src/hooks/features/useFeatureFlag.js:1-10`; `src/hooks/stt/useSttProviderResolution.ts:1-55`; `src/constants/features.ts`; revision `fee46ae1a035e44957bb8fddc0a2233fdaf32e16`.
- **Implication:** The final swap plan can require a new replacement-specific flag/config at the host boundary, with legacy as default and kill-switch rollback.
