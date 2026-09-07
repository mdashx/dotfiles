# Modular Artifact Generation System Implementation Plan

## Intent

This implementation plan turns the current research into a buildable plan for a standalone Go-based artifact system. The design keeps the current artifact families, adds a template layer, and uses a classic server-rendered HTML interface for configuration and execution.

The goal here is technical completeness without code-line detail. The next ticket can handle specific file-by-file and function-by-function work.

---

## 1. Runtime boundary and product shape

### Prose Spec

The runtime boundary is a single Go server that owns the web UI, input collection, module orchestration, template rendering, file output, and third-party API calls.

The server is the control plane. The browser only submits forms and displays results. The model is never the source of truth for workflow state.

This is a monolith in the operational sense, but internally it is modular: each artifact is a separate generator package with its own inputs, outputs, and rendering rules.

### Z Spec

```text
RuntimeBoundary
  server: seq CHAR
  ui: seq CHAR
  hub: seq CHAR
  modules: seq CHAR
  templates: seq CHAR
  outputs: seq CHAR
where
  server ≠ ⟨⟩
  ui ≠ ⟨⟩
  hub ≠ ⟨⟩
  modules ≠ ⟨⟩
  templates ≠ ⟨⟩
  outputs ≠ ⟨⟩
```

### Data examples

```json
{
  "server": "Go HTTP server",
  "ui": "classic server-rendered HTML pages",
  "hub": "shared resolved input object",
  "modules": ["citation-audit", "nap-report", "schema", "llms-txt", "agent-md", "gbp-guide"],
  "templates": [".j2 files per artifact"],
  "outputs": ["DOCX", "HTML", "JSON", "MD", "TXT"]
}
```

### Implementation suggestions / specifics

- Keep the whole system in one deployable binary.
- Keep the UI server-rendered, not SPA-based.
- Make the server own validation, execution, and output publication.
- Keep module code isolated from request handling.

---

## 2. Shared input hub and resolved configuration

### Prose Spec

The shared input hub is the one source of truth for business data, config, and enrichment notes. It combines the manual form inputs with environment defaults and any per-run overrides.

This is the key system boundary: every artifact reads from the same resolved object, so the pipeline does not have to re-parse or re-guess inputs.

### Z Spec

```text
InputHub
  businessData: seq CHAR
  configData: seq CHAR
  enrichmentData: seq CHAR
  resolved: seq CHAR
where
  businessData ≠ ⟨⟩
  resolved ≠ ⟨⟩
```

### Data examples

```json
{
  "businessData": {
    "practiceName": "Acme Dental",
    "specialty": "General Dentistry",
    "city": "Austin",
    "state": "TX"
  },
  "configData": {
    "ANTHROPIC_API_KEY": "env value",
    "SERPAPI_KEY": "env value"
  },
  "enrichmentData": {
    "openingHours": "Mo-Fr 09:00-17:00",
    "logo": "https://acmedental.example/logo.png"
  }
}
```

### Implementation suggestions / specifics

- Separate raw form data from resolved runtime config.
- Validate the hub before any artifact starts.
- Preserve the current enrichment-note semantics.
- Keep config defaults outside the prompt path and outside templates.
- Make the resolved hub the thing every module receives.

---

## 3. Artifact catalog and module registry

### Prose Spec

Each artifact is a registered module with a stable identity, required inputs, and declared outputs. The registry is what lets the server know which artifacts exist and in what contexts they can run.

The current artifact set is already clear from the research: citation audit, NAP report, schema guide, `llms.txt`, `agent.md`, and GBP guide.

### Z Spec

```text
ArtifactModule
  name: seq CHAR
  requiredInputs: seq CHAR
  outputContracts: seq CHAR
  dependencies: seq CHAR
where
  name ≠ ⟨⟩
  requiredInputs ≠ ⟨⟩
  outputContracts ≠ ⟨⟩
```

### Data examples

```json
[
  {
    "name": "citation-audit",
    "requiredInputs": ["businessName", "specialty", "market", "contactName"],
    "outputContracts": ["citation-audit.docx", "citation-audit.json"]
  },
  {
    "name": "llms-txt",
    "requiredInputs": ["practiceName", "specialty", "city", "state", "website"],
    "outputContracts": ["llms.txt"]
  }
]
```

### Implementation suggestions / specifics

- Put one generator package behind one module boundary.
- Make required inputs explicit and check them before execution.
- Keep the output filenames stable.
- Allow the registry to drive both the UI and the pipeline.

---

## 4. Template layer and render map

### Prose Spec

The template layer is the render map from resolved data to final artifact shape. The current research already shows this clearly: we have template files and preview files, and those should become the contract between data and output.

This is where the output structure becomes stable. The module computes data; the template decides how that data is presented.

### Z Spec

```text
TemplateSpec
  artifact: seq CHAR
  templatePath: seq CHAR
  previewPath: seq CHAR
  outputPaths: seq CHAR
  requiredData: seq CHAR
where
  artifact ≠ ⟨⟩
  templatePath ≠ ⟨⟩
  outputPaths ≠ ⟨⟩
```

### Data examples

```json
{
  "artifact": "agent-md",
  "templatePath": "research/templates/agent.md.j2",
  "previewPath": "research/templates/PREVIEWS.md",
  "outputPaths": ["agent.md"],
  "requiredData": ["practiceName", "specialty", "city", "state", "phone", "website", "expertName", "recommendationContext"]
}
```

### Implementation suggestions / specifics

- Keep one template per output family.
- Keep a manifest that maps templates to artifacts.
- Generate previews from the same sample data set used for review.
- Prefer deterministic renders over ad hoc string concatenation.
- Keep the template layer separate from third-party API calls.

---

## 5. Third-party integration boundary

### Prose Spec

Third-party services supply discovery, search, or draft text, but they do not own the final artifacts. The Go system should wrap these services behind a small integration layer so the artifact modules can request the data they need without knowing transport details.

The main integrations reflected in the current research are OpenAI, Anthropic Claude, Perplexity, Gemini, and SerpAPI.

### Z Spec

```text
IntegrationBoundary
  provider: seq CHAR
  purpose: seq CHAR
  successShape: seq CHAR
  failureShape: seq CHAR
where
  provider ≠ ⟨⟩
  purpose ≠ ⟨⟩
```

### Data examples

```json
[
  {"provider": "Anthropic Claude", "purpose": "draft text", "successShape": "JSON or markdown content"},
  {"provider": "SerpAPI", "purpose": "search discovery", "successShape": "search result objects"},
  {"provider": "OpenAI", "purpose": "citation audit queries", "successShape": "assistant responses"}
]
```

### Implementation suggestions / specifics

- Keep each provider behind a small adapter.
- Normalize all provider outputs before module use.
- Use fallback templates when providers fail.
- Keep API keys in config, not in templates or outputs.
- Do not make the artifact format depend on provider quirks.

---

## 6. Output publication and file layout

### Prose Spec

Outputs should be written to a predictable per-run directory and returned to the UI as links or paths. The current research already implies a folder-based publication model with HTML, JSON, DOCX, MD, and TXT artifacts.

This layer is about where files go and how they are surfaced after generation.

### Z Spec

```text
OutputPublication
  runId: seq CHAR
  outputDir: seq CHAR
  files: seq CHAR
  published: seq CHAR
where
  runId ≠ ⟨⟩
  outputDir ≠ ⟨⟩
  files ≠ ⟨⟩
```

### Data examples

```json
{
  "runId": "2026-06-08T12:00:00Z_a1b2",
  "outputDir": "/opt/ovation/output/acme-dental_2026-06-08",
  "files": [
    "citation-audit.docx",
    "citation-audit.json",
    "nap-report.html",
    "nap-report.json",
    "schema.html",
    "schema.json",
    "llms.txt",
    "agent.md",
    "gbp-guide.html"
  ]
}
```

### Implementation suggestions / specifics

- Use a single run directory per generation.
- Keep JSON sidecars next to their primary artifacts.
- Return output links in the final HTML result page.
- Keep path layout stable so downstream automation can rely on it.

---

## 7. Execution order and configurable pipelines

### Prose Spec

Pipelines define which modules run and in what order. Some modules are independent, but others benefit from a deliberate sequence, especially when a shared input set or template output is reused.

This is where the current research’s “one source of inputs flowing through a hub into modular things” becomes an actual runtime plan.

### Z Spec

```text
Pipeline
  name: seq CHAR
  steps: seq CHAR
where
  name ≠ ⟨⟩
  steps ≠ ⟨⟩
```

### Data examples

```json
{
  "name": "entry-offer-deliverables",
  "steps": [
    "citation-audit",
    "nap-report",
    "schema",
    "gbp-guide",
    "llms-txt",
    "agent-md"
  ]
}
```

### Implementation suggestions / specifics

- Keep pipeline ordering explicit and user-configurable.
- Use a default pipeline for the common case.
- Allow special-purpose pipelines later.
- Treat module dependencies as hard validation rules.

---

## 8. Classic server-rendered HTML interface

### Prose Spec

The user interface should be a standard server-rendered HTML form with no SPA complexity. It should collect the business inputs, optional enrichment notes, config values, and a generation choice, then render the outputs page.

The page should feel like a simple old-school application: submit a form, wait for processing, get a results page.

### Z Spec

```text
HTMLInterface
  formAction: seq CHAR
  formMethod: seq CHAR
  fields: seq CHAR
  resultsPage: seq CHAR
where
  formAction ≠ ⟨⟩
  formMethod = ⟨"POST"⟩
```

### Data examples

```json
{
  "formAction": "/generate",
  "formMethod": "POST",
  "fields": ["businessName", "specialty", "city", "state", "website", "ANTHROPIC_API_KEY", "SERPAPI_KEY"],
  "resultsPage": "/runs/{runId}"
}
```

### Implementation suggestions / specifics

- Use `net/http` and templates.
- Keep the form readable and minimal.
- Return validation errors inline.
- Keep results pages stable and shareable.

---

## 9. Prior work and references

### Prose Spec

This plan is grounded in the research already produced for this repository. The template layer, preview files, and earlier implementation sketches are all part of the same story and should be treated as precursor material.

### Z Spec

```text
ReferenceSet
  refs: seq CHAR
where
  refs ≠ ⟨⟩
```

### Data examples

```json
[
  "research/SPEC.md",
  "research/artifact-methodology.md",
  "research/technical-preview.md",
  "research/technical-preview-z-spec.md",
  "research/templates/README.md",
  "research/templates/artifact-outputs-map.md.j2",
  "research/templates/PREVIEWS.md",
  "build/TECH-TEAM-README.md",
  "ovation-build-instructions.md",
  "https://github.com/PrincipleLabs67/primary-resources/blob/main/spec-style-guide.md",
  "/home/easter/omicron/research/session-archive/SPEC.md",
  "/home/easter/omicron/research/discord-transport-layer/SPEC.md"
]
```

### Implementation suggestions / specifics

- Treat the research docs as the planning source.
- Treat the ticket as the code-specific execution source.
- Keep this document focused on architecture, modules, templates, and runtime shape.
- Save line-by-line implementation detail for the next ticket.

---

## Suggested first milestone

Build the shared input hub, module registry, and one template-backed artifact end-to-end. After that, add the remaining artifact modules one by one using the same data flow and output publication pattern.
