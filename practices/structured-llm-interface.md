# Design Manifesto: Constrain the LLM with a Structured Language

## Purpose

When correctness matters, do not ask an LLM to operate directly on an unconstrained problem representation if the domain can be expressed more precisely.

Instead, place the LLM behind a structured interface.

The system should convert raw input into a constrained representation, present that representation to the LLM, require the LLM to respond in a constrained representation, and validate the response before it is accepted.

The LLM remains useful for ambiguity, synthesis, and completion. It does not become the authority for syntax, ontology, or validity.

## Governing Principle

> The LLM may reason inside the language of the system, but it should not be allowed to redefine that language.

A useful architecture is:

```text
raw input
   |
   v
deterministic analysis / compilation
   |
   v
structured intermediate representation
   |
   v
LLM
   |
   v
structured candidate output
   |
   v
parser / compiler / validator
   |
   +---- invalid ----> reject, repair, or ask again
   |
   v
validated program / semantic structure
```

The important boundary is not natural language versus structured data.

The important boundary is:

```text
unvalidated interpretation
        |
        v
formal interface
        |
        v
validated interpretation
```

## Why This Pattern Exists

LLMs are valuable precisely where a problem contains ambiguity, incomplete information, linguistic variation, or combinatorial search.

Those same properties make them poor candidates for being the final authority on whether an output is structurally or semantically valid.

A deterministic system is usually bad at guessing.

An LLM is usually good at guessing.

Therefore:

> Let deterministic machinery establish what is known. Let the LLM work on what remains unresolved. Then force the result back through deterministic validation.

The goal is not to remove the LLM.

The goal is to put the LLM in the part of the system where probabilistic reasoning is useful and surround it with interfaces that make mistakes visible.

## The Geometry Precedent

A useful precedent is a domain-specific language for Euclidean construction.

Instead of asking an LLM to discuss arbitrary geometry and hoping that its answer corresponds to a legal construction, define a construction calculus with a parser/compiler.

The interaction becomes:

```text
formal geometry state
        |
        v
LLM receives valid construction language
        |
        v
LLM proposes construction language
        |
        v
compiler validates proposal
```

The LLM can search, suggest, and compose.

The compiler decides whether the proposed construction belongs to the language.

This changes the nature of the interaction. The LLM is no longer merely writing prose *about* geometry. It is proposing a program in a domain language whose validity is independently decidable.

## The Radiology Analogy

The same pattern applies to radiology-report interpretation.

A raw transcript should not need to be handed to the LLM as an undifferentiated block of text and interpreted from scratch.

Deterministic stages can establish substantial structure first:

```text
raw transcript
      |
      v
linguistic analysis
      |
      v
UD / grammatical structure
      |
      v
known constructions
      |
      v
RadLex concept candidates
      |
      v
measurements, modifiers, assertions,
relations, source spans, unresolved pieces
```

The resulting representation can say explicitly:

```text
KNOWN
- this span is a measurement
- this nominal is a RadLex anatomy candidate
- this grammatical construction attaches the measurement to this finding
- this phrase is negated
- these two clauses are coordinated

UNRESOLVED
- this pronoun has two plausible antecedents
- this modifier has two plausible attachments
- this elliptical fragment has incomplete structure
```

That is a much better problem to give an LLM.

The LLM can then perform semantic completion or reconciliation over a partially compiled representation rather than rediscovering every fact from raw text.

## Ambiguity Is the Reason for the Architecture

The objective is not token reduction.

The objective is **ambiguity reduction without false certainty**.

A deterministic stage should make a claim only when it has a rule or source that justifies the claim.

If it cannot justify a choice, the correct output is not a guess.

The correct output is an explicit ambiguity:

```text
candidate A
candidate B
unresolved
```

The LLM is then asked to solve the remaining ambiguity using the structured evidence available to it.

This creates an important asymmetry:

```text
DETERMINISTIC LAYER
high precision
partial coverage is acceptable

LLM LAYER
handles difficult residue
must respect the existing structure

VALIDATOR
does not care how persuasive the LLM sounds
accepts only valid output
```

## Structured Input Is More Than Serialization

JSON is not automatically a good structured interface.

Neither is XML, Prolog, a typed AST, or any other syntax.

A useful structured input has **semantics**.

For example, these are not merely fields:

```text
mention
discourse referent
measurement
grammatical attachment
ontology concept
assertion
candidate relation
unresolved reference
```

Each should have a defined meaning.

The LLM should receive a representation whose distinctions have already been made explicit.

The representation should prevent accidental conflation of:

```text
word
mention
concept
entity
assertion
ontology fact
case-specific fact
```

The format is secondary to the model.

## Structured Output Must Be a Language

The LLM's output should not merely "look structured."

It should belong to a language that the application understands.

That language may be defined by:

- a grammar;
- a schema;
- a type system;
- Prolog predicates and invariants;
- a DSL;
- an AST definition;
- or a combination of these.

The important property is that membership is mechanically checkable.

Conceptually:

```text
LLM output
    |
    v
parse?
    |
    +-- no --> invalid
    |
    v
well-typed?
    |
    +-- no --> invalid
    |
    v
satisfies domain invariants?
    |
    +-- no --> invalid
    |
    v
accepted
```

A model response that cannot pass the validator is not an application result.

It is merely another candidate.

## Validation Should Be Semantic Where Possible

Syntax validation is necessary but weak.

The stronger pattern is:

```text
syntactic validity
        +
referential validity
        +
ontology validity
        +
domain invariants
        +
source provenance
```

For example, a radiology output might be syntactically valid while asserting:

```text
measurement_of(m1, nonexistent_entity)
```

or inventing a patient-world entity solely because the ontology contains an existential relationship.

A useful validator should reject such structures even if they parse correctly.

Likewise, a geometry construction can be grammatically valid while referring to a point that has not yet been constructed.

The domain language should make these errors mechanically observable.

## Deterministic Knowledge Should Not Be Re-Decided by the LLM

If the system has already established something reliably, do not ask the LLM to infer it again.

Prefer:

```text
measurement_of(m1, finding_7)
```

over:

```text
There is a measurement near a finding. Determine what it modifies.
```

Prefer:

```text
ontology_match(m12, right_upper_lobe)
```

over asking the model to normalize a term that has already been matched unambiguously.

The LLM should receive decisions as facts and unresolved questions as questions.

This reduces the chance that the model will "improve" a correct deterministic result into an incorrect probabilistic one.

## Provenance Is Part of the Interface

A structured proposition should ideally carry enough provenance to explain why it exists.

Useful provenance classes include:

```text
source transcript
grammatical production
ontology lookup
ontology entailment
application rule
LLM completion
```

This allows downstream validation to distinguish:

```text
"The radiologist said this."

"The grammar supports this."

"RadLex says this generally."

"The LLM proposed this."

"The application accepted this."
```

Those are materially different statements.

## The LLM Should Be Replaceable

A healthy architecture should make the LLM a component, not the ontology of the system.

If a better model becomes available, it should be possible to replace:

```text
LLM_A
```

with:

```text
LLM_B
```

without redefining:

- the source representation;
- the ontology;
- the DSL;
- the output grammar;
- the validator;
- or the application semantics.

Likewise, some ambiguities may eventually be solved by deterministic productions that previously required an LLM.

The architecture should allow work to migrate from probabilistic to deterministic stages over time.

## Progressive Compilation

A useful mental model is **progressive compilation**.

At each stage, transform what can be justified and preserve what cannot.

```text
raw input
   |
   v
partially understood representation
   |
   v
more constrained representation
   |
   v
more constrained representation
   |
   v
unresolved residue
   |
   v
LLM completion
   |
   v
validated representation
```

The intermediate states are not failures.

They are increasingly precise programs.

This makes it possible to improve the system incrementally without requiring an all-or-nothing natural-language understanding solution.

## Failure Is a First-Class Output

The system should make these outcomes normal:

```text
unknown
ambiguous
unsupported
partially parsed
multiple candidates
validation failed
```

The architecture becomes dangerous when it converts every failure to understand into a forced interpretation.

A useful rule is:

> An explicit hole is better than a fabricated fact.

## The Compiler/Validator Is the Boundary of Trust

The LLM can propose.

The compiler or validator accepts.

This is the same principle whether the domain is:

- Euclidean constructions;
- radiology reports;
- mathematical proof objects;
- workflow specifications;
- query languages;
- configuration;
- code generation;
- planning;
- or any other domain where a useful formal language can be defined.

The formal interface turns an LLM from an unconstrained text generator into a participant in a larger symbolic system.

## Design Heuristic

When approaching a new LLM problem, ask:

1. What parts of the input can be deterministically recognized before the LLM is involved?
2. What distinctions should be made explicit rather than left implicit in prose?
3. What ambiguity genuinely remains?
4. Can the unresolved problem be expressed in a small domain language?
5. Can the model's answer be required to belong to a mechanically validated language?
6. Which semantic invariants can be checked independently of the model?
7. Can every accepted output be traced back to evidence?
8. Can an unresolved result remain unresolved rather than being guessed?
9. Could more deterministic productions gradually replace LLM work later?
10. Can the LLM implementation be swapped without changing the formal interface?

If the answer to several of these questions is yes, a structured-language boundary is probably preferable to direct prompting.

## Compact Manifesto

```text
DO NOT
────────────────────────────────────────
give an LLM an ambiguous world,
ask it to reconstruct everything,
and trust whatever prose comes back.


DO
────────────────────────────────────────
compile what can be known,
represent what remains ambiguous,
give the model a structured problem,
require a structured answer,
and validate that answer independently.
```

Or more compactly:

> **Compile before the LLM. Constrain during the LLM. Validate after the LLM. Preserve ambiguity throughout.**
