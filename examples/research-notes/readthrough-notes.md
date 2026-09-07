# Report-generation read-through notes

These are chronological observations from reading the existing system. They
are intentionally kept separate from the reverse conceptual specification and
should not be normalized prematurely.

## 2026-09-07

### Report type / study type as operational rail

`ReportStudy` appears early primarily because it is the system's routing key.
Once selected, it provides access to templates, rules, impression families,
defaults, overrides, and prompts. Its early position is therefore a
configuration/indexing necessity, not evidence that it is the deepest semantic
concept in a report.

Working distinction:

```text
operationally first  ≠  conceptually fundamental
```

### Durable artifact versus workflow container

The persisted `Report` appears to combine durable clinical-document identity
and content with mutable generation/reclassification workflow state. A durable
artifact wants stable identity, versions, auditability, and reproducibility; a
workflow container wants retries, intermediate decisions, pending proposals,
and failure recovery.

The co-location is evidence of an important hidden boundary, not merely a
database-design imperfection.
