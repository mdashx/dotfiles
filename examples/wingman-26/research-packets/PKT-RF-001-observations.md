# Observations — PKT-RF-001

Use [`../../templates/observation.md`](../../templates/observation.md). Add one evidence-backed claim per entry.

## OBS-RF001-001 — Available checkout lacks the frontend workspace source

- **Status:** VERIFIED
- **Topic:** source availability
- **Claim:** The local `frontend` checkout contains project guidance, documentation, and research files, but not the expected application source tree such as `src/components/pages/ReportDetailsPage.jsx`.
- **Evidence:** `/home/raddev/getting-started/RADPAIR/frontend`; `find` inspection on 2026-09-07. The expected file is referenced by backend research but is absent locally.
- **Interpretation:** The workspace cannot currently establish the exact frontend entry seam or component call graph.
- **Implications:** RF-001 needs a source-checkout recovery step before it can reach function-level confidence.
- **Unknowns:** route/page ownership, store hydration, exact feature-flag location, and iframe/parent integration calls.
- **Follow-up:** obtain or mount a complete frontend source checkout; then trace work-item opening through workspace render.

## OBS-RF001-002 — Report processing depends on work-item study and template context

- **Status:** VERIFIED from maintained research notes
- **Topic:** host context
- **Claim:** Meaningful report processing requires a report/work item with an assigned study and usable template; a fresh report without `study_id` fails with `StudyNotAssignedException`.
- **Evidence:** `/home/raddev/getting-started/RADPAIR/backend/research/report-processing-local-dev.md`, “Fresh dev DB had no studies or templates”; `seed-data-requirements.md`, “Minimum Seed Data For Report Work”.
- **Interpretation:** Study and template association are host context that a replacement workspace or interpretation engine must receive or resolve through an adapter.
- **Implications:** A frontend replacement cannot be specified as a visual swap alone; it must preserve study/template context establishment.
- **Unknowns:** exact page-load API sequence and whether context is derived from a single report payload or multiple requests.

## OBS-RF001-003 — Report lifecycle is broader than interpretation

- **Status:** VERIFIED from maintained concept notes
- **Topic:** host lifecycle
- **Claim:** The existing Report concept includes ownership, status, study, template, signing history, grouping, and publish scheduling in addition to transcript and final report content.
- **Evidence:** `/home/raddev/getting-started/RADPAIR/backend/research/CONCEPT-NOTES.md`, “Report”; `/home/raddev/wingman-26/research/Wingman 26 - Report Interpretation Disentanglement Map.docx`, sections 3 and 15.
- **Interpretation:** Workspace replacement must preserve or adapt host lifecycle state rather than replace the entire work-item contract.
- **Implications:** The likely frontend seam is between host work-item context/lifecycle and the current reporting workspace, but its exact location remains unverified.

## OBS-RF001-004 — Page entry already separates report loading from workspace rendering

- **Status:** VERIFIED
- **Topic:** frontend entry seam
- **Claim:** `frontend/src/pages/reports/[id].js` owns route-level report loading, organization-settings readiness, ownership takeover/error handling, and store hydration; after loading it dynamically renders `ReportDetailsPage` with `id` and `refetchReport`.
- **Evidence:** `frontend/src/pages/reports/[id].js:23-35,54-117,128-172`, source revision `fee46ae1a035e44957bb8fddc0a2233fdaf32e16`.
- **Implications:** This is a strong existing host/workspace selection seam. Wingman can potentially be selected here while preserving route-level loading, ownership, org-settings readiness, and refetch behavior.
- **Unknowns:** exact feature-flag source and headless/iframe behavior when selecting an alternate workspace.

## OBS-RF001-005 — ReportDetailsPage is the current coupled workspace boundary

- **Status:** VERIFIED
- **Topic:** frontend responsibility
- **Claim:** `ReportDetailsPage` directly owns report state, transcript/final-report editors, organization settings, STT hook selection, processing, save, sign, dictation-session events, and iframe/reporting events.
- **Evidence:** `frontend/src/components/pages/ReportDetailsPage.jsx:347-382,753-812,950-1065,1229-1275,1519-1545,1868-1902,2608-2619,3332-3368,3941-3960`, source revision `fee46ae1a035e44957bb8fddc0a2233fdaf32e16`.
- **Implications:** Replacing page internals incrementally would inherit a broad mutable state surface. A host-level workspace selection is preferable to making this component the Wingman integration boundary.

## OBS-RF001-006 — The workspace contract includes report payload, editor operations, org settings, and refetch

- **Status:** VERIFIED
- **Topic:** workspace context
- **Claim:** The route calls `ReportsService.detail(id)`, stores `data.report`, pushes `data.editor_operations`, waits for org settings after the report org ID is known, and passes a refetch callback into the workspace.
- **Evidence:** `frontend/src/pages/reports/[id].js:54-70,80-117,128-169`.
- **Implications:** A workspace replacement cannot be specified as a visual swap that receives only a report ID.
