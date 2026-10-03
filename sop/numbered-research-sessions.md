# Numbered Research Sessions

Keep a stretch of research work — a conversation, an investigation, a
build — exactly as it happened, in its own numbered directory, and never
touch it again once you move on.

The alternative is one living research directory, continuously revised.
That loses the thing worth keeping. Not the conclusions, which end up in
specs, plans, and code either way, but the order they arrived in and the
turns that were taken and abandoned. A frozen session answers "what did
we know, and when" without archaeology.

## Two kinds of research artifact

```text
research/
├── program-NNN-<slug>/     a standing research program
└── session-NN-<slug>/      one frozen stretch of work
```

A **program** has a question, a corpus, and a plan. It is *revised* —
standing notes get rewritten as the answer changes, baselines accumulate,
scripts get re-run against the live stack. Its `PLAN.md` holds the open
questions; its `LOG.md` records what happened to them, dated and
reverse-chronological. A program ends when its question is answered, and
is then swept to `../archive/research/` like any other completed work.

A **session** is one stretch of work. It owns a directory holding
whatever that work needed — notes, findings, sketches, scratch data,
illustrations — and the four rules below.

A day that only advances one program's standing notes needs no session.
Open one when the stretch of work itself, not just its conclusions, is
worth preserving in order.

## The four rules

**Numbered, then named.** `session-NN-<slug>`. The number is the stable
handle — cite a session by number even after renaming. The slug is the
memory hook and names the milestone, which is often clearer at the end
than at the start, so renaming the slug while the session is still open
is fine.

**Frozen when you move on.** A milestone, or just clearing the desk to
start something else, ends a session. Leave it exactly where it is — no
tidying, no consolidating, no migrating conclusions forward.

**Never retro-edited.** If a closed session's conclusion turns out wrong,
the correction goes in the *current* session, pointing back at what it
supersedes. What we believed at the time is worth more than a record
that always agrees with today — a wrong conclusion, dated, tells a later
reader something a silently-fixed one would hide.

**Traceable.** A session opens with an `Inherits from:` line naming what
it most directly follows, so a reader has a starting point without
reading every prior session in full. This is a citation, not a
dependency contract: a session may inspect and cite *any* earlier
session's results by path when useful, and often will, but nothing
obligates reading or satisfying a backward chain before proceeding.

## No handoffs

A session never writes instructions for the future. Its only pointers
run backward — `Inherits from:`, and citations of earlier sessions. What
was unresolved at close is recorded as a fact about that moment, not as
a task list for whoever comes next.

This is also practical: a handoff is a frozen copy of mutable state.
Ticket status belongs in a program's `STATE.md`, carried defects in
`GAPS.md`, open questions in a `PLAN.md` — files that stay current. A
frozen copy of that state cannot be corrected, will drift from the live
version, and the drift will eventually be discovered by someone who
trusted the wrong one.

Do not confuse this with `templates/research-session-handoff.md`, which
serves a different, older convention: a long *orchestration* session
(agents running packets against a packet-and-ledger research program)
produces a handoff when it ends, because the orchestration itself is
continuous program state, not a frozen session. A numbered research
session under this SOP produces no such document.

## What a session is not

Implementation work does not live in a session. It lives in a sibling
`../implementation/<program>/` package, using the standard templates in
`../templates/orchestration/`: `plan.md`, `decisions.md`, `state.md`,
`acceptance-matrix.md`, `ticket.md`. A session may *open* such a program
and should link to it rather than restate it — a session records what
was learned, a program records what was built.

When a design session's conclusions are ready to become implementation,
an explicit instruction (e.g. "go") adopts the prepared execution
protocol for that program. Its mere presence on disk is not
authorization. Once adopted:

- the coordinator is the only source writer; no parallel source writers
  are authorized unless the protocol says otherwise;
- at most one ticket is `in_progress` at a time;
- a ticket becomes `complete` only once its verification has passed and
  the completion evidence is recorded;
- stop only for a genuine blocker, an explicit pause or redirect, scope
  that would overwrite unrelated work or exceed what was authorized, or
  evidence contradicting the accepted research — not merely because one
  ticket or one milestone finished.

## Numbering

Start numbering wherever a project's working-session count roughly
stands if there is no prior record. Do not retroactively number or
reconstruct sessions that predate adoption of this convention — missing
numbers below the starting point are expected, not an error.

## Starting a session

```text
SESSION.md
  # Session NN — <slug>
  Opened: <date>
  Inherits from: <path to the session or program this follows>
  ## Question
  <what this stretch of work is trying to settle>
```

## Closing a session

Add to `SESSION.md`:

- **Established in this session** — the durable conclusions, written so
  they can be cited later without re-reading the session.
- **Contents** — a table of every file in the session directory and its
  role.

Then stop. Do not come back to tidy it.

## Source

Observed convention, independently written on the same day
(2026-09-30) by the same author in two sibling repositories —
`research/README.md` in `rad-ipsum` (`ui` branch) and `research/README.md`
in `wingman`, the latter extending it with the program/session split.
This SOP consolidates both into one procedure.
