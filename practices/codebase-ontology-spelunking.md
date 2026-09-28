# Codebase Spelunking Spikes

Source: a fieldstone-shaped unit (`../sop/fieldstone-method.md`), retargeted
from reconstructing a conversation to validating a codebase, and given the
four-representation shape of `../sop/specification-writing.md` in abbreviated
form.

## Purpose

While spelunking an unfamiliar or partially-understood codebase — reading
code, cross-checking it against what people believe or intend, building
toward a design or implementation plan — record each durable, code-grounded
fact as a small, indexable unit called a **spike**, the moment it's
established. Not a parallel note-taking system: the same instinct as a
fieldstone, redirected at code instead of conversation.

## Spike, Not Fieldstone — the Actual Difference

A **fieldstone** reconstructs a design conversation: a decision, a belief,
a distinction someone drew, a human-led correction. Its evidentiary
backbone is *who said what, when* — the `Contribution` field
(human-led/assistant-led/joint/source-derived) matters because the point is
preserving how a conversation shaped an idea.

A **spike** validates a fact about the real running system. Its evidentiary
backbone is a file:line at a specific commit, or (for something not yet
built) an explicit note that it's still provisional. A spike does not carry
a `Contribution` field, because who first said it is not the point — what
matters is `Status` (confirmed / provisional / superseded) and
`Verified against` (the repo, branch, and date the citation was checked).

The two do intersect: a spike is often *prompted* by something someone said
in a conversation ("KZ said X is true of the code" → go check → write the
spike). When that happens, the spike records the code fact, not the
quote — if the quote itself is worth preserving as a decision or belief,
that's a separate fieldstone, not a substitute for checking the code.

A spike that turns out to correct something someone (including the human
directing the work) asserted is not a contradiction to hedge around — write
it plainly, cite the code, and say what it changes. See
`feedback_code-vs-transcript-temporal-alignment` (project memory): before
treating a spike as correcting a stated belief, confirm the code in
question actually existed — merged, deployed — at the time the belief was
stated. A same-day, unmerged branch correcting yesterday's transcript is a
category error, not a finding.

## Shape

Use `templates/spike.md`. Four content sections, kept short — this is a
fieldstone, not a specification:

- **Concept** — the fact, in prose, one or two sentences.
- **Z** — a lightweight formal note (state, relation, invariant) *only* if
  it earns its keep. A trivial fact doesn't need a schema forced onto it.
- **Data** — a concrete instance or worked example.
- **Code** — the file:line citations. This is what a re-verification pass
  re-checks; everything else is interpretation built on top of it.

Plus `Why it matters` (what this changes about a plan — skip if purely
foundational) and `Related` (other spike IDs, cross-referenced by ID rather
than restated).

## When to Just Write It

Don't ask permission to write a spike for something already established in
the conversation — either because you just verified it in code moments
earlier, or because the human stated a correction and you both moved on.
Re-deriving or re-confirming an already-agreed fact before recording it is
wasted motion. Write the spike, cite what's already been shown, and keep
moving. Reserve actually stopping to check code for claims that haven't
been verified yet at all.

## Re-verification

`Verified against` is an expiration date, not decoration. Before leaning on
a spike to justify a new decision, spot-check its `Code` citations against
the current commit. If they've drifted, don't silently edit the spike in
place — mark it `superseded` and write a new one; the old one's history is
part of the record.

## Storage

Spikes live inside the active project's own directory, alongside its
fieldstones if it has any — `research/spelunking/` next to
`research/fieldstones/` — not in a separate ontology project. A spike is
part of *this* investigation's research trail, with the same status as a
technical illustration or an implementation plan: material that belongs to
the problem being worked, not a standalone system to maintain for its own
sake.
