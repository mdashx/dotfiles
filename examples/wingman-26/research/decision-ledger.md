# Decision Queue

Record choices separately from observations. A decision may be pending, provisional, settled, deferred, rejected, or obsolete.

Use [`templates/decision.md`](templates/decision.md).

## Queue

| ID | Question | Status | Evidence / next step |
|---|---|---|---|
| DEC-0001 | What is the first frontend replacement seam? | settled | RF-001, OBS-0011 |
| DEC-0002 | What is the first backend replacement seam? | settled | RF-003, RF-007, OBS-0013 |
| DEC-0003 | What provenance minimum must Wingman guarantee? | settled | RF-006, OBS-0008 |
| DEC-0004 | Which current rules belong in semantic interpretation versus rendering? | provisional | RF-005 |
| DEC-0005 | Can the current source evidence support a high-confidence swap plan? | provisional | Source recovery, OBS-0011–0015 |

## Decisions

<!-- Add full decision records below. -->

## DEC-0001 — Frontend workspace seam

- **Status:** settled
- **Question:** Where can legacy and Wingman workspaces diverge?
- **Decision:** Keep route-level report loading, org-settings readiness, ownership/takeover handling, store hydration, and headless/iframe shell in the host; select the alternate workspace at the existing `pages/reports/[id].js` render boundary currently occupied by `ReportDetailsPage`.
- **Alternatives:** host page selects workspace; nested workspace adapter; parallel route/page.
- **Criteria:** host lifecycle preservation, flag concentration, iframe/headless behavior, rollback, contract stability.
- **Evidence:** OBS-0002, OBS-0011; RF-001 packet observations.
- **Reversal conditions:** source trace or runtime contract demonstrates that the candidate host shell cannot preserve required lifecycle behavior.
- **Follow-up:** recover complete frontend source and trace RF-001.

## DEC-0002 — Backend reporting seam

- **Status:** settled
- **Question:** Where can legacy report processing and Wingman reporting coexist?
- **Decision:** Keep `POST /v2/reports/processing/process/<report_id>` and its context, response, SSE, persistence, verification/rejoin, and error responsibilities in the host; select legacy versus Wingman behind the delegated processing boundary, before sign/publish infrastructure.
- **Alternatives:** existing route adapter; parallel route; service-level implementation selection.
- **Criteria:** request/response and streaming compatibility, side-effect isolation, host context, rollback, contract tests.
- **Evidence:** OBS-0005, OBS-0006, OBS-0013, OBS-0014; RF-003/RF-004 packet observations.
- **Follow-up:** recover backend source and trace RF-003/RF-004.

## DEC-0003 — STT compatibility contract

- **Status:** settled for host contract; provider choice remains out of scope
- **Question:** What must any recognizer replacement preserve?
- **Decision:** Preserve session ACK/control semantics, ordered interim/final events, short utterances, section ordering, timing expectations, provenance metadata available at the boundary, and last-final behavior; substitute only behind the recognizer/provider boundary.
- **Alternatives:** provider-only substitution; worker pipeline replacement; end-to-end transport replacement.
- **Criteria:** workflow correctness, latency, replayability, provenance, rollback.
- **Evidence:** OBS-0003, OBS-0004, OBS-0008, OBS-0010.
- **Reversal conditions:** complete source trace shows the documented provider boundary is not real or cannot preserve the contract.

## DEC-0004 — Policy classification at the host boundary

- **Status:** provisional
- **Question:** Which current rules belong in semantic interpretation versus rendering?
- **Decision:** Treat content fidelity, measurements, comparisons, negatives, laterality, contradictions, and recommendations as semantic correctness outcomes; treat section/formatting expression as rendering policy; supply organization policy and user preferences as explicit host context; do not require provider/model and prompt-workaround mechanics at the replacement boundary.
- **Evidence:** RF-005 observations; OBS-0006; OBS-0013.
- **Reversal conditions:** a contract fixture proves a currently classified rendering or orchestration rule materially changes required clinical meaning.
- **Follow-up:** turn this classification into acceptance fixtures during implementation.

## DEC-0005 — Source evidence sufficiency

- **Status:** provisional
- **Question:** Is the current local evidence sufficient for the final high-confidence report?
- **Decision:** Source evidence is sufficient to specify host-side swap seams, preserved infrastructure, and acceptance criteria; confidence remains provisional until the final report records contract-test coverage, rollback sequencing, and bounded destination/deployment unknowns.
- **Evidence:** OBS-0011–0015; source-backed packet handoffs RF-001 through RF-004.
- **Follow-up:** complete RF-007 scoring and final report confidence audit.
