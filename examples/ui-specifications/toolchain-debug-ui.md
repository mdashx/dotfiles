# Toolchain Debug UI
# Design Specification

**Status:** Research Draft — Unapproved
**Application:** Toolchain
**Scope:** Installation, capability, interoperability, and evidence inspection for the research toolchain
**Design basis:** *Debug Interface Design Philosophy*
**Current empirical basis:** `setup/PLAN.md`, `setup/ACCEPTANCE-MATRIX.md`, and `setup/STATE.md`

This document records a candidate design. Its presence under `research/` does not approve an architecture or authorize implementation. Requirements language describes the proposed design if adopted. Planning assumptions are called out separately and remain revisable until explicitly accepted.

---

# 1. Vision

The Toolchain Debug UI is a separate technical application for understanding whether the research toolchain is present, operable, and interoperable.

Its central question is:

> **Is this toolchain ready for research, what capabilities were demonstrated, and what evidence proves it?**

The application does not explain a radiology transcript interpretation. It does not present mentions, constructs, referents, frames, groundings, or clinical meaning. Those belong to the Radiology Transcript Interpreter and its own debug application.

The Toolchain application instead presents the domain of research infrastructure:

```text
declared toolchain
      │
      ▼
components and identities
      │
      ▼
required capabilities and seams
      │
      ▼
version-bound evaluation
      │
      ▼
verifications
      │
      ▼
inspectable evidence and diagnostics
```

The interface is successful when an engineer can determine, without reading setup scripts or inferring meaning from logs:

- which executable tools and knowledge resources constitute the toolchain;
- which capabilities each component is expected to provide;
- which artifacts cross component boundaries;
- which seams have actually been exercised;
- which claims passed, failed, were blocked, or have not been attempted;
- whether prior evidence still applies to the selected versions and environment;
- how to inspect and reproduce every readiness claim; and
- what the readiness claim explicitly does **not** establish.

## 1.1 Boundary with the interpreter application

Toolchain and Radiology Interpreter are separate applications with separate concepts and separate primary objects of inspection.

```text
TOOLCHAIN DEBUG UI                     RADIOLOGY INTERPRETER DEBUG UI

Toolchain                              Interpretation Execution
Component                              Source
Capability                             Mention
Artifact                               Construct
Seam                                   Referent
Service                                —
Endpoint                               —
Service Instance                       —
Environment                            Frame
Evaluation                             Grounding
Verification                           Validation
Evidence                               Provenance
Diagnostic                             Diagnostic

"Can the machinery work together?"     "How did this text become this meaning?"
```

The applications may link to one another by stable URL when useful. Neither should embed the other's domain as a subordinate dashboard.

Toolchain readiness is a prerequisite claim about research machinery. It is not evidence that the radiology interpretation model is implemented correctly, that a clinical interpretation is valid, or that an end-to-end product is ready.

## 1.2 Governing principles

This application follows the general debug-interface philosophy, with one important domain-specific consequence:

> In a toolchain application, component boundaries and interoperability seams are domain concepts, not incidental implementation telemetry.

Even so, a process diagram or package inventory is not sufficient. The interface is organized around **capabilities that have been demonstrated**, with versions, commands, logs, and artifacts serving as evidence.

The following propositions organize the current research draft:

1. Toolchain is a distinct application, not a section of the Radiology Interpreter UI.
2. Readiness is derived from current verification evidence; it is never a manually assigned green state.
3. Installation and version discovery are evidence about a component, not proof of its behavior.
4. Independent component checks and cross-component seam checks are both required.
5. Evidence is bound to exact component identities and an environment.
6. Raw evidence is directly reachable but subordinate to the explanation it supports.
7. Observation is safe by default; rerunning a check is an explicit operation.
8. The rendered DOM is a stable, semantic, machine-readable inspection surface.

---

# 2. Technical Introduction

## 2.1 Primary object of inspection

The durable domain object is a **Toolchain**: a declared composition of components, required capabilities, and required seams.

The primary inspectable snapshot is an **Evaluation**: one bounded assessment of a toolchain in a particular environment against particular component identities.

This distinction matters because the toolchain can remain conceptually stable while its installed versions, generated resources, host environment, or test results change.

The default page presents the selected Toolchain through its latest Evaluation. Historical evaluations remain stable and addressable.

## 2.2 Core concepts

### Toolchain

A declared composition of components and research-readiness requirements.

A toolchain defines what is required. It does not acquire readiness merely because its components have been named or installed.

### Component

An independently identifiable constituent of the toolchain.

The initial application distinguishes at least two component kinds:

- **Tool** — executable machinery that transforms, queries, validates, or transports artifacts.
- **Knowledge Resource** — versioned declarative data, schemas, models, rules, or vocabularies used by tools.

A distribution such as UCxn may expose several independently identified constituents—adapter, rules, corpus, or generated annotations—rather than being forced into one kind.

Every component identity should include the strongest practical identity available, such as package version, source revision, model name, database release, generated-bundle digest, or local artifact path.

### Service

A durable operational boundary that hosts one or more executable Components and exposes their Capabilities to another program.

A Service is not synonymous with a Component. One Python Service may host Stanza, the UCxn adapter, MoCCA, and FrameNet while those remain separately identified Components with separately verified Capabilities.

### Endpoint

A versioned callable operation through which a Service exposes a Capability.

An Endpoint defines an input contract, output contract, error vocabulary, timeout behavior, and identity. It does not expose arbitrary execution merely because its underlying runtime can execute arbitrary Python, Grew, or Prolog code.

### Service Instance

One running realization of a Service in an Environment.

Its process identity, start time, readiness, resource observations, and restart history are operational facts. Clients must not depend on its process ID or on ephemeral in-memory handles surviving a restart.

### Capability

A behavior that a component is required or expected to demonstrate.

Examples include:

```text
parse English text into valid CoNLL-U
mutate a dependency graph using a Grew rule
load and query a construction graph
index FrameNet frames and lexical units
execute a Prolog transport query over CoNLL-U
resolve RadLex concepts through the generated consumer bundle
```

A capability is a claim in the domain model. A version string, import statement, process exit code, or log line may support the claim but is not the claim itself.

### Artifact

A typed, inspectable object consumed, produced, or retained by a component.

Examples include text, a Stanza document, CoNLL-U, a Grew graph, construction annotations, FrameNet XML, a MoCCA graph, a RadLex bundle, a Prolog term, or a verification report.

An artifact may also serve as evidence, but the concepts are not identical:

- artifact describes the role of data in the toolchain;
- evidence describes the role of an observation in supporting a claim.

### Seam

A declared interoperability boundary through which one component's artifact becomes usable by another component.

A seam identifies:

- producing component;
- consuming component;
- transported artifact kind;
- representation or contract;
- any adapter or transformation;
- required invariants; and
- the verification that exercises the boundary.

A seam is not proven by the independent health of its endpoints. It must be exercised across the boundary.

### Environment

The execution context in which an evaluation is performed.

It records only facts material to interpreting or reproducing results: operating system and architecture, relevant runtimes, accelerator availability, selected environment or package roots, and other declared compatibility dimensions.

### Evaluation

One bounded assessment of one Toolchain under one Environment and one set of component identities.

An evaluation collects verifications and derives the readiness state. It records start and completion times, but chronological ordering does not define conceptual structure.

### Verification

One execution of a prescribed check against a Capability or Seam.

A verification records:

```text
subject
requirement checked
command or procedure
inputs
environment
component identities
outcome
measurements
evidence
diagnostics
time
```

### Evidence

An inspectable observation that supports or contradicts a verification claim.

Evidence includes structured assertions, counts, selected output, hashes, paths, generated artifacts, logs, and commands. Evidence must remain connected to the claim it supports.

### Diagnostic

A structured explanation of an incomplete, blocked, stale, or failed verification.

A diagnostic should identify the affected concept, failure phase, observed condition, available evidence, and likely reproduction step. A stack trace can be attached as evidence; it is not the complete diagnostic by itself.

## 2.3 Concept relations

```text
Toolchain contains Component
Toolchain requires Capability
Toolchain requires Seam

Component provides Capability
Component consumes Artifact
Component produces Artifact

Service hosts Component
Service exposes Endpoint
Endpoint makes-callable Capability
Service Instance realizes Service
Service Instance runs-in Environment

Seam connects Component to Component
Seam transports Artifact

Evaluation evaluates Toolchain
Evaluation occurs-in Environment
Evaluation identifies Component
Evaluation includes Verification

Verification checks Capability or Seam
Verification yields Evidence
Verification may-yield Diagnostic
```

The corresponding high-level technical structure is:

```text
                         ┌──────────────────────┐
                         │      TOOLCHAIN       │
                         │ requirements + parts │
                         └──────────┬───────────┘
                                    │ evaluated as
                                    ▼
                         ┌──────────────────────┐
                         │      EVALUATION      │
                         │ identities + env     │
                         └──────────┬───────────┘
                                    │ contains
              ┌─────────────────────┼─────────────────────┐
              ▼                     ▼                     ▼
      component verification   seam verification      diagnostic
              │                     │                     │
              └──────────────┬──────┴─────────────────────┘
                             ▼
                       evidence bundle
                 command · output · artifact · hash
```

## 2.4 Formal readiness model

Let:

```text
Req(T)       = required capabilities and seams of toolchain T
checks(v, r) = verification v checks requirement r
passed(v)    = v completed with the outcome passed
current(v,E) = v's component identities and relevant environment facts
               agree with evaluation E
```

A requirement is satisfied only by current passing evidence:

```text
satisfied(r, E)
    iff ∃ v ∈ verifications(E):
           checks(v, r) ∧ passed(v) ∧ current(v, E)
```

Toolchain readiness is derived:

```text
ready(T, E)
    iff completed(E)
    ∧ evaluation-of(E, T)
    ∧ ∀ r ∈ Req(T): satisfied(r, E)
```

Consequences:

- Installed does not imply passed.
- A passing component check does not imply a passing seam check.
- A historical pass does not imply a current pass after an identity changes.
- Optional or exploratory checks may inform the interface but do not block readiness.
- Overall readiness cannot contradict the underlying required verifications.

## 2.5 State vocabulary

State must preserve meaningful distinctions.

For a verification:

```text
not attempted
running
passed
failed
blocked
```

For previously obtained evidence:

```text
current
stale
```

For a component:

```text
unavailable
identified
installed
```

For a toolchain evaluation:

```text
not evaluated
evaluating
ready
not ready
incomplete
```

These vocabularies must not be collapsed into generic green, yellow, and red labels. Human-readable labels must remain present even when color is used redundantly.

The system must also preserve `unknown`, `not applicable`, and `not observed` where those are facts rather than errors.

## 2.6 Current empirical toolchain

The first Toolchain represented by the application is the `rad-nlp` research toolchain established by the setup plan.

Its current executable path is:

```text
source text
    │
    ▼
Stanza 1.14.0 / torch 2.14.0
    │  dependency parse
    ▼
CoNLL-U
    │
    ▼
official UCxn adapter + Grew 1.21.0
    │  construction matching and annotation
    ▼
annotated CoNLL-U
    │
    ▼
SWI-Prolog 9.2.9
       transport and existential query checks
```

The current knowledge-resource capabilities branch from that executable path rather than pretending to form one linear runtime pipeline:

```text
UCxn pinned source and official rules ──► construction rules and corpus adapter
MoCCA DB 1.0                    ────────► construction graph queries
FrameNet 1.7 XML               ────────► frames, FEs, LUs, and relations
RadLex generated bundle        ────────► ontology consumer queries
```

The initial evaluation is backed by ten setup obligations, S-01 through S-10. Existing evidence includes:

| Area | Demonstrated evidence |
|---|---|
| Stanza | 10 documents, 12 dependency trees, 125 tokens, valid CoNLL-U |
| Grew | graph mutation emitting `Smoke=grew-ok` |
| UCxn | official adapter over 500 EWT sentences and 7,275 tokens, producing 61 `Cxn` and 91 `CxnElt` rows |
| MoCCA | graph load and query over 1,278 nodes and 3,049 edges |
| FrameNet | 1,221 frames, 11,428 frame elements, 13,572 indexed lexical units, and relation indexes |
| SWI-Prolog | three passing `plunit` CoNLL-U transport tests |
| RadLex | six consumer tests against a generated bundle with recorded digest |
| Assembly seam | Text → Stanza → CoNLL-U → UCxn/Grew → SWI-Prolog with an exact existential anchor/pivot assertion |

These numbers are baseline evidence from the current setup, not constants in the design. The UI must read the current evaluation record and never hard-code them as permanent truths.

---

# 3. Survey of Design Decisions and Translation Rules

## 3.1 Primary narrative

The default Toolchain page should read as a compact technical explanation, in this order:

1. **Identity and boundary** — which declared toolchain and environment are being inspected.
2. **Readiness statement** — whether it is ready, why, when evaluated, and what the statement excludes.
3. **Executable transport path** — the main artifacts and seams exercised end to end.
4. **Knowledge-resource capabilities** — independently queryable resources and demonstrated operations.
5. **Verification ledger** — every required and optional check with exact state.
6. **Diagnostics and drift** — failures, blocked work, stale results, or changed identities.
7. **Reproduction** — commands and retained evidence sufficient to inspect or rerun the evaluation.

This order presents the conclusion first, then its structured proof.

## 3.2 Page geometry

The default desktop layout uses one dominant narrative column and one narrower evidence margin.

```text
┌────────────────────────────────────────────────────────────────────────────┐
│ Toolchain: rad-nlp research                                 READY          │
│ Evaluation identity · environment · completed time · scope boundary       │
├───────────────────────────────────────────────────┬────────────────────────┤
│                                                   │                        │
│ READINESS EXPLANATION                             │ EVIDENCE MARGIN        │
│                                                   │                        │
│ EXECUTABLE TRANSPORT PATH                         │ selected claim         │
│ text → Stanza → CoNLL-U → UCxn/Grew → Prolog     │ versions               │
│                                                   │ source revisions       │
│ KNOWLEDGE-RESOURCE CAPABILITIES                   │ command                │
│ MoCCA · FrameNet · RadLex                         │ measurements           │
│                                                   │ artifact links         │
│ VERIFICATION LEDGER                               │ raw output             │
│ S-01 … S-10                                       │ reproduction           │
│                                                   │                        │
│ DIAGNOSTICS AND DRIFT                             │                        │
│                                                   │                        │
└───────────────────────────────────────────────────┴────────────────────────┘
```

On narrow screens, the evidence margin follows the selected claim in document order. The conceptual hierarchy must survive without CSS or JavaScript.

The initial interface should not introduce a dashboard of equal-weight cards, tabbed subsystems, a permanent icon sidebar, or a node-link graph as the only account of the pipeline.

## 3.3 Readiness explanation

The readiness statement must be a sentence with inspectable support, not merely a badge.

Example:

> Ready for research experiments: all 10 required component and seam verifications passed for the identified local versions in this CPU environment. This does not establish radiology interpretation correctness or clinical validity.

If the toolchain is not ready, the statement should name the minimal blocking set:

> Not ready: 8 of 10 requirements pass; the UCxn-to-Prolog seam failed and the RadLex consumer verification has not been attempted for the current bundle digest.

Every clause links to the verification or identity that justifies it.

## 3.4 Pipeline representation

The transport path is an ordered relation among components, seams, and artifacts. It must not be rendered as decorative boxes detached from evidence.

Each step exposes:

```text
component identity
capability exercised
input artifact
output artifact
outcome
verification link
```

Each connector exposes:

```text
seam identity
artifact contract
adapter, if any
invariants checked
verification link
```

The visual path is a summary of those semantic relations. A text or table representation must remain available in the DOM.

## 3.5 Verification ledger

The ledger is the complete accounting surface for readiness.

Each row presents:

| Field | Meaning |
|---|---|
| Requirement | Stable capability or seam identifier and name |
| Kind | Component capability or interoperability seam |
| Required | Whether failure blocks readiness |
| Subject | Component or seam checked |
| Outcome | Exact verification state |
| Currentness | Whether evidence matches selected identities and environment |
| Measurement | Compact result that demonstrates useful work |
| Evidence | Stable link to the verification explanation and raw artifacts |

Filtering may reduce what is visible, but the document must state that a filter is active and preserve the complete evaluation count.

## 3.6 Evidence presentation

Evidence should be progressively disclosed in three layers:

1. **Claim** — the capability or seam result in domain language.
2. **Structured evidence** — identities, command, assertions, measurements, and artifact references.
3. **Raw evidence** — complete output, log, serialized artifact, or retained report.

The interface must not require a user to search an undifferentiated log for the fact that supports a passing claim.

Raw outputs should use native `<details>` disclosure where practical. Commands and short artifacts should be copyable as text. Large retained artifacts should be linked with type, size, digest, and availability state.

## 3.7 Provenance and freshness

Every verification carries provenance sufficient to answer:

```text
What ran?
Against which component identities?
In which environment?
Using which inputs?
At what time?
What exact observations determined the outcome?
Where is the retained evidence?
```

A change to a relevant identity does not rewrite a historical evaluation. It causes prior evidence to be marked stale relative to a new evaluation.

Freshness must be semantic, not merely chronological. A result is stale because a declared dependency or compatibility dimension changed, not simply because an arbitrary number of days elapsed.

## 3.8 Diagnostics

Diagnostics are attached to the capability, seam, component, artifact, or verification they explain.

A diagnostic contains:

```text
stable identity
severity
affected concept
phase
summary
observed condition
expected condition
evidence references
reproduction command or procedure
```

The interface preserves the difference between:

- failed — the check ran and contradicted its acceptance condition;
- blocked — the check could not run because a prerequisite was absent;
- not attempted — no check was run;
- stale — evidence exists but does not apply to the selected identities; and
- unavailable — a component or retained artifact cannot be reached.

## 3.9 Safe interaction model

The default application is observational.

Ordinary interactions include:

```text
inspect
follow
filter
compare
copy
download retained evidence
```

Rerunning verification changes machine state by starting processes and producing artifacts. It is therefore an explicit operation presented as a semantic form or button whose label states the action and scope, such as:

```text
Run verification S-08
Run failed required verifications
Start new full evaluation
```

Before submission, the interface shows the target toolchain, selected checks, environment, and command or procedure. The new run creates a new verification or evaluation record; it does not overwrite historical evidence.

## 3.10 Semantic DOM contract

The rendered document is a public inspection surface for humans, browser tools, tests, and local agents.

Core concepts require stable IDs and explicit semantic relationships. A representative structure is:

```html
<article id="toolchain-rad-nlp-research"
         data-concept="toolchain"
         data-toolchain-id="rad-nlp-research"
         data-readiness="ready">
  <header>
    <h1>rad-nlp research toolchain</h1>
    <p id="readiness-statement">…</p>
  </header>

  <section id="transport-path" aria-labelledby="transport-path-heading">
    <h2 id="transport-path-heading">Executable transport path</h2>
    <ol data-relation="artifact-transport">…</ol>
  </section>

  <section id="verification-ledger" aria-labelledby="verification-heading">
    <h2 id="verification-heading">Verification ledger</h2>
    <table>…</table>
  </section>
</article>
```

Concept instances should use a consistent vocabulary such as:

```text
data-concept="component"
data-component-kind="tool"
data-concept="capability"
data-concept="artifact"
data-concept="seam"
data-concept="evaluation"
data-concept="verification"
data-concept="evidence"
data-concept="diagnostic"
```

Relations should be discoverable through links, IDs, and attributes rather than inferred from visual proximity alone.

The essential page must remain readable and navigable with JavaScript disabled. Native HTML links, tables, forms, headings, lists, and disclosure controls are preferred.

## 3.11 Stable routes and identity

The application should provide meaningful, bookmarkable routes:

```text
/toolchains/{toolchain-id}
/toolchains/{toolchain-id}/evaluations/{evaluation-id}
/toolchains/{toolchain-id}/components/{component-id}
/toolchains/{toolchain-id}/capabilities/{capability-id}
/toolchains/{toolchain-id}/seams/{seam-id}
/toolchains/{toolchain-id}/verifications/{verification-id}
```

The first route resolves to the current selected evaluation while making that selection explicit. Historical evaluation URLs remain immutable.

Fragments should deep-link to specific evidence, diagnostics, artifacts, and verification rows.

## 3.12 Visual language

The visual implementation begins with Basic Web Theme and the conventions of the general debug-interface philosophy:

- native typography and controls;
- high information density without crowding;
- restrained borders and color;
- sentence-like status explanations;
- aligned measurements where comparison matters;
- no icon-only concepts;
- no animation required to understand state; and
- no decorative system diagram competing with the evidence.

Color may reinforce outcome, currentness, or severity. It may not carry those distinctions alone.

## 3.13 Candidate invariants

An implementation of this draft would preserve these invariants:

1. Every readiness-blocking requirement is represented by a stable Capability or Seam.
2. Every required Capability or Seam has a Verification in a completed Evaluation, or is explicitly shown as unsatisfied.
3. Every passing Verification exposes positive evidence beyond process exit status.
4. Every failed or blocked Verification exposes at least one Diagnostic.
5. Every Verification identifies its relevant components, inputs, environment, procedure, and time.
6. Every Seam names its producer, consumer, artifact contract, and exercising Verification.
7. Overall readiness is derived from required verification state and currentness.
8. Historical evaluations are not silently mutated when versions or environments change.
9. Missing, false, empty, unknown, unavailable, not attempted, not applicable, blocked, failed, and stale remain distinguishable.
10. Raw evidence is reachable from the claim it supports.
11. The default page states the boundary of the readiness claim.
12. No Toolchain state is presented as proof of radiology interpretation or clinical correctness.
13. The UI distinguishes a Component from the Service that hosts it.
14. Every callable Endpoint identifies the Capability it exposes and the Service that owns it.
15. No durable URL, evaluation record, or client contract depends on an ephemeral process ID or in-memory backend handle.

## 3.14 Initial implementation slice

The first useful UI need not be a general toolchain platform. It should render the current `rad-nlp` setup state faithfully.

The initial slice should support:

1. one declared toolchain, `rad-nlp-research`;
2. the current local environment and component identities;
3. all setup obligations S-01 through S-10;
4. the executable assembly seam and independent knowledge-resource checks;
5. structured summaries of the existing heavy smoke evidence;
6. stable links to commands, reports, logs, and retained artifacts;
7. exact readiness derivation;
8. diagnostics for absent or failed evidence; and
9. reproduction through the existing `make -C setup verify` entry point and narrower check commands.

Comparison across evaluations, remote execution, arbitrary toolchain editing, service restart controls, and generalized plugin discovery are later concerns. Live progress may be added as a small progressive enhancement for an explicitly started verification run.

## 3.15 Acceptance criteria

The initial interface is acceptable when an engineer can answer all of the following from the page and its directly linked evidence:

- What is the current toolchain identity?
- Which exact tool and resource versions are selected?
- Which capabilities are required for readiness?
- Which component produced and consumed each transported artifact?
- Which seams were exercised rather than merely configured?
- What useful work did each heavy smoke check perform?
- Which checks block readiness, and why?
- Is each result current for this environment and these identities?
- How was the overall readiness state derived?
- How can a particular check or the complete evaluation be reproduced?
- What is not established by this readiness result?

Machine-facing acceptance additionally requires:

- semantic headings and landmarks;
- stable concept IDs;
- explicit status text;
- discoverable concept relations;
- ordinary links for navigation;
- native controls for disclosure and operations; and
- a complete useful document without client-side JavaScript.

## 3.16 Open decisions

The following decisions remain provisional and should be resolved against the setup implementation rather than guessed in the UI:

1. **Evaluation record format** — whether setup emits one canonical JSON document, a directory of per-check records, or both.
2. **Compatibility dimensions** — which environment facts make evidence stale for each requirement.
3. **UCxn component boundaries** — whether distribution, adapter, rules, and corpus should appear as one compound component or several related components.
4. **Artifact retention** — which raw artifacts are retained permanently and which can be reproduced on demand.
5. **Execution boundary** — whether the initial UI may start checks directly or only present copyable commands.
6. **Evaluation comparison** — the smallest useful comparison between two version-bound evaluations.

These are implementation decisions within the Toolchain application. None changes the separation between Toolchain and Radiology Interpreter.

## 3.17 Infrastructure planning assumptions

The proposed Toolchain Service Infrastructure orchestration plan currently uses the following unapproved assumptions to make the UI work concrete:

1. A Go hub serves the Toolchain HTML, owns evaluation records, and invokes capability endpoints.
2. The first UI is server-rendered with Go templates, native HTML, and one small stylesheet rather than a separate single-page application.
3. A local Python Service hosts the Python-facing Components and owns the private `grewpy_backend` child process.
4. A local SWI-Prolog Service loads the generated RadLex bundle and exposes named ontology and transport operations.
5. Services expose versioned HTTP/JSON operations on loopback interfaces plus liveness, readiness, and identity documents.
6. A user-level process supervisor, provisionally systemd, owns service lifetimes; the Go hub reports availability but does not act as PID 1.
7. The UI begins read-only. A later ticket adds explicit forms to start named verification runs and optional server-sent progress events.
8. The browser never calls the bare services directly. It calls the Go hub, which preserves timeouts, evidence, artifact identity, and a single public contract.

These assumptions exist to support executable research. Evidence obtained during service experiments may refine or reject them through an explicit decision record.

---

# 4. Reference Appendices

## Appendix A. Initial component map

| Component | Kind | Identity basis | Principal demonstrated capability |
|---|---|---|---|
| Python | Tool/runtime | runtime version | execute Python verification programs |
| Stanza | Tool | package and model versions | produce dependency parses and valid CoNLL-U |
| PyTorch | Tool/runtime | package version and accelerator state | execute Stanza model inference |
| OCaml | Tool/runtime | compiler version | support Grew ecosystem runtime |
| opam | Tool/package manager | client and switch identity | resolve the OCaml tool environment |
| Grew | Tool | package version | load, query, and mutate dependency graphs |
| grewpy / backend | Tool/adapter | package versions | bridge Python checks to Grew |
| UCxn | Mixed distribution | pinned source revision and resource identities | adapt UD corpora and run official construction rules |
| MoCCA | Knowledge Resource | DB release and source revision | load and query a construction graph |
| FrameNet | Knowledge Resource | FrameNet release and local XML identity | query frames, FEs, lexical units, and relations |
| SWI-Prolog | Tool | runtime version | load transported facts and prove queries/tests |
| RadLex bundle | Knowledge Resource | source identity and generated-bundle digest | serve application-shaped ontology consumer queries |

This table is an initial decomposition, not a substitute for the version-bound identities in an Evaluation.

## Appendix B. Initial requirement families

The setup obligations can be presented under conceptual families while retaining their stable S-01 through S-10 identities:

```text
Environment identity
    runtimes and package roots are explicit

Component operation
    Stanza parses nontrivial input
    Grew mutates graphs
    MoCCA answers graph queries
    FrameNet loads and indexes its relations
    SWI-Prolog executes transport tests
    RadLex serves consumer-shaped queries

Official-resource fidelity
    UCxn official adapter and rules run against pinned upstream material

Interoperability
    serialized artifacts survive each declared seam
    assembled Text → Stanza → UCxn/Grew → Prolog path proves an exact assertion

Reproducibility
    verification succeeds from installed local artifacts through the declared setup entry point
```

The UI should not invent a different source of truth for these requirements. It should consume or faithfully translate the setup plan's declared acceptance model.

## Appendix C. Source documents

This specification is governed by:

- [Debug Interface Design Philosophy](<./Debug Interface Design Philosophy _ Draft Specification.md>)
- [`setup/PLAN.md`](../../setup/PLAN.md)
- [`setup/ACCEPTANCE-MATRIX.md`](../../setup/ACCEPTANCE-MATRIX.md)
- [`setup/STATE.md`](../../setup/STATE.md)

The [Radiology Transcript Interpreter Debug UI specification](<./Radiology Transcript Interpreter _ Debug UI Design Specification.md>) was consulted to establish and preserve the application boundary. It is not the domain model for this application.

## Appendix D. Design provenance

The separation of Toolchain from Radiology Interpreter is a human-led architectural decision established during design discussion. The Toolchain concept model and this UI specification translate that decision into an independent application boundary, readiness semantics, evidence model, DOM contract, and initial implementation slice.
