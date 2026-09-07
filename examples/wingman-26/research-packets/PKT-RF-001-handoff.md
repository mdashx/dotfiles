# Handoff — PKT-RF-001

Use [`../../templates/session-handoff.md`](../../templates/session-handoff.md) when the investigation ends.

## Session result

- **Objective:** Complete for the current host/workspace entry trace.
- **Established:** The route owns report loading, organization-settings readiness, ownership/takeover handling, store hydration, and refetch; it dynamically renders `ReportDetailsPage`. `HeadlessApp` owns iframe authentication, report identifier navigation, theme/headless state, and event queuing.
- **Confidence:** High for the existing host/workspace cut-line; medium for the design of a future alternate workspace because that implementation is intentionally out of scope.
- **Blocking condition:** None for host-side swap specification. Remaining implementation-time question: exact flag/config name and rollout audience.
- **Next packet:** Validate the candidate selection point with a contract test plan covering normal route, headless/iframe open, report refetch, and rollback.
