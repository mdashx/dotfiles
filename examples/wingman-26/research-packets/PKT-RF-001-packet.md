# PKT-RF-001 — Work Item Opening to Workspace Selection

- **Status:** READY
- **Frontier:** RF-001
- **Goal:** G2 — Find coarse replacement boundaries
- **Action:** ACT-0001

## Objective

Trace how an existing RADPAIR work item is opened, how study/template/organization/user context is established, and how the current reporting workspace is selected and rendered.

## Question

Where can the frontend choose legacy versus Wingman while preserving host lifecycle, permissions, study context, integrations, and signing?

## Scope

Inspect the frontend route/page/store/service path and the backend endpoint(s) needed to establish the initial page context. Include relevant iframe or parent-window integration behavior if it affects workspace selection.

## Required output

1. Ordered call and state trace.
2. Host context required by the workspace.
3. Current observable API/store/component contracts.
4. Candidate frontend cut-lines.
5. Feature-flag insertion points and estimated dispersion.
6. Host behavior that must remain untouched.
7. Contract-test and fixture proposals.
8. Unknowns, contradictions, and follow-up packets.

## Evidence standard

Use concrete repository, file, symbol, route, event, persisted field, or test references. Classify claims as VERIFIED, INFERRED, HYPOTHESIS, or UNKNOWN.

## Stopping condition

The successful opening path and one relevant failure/permission path are traced far enough to identify the earliest safe workspace divergence point, or the exact missing evidence is recorded.

## Submission

Write findings to `observations.md` and `handoff.md` in this directory. Keep canonical ledgers unchanged.
