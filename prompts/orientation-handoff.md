# Orientation Handoff Prompt

Use when starting a fresh agent that needs to get oriented on an existing
fieldstone-based design conversation (a `DESIGN.md` + `FIELDSTONES.md` pair,
per `~/dotfiles/prompts/conversation-to-spec-fieldstone.md`) before doing
any further work on it.

This is a comprehension check, not a continuation. The agent reads, then
reports its own understanding back in its own words — it does not propose
next design moves, edit either file, or treat the read as permission to
keep going.

```text
You're being oriented on an existing design project, not asked to continue
it yet.

Read, in this order:
1. ~/dotfiles/agents/working-profile-tom-hyndman.md — how I like to be
   talked to.
2. {path to DESIGN.md}
3. {path to FIELDSTONES.md}

This is a "{project name}" project: {one-line description}. It uses the
fieldstone method (Weinberg) — FIELDSTONES.md is a quiet log of the moments
of real deliberation, DESIGN.md is the living synthesis.

Do not propose new design moves, do not add to either file, do not treat
this as an invitation to start specifying or implementing anything.

Once you've read all three, tell me — in your own words, not by
summarizing/quoting the documents back — your understanding of:

- The working thesis in one or two sentences.
- The current governing principles/tensions that seem load-bearing right
  now (not an exhaustive fieldstone recap — just what you'd treat as
  live constraints if you were about to help move this forward).
- What's genuinely settled vs. still open.
- Which of the three next moves `~/dotfiles/agents/design-conversation.md`
  names — targeted research, a conceptual specification, or an
  implementation plan — the project seems closest to being ready for, if
  any, and why.

If anything in the documents reads as unclear, underspecified, or
internally in tension to you, say so explicitly — that's useful signal,
not a mistake on your part.
```
