# Modular Artifact Generation System Discussion Report

## Creating a Go-Based Artifact Platform from the Current Research

This report synthesizes the discussion about reworking the current Ovation artifact workflow stack into a standalone Go service with a classic server-rendered HTML interface, modular artifact generators, and a template layer.

It is intended for internal alignment: to explain what we discussed, why the design takes shape the way it does, and how the current research files fit together as one coherent system.

---

## Table of Contents

1. [Opening Position: What We’re Building](#1-opening-position-what-were-building)
2. [The Current Research Stack](#2-the-current-research-stack)
3. [The Core Model We Identified](#3-the-core-model-we-identified)
4. [Artifact-by-Artifact Breakdown](#4-artifact-by-artifact-breakdown)
5. [Template Layer and Output Mapping](#5-template-layer-and-output-mapping)
6. [Implementation Direction and Technical Shape](#6-implementation-direction-and-technical-shape)
7. [What We Are Deliberately Not Doing Yet](#7-what-we-are-deliberately-not-doing-yet)
8. [Next Step: The Code Ticket](#8-next-step-the-code-ticket)
9. [Appendices](#9-appendices)

---

## 1. Opening Position: What We’re Building

The central insight from the discussion was that the current workflow-based system already contains a clear artifact model. Each deliverable has a stable input shape, a known output shape, and a predictable generation method. The n8n machinery is doing orchestration, but the artifact logic itself is already modular.

That led to a simple architectural conclusion: we can treat the system as a modular artifact platform rather than a collection of unrelated automation jobs.

> “We have a concept of each of these artifacts, each artifact that’s kind of like a type… and we have a concept of this kind of modular system… one source of inputs that can flow through into this hub out to all of these different modular things that are plugged in.”

That statement captures the core model well. The system is not just a bundle of scripts; it is a shared input hub feeding artifact modules, with explicit mapping from resolved inputs to outputs.

### Why this matters

If we preserve that model in a standalone Go program, we get:
- one runtime boundary
- one place for inputs and config
- one place for templates and output publication
- one module per artifact family
- a predictable path from input to final deliverable

---

## 2. The Current Research Stack

We now have a layered research stack that defines the architecture at multiple levels:

| Document | Role |
|---|---|
| `research/artifact-methodology.md` | Explains each artifact, how it is produced, and what third-party services are involved |
| `research/technical-preview.md` | High-level Go monolith preview using a classic server-rendered HTML webpage |
| `research/technical-preview-z-spec.md` | Z-style sketch of the modular artifact system |
| `research/SPEC.md` | Formal interleaved spec for the modular artifact generation system |
| `research/IMPLEMENTATION-PLAN.md` | Execution-oriented architecture plan |
| `research/templates/README.md` | Template inventory and purpose |
| `research/templates/artifact-outputs-map.md.j2` | Maps artifacts to outputs and required data |
| `research/templates/PREVIEWS.md` | Sample renders using fictional data |
| `research/TICKET.md` | Coding-agent prompt in Omicron-style format |
| `research/conversation-export.md` | Clean markdown export of the topic conversation |

This is important because the system is no longer an idea in isolation. We already have:
- conceptual framing
- formal model
- output mapping
- sample rendering
- ticketing language
- conversation history

That means the next implementation step can be highly focused.

---

## 3. The Core Model We Identified

The discussion converged on four core ideas:

### 3.1 One shared input hub

All artifact generators should read from one resolved input set. This avoids repeated parsing, repeated validation, and inconsistent behavior across outputs.

This was reflected in the spec and implementation plan as the **shared input hub**.

### 3.2 One module per artifact

Each deliverable should be a module with explicit required inputs and stable output contracts.

The artifact families are:
- citation audit
- NAP report
- schema guide
- `llms.txt`
- `agent.md`
- GBP guide

### 3.3 A template layer

We identified that the output shape should be separated from the generation logic. The templates are already visible in the research directory, and they provide the right place to stabilize the final deliverable format.

### 3.4 A classic server-rendered HTML interface

We intentionally settled on the phrase “classic server-rendered HTML webpage” instead of any newer frontend shorthand. That means:
- plain HTML forms
- POST back to the server
- results page after submission
- no SPA requirement

This keeps the first version simple and durable.

> “Let’s call it a classic server-rendered HTML webpage.”

That phrasing matters because it defines the implementation in plain terms.

### The discussion’s architecture in one sentence

One form collects data, one hub resolves it, one registry selects the artifact module, templates render the output, and the server publishes the files.

---

## 4. Artifact-by-Artifact Breakdown

This section summarizes the six deliverables in the way we discussed them, using the artifact methodology and the template map as the practical reference.

### 4.1 Citation Audit

The citation audit is the most model-dependent deliverable. It runs multiple search/query prompts, compares whether the target business is cited, and extracts competitor names from responses.

**Inputs**
- business name
- specialty
- market / city-state
- contact name
- enrichment notes, if available
- API keys for model providers

**Outputs**
- `citation-audit.docx`
- `citation-audit.json`

**Third-party services**
- OpenAI
- Perplexity
- Gemini

**What the system does**
Our code owns the query strategy, scoring logic, competitor extraction, and final document assembly. The providers only supply responses.

### 4.2 NAP Report

The NAP report evaluates Name, Address, and Phone consistency across search/directory-style results.

**Inputs**
- business name
- specialty
- address
- city/state/zip
- phone
- website

**Outputs**
- `nap-report.html`
- `nap-report.json`

**Third-party services**
- SerpAPI

**What the system does**
The local code compares results to the reference NAP, computes a score, and flags mismatches or not-found entries.

### 4.3 Schema Guide

The schema guide is a structured-data implementation guide and schema object generator.

**Inputs**
- business identity fields
- CMS
- expert name
- enrichment notes

**Outputs**
- `schema.html`
- `schema.json`

**Third-party services**
- Anthropic Claude (optional for draft copy)

**What the system does**
The schema structure is local and deterministic; the model is only used to help draft descriptive copy when enabled.

### 4.4 `llms.txt`

The `llms.txt` artifact is a concise machine-readable profile intended to make the business legible to AI assistants.

**Inputs**
- business identity fields
- website
- enrichment notes
- profile discovery data

**Output**
- `llms.txt`

**Third-party services**
- SerpAPI
- Anthropic Claude

**What the system does**
The local generator assembles a concise markdown profile, while optional services help with discovery and drafting.

### 4.5 `agent.md`

The `agent.md` artifact is the more detailed agent instruction file, designed to help AI systems understand how to represent and recommend the business.

**Inputs**
- business identity fields
- owner/expert name
- enrichment notes

**Output**
- `agent.md`

**Third-party services**
- Anthropic Claude

**What the system does**
The generator produces structured service descriptions, recommendation questions, trust signals, negative scope, and usage guidance.

### 4.6 GBP Guide

The GBP guide is the least model-dependent artifact and the most template-like.

**Inputs**
- business identity fields
- specialty
- contact details

**Output**
- `gbp-guide.html`

**Third-party services**
- none required for the core output

**What the system does**
It applies a specialty-to-category mapping and fills a guidance template for Google Business Profile optimization.

---

## 5. Template Layer and Output Mapping

The template work clarified something important: the system’s outputs are not just files, they are predictable render targets with known data requirements.

The template inventory now gives us a clean map:

| Template | Purpose |
|---|---|
| `citation-audit-report.md.j2` | Citation audit narrative output |
| `citation-audit.json.j2` | Citation audit summary output |
| `nap-report.html.j2` | NAP report HTML output |
| `nap-report.json.j2` | NAP report JSON output |
| `schema.html.j2` | Schema guide HTML output |
| `schema.json.j2` | Schema JSON output |
| `llms.txt.j2` | `llms.txt` output |
| `agent.md.j2` | Agent instruction output |
| `gbp-guide.html.j2` | GBP guide HTML output |

This is the point where the architecture becomes concrete:
- the module prepares the data
- the template renders the final artifact
- the publication layer writes the file to a predictable location

The preview file also gave us sample data, which is useful for implementation because it anchors the render layer in real examples rather than abstract shapes.

> The template layer is where output structure becomes stable.

That’s the right way to think about it. The generator may evolve, but the template contract is what makes the output durable.

---

## 6. Implementation Direction and Technical Shape

The implementation plan points to a straightforward Go monolith with internal modularity.

### The technical shape

- one Go binary
- one classic server-rendered HTML interface
- one input hub
- one module per artifact
- one template map
- one output publication path
- one integration boundary for external services

### Why Go still fits

Go fits because this is an operational service with:
- predictable file output
- straightforward HTTP form handling
- simple config resolution
- plugin-like package boundaries
- small dependency surface

### What the runtime boundary should own

The server should own:
- request validation
- config resolution
- module selection
- template rendering
- output writing
- results-page generation

The browser should only own:
- input collection
- submission
- display of results

### How the system should feel

The user experience should feel like a classic internal tool:
1. fill out a form
2. submit
3. wait for processing
4. open the results page
5. download the artifacts

That is consistent with the “old school webpage” framing we discussed.

---

## 7. What We Are Deliberately Not Doing Yet

A good discussion report should also make clear what is out of scope.

We are not trying to solve:
- workflow automation replacement in detail
- Discord bridge behavior
- PTY handling
- full plugin marketplace design
- frontend framework selection
- distributed job orchestration
- code-line level implementation here

Those belong in the ticket and in the implementation work.

This report is for architecture, alignment, and synthesis.

---

## 8. Next Step: The Code Ticket

The natural next step is the implementation ticket, which should carry the code-specific details and file-level tasks.

That ticket should not repeat the whole architecture. It should simply consume the decisions already made here and turn them into a build plan.

In other words:
- this report = the synthesized discussion
- the implementation plan = the architecture map
- the ticket = the work assignment
- the code = the execution

---

## 9. Appendices

### Appendix A — Research files incorporated into this report

- `research/SPEC.md`
- `research/IMPLEMENTATION-PLAN.md`
- `research/artifact-methodology.md`
- `research/technical-preview.md`
- `research/technical-preview-z-spec.md`
- `research/TICKET.md`
- `research/conversation-export.md`
- `research/templates/README.md`
- `research/templates/artifact-outputs-map.md.j2`
- `research/templates/PREVIEWS.md`
- `research/templates/citation-audit-report.md.j2`
- `research/templates/citation-audit.json.j2`
- `research/templates/nap-report.html.j2`
- `research/templates/nap-report.json.j2`
- `research/templates/schema.html.j2`
- `research/templates/schema.json.j2`
- `research/templates/llms.txt.j2`
- `research/templates/agent.md.j2`
- `research/templates/gbp-guide.html.j2`

### Appendix B — References to current work

- `build/TECH-TEAM-README.md`
- `ovation-build-instructions.md`
- `https://github.com/PrincipleLabs67/primary-resources/blob/main/spec-style-guide.md`
- `https://github.com/PrincipleLabs67/primary-resources/blob/main/discussion-report-style-guide.md`

### Appendix C — Conversation source summary

The discussion covered:
- locating the shared Ovation repository
- copying it into workbench
- analyzing the current build directory and artifact outputs
- documenting artifact methodology
- proposing a Go-based monolith with a classic HTML interface
- formalizing the system with a Z-style sketch
- writing a spec, implementation plan, template layer, previews, and ticket prompt

### Appendix D — Final architectural takeaway

The strongest conclusion from the discussion is that the system already behaves like a modular artifact platform. The current research is enough to support a clean standalone implementation with a shared input hub, discrete artifact modules, a template layer, and a simple server-rendered UI.

That means the architecture is no longer speculative. It is documented, mapped, and ready for the code ticket.
