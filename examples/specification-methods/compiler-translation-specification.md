# Compiler and Translation Specification Method

> **Provenance:** This is the earlier specification-writing method developed
> for the RadLex compiler work. It remains useful when a project translates a
> formal source language into a target representation. It is a specialized
> example, not the general Principle Labs specification style.

## 1. Purpose

This document defines a method for writing technical specifications that begin with a design vision, proceed through technical grounding and explicit translation or design decisions, and end with concise provenance documenting how the important decisions emerged.

The resulting specification should be:

- technically precise;
- readable by engineers who did not participate in the original discussion;
- explicit about settled and unsettled decisions;
- grounded in actual source systems, data, protocols, or upstream specifications;
- concise enough to function as a design document rather than a transcript;
- useful as both an implementation reference and a teaching artifact.

The specification should preserve the logic of the design process without preserving the entire conversational history that produced it.

The governing principle is:

> Preserve the decisions, distinctions, evidence, and unresolved questions. Compress the conversation.

---

# 2. Information Architecture

The document should normally contain four top-level sections:

1. **Vision**
2. **Technical Introduction**
3. **Survey of Decisions and Translation Rules**
4. **Reference Appendices**

The table of contents should list only these top-level sections unless the document is unusually large.

This hierarchy should remain stable even when the technical subject changes.

---

# 3. Vision

The Vision section explains why the project exists and what kind of system is being designed.

It should answer:

- What problem are we solving?
- What is the intended result?
- What are we deliberately not trying to solve?
- What qualities should the finished system have?
- What important distinction motivates the architecture?
- What source system, specification, or model are we respecting?

The Vision should not begin with implementation details.

It may name specific technologies when they are central to the project, but it should explain the purpose of those technologies rather than merely list them.

A strong Vision often contains one short governing principle.

For example:

> Preserve the upstream model's meaning; compile away its representational machinery.

The Vision should also establish the major conceptual boundaries of the system.

If the project distinguishes between an abstract ontology and an application model, for example, that distinction belongs in the Vision because later technical decisions depend upon it.

A compact diagram is often useful:

```text
ABSTRACT MODEL
─────────────────────────────────────
Classes, rules, constraints, and relationships.

No execution-specific individuals.


APPLICATION MODEL
─────────────────────────────────────
Concrete individuals and facts established
from the input to this execution.
```

The diagram should explain a distinction that recurs throughout the document. It should not merely decorate the section.

---

# 4. Technical Introduction

The Technical Introduction establishes the factual and formal context necessary to understand the design decisions that follow.

It normally contains some combination of:

## 4.1 Empirical Source Inventory

When the project depends on an existing codebase, ontology, protocol, API, schema, or data format, inspect the actual source and summarize what it contains.

Prefer empirical statements such as:

```text
46,952 named classes
83,161 existential restrictions
52 object properties
19 inverse relation declarations
```

over general statements such as:

> OWL supports many kinds of restrictions.

The specification should describe the source system **as it is actually used**, not as broadly as the underlying standard permits.

This distinction is especially important when building a compiler, adapter, importer, or compatibility layer.

The useful question is usually:

> What language does this upstream artifact actually speak?

not:

> What could the general-purpose standard theoretically express?

---

## 4.2 Core Conceptual Model

Explain the small number of abstractions that later decisions use.

For example:

```text
Class
ClassExpression
Relation
Individual
Literal
```

or:

```text
Request
Context
StateTransition
ExternalCall
```

Avoid defining a large vocabulary prematurely.

Introduce a concept only when it is necessary to explain the design.

---

## 4.3 Notation

Define all mathematical or formal notation before using it repeatedly.

Prefer simple Unicode mathematics when it renders reliably:

```text
A ⊆ B
A ∪ B
A ∩ B
∃ P.B
P(x,y) → A(x)
```

Unicode notation is often preferable to embedded equation formats in Markdown because it remains readable in source form and across renderers.

If a notation cannot be rendered clearly in ordinary Markdown, use a fenced text block rather than relying on fragile equation rendering.

For example:

```text
C ⊆ ∃ P.D
```

is preferable to a complicated rendering system when portability matters.

---

## 4.4 Source-Language Grammar or Shape Inventory

When the system translates from one representation to another, define the supported source forms.

Use EBNF or a similar grammar for **syntactic recognition**.

For example:

```ebnf
ClassAxiom ::= NamedSubclass
             | ExistentialSubclass
             ;

NamedSubclass ::= Class "rdfs:subClassOf" Class ;

ExistentialSubclass ::=
    Class "rdfs:subClassOf" Restriction ;

Restriction ::=
    "owl:onProperty" Relation
    "owl:someValuesFrom" Class
    ;
```

Grammar describes what source forms are accepted.

It does **not** define their meaning.

---

## 4.5 Compiler or System Architecture

Give a compact architecture showing the major transformations.

For example:

```text
Upstream source
      │
      ▼
Parser / loader
      │
      ▼
Normalized intermediate representation
      │
      ▼
Validation
      │
      ▼
Generated target model
      │
      ▼
Application layer
```

The architecture should identify boundaries of responsibility.

It should avoid implementation detail that belongs in tickets or code comments.

---

# 5. Survey of Decisions and Translation Rules

This is usually the largest section.

Each significant design decision should appear as a subsection under this top-level section.

Examples might include:

- named classes;
- subclass relationships;
- existential relationships;
- domain and range semantics;
- union expressions;
- inverse relations;
- relation specialization;
- functional constraints;
- lexical metadata;
- application entailment boundaries;
- identity rules;
- error handling.

The specification should organize these subsections by **semantic concept**, not merely by the names of upstream syntax constructs.

Prefer:

> Relation Participation Implies Classification

over:

> `rdfs:domain`

The upstream syntax can appear in the subsection title or introduction, but the section should be named after the idea being modeled.

---

# 6. Standard Structure for a Decision Section

Every important translation or design decision should use the same explanatory pattern.

## 6.1 Upstream Meaning

Explain what the source system says in ordinary Standard Written English.

Do not begin by showing the proposed target representation.

The reader must be able to distinguish:

1. what the upstream system says;
2. what that statement means;
3. what the target system will do with it.

Where useful, show the logical meaning:

```text
P(x,y) → C(x)
```

This layer is especially important when the upstream syntax is misleading or unfamiliar.

---

## 6.2 Model Interpretation

Show how the rule belongs to the abstract model and how it relates to the application model.

Use recurring diagrams when the distinction matters.

For example:

```text
ONTOLOGY
─────────────────────────────────────
right_kidney ⊆
    ∃ contained_in.right_retroperitoneal_compartment

This is abstract knowledge about a class.


APPLICATION MODEL
─────────────────────────────────────
instance_of(k1, right_kidney).

If no compartment has been established from
the input, no compartment individual exists
in this application model.
```

The prose should use complete sentences and Standard Written English.

Avoid presentation-style fragments such as:

```text
No compartment established?
No compartment exists.
```

unless the document is intentionally using a Q&A format.

---

## 6.3 Translation or Design Decision

State the decision explicitly.

For example:

> Existential restrictions are represented as class-level relationships. The compiler does not introduce synthetic application individuals.

This paragraph should make clear whether the rule is:

- normative;
- provisional;
- experimental;
- unresolved.

Do not bury uncertainty in ordinary prose.

---

## 6.4 Concrete Source → Target Example

Use the smallest realistic example that demonstrates the rule.

For a compiler:

```turtle
radlex:RID29662
    rdfs:subClassOf [
        a owl:Restriction ;
        owl:onProperty radlex:Contained_In ;
        owl:someValuesFrom radlex:RID29541
    ] .
```

becomes:

```prolog
some_relation(
    rid29662,
    contained_in,
    rid29541
).
```

The example should be representative of actual upstream data whenever possible.

Do not invent elaborate examples when a real one is available.

---

## 6.5 Formal Translation Rule

After the prose explanation and concrete example, state the general rule formally.

For example:

```text
C,D ∈ Class    P ∈ Relation
C ⊆ ∃ P.D
───────────────────────────
C ⟹ some_relation(C,P,D)
```

This formal rule should be short enough that the reader can compare it directly with the concrete example.

Formal notation is most useful after the reader already understands the idea.

---

## 6.6 Entails / Does Not Entail

For rules with any risk of overinterpretation, state their consequences explicitly.

For example:

```text
ENTAILS
─────────────────────────────────────
Every instance of C participates in P with at
least one instance belonging to D.

DOES NOT ENTAIL
─────────────────────────────────────
A named D individual exists in the application.

The application contains a concrete P relation
unless one has been established independently.
```

This section is especially valuable for:

- existential statements;
- inverse relationships;
- union expressions;
- domain/range semantics;
- identity;
- optional values;
- inference boundaries.

Many specification errors come from assumptions about what a rule **also** means.

A good “Does Not Entail” section prevents those errors directly.

---

# 7. Handling Open Decisions

Unresolved decisions should be visually obvious.

Use a consistent ASCII box such as:

```text
╔════════════════════════════════════════════════════════╗
║  ⚠ OPEN DECISION                                      ║
║                                                        ║
║  Define how functional relations should interact      ║
║  with application-level identity.                     ║
╚════════════════════════════════════════════════════════╝
```

Do not allow unresolved questions to appear indistinguishable from settled specification language.

For each open decision, include:

- the exact unresolved question;
- why the question matters;
- known constraints;
- candidate approaches;
- what would change under each approach;
- what evidence would resolve the decision.

The specification should prefer a small number of sharply defined open decisions over a long list of vague uncertainties.

---

# 8. Invariants

Once several decisions have converged, collect the strongest cross-cutting principles into an invariant section.

Examples:

```text
1. No application individuals are introduced by ontology compilation.

2. No supported upstream construct is silently discarded.

3. Existential constraints preserve existential meaning without
   requiring named witnesses.

4. Abstract class relationships and concrete application relationships
   remain semantically distinct.

5. Every generated rule can be traced to either an upstream source axiom
   or an explicitly specified compiler inference.
```

An invariant should describe a property that many individual rules must respect.

Do not use the invariant section to repeat local implementation details.

---

# 9. Acceptance Criteria

A specification should define when it is ready to implement.

Typical criteria include:

- every upstream construct in scope has been inventoried;
- every supported source form has a defined translation;
- every unresolved decision has been resolved or deliberately deferred;
- unsupported constructs produce explicit diagnostics;
- representative source examples compile as expected;
- generated statements retain sufficient provenance;
- tests demonstrate that no supported source construct is silently lost.

Acceptance criteria should evaluate the **specification and compiler behavior**, not merely the existence of documentation.

## 9.1 Version Identity in User Interface Specifications

A specification for a user interface must define how a person can identify the
version they are viewing. Version identity is part of the interface contract,
not merely build metadata hidden in source control, an asset URL, or an HTTP
header.

The specification should require:

- a visible application version in a stable location on every primary view;
- machine-discoverable version identity in the semantic DOM;
- clear labels that distinguish the application version from API, contract,
  schema, data, model, resource, and build versions;
- one authoritative implementation source for each displayed version;
- an explicit rule for when user-visible behavior causes the application
  version to change; and
- acceptance tests that verify both the visible and machine-discoverable
  identities.

A commit identifier or build timestamp may supplement an application version,
but it does not replace one. A specification should not display several
unlabelled version-like strings and require the user to infer which one
identifies the interface itself.

---

# 10. Reference Appendices

Reference material that is useful but disruptive to the main narrative belongs in appendices.

Examples include:

- complete inverse-relation tables;
- subproperty tables;
- RID or identifier mappings;
- grammar listings;
- known edge cases;
- generated predicate catalogues;
- source statistics;
- external cross-reference tables.

The appendices should support the specification without becoming part of its reading path.

---

# 11. Design Conversation and Prompt Provenance

A specification created through iterative human–AI or team design discussion may include a provenance appendix.

This appendix is **not normative**.

Its purpose is to record how important design distinctions emerged and to provide a teaching artifact for future design work.

It should not reproduce the complete transcript.

Long prompts and long assistant responses are usually poor teaching material because the important decision becomes difficult to locate.

Instead, summarize each pivotal interaction using a consistent structure.

---

## 11.1 Provenance Entry Format

### Design issue

A short descriptive title.

### Original input

Include a short verbatim quotation only when the wording itself is useful.

For example:

> “We know the class that shows where a kidney is, but we don't claim to have a member of that class on hand.”

Keep quotes short.

The quote provides color and anchors the entry in the actual conversation. The summary carries the technical content.

### Context summary

Explain briefly what the design discussion was considering before this intervention.

### Design contribution

State who introduced the important distinction or correction.

Use fair attribution.

Examples:

> **Human-led correction.** The author rejected automatic witness creation and reframed the ontology/application boundary around known filler classes rather than fabricated individuals.

> **Joint refinement.** The conversation then formalized this distinction as an existential class-level relation in the Prolog ontology.

Do not rewrite a human correction as an anonymous “we decided” when the correction materially redirected the design.

Likewise, do not over-credit a minor wording preference as a conceptual breakthrough.

### Resulting specification rule

State the rule that entered the specification.

For example:

```text
C ⊆ ∃ P.D
```

becomes:

```prolog
some_relation(C, P, D).
```

without creating an application individual.

### Why the interaction was useful

Describe the prompt-engineering or design pattern.

For example:

> The input corrected the model at the level of ontology semantics rather than proposing implementation syntax. This allowed the target representation to emerge from the distinction instead of forcing the distinction to fit an existing representation.

---

# 12. Attribution Principles

When documenting provenance, attribution should reflect actual intellectual contribution.

Use explicit credit when a participant:

- rejects an incorrect assumption;
- introduces a distinction that changes the design;
- supplies the governing constraint that resolves an ambiguity;
- identifies a semantic pitfall;
- proposes a representation that becomes normative;
- changes the scope of the project;
- introduces an architectural boundary;
- insists on empirical verification rather than assumption.

Use neutral language for routine refinements.

Prefer:

> **Human-led direction.** The author reframed the project as a fixed compiler for the RadLex dialect rather than a general OWL grammar.

over:

> The discussion decided not to implement general OWL.

The first preserves useful provenance.

---

# 13. Quote Discipline

Quotes in the provenance appendix should normally be short.

A useful quote is usually:

- one sentence;
- one sharp correction;
- one memorable formulation;
- one statement that reveals the conceptual pivot.

Avoid reproducing long prompts unless the full structure of the prompt itself is the object of study.

A good rule is:

> Use the quote to show the moment. Use the summary to explain the decision.

The provenance appendix should remain readable even when someone skips every quotation.

---

# 14. Prompt-Engineering Patterns Worth Recording

The provenance appendix should highlight recurring productive patterns.

Common patterns include:

### 14.1 Correct the abstraction, not the wording

A short objection can expose that the model is wrong at a deeper level.

Example pattern:

```text
proposal
    ↓
“that is not what this means”
    ↓
semantic distinction
    ↓
new representation
```

### 14.2 Ask for empirical inventory before general architecture

Instead of designing for everything a standard could express, inspect what the actual source uses.

```text
general standard
    ↓
actual source inventory
    ↓
small effective language
    ↓
simpler compiler
```

### 14.3 Separate source meaning from target representation

Require the discussion to distinguish:

```text
upstream syntax
    ↓
logical meaning
    ↓
target implementation
```

This prevents hypothetical target code from being mistaken for the source system.

### 14.4 Push back on accidental semantics

Examples include:

- reading OWL domain/range as type validation;
- treating a union as several independent memberships;
- inverting existential restrictions;
- materializing existential witnesses;
- treating closed-world application absence as ontology-level negation.

### 14.5 Prefer explicit fixed translations when the source vocabulary is small

A fixed upstream relation vocabulary may justify explicit compiler cases instead of a general metaprogramming framework.

This often improves readability, auditability, and semantic safety.

### 14.6 Convert a useful objection into an invariant

A good design conversation does not stop when a local example is fixed.

The strongest correction should often become a global rule.

For example:

```text
local problem:
    do not invent a compartment

global invariant:
    ontology compilation never introduces application individuals
```

---

# 15. Writing Style

The prose should use Standard Written English.

Prefer complete declarative sentences.

Use terse notation only where terseness itself carries formal meaning.

Avoid:

- rhetorical Q&A fragments;
- slide-deck shorthand;
- missing prepositions;
- unexplained abbreviations;
- prose that assumes the reader participated in the conversation;
- conversational filler;
- vague claims such as “this is cleaner” without explaining why.

Prefer:

> If no compartment has been established from the report or by an explicitly permitted application derivation, no compartment individual exists in the application model.

over:

> No compartment established? No compartment exists.

The document should read as a specification first and as a record of a conversation only in the provenance appendix.

---

# 16. Mathematical Style

Use mathematics when it removes ambiguity.

Prefer compact Unicode expressions:

```text
C ⊆ D
C ⊆ ∃ P.D
P(x,y) → C(x)
A ∪ B
P(x,y) ↔ Q(y,x)
```

Do not use mathematics merely to make the document appear formal.

Every mathematical expression should have a prose interpretation nearby the first time it appears.

Use code when describing executable representation:

```prolog
some_relation(C, P, D).
```

Use mathematics when describing logical meaning:

```text
C ⊆ ∃ P.D
```

Do not substitute one for the other.

---

# 17. Desired Compression

The specification should be substantially shorter than the conversation that produced it.

The provenance appendix should be substantially shorter than the main specification.

A useful hierarchy of compression is:

```text
full design conversation
        ↓
technical specification
        ↓
decision summaries
        ↓
short provenance quotes
```

The goal is not to preserve every thought.

The goal is to preserve the reasoning necessary to understand, implement, review, and later reconsider the design.

---

# 18. Quality Test

A strong specification written according to this method should allow a new engineer to answer four questions:

1. **What are we building, and why?**
2. **What does the upstream system actually say?**
3. **What translation or design decisions have we made, and what do they imply?**
4. **Where did the important decisions come from, especially when someone challenged an earlier assumption?**

If the reader can answer all four without reading the original design conversation, the specification has done its job.

If the provenance appendix then helps the reader understand **how** those decisions were discovered, it has done something additional: it has become a reusable teaching artifact for design and prompt engineering.
