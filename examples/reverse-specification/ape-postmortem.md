# Attempto Parsing Engine (APE): Reverse Specification and Postmortem

## Purpose

This document reverse-engineers the Attempto Parsing Engine (APE) as
implementation prior art for a radiology transcript interpretation
system. It is not a proposal to adopt Attempto Controlled English (ACE),
nor is it a specification for the RADPAIR application. Its purpose is to
understand what APE's authors built, why the architecture works, where
the controlled-language assumption is doing essential work, what
engineering mechanisms are reusable, and which lessons should constrain
our own design.

The central question is:

> If we want to transform unconstrained radiology dictation into a
> source-anchored grammatical and semantic representation that can be
> enriched with RadLex, what can we learn from a mature Prolog system
> that transforms English-like text into explicit discourse and logical
> representations?

APE is unusually valuable prior art because it is not merely an NLP
paper. It is a complete, open-source Prolog implementation with a
tokenizer, lexicons, a grammar, feature structures, syntax-tree
generation, discourse representation, anaphora resolution, logical
transformations, tests, command-line and service interfaces, and domain
lexicon extension.

The most important qualification must remain visible throughout this
document: APE parses **Attempto Controlled English**, not unrestricted
English. Its success therefore cannot be transferred mechanically to
radiology dictation. The architectural techniques are more reusable than
the grammar itself.

## 1. Executive Summary

APE implements a staged natural-language-to-formal-representation
pipeline:

``` text
ACE text
   |
   v
tokenization
   |
   v
sentence segmentation
   |
   v
lexical classification
   |
   v
feature-structured DCG parsing
   |
   +-------------------+
   |                   |
   v                   v
syntax trees      unresolved DRS
                         |
                         v
                 anaphora resolution
                         |
                         v
                    resolved DRS
                         |
                         v
            derived formal representations
          FOL / OWL / RuleML / TPTP / etc.
```

The important architectural properties are:

1.  The source text is processed through explicit intermediate
    representations.
2.  Lexical knowledge is separated from grammatical knowledge.
3.  Domain vocabulary is injectable rather than hard-coded into the
    grammar.
4.  The grammar carries feature structures rather than exploding into
    predicates with long positional argument lists.
5.  Syntactic parsing and discourse-reference resolution are separate
    concerns.
6.  The parser can expose its intermediate products---tokens, syntax
    trees, and DRS---not merely a final logical result.
7.  The discourse representation is a first-class semantic intermediate
    representation rather than a side effect of parsing.
8.  Multiple target logical formats are projections from the DRS rather
    than independent parsers.
9.  Controlled language removes much of the ambiguity that would
    otherwise dominate the engineering problem.

For our radiology work, the strongest reusable lesson is not "use ACE."
It is:

> Build explicit linguistic and discourse intermediate representations,
> keep the domain lexicon separable, and postpone domain-semantic
> commitment until grammatical evidence has been made inspectable.

A second strong lesson is:

> Reference resolution deserves its own phase. A parser should not be
> forced to decide that "it" and "the nodule" denote the same discourse
> referent while it is merely determining sentence structure.

A third is:

> A grammar becomes maintainable when syntactic, semantic, discourse,
> and source features can travel with constituents without being encoded
> as brittle positional arguments.

## 2. What APE Is

APE is the reference parser for Attempto Controlled English (ACE), a
controlled natural language developed to let domain specialists write
English-like statements that can be translated deterministically into
formal representations.

The original Attempto motivation was requirements and knowledge
representation. ACE was intended to remain readable as English while
eliminating enough lexical, syntactic, and semantic ambiguity to support
accurate machine interpretation.

APE is implemented principally in Prolog and historically targets
SWI-Prolog. The public repository organizes the principal code into:

``` text
prolog/
    logger/
    lexicon/
    utils/
    parser/
```

The parser package contains the tokenizer, grammar, and
anaphoric-reference resolver. The utilities transform the resulting
Discourse Representation Structure (DRS) into other representations.

APE exposes tokens, sentences, syntax trees, DRS, first-order logic,
prenex normal form, TPTP, OWL representations, RuleML, and paraphrases.
This is significant: APE is architected as a transformation pipeline
with observable intermediate products, not as a black-box
`text -> answer` system.

## 3. Reverse Specification

### 3.1 Inputs

APE accepts ACE text; optionally a user lexicon; parser/output
configuration; and optionally unknown-word guessing.

The user lexicon can extend the parser with domain-specific content
words. User entries take precedence over the built-in content lexicon.

The lexical universe is divided broadly into function
words---determiners, conjunctions, query words, prepositions, fixed
grammatical expressions---and content words such as nouns, proper names,
verbs, adjectives, adverbs, and measurement nouns.

This division is highly relevant to a RadLex-backed parser. English
grammatical vocabulary and medical/domain vocabulary need not be one
undifferentiated lexicon.

### 3.2 Outputs

APE's primary semantic output is a DRS.

A DRS represents discourse referents; predicates and conditions applying
to referents; relations among referents; logical structures such as
negation, implication, and disjunction; and resolved discourse
references where possible.

Syntax trees and token streams remain independently observable. Derived
logical outputs are generated from the DRS.

Reconstructed as an invariant:

> APE does not require every consumer to interpret the parser's internal
> grammar. It creates an intermediate semantic object from which
> downstream formal representations can be derived.

### 3.3 Processing Contract

A simplified reconstructed contract is:

``` text
tokenize(Text, Tokens)
segment(Tokens, Sentences)
parse(Sentences, SyntaxTrees, UnresolvedDRS)
resolve_anaphora(UnresolvedDRS, ResolvedDRS)
project(ResolvedDRS, TargetRepresentation)
```

The exact implementation has more state and machinery, but this
decomposition captures the important boundaries.

## 4. Tokenization

APE owns a tokenizer rather than delegating all lexical processing to a
generic English tokenizer. Controlled languages depend on lexical
distinctions that must agree exactly with the grammar and lexicon.

For radiology, we should expect tokenization to be part of our language
contract. Medical dictation contains lexical objects such as `6 mm`,
`1.2 cm`, `6 x 8 mm`, `T12-L1`, `L4/5`, `T2-weighted`, `BI-RADS 3`,
`RUL`, and `RLL`.

Unlike historical APE requirements, our system should preserve source
offsets as a first-class requirement:

> Every token, constituent, mention, and interpreted relationship must
> remain traceable to the exact source span that supplied its evidence.

## 5. Lexicon Architecture

APE has built-in vocabulary and user-extensible vocabulary. The user
lexicon permits domain concepts to enter the grammatical system without
rewriting the grammar.

For us:

``` text
linguistic vocabulary
    |
    +-- English function words
    +-- general English lexical/morphological knowledge
    +-- RadLex labels
    +-- RadLex synonyms
    +-- RadLex abbreviations
    +-- application-specific reporting vocabulary
```

RadLex should not become "the grammar." RadLex supplies domain lexical
and ontological information. English syntax remains a linguistic
concern.

A lexical item may carry both:

``` prolog
lexical_item(
    source("nodule"),
    linguistic_category(noun),
    ontology_candidates([rid_pulmonary_nodule, ...])
).
```

The grammar consumes the linguistic category; semantic interpretation
can consume ontology candidates.

## 6. Grammar Implementation

APE implements ACE construction and interpretation rules using a
Definite Clause Grammar enhanced with feature structures.

A naive Prolog grammar quickly produces unreadable predicates with many
positional arguments. APE instead uses structured feature bundles.
Conceptually, a constituent can carry syntactic features, semantic
arguments, DRS state, scope information, tree construction, token
information, and non-local grammatical information.

Reconstructed requirement:

> Grammar productions must be able to constrain and propagate named
> grammatical and semantic features without relying on the positional
> ordering of a large number of predicate arguments.

If our experimental grammar remains small, ordinary DCGs are sufficient.
If it grows to carry part of speech, number, tense, voice, head,
dependency role, source span, RadLex candidates, measurement structure,
negation state, discourse referent, and semantic candidates, then an
explicit feature representation becomes justified.

We do not need to adopt APE's exact `.fit` system. The lesson is
architectural.

## 7. Syntax Trees as Products

APE can emit simplified and detailed syntax trees. This makes wrong
interpretations debuggable.

If a parser produces only:

``` prolog
located_in(n1, rul1).
measurement(n1, 6, mm).
```

we cannot easily explain an error. If it also produces a tree in which
`6 mm` modifies `nodule` and `in the right upper lobe` is a PP modifying
that NP, the evidence chain is inspectable.

Our grammatical representation should therefore be a first-class
artifact:

``` text
medical proposition
    ^
semantic interpretation rule
    ^
grammatical relationship
    ^
source spans
```

This is stronger than attaching relations based on token distance.

## 8. Discourse Representation Structures

APE uses Discourse Representation Theory as its central semantic
representation. The core conceptual move is to distinguish discourse
referents from the words used to introduce or refer to them.

For `A customer buys a book`, a simplified DRS introduces referents `x`
and `y` and conditions such as `customer(x)`, `book(y)`, and
`buys(x,y)`.

This matters enormously for our application:

``` text
There is a pulmonary nodule in the right upper lobe.
It measures 6 mm.
```

Multiple linguistic expressions can refer to one discourse object. The
pronoun `it` need not become another entity; it can resolve to the
existing referent.

Crucially, our discourse referent is an object of the **interpretation
of the transcript**. It is not automatically a metaphysical assertion
that a physical entity exists in the patient.

Under negation, `No pleural effusion` must represent the medical concept
and the negative assertion without accidentally creating a positive
patient-world object.

APE's DRS machinery is valuable because DRT was designed for discourse,
quantification, negation, and anaphora rather than flat entity
extraction.

## 9. Anaphora Resolution

APE separates initial parsing from anaphoric-reference resolution.

For:

``` text
A nodule is present.
It measures 6 mm.
```

the second sentence can first yield a pronoun, a predicate, and a
measurement without requiring the local sentence grammar to identify the
antecedent. A subsequent resolver can consider available discourse
referents.

Reconstructed invariant:

> Anaphoric identity is a discourse-level relationship and must not be
> conflated with local constituent parsing.

This applies to `it`, `this`, `this lesion`, `the lesion`, `the nodule`,
`the latter`, `the former`, `the larger one`, and repeated definite noun
phrases such as `the kidney`.

This strongly supports:

``` text
mention != ontology concept != discourse referent
```

## 10. Ambiguity

APE's controlled-language assumption is doing substantial work. ACE
constrains ambiguity and defines interpretation conventions.

Radiologists dictate unrestricted, abbreviated, fragmentary, and
sometimes malformed English:

``` text
No acute disease.
Stable right basilar opacity.
Lungs otherwise clear.
6 mm RUL nodule unchanged.
Compared to prior, slightly decreased.
No PTX.
Could represent atelectasis.
```

We cannot require ACE-like author discipline.

Therefore we should copy APE's **representation discipline**, not its
assumption of grammatical determinism.

Our parser must be allowed to return one parse, multiple candidate
parses, a partial parse, unresolved attachment, unknown lexical items,
and ambiguous ontology normalization without fabricating certainty.

## 11. Unknown Words

APE supports built-in lexicons, user lexicons, unknown-word guessing,
and explicit word-class marking.

For radiology, unknown words arise from dictation errors, abbreviations,
proper names, devices, drugs, procedures, institution-specific language,
and vocabulary outside RadLex.

"Unknown to RadLex" must not mean "grammatically unknown."

A nominal such as `Port-a-Cath` can retain a grammatical analysis even
if ontology normalization is unresolved.

## 12. Semantic Projection

APE constructs semantic conditions while parsing and projects the DRS
into multiple formal languages.

For us, three representations should probably remain more distinct:

``` text
GRAMMATICAL REPRESENTATION
        |
        v
DISCOURSE REPRESENTATION
        |
        v
MEDICAL SEMANTIC INTERPRETATION
        |
        v
ONTOLOGY ENRICHMENT
```

ACE can collapse some of these because it was designed for controlled
formal interpretation. Unrestricted radiology grammar does not uniquely
determine every medical relationship.

For `nodule in the right upper lobe`, grammatical structure plus
ontology typing strongly supports `located_in`. For
`opacity over the right hilum`, `over` may be projectional rather than
containment. For `nodule near the fissure`, we want proximity rather
than containment.

The semantic projection layer is where our radiology-specific work
begins.

## 13. APE's Build-Time Grammar Transformation

APE's grammar source includes feature-oriented `.fit` files and
transformation tooling that generates executable parser code.

Large declarative grammars contain repetitive plumbing: pass features
down, copy features upward, unify values, thread DRS state, construct
trees. A higher-level source notation can express the grammar while a
transformation step generates the Prolog machinery.

Lesson: do not prematurely build a grammar compiler. But recognize when
positional DCG arguments have become evidence that a declarative feature
layer is warranted.

## 14. Testing Philosophy

APE includes tests and exposes intermediate parser products.

Our fixtures should eventually contain:

``` text
source transcript
expected tokens
expected grammatical constituents
expected lexical ontology candidates
expected discourse referents
expected resolved/unresolved references
expected medical relationships
explicit non-inferences
```

The last category is critical.

Example:

``` text
INPUT
Right kidney visualized.
Retroperitoneum partially visualized.

EXPECTED
mention(right_kidney)
mention(retroperitoneum)

ONTOLOGY CONTEXT
right_kidney contained_in some ...

MUST NOT PRODUCE
contained_in(kidney_instance, retroperitoneum_instance)
```

## 15. Interfaces and Operational Design

APE supports direct Prolog calls, command line, stdin/stdout, socket,
HTTP, and Java integration.

Our parser/enrichment engine should likewise have a pure core interface
first:

``` prolog
interpret_transcript(Source, Options, Result).
```

Everything else should wrap that interface. This is particularly
valuable for golden-corpus testing.

## 16. What APE Gets Right

### Explicit Intermediate Representations

APE does not leap directly from text to final output.

### Domain Lexicon Injection

Domain vocabulary does not require rewriting English grammar.

### Feature-Structured Grammar

Grammar state is named and structured.

### Discourse as a First-Class Layer

A text is more than independent sentences.

### Separate Reference Resolution

Anaphora is its own reasoning problem.

### Multiple Projections from One Semantic IR

A semantic hub supports multiple outputs.

### Inspectability

Tokens, trees, DRS, and logical outputs can all be examined.

## 17. What APE's Success Depends On

APE depends critically on ACE being controlled. The language defines
permitted constructions, lexical categories, interpretation conventions,
ambiguity restrictions, and anaphora behavior.

APE is solving:

``` text
parse a formally constrained English-like language
```

not:

``` text
recover intended meaning from arbitrary human English
```

This distinction is foundational.

## 18. Where APE Would Fail Us If Adopted Directly

1.  Radiology dictation is not controlled English.
2.  Medical semantics are not reducible to general grammatical
    semantics.
3.  Ontology recognition is ambiguous.
4.  Patient-world inference must remain constrained.
5.  Partial success is essential; one failed phrase cannot invalidate a
    transcript.

## 19. Proposed Lessons for Our Architecture

These are lessons, not application-specification requirements.

**A --- Preserve a Linguistic IR.** Do not make RadLex predicates the
first representation after text.

**B --- Preserve a Discourse IR.** Do not jump directly from mentions to
patient-world entities.

**C --- Keep Syntax and Medical Semantics Separate.** Grammar is
evidence for a medical relationship, not the relationship itself.

**D --- Make RadLex a Domain Lexicon and Semantic Constraint.** RadLex
should not be used as English grammar.

**E --- Separate Anaphora Resolution.** Cross-sentence identity is not
local syntax.

**F --- Make Ambiguity Representable.** Multiple candidates and
unresolved structures are legitimate outputs.

**G --- Make Partial Parsing Legitimate.** A transcript can be useful
even if some phrases remain unparsed.

**H --- Carry Provenance.** Interpretations should be traceable to
source, grammar, and ontology evidence.

**I --- Use Feature Structures When the Grammar Demands Them.** Avoid
unmaintainable positional DCG arguments.

**J --- Keep the Core Parser Independent of Its Service Wrapper.**

## 20. APE Versus the Emerging Radiology Architecture

  --------------------------------------------------------------------------
  Concern                 APE                     Emerging radiology system
  ----------------------- ----------------------- --------------------------
  Input language          Attempto Controlled     Unrestricted/telegraphic
                          English                 radiology dictation

  Parser                  Prolog DCG + feature    Open question
                          structures

  Lexicon                 Function + general      English + RadLex +
                          content + user lexicon  reporting vocabulary

  Syntax output           Yes                     Should be yes

  Semantic IR             DRS                     Likely discourse/semantic
                                                  IR; exact form open

  Anaphora                Separate resolver       Should be separate

  Ontology                Target/projection and   Semantic authority and
                          domain vocabulary       enrichment source

  Ambiguity               Constrained by ACE      Must be explicitly
                                                  represented

  Partial parse           Less central            Essential

  Negation                Logical DRS structure   Must avoid positive entity
                                                  invention

  Provenance              Token/syntax machinery  Must be stronger and
                                                  source-span oriented

  Purpose                 Formalize controlled    Enrich radiologist
                          statements              language

  Clinical inference      Not its domain          Outside present
                                                  application

  Outputs                 Many logical forms      Annotated transcript +
                                                  semantic view initially
  --------------------------------------------------------------------------

## 21. Worked Comparison

Input:

``` text
There is a 6 mm pulmonary nodule in the right upper lobe.
It is unchanged.
```

### Lexical Layer

Recognize `6 mm` as measurement, `pulmonary nodule` and
`right upper lobe` as ontology candidates, `It` as pronoun, and
`unchanged` as comparative/temporal language.

### Grammatical Layer

``` text
Sentence 1
└── clause
    └── NP
        ├── measurement modifier: 6 mm
        ├── head: pulmonary nodule
        └── PP modifier
            ├── in
            └── NP: right upper lobe

Sentence 2
├── subject: pronoun "It"
└── predicate: is unchanged
```

### Unresolved Discourse Layer

``` text
f1 : introduced by "pulmonary nodule"
a1 : introduced by "right upper lobe"
x1 : anaphoric mention "It"

measurement(6, mm) modifies f1
candidate_locative_relation(f1, a1)
unchanged(x1)
```

### Reference Resolution

``` text
x1 -> f1
```

### Medical Semantic Interpretation

``` text
f1 identified_as pulmonary_nodule
a1 identified_as right_upper_lobe
measurement_of(6_mm, f1)
located_in(f1, a1)
temporal_status(f1, unchanged)
```

Each relation should retain its grammatical and source evidence.

### Ontology Enrichment

RadLex can expose class-level context for recognized concepts but must
not manufacture additional case entities merely because ontology
restrictions existentially imply them.

## 22. Why DRS Matters

DRS is not accidental plumbing. Natural-language semantics must handle
indefinite introductions, later references, pronouns, quantification,
negation, conditionals, and discourse scope.

A DRS provides a place for referents to exist as **discourse objects**
before downstream logical translation.

This aligns strongly with our earlier problem: entity extraction is too
weak an abstraction for report understanding. A discourse representation
is a more appropriate intermediate object.

Whether we use classical DRT/DRS exactly remains open.

## 23. DRS and Our Ontology/Application Boundary

There is an elegant alignment between DRT and the boundary we discovered
independently:

> Enrich the doctor's language; do not enrich the patient.

DRT gives us a conceptual place for the doctor's discourse objects.

This suggests a three-world discipline:

``` text
SOURCE WORLD
what character spans and grammatical structures occurred

DISCOURSE WORLD
what referents and propositions the report introduces

ONTOLOGY WORLD
what RadLex says generally about identified concepts
```

`source -> discourse` is interpretation.

`discourse -> ontology concept` is normalization/classification.

`ontology -> discourse` is constrained enrichment and must not silently
become case-world assertion.

## 24. Dependency Parsing Versus APE-Style Parsing

Modern NLP often exposes dependency trees; APE uses a hand-specified
grammar and formal semantic construction.

Possible architecture A:

``` text
standard NLP parser
 -> UD dependency structure
 -> + RadLex lexical candidates
 -> Prolog semantic interpretation
 -> discourse representation
```

Possible architecture B:

``` text
tokens
 -> domain-extended Prolog grammar
 -> syntax + discourse semantics
```

A hybrid is possible.

APE does not prove DCGs are superior. It proves a Prolog grammar can
successfully thread syntactic, semantic, and discourse state through a
substantial language implementation.

## 25. What We Should Prototype Before Choosing

A useful bake-off should compare a modern UD dependency parser, a small
radiology-aware SWI-Prolog DCG, and perhaps APE itself with a tiny
medical user lexicon solely to observe its failure boundary.

Representative sentences:

``` text
There is a 6 mm pulmonary nodule in the right upper lobe.
A pulmonary nodule in the right upper lobe measures 6 mm.
Within the right upper lobe is a 6 mm pulmonary nodule.
The right upper lobe contains a 6 mm pulmonary nodule.
A nodule is present adjacent to the major fissure.
It measures 6 mm.
No pleural effusion.
The right kidney measures 11 cm.
The kidney is otherwise unremarkable.
Two cysts are present in the right kidney.
The larger measures 8 mm.
Stable right basilar opacity.
No focal airspace disease, pleural effusion, or pneumothorax.
```

Compare whether each approach recovers the grammatical attachment
justifying desired medical relations, preserves ambiguity, handles
fragments, preserves spans, and explains failures.

## 26. Failure Modes to Design for

**Lexical failure:** `RUL noduel`. Preserve the span even if
normalization fails.

**Fragment:** `Stable bibasilar atelectasis.` Parse as elliptical
assertion rather than reject.

**Attachment ambiguity:** `Nodule near the fissure measuring 6 mm.`
Domain typing may favor the nodule, but evidence should remain
inspectable.

**Coordination:** `No effusion or pneumothorax.` Negation scopes over
coordinated concepts.

**Cross-sentence reference:**
`A right upper lobe nodule is present. It is unchanged.` Requires
discourse resolution.

**Multiple same-type referents:**
`Two nodules are present. The larger measures 8 mm.` Requires discourse
comparison/reference.

**Ontology overreach:**
`Right kidney visualized. Retroperitoneum partially visualized.` Must
not infer concrete containment solely from RadLex.

## 27. Engineering Patterns Worth Stealing

1.  Observable pipeline.
2.  Declarative lexicon.
3.  Feature-carrying constituents.
4.  Separate discourse resolver.
5.  Semantic hub supporting multiple projections.
6.  Formal negative tests.
7.  Domain extension without grammar forking.
8.  Graceful unknowns.

## 28. Engineering Patterns Not to Copy Blindly

1.  Assume controlled input.
2.  Treat parse success as binary.
3.  Equate linguistic semantics with clinical truth.
4.  Couple grammar to one target logic.
5.  Hide ambiguity with arbitrary interpretation conventions.

## 29. Candidate Vocabulary

Keep distinct:

``` text
source span
token
lexeme
part-of-speech annotation
constituent
grammatical relation
mention
ontology candidate
discourse referent
anaphoric expression
assertion
measurement
semantic relation
ontology context
provenance/evidence
```

A word such as `kidney` can simultaneously be a source span, token,
noun, NP head, mention, RadLex candidate, and reference to a discourse
referent. Those are different propositions.

## 30. Candidate Phase Model

Technical-preview model, not specification:

``` text
PHASE 0 — SOURCE PRESERVATION
PHASE 1 — LEXICAL ANALYSIS
PHASE 2 — GRAMMATICAL ANALYSIS
PHASE 3 — DISCOURSE CONSTRUCTION
PHASE 4 — REFERENCE RESOLUTION
PHASE 5 — MEDICAL SEMANTIC INTERPRETATION
PHASE 6 — ONTOLOGY ENRICHMENT
PHASE 7 — PROJECTIONS
```

APE provides especially strong precedent for phases 1--4 and the IR
boundaries among them.

## 31. Open Questions Exposed by the APE Study

1.  Should our primary linguistic IR be a constituency tree, Universal
    Dependencies, or both?
2.  Should SWI-Prolog perform grammatical parsing itself, or consume a
    modern NLP parse?
3.  Do we want DRT-inspired discourse representation or a simpler
    application-specific discourse IR?
4.  At what stage should RadLex candidates enter?
5.  How should partial parses be represented?
6.  How should competing grammatical attachments be represented?
7.  What minimum feature set must constituents carry?
8.  Should semantic interpretation occur during parsing or in a separate
    pass?
9.  What exact distinction should we make between discourse referent and
    application entity?
10. How should negated concepts be represented without positive
    existential commitment?
11. What evidence suffices to resolve anaphora deterministically?
12. When may ontology typing disambiguate grammatical attachment?
13. How do we preserve exact source spans through normalization?
14. How much general English lexicon is needed if RadLex supplies domain
    vocabulary?
15. Which APE mechanisms remain useful for fragments and elliptical
    dictation?
16. Could APE's feature structures be simplified using modern SWI-Prolog
    facilities?
17. Should ambiguity resolution be deterministic Prolog, probabilistic
    NLP, LLM-assisted, or staged?
18. What is the error contract for partially understood sentences?

## 32. Recommended Source-Code Reading Order

1.  `README.md` --- external contract and package structure.
2.  `prolog/parser/ace_to_drs.pl` --- top-level pipeline.
3.  `prolog/parser/tokenizer.pl` --- lexical front end.
4.  `prolog/parser/grammar.fit` --- central grammar.
5.  `prolog/parser/grammar_functionwords.fit` --- grammatical
    vocabulary.
6.  `prolog/parser/grammar_contentwords.fit` --- content-word
    integration.
7.  feature-structure transformation tooling.
8.  `prolog/parser/refres.pl` --- anaphoric reference resolution.
9.  lexicon and user-lexicon handling.
10. syntax-tree output code.
11. DRS transformation utilities.
12. tests revealing ambiguity and anaphora assumptions.

Trace one sentence end-to-end rather than reading every grammar rule.

## 33. Suggested End-to-End Trace

Use:

``` text
A man owns a dog. The dog follows the man.
```

Trace:

``` text
characters
 -> tokens
 -> lexicon entries
 -> grammar productions
 -> syntax trees
 -> unresolved DRS
 -> anaphora candidates
 -> resolved DRS
 -> FOL projection
```

Then repeat with a radiology-shaped sentence after adding a tiny user
lexicon:

``` text
A nodule is in a lobe. The nodule measures 6 mm.
```

The purpose is to observe where controlled-language machinery helps and
where our application needs a different abstraction.

## 34. Postmortem: The Deeper Lesson

The superficial lesson is: Prolog DCGs can parse English.

The deeper lesson is:

> A serious language system benefits from separating surface language,
> grammar, discourse identity, semantic representation, and downstream
> logical projection.

The deeper lesson for our project is that ontology enrichment should not
erase those distinctions.

Our likely path is not:

``` text
transcript -> RadLex facts
```

but:

``` text
transcript
 -> linguistic structure
 -> discourse structure
 -> medical semantic interpretation
 <-> RadLex ontology
 -> application projections
```

This makes it possible to explain why a measurement belongs to a nodule,
why `it` refers to that nodule, why `in` was interpreted as location,
and which information came from transcript versus ontology.

## 35. Fieldstones

### Linguistic IR

**Status:** provisional. **Contribution:** joint. Preserve an explicit
standardized linguistic representation before medical semantic
interpretation.

### Discourse Before Patient World

**Status:** provisional. **Contribution:** joint. A discourse referent
is an object in the interpretation of the report, not automatically a
patient-world existential commitment.

### Separate Reference Resolution

**Status:** strong provisional. **Contribution:** prior-art-supported.
Parse grammatical structure before resolving cross-sentence references.

### Domain Lexicon Is Not Grammar

**Status:** strong provisional. **Contribution:**
joint/prior-art-supported. RadLex supplies domain lexical and semantic
knowledge; it should not define English grammatical structure.

### Observable Intermediate Products

**Status:** strong provisional. **Contribution:** prior-art-supported.
Tokens, grammatical structures, discourse structures, and semantic
interpretations should be independently inspectable.

### Ambiguity Is Data

**Status:** provisional. **Contribution:** joint. Unlike ACE,
unrestricted radiology input requires ambiguity and partial
interpretation to be representable outputs.

### Grammar Evidence for Semantic Relations

**Status:** strong provisional. **Contribution:** human-led direction
refined through prior art. Follow grammatical relationships to establish
attachment rather than using bounded token windows.
`measurement_of(M,E)` should be supported by a grammatical
modifier/complement relationship, not mere proximity.

## 36. Sources and Prior Art

Primary implementation and documentation:

-   Attempto/APE public source repository.
-   APE README, parser source, tokenizer, grammar, lexicon, and
    reference resolver.
-   Norbert E. Fuchs and Rolf Schwitter, *Attempto Controlled English
    (ACE)*, 1996.
-   Rolf Schwitter and Norbert E. Fuchs, *Attempto --- From
    Specifications in Controlled Natural Language towards Executable
    Specifications*, 1996.
-   Norbert E. Fuchs, Kaarel Kaljurand, and Tobias Kuhn, *Attempto
    Controlled English for Knowledge Representation*, Reasoning Web,
    2008.
-   ACE Syntax Report.
-   ACE 6.7 in a Nutshell.
-   APE Webservice and Webclient documentation.
-   Attempto/ACE-in-GF as related grammar implementation prior art.

## 37. Conclusion

APE is not a parser we can simply point at radiology reports. It is more
valuable than that.

It is a mature demonstration that a Prolog-based language system can
maintain explicit boundaries among tokenization, lexical classification,
feature-rich grammar, syntax trees, discourse referents, anaphora
resolution, semantic representation, and multiple logical projections.

The controlled-language assumption explains much of APE's determinism
and must not be imported accidentally. Radiology dictation requires
partial parsing, explicit ambiguity, robust fragments, source
provenance, ontology normalization, and a strict prohibition against
turning general ontology knowledge into unsupported case facts.

Nevertheless, APE gives us a concrete architectural lineage for the
system we are beginning to imagine.

The most promising adaptation is not to reproduce ACE. It is to preserve
the architecture's strongest separation of concerns while replacing
controlled-language semantics with a radiology-specific,
evidence-preserving semantic interpretation layer backed by RadLex.

The next research step should be empirical: trace several APE sentences
through the actual implementation, then compare the same grammatical
phenomena in representative radiology sentences. That will show which
mechanisms can be reused directly, which should merely inspire our
architecture, and where modern dependency parsing or other NLP
components should replace APE's controlled grammar.
