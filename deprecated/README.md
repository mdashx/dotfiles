# Deprecated

Superseded process material, kept because the reasoning in it is often
better than the summary that replaced it, and because a reader who finds
a stale reference should be able to see what it pointed at.

Structure mirrors the original layout, so an old path maps directly:
`agents/x.md` → `deprecated/agents/x.md`.

| Deprecated | Superseded by |
| --- | --- |
| `agents/conversation-to-spec-fieldstone.md` | `sop/fieldstone-method.md` |
| `practices/conversation-to-spec-fieldstones.md` | `sop/fieldstone-method.md` |
| `prompts/conversation-to-spec-fieldstone.md` | `sop/fieldstone-method.md` |
| `templates/fieldstone.md` | `sop/fieldstone-method.md` (record shape) |
| `practices/concept-design.md` | `sop/concept-design.md` |
| `agents/specification-writing.md` | `sop/specification-writing.md` |
| `practices/specification-writing.md` | `sop/specification-writing.md` |
| `templates/specification.md` | `sop/specification-writing.md` (shape folded in) |
| `sop/fieldstone-method.md` | retired, no replacement |

## Note on the fieldstone material

Four documents covered fieldstones. The longest, in `agents/`, held the
real content — the Weinberg attribution, the negative rules, and the
recognition pattern — while the `practices/` file was a thinner
restatement of it and the `prompts/` file restated it again for pasting.
The single SOP carries what was load-bearing in all four.

One statement from the deprecated `agents/` file is worth flagging
because it was correct and was being overridden elsewhere: *the final
specification should be substantially more concise than the conversation
that produced it, and the provenance appendix more concise still.*

## Note on the specification material

Three documents covered specification writing: a 33-line router in
`agents/`, a 198-line method in `practices/`, and a template encoding the
section structure. The four-part interleaved concept account was stated
in all three, plus a fourth time inside a prompt — which is why the
operational principle could go missing and stay missing. There was no
single place to add it to.

The substantive change in the replacement is the framing. The deprecated
practice opened with *"The specification is a durable contract... what
enforces the behavior in reality."* That is build-side language for a lab
artifact, and it generated most of what made our specifications
unreadable: if a document binds implementation, it must record every
amendment and justify every clause. The SOP calls a specification an
exploratory design document, which it always was.

The other visible change is that the four parts are no longer labelled in
the output. A heading reading *Prose Spec* tells a reader nothing they
could not see by looking. The four parts remain mandatory as an authoring
check.

## Note on retiring the fieldstone method

The method itself was never wrong, but requiring it as a formal step
produced exactly the secretary failure mode it was meant to avoid:
agents reporting a fieldstone the moment it was found, turning a design
conversation into bookkeeping. In practice, the durable material a
conversation produces is already legible from the specification or
design document it feeds, and naming it as a separate mandatory step
stopped paying for itself. The record stays here for the reasoning and
the recognition pattern, which are still worth reading; it is no longer
a required procedure.
