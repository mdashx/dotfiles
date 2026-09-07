# Debug Interface Design Philosophy

**Status:** Draft
**Scope:** Browser-based engineering, diagnostic, administrative, and technical interfaces
**Visual starting point:** Basic Web Theme
**Intellectual influences:** Edward Tufte's information design and Daniel Jackson's concept design

## 1. Vision

A debug interface is an instrument for understanding a system.

Its purpose is not merely to expose logs, traces, network requests, database records, metrics, or internal objects. Those artifacts may provide valuable evidence, but their availability does not constitute an information architecture.

The interface must first define the domain through which the system is to be understood.

It must identify the concepts that matter within that domain, present the behavior of the system in terms of those concepts, and make the underlying implementation evidence available in support of that explanation.

The governing principle is:

> **A debug interface should explain a system in its domain language and use implementation telemetry as evidence. It should not mistake the availability of telemetry for an information architecture.**

This interface should be useful both to a person investigating the system and to software inspecting or operating it.

The rendered browser document is therefore not merely the visual output of an application.

> **The DOM is the interface, not a byproduct of the interface.**

> **The rendered interface is part of the system's public machine-readable surface.**

The objective is an interface whose conceptual structure is clear enough that its visual organization, semantic HTML, machine accessibility, and debugging utility reinforce one another.

---

# 2. Conceptual Design

## 2.1 Define the domain before designing the interface

Every interface governed by this philosophy must define the domain that it presents.

The existence of an implementation subsystem does not automatically justify a corresponding section of the interface.

For example, the following are implementation observations:

```text
HTTP request
JSON response
log entry
database row
Prolog query
RDF triple
cache lookup
stack trace
network event
```

They may be essential evidence, but they are not necessarily the concepts through which the system should be understood.

Before designing the primary interface, identify concepts such as:

```text
Request
Compilation
Source Construct
Translation
Match
Assertion
Derivation
Diagnostic
```

The correct vocabulary depends on the system. The interface design process must discover that vocabulary rather than assume it.

## 2.2 Implementation topology must not become information architecture by default

A subsystem, API endpoint, database table, process, queue, log stream, or telemetry source does not acquire a primary place in the interface merely because it exists.

The interface should instead ask:

> What does the engineer need to understand?

Several implementation components may provide evidence about one domain concept.

For example:

```text
HTTP request ─────────┐
database lookup ──────┤
ontology assertion ───┼──► Match
Prolog query ─────────┤
log event ────────────┘
```

The primary interface should present the **Match**.

The implementation observations should remain available as evidence for that match.

## 2.3 Constraint forces interpretation

The interface deliberately restricts its visual vocabulary and the number of information layers available for ordinary presentation.

This restriction is not merely aesthetic.

An unconstrained component system makes it possible to reproduce an implementation hierarchy directly:

```text
request
  parser
    tokenizer
      token
        normalization
          candidate
            lexical metadata
              ontology metadata
                ...
```

The designer can always introduce another card, heading, tab, tree level, accordion, or enclosing panel.

The resulting interface may faithfully reproduce the structure of the implementation without explaining its meaning.

A constrained interface removes this escape route.

When arbitrary nesting is unavailable, the designer must determine:

- what the information represents;
- which concept owns it;
- what relationship connects it to other information;
- whether it belongs to the primary explanation;
- whether it is evidence;
- whether it is provenance or qualification;
- whether it is genuinely a separate concept.

> **Flattening the representation becomes an act of modeling rather than formatting.**

## 2.4 Presentation is a test of concept quality

A concept should admit an intelligible presentation.

When a subsystem cannot be explained without a deep hierarchy of UI containers, the first response should be to reconsider the conceptual model rather than immediately expand the visual vocabulary.

If two supposedly independent concepts constantly require access to each other's state in order to be explained, their conceptual boundaries may be wrong.

If two displayed facts cannot be connected by a meaningful relationship, their proximity may reflect implementation adjacency rather than conceptual relationship.

Therefore:

> **Difficulty presenting a system clearly may be evidence of difficulty conceptualizing the system clearly.**

The constrained interface acts as a lightweight conceptual-design discipline.

---

# 3. Evidence-Centered Presentation

## 3.1 The interface presents explanations supported by evidence

The fundamental unit of a debug interface is not a UI component.

It is:

> **an explanation supported by inspectable evidence.**

The primary interface should answer questions such as:

```text
What happened?
Where did it happen?
Why did it happen?
What evidence supports that explanation?
Can the case be reproduced?
```

## 3.2 Show the data

The interface should devote as much of its representational capacity as practical to the system being investigated.

Decorative interface machinery must justify the attention and space that it consumes.

Borders, cards, backgrounds, icons, legends, navigation structures, status graphics, and other chrome should not compete with evidence merely to make the interface resemble a contemporary application.

A useful adaptation of Tufte's data-ink principle is:

> **How much of the visible interface represents the system under investigation, and how much represents the debugger itself?**

The ratio should strongly favor the system.

## 3.3 High information density is desirable

Minimal interface design does not imply sparse information.

Expert interfaces may legitimately display large amounts of information when that information contributes to reasoning.

The goal is:

- high information density;
- low non-information density;
- strong conceptual organization.

Do not replace rich evidence with a large status indicator merely because the latter is visually simpler.

Do not reduce meaningful system state to green, yellow, and red when the underlying state can be presented intelligibly.

## 3.4 Layer and separate

Different kinds of information should remain perceptually distinct without being isolated into independent containers.

Use:

- position;
- typography;
- whitespace;
- line weight;
- scale;
- alignment;
- subtle rules;
- restrained intensity.

These devices should establish information layers before cards, nested panels, or decorative containers are introduced.

A useful default model is:

```text
PRIMARY
    the thing being explained

EVIDENCE
    what establishes or explains it

ANNOTATION
    what identifies, qualifies, or provides provenance for it
```

The exact number of layers may vary, but it should remain deliberately small.

The scarcity of layers is itself a design constraint.

## 3.5 Narrative column and evidence margin

A particularly useful geometry is a primary reading column accompanied by a generous contextual margin.

```text
PRIMARY NARRATIVE                 EVIDENCE / ANNOTATION
─────────────────                 ─────────────────────

Input                             source location
                                  request identifier

        ↓

Interpretation                    normalization
                                  source representation

        ↓

Match                             concept identifier
                                  matching basis

        ↓

Derivation                        rule
                                  premises
                                  provenance

        ↓

Result                            timing
                                  output identifier
```

The primary column carries the explanation.

The margin contains information that supports, identifies, qualifies, illustrates, or provides provenance for something in that explanation without becoming another step in it.

The margin is therefore not a miscellaneous sidebar.

It has semantic meaning.

## 3.6 Put evidence near the claim

Evidence should be physically close to the proposition it supports whenever practical.

Do not require an engineer to:

1. observe a result;
2. memorize an identifier;
3. switch to another tab;
4. search a log;
5. locate the identifier;
6. reconstruct the relationship mentally.

Prefer:

```text
claim              evidence
claim              provenance
claim              source
claim              derivation
```

over spatially and temporally separated evidence.

## 3.7 Comparison should occur in space

When two states must be compared, place them together.

Do not require the engineer to remember one screen while examining another.

Repeated comparable objects should use stable visual structures so that differences become salient.

This makes Tufte's small-multiples principle particularly useful for:

- repeated executions;
- compiler passes;
- before-and-after state;
- alternative interpretations;
- rule applications;
- requests through the same processing stage.

The representation should remain stable while the data varies.

---

# 4. Raw Evidence and Provenance

## 4.1 Raw representation must remain reachable

Conceptual presentation must not sanitize the implementation.

Logs, traces, requests, responses, source representations, serialized objects, queries, database values, stack traces, and other raw evidence should remain inspectable when available.

However:

> **Raw representation must remain reachable, but it does not determine the information architecture.**

A REST object is a representation.

An RDF graph is a representation.

A Prolog term is a representation.

A database schema is a representation.

A log stream is a representation.

None of these is automatically the conceptual model of the interface.

## 4.2 Provenance is first-class

Any nontrivial value should, when practical, be able to answer:

> **Why is this here?**

Useful provenance may include:

```text
input span
source identifier
request identifier
rule
predicate
compiler pass
database query
external call
timestamp
cache source
derivation
source location
```

Provenance should normally appear as evidence or annotation associated with the concept it explains.

## 4.3 Absence has semantics

The interface must preserve distinctions among states such as:

```text
false
empty
unknown
unavailable
not attempted
not applicable
failed
```

For example:

```text
No matches were found.
```

is different from:

```text
The matcher did not run.
```

which is different from:

```text
The matcher failed.
```

which is different from:

```text
The matcher state is unavailable.
```

Visual emptiness must not collapse these states.

---

# 5. The DOM as an Interface

## 5.1 We live in the DOM

The DOM is not disposable output produced for a visual renderer.

It is the concrete interactive information environment in which humans and software encounter the interface.

Humans read it through the browser.

Browsers navigate it.

Screen readers interpret it.

Scripts query it.

Tests operate it.

Bots traverse it.

AI agents reason over it and act through it.

Therefore:

> **Semantic HTML is an architectural material, not an implementation detail.**

## 5.2 The rendered interface is machine-readable

Domain objects, relationships, actions, state, and identifiers that are meaningful in the interface should, wherever practical, be explicitly identifiable in the DOM.

A machine should not have to infer from pixels something that the document already knows structurally.

For example:

```html
<section
    id="match-RID29662"
    data-concept="match"
    data-rid="RID29662">

    <h2>Right kidney</h2>

    <dl>
        <dt>RID</dt>
        <dd>RID29662</dd>

        <dt>Match type</dt>
        <dd>preferred-label</dd>
    </dl>

    <a href="/concepts/RID29662">
        Inspect concept
    </a>
</section>
```

The conceptual identity of the object is not hidden exclusively inside JavaScript state or framework internals.

## 5.3 Important things require stable semantic identity

Important domain objects should have stable machine-addressable identities when practical.

Useful mechanisms include:

```text
id
name
href
for
role
aria-*
data-*
```

Native HTML semantics should be preferred where they already express the intended relationship.

Custom attributes should supplement native semantics rather than replace them unnecessarily.

CSS class names should not be the sole machine interface to domain concepts.

## 5.4 Use the browser as a browser

Navigation should use real links when the operation is navigation.

Input should use ordinary form semantics when practical.

Labels should be structurally associated with controls.

Resources should have meaningful URLs.

Browser history should remain useful.

Opening a link in another tab should work.

Text should remain selectable.

Keyboard navigation should work.

Important state should be reflected in the DOM and, where appropriate, in the URL.

JavaScript may extend the browser's interaction model, but it should not casually replace capabilities the browser already provides.

## 5.5 Frameworks are subordinate to the document

No particular rendering technology is prohibited by this philosophy.

React, server templates, HTMX, plain HTML, or another implementation may be used when appropriate.

The architectural requirement is:

> **Framework abstractions must not obscure the semantic document.**

The meaning of the interface must not exist exclusively in an opaque component tree, synthetic event system, transient client state, or generated class hierarchy.

The HTML emitted to the browser is a first-class interface contract.

---

# 6. Addressability and Automation

## 6.1 Debuggable things should be addressable

Whenever practical, important resources and executions should have meaningful URLs.

For example:

```text
/requests/abc123
/concepts/RID29662
/compilations/2026-09-06T18:42:03Z
/reports/xyz/matches
```

An engineer should be able to paste a URL into:

- an issue;
- a pull request;
- a test;
- a notebook;
- a chat;
- another browser;
- an automated tool.

## 6.2 Copyability is a feature

Important values should be easy to copy exactly.

Examples include:

```text
identifiers
JSON
Prolog terms
SQL
ontology assertions
source text
timestamps
URLs
errors
stack traces
generated commands
```

Machine-readable values should not be silently altered merely to improve their visual appearance.

## 6.3 Automation should survive visual refinement

The DOM should remain stable enough that scripts and tests can operate against semantic identities rather than fragile presentation details.

Automation should not normally depend on:

```text
the third div inside the second card
generated CSS class names
pixel coordinates
visible text when a stable identifier exists
```

Prefer selectors based on concepts, controls, names, identifiers, relationships, and document semantics.

---

# 7. Interaction

## 7.1 Prefer inspection over workflow

A debug interface is normally an inspector rather than a wizard.

Prefer operations such as:

```text
inspect
follow
filter
expand
compare
copy
replay
```

over unnecessary sequential workflows.

An engineer usually arrives with a question and should be free to move among related evidence.

## 7.2 Observation is safe by default

Inspection should not mutate the system.

If the interface exposes operations such as:

```text
replay request
reload ontology
invalidate cache
clear state
retry operation
submit synthetic input
```

those operations should be clearly distinguished from observational controls.

The interface should make the target and scope of mutation explicit.

## 7.3 Debugging should lead naturally to reproduction

A successful investigation frequently ends by producing a reproducible case.

Where practical, the interface should make it easy to obtain artifacts such as:

```text
request payload
curl command
Prolog query
test fixture
JSON
source assertion
normalized input
```

The transition from:

> I found the problem.

to:

> I can reproduce the problem.

should be inexpensive.

---

# 8. Visual Vocabulary

## 8.1 Basic Web Theme establishes the baseline

Basic Web Theme provides an appropriate starting vocabulary because it favors:

```text
ordinary HTML
system typography
plain links
simple tables
readable prose
minimal chrome
automatic dark mode
no card-grid aesthetic
no JavaScript dependency for basic presentation
```

These constraints should be treated as useful pressure rather than limitations to escape immediately.

## 8.2 Use a small primitive vocabulary

The ordinary visual vocabulary should consist primarily of:

```text
prose
headings
links
lists
tables
code
forms
rules
annotations
figures
```

This is approximately the vocabulary required to construct a technical document or scientific argument.

It should be sufficient for a large portion of a technical interface.

## 8.3 New visual primitives incur a complexity cost

A new component or representational dimension should correspond to a meaningful distinction in the domain or to a genuine interaction requirement.

The burden of proof belongs to additional interface machinery, not to simplicity.

If the interface appears to require a complex specialized component, first ask whether the underlying concept has been identified clearly enough.

The answer may still be that the component is justified.

The requirement is to make that justification explicit.

## 8.4 Prose stays readable; evidence gets the space it requires

Narrative prose should normally remain within a comfortable reading width.

Evidence may legitimately require additional horizontal space.

Large tables, traces, serialized structures, diagrams, comparisons, and other intrinsically wide material may break out of the reading column.

> **Prose stays readable; evidence gets the space it requires.**

---

# 9. Design Method

The design process for a new interface should proceed approximately as follows:

```text
DEFINE THE DOMAIN
        ↓
IDENTIFY THE CONCEPTS
        ↓
IDENTIFY THEIR RELATIONSHIPS
        ↓
IDENTIFY THE QUESTIONS
AN ENGINEER ASKS
        ↓
DESIGN THE EXPLANATIONS
        ↓
ASSOCIATE EVIDENCE
WITH EACH EXPLANATION
        ↓
REPRESENT THE CONCEPTS
IN SEMANTIC HTML
        ↓
APPLY THE RESTRICTED
VISUAL VOCABULARY
        ↓
ADD SPECIALIZED INTERACTION
ONLY WHERE REQUIRED
```

This order is intentional.

Do not begin with a page inventory or component inventory.

Do not begin by asking:

> What should be in the sidebar?

Begin by asking:

> What is this system about?

and:

> What must a person understand about it?

---

# 10. Governing Principles

The philosophy can be summarized by the following rules.

### Domain before telemetry

> **A debug interface must define the domain it presents.**

### Concepts before implementation topology

> **Implementation topology must not become information architecture by default.**

### Explanation before component

> **The fundamental unit of the interface is an explanation supported by inspectable evidence.**

### Constraint before complexity

> **A restricted presentation vocabulary forces conceptual clarity.**

### Evidence before decoration

> **The interface should devote its representational capacity primarily to the system being investigated.**

### Proximity of claim and evidence

> **Put evidence physically near the claim that it supports.**

### Raw evidence remains available

> **Raw representation must remain reachable, but it does not determine the information architecture.**

### The DOM is the interface

> **The DOM is the interface, not a byproduct of the interface.**

### Machine readability is architectural

> **The rendered interface is part of the system's public machine-readable surface.**

### HTML has meaning

> **Semantic HTML is an architectural material, not an implementation detail.**

### Frameworks serve the document

> **Framework abstractions must not obscure the semantic document.**

### Complexity must correspond to meaning

> **Every additional representational dimension should correspond to a meaningful dimension in the system.**

---

# 11. Design Review Test

Before accepting an interface, ask:

1. What domain does this interface present?
2. What are its primary concepts?
3. Can those concepts be explained without reproducing the implementation hierarchy?
4. What engineering question does each major element help answer?
5. What is primary information, what is evidence, and what is annotation?
6. Is evidence physically close to the claim it supports?
7. Can the engineer reach the raw representation?
8. Does the interface preserve provenance?
9. Are absence, failure, unknown state, and falsehood distinguished?
10. Are comparable things presented so they can be compared directly?
11. Does visual structure correspond to conceptual structure?
12. Can important domain objects be identified directly in the DOM?
13. Can software determine what important controls do?
14. Do important resources have meaningful URLs?
15. Can a script operate the interface without reverse-engineering its visual appearance?
16. Is important state exposed outside opaque client-side framework state?
17. Would removing a container, card, heading level, or component reveal a conceptual ambiguity?
18. Does every specialized visual primitive earn its existence?
19. Is most of the screen describing the system rather than the debugger?
20. Does the interface make the system easier to reason about?

The strongest diagnostic question is:

> **If we cannot explain this system clearly with a small vocabulary of concepts and visual structures, have we actually understood the system well enough to design its interface?**