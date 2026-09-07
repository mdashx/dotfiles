# Modular Artifact Generation System Spec

## Intent

This system is a modular artifact generator built around one shared input hub, a registry of artifact modules, and configurable execution pipelines. Each artifact module is responsible for one output family such as the citation audit, NAP report, schema guide, `llms.txt`, `agent.md`, or GBP guide.

The behavior is enforced by runtime wiring, module validation, and pipeline configuration. It is not dependent on prompt memory or implicit model behavior.

---

## 1. Shared Input Hub

### Prose Spec

The shared input hub is the single source of truth for business data, optional enrichment notes, and run-level configuration. It exists so that each artifact module can read the same canonical inputs without duplicating parsing or validation logic.

The hub owns raw inputs and resolved values. It does not own artifact-specific business logic. Its job is to make sure the data needed by downstream modules exists, is normalized, and is available in a consistent shape.

### Z Spec

```z
[INPUT, VALUE]

InputHub
    inputs : INPUT \pfun VALUE
```

### Data examples

```json
{
  "practiceName": "Acme Dental",
  "specialty": "General Dentistry",
  "address": "123 Main St",
  "city": "Austin",
  "state": "TX",
  "zip": "78701",
  "phone": "(512) 555-0100",
  "website": "https://acmedental.example",
  "cms": "WordPress",
  "expertName": "Dr. Acme",
  "enrichmentNotes": "openingHours: Mo-Fr 09:00-17:00\nyelp: https://yelp.com/biz/acme-dental"
}
```

### Implementation suggestions / specifics

- Collect inputs once at the UI boundary.
- Validate required fields before any artifact runs.
- Normalize obvious variants such as trimmed strings, missing trailing slashes, and formatted phone numbers.
- Store config separately from business data, but resolve both into one runtime input set.

---

## 2. Artifact Modules

### Prose Spec

An artifact module is a plug-in generator for one artifact family. It declares what it needs, what it produces, and how it should behave when given valid inputs.

The module does not own the whole system. It only owns the logic for its artifact: generation, formatting, scoring, or guide assembly. Third-party services may be used inside a module, but the module still owns the final artifact shape and output rules.

### Z Spec

```z
[ARTIFACT, MODULE, KEY, OUTPUT]

ArtifactModule
    artifact : ARTIFACT
    requiredInputs : \power INPUT
    outputs : \power OUTPUT
    configKeys : \power KEY
```

### Data examples

```json
[
  {
    "artifact": "schema",
    "requiredInputs": ["practiceName", "specialty", "city", "state", "website"],
    "outputs": ["schema.html", "schema.json"],
    "configKeys": ["ANTHROPIC_API_KEY"]
  },
  {
    "artifact": "llms-txt",
    "requiredInputs": ["practiceName", "specialty", "city", "state", "website"],
    "outputs": ["llms.txt"],
    "configKeys": ["SERPAPI_KEY", "ANTHROPIC_API_KEY"]
  }
]
```

### Implementation suggestions / specifics

- Keep one Go package per artifact.
- Make required inputs explicit.
- Keep outputs deterministic when possible.
- Use third-party calls only where the artifact needs discovery or draft text.

---

## 3. Pipelines

### Prose Spec

A pipeline is an ordered configuration of modules. It exists for the cases where artifact generation should happen in a specific sequence, or where the output of one step informs the next.

The pipeline does not invent artifact behavior. It only defines execution order and composition. This lets the same artifact modules be run alone, in groups, or in a different order when business requirements change.

### Z Spec

```z
[PIPELINE]

System
    hub : InputHub
    modules : ARTIFACT \pfun MODULE
    pipelines : PIPELINE \pfun seq MODULE

SystemInvariant
    \forall p : PIPELINE | p \in \dom pipelines @
        \forall m : MODULE | m \in ran (pipelines(p)) @ m \in ran modules
```

### Data examples

```json
{
  "name": "entry-offer-deliverables",
  "steps": ["citation-audit", "nap-report", "schema", "gbp-guide", "llms-txt", "agent-md"]
}
```

### Implementation suggestions / specifics

- Allow pipelines to be configured without changing module code.
- Require every step to resolve to a registered module.
- Support a fixed default order and optional alternate orders.
- Keep pipeline configuration explicit so execution is predictable.

---

## 4. Output Artifacts

### Prose Spec

Outputs are the files or structured results produced by the modules. Each artifact has a stable output contract so downstream users and systems can rely on filenames, formats, and sidecar data.

This concept is important because the output file is often the real deliverable, while the generation process is just the machinery that creates it.

### Z Spec

```z
[OUTPUT]

OutputSet
    outputs : \power OUTPUT
```

### Data examples

```json
[
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
```

### Implementation suggestions / specifics

- Keep output names stable across runs.
- Prefer one primary file and one optional JSON sidecar where helpful.
- Write outputs into a predictable per-run directory.
- Return download links or file paths on the results page.

---

## 5. Classic Server-Rendered HTML Interface

### Prose Spec

The user interface is a classic server-rendered HTML webpage. Users fill out a standard form with business data, optional enrichment notes, and configuration values such as API keys or overrides. The server processes the submission and returns a rendered results page.

This boundary is important because it keeps the runtime simple and explicit. The browser submits a form; the server validates it; the server runs modules; the server renders the result.

### Z Spec

```z
[KEY, VALUE]

RuntimeConfig
    keys : KEY \pfun VALUE
```

### Data examples

```json
{
  "action": "/generate",
  "method": "POST",
  "fields": [
    "practiceName",
    "specialty",
    "city",
    "state",
    "website",
    "ANTHROPIC_API_KEY",
    "SERPAPI_KEY"
  ]
}
```

### Implementation suggestions / specifics

- Use `net/http` and `html/template`.
- Avoid SPA complexity.
- Keep config inputs clearly separated from business inputs in the form UI.
- Show validation errors before any generation begins.
- Render a final page with status, outputs, and download links.

---

## 6. Module-Specific Behavior

### Prose Spec

Each artifact module has its own local logic, but the overall pattern stays consistent:
- read from the shared input hub
- optionally call a third-party service
- generate the artifact
- write the artifact to disk
- return structured output metadata

### Z Spec

```z
GenerateArtifact
    \Delta System
    a? : ARTIFACT
    out! : OUTPUT
    ok! : \mathbb{B}

    a? \in \dom modules
    modules(a?).requiredInputs \subseteq \dom hub.inputs
    out! \in modules(a?).outputs
    ok! = true
```

### Data examples

```json
{
  "artifact": "agent-md",
  "inputsUsed": ["practiceName", "specialty", "city", "state", "phone", "website", "expertName"],
  "outputs": ["agent.md"]
}
```

### Implementation suggestions / specifics

- Keep module code isolated and testable.
- Let each module own its own prompt templates and formatting rules.
- Let the shared system own validation, orchestration, and file handling.
- If a third-party service fails, fall back to a deterministic template when possible.

---

## 7. Template Layer

### Prose Spec

The template layer is the rendering map between resolved inputs and final deliverables. Each artifact should have a template that describes the final shape of its output, even if the final renderer is not literally Jinja2 in the implementation.

This layer is useful because it separates content structure from execution logic. The module decides what data exists; the template decides how that data is displayed or serialized.

### Z Spec

```z
[TEMPLATE]

TemplateSpec
    artifact : ARTIFACT
    templatePath : seq CHAR
    outputPaths : \power OUTPUT
    requiredData : \power INPUT
```

### Data examples

```json
{
  "artifact": "llms-txt",
  "templatePath": "research/templates/llms.txt.j2",
  "outputPaths": ["llms.txt"],
  "requiredData": ["practiceName", "specialty", "city", "state", "website"]
}
```

### Implementation suggestions / specifics

- Keep one template per artifact output family.
- Keep a manifest that maps templates to concrete output paths.
- Use the same field names in the template as in the resolved input object.
- Prefer a deterministic template render over ad hoc string assembly when possible.

## Summary

The system is simple at the conceptual level:
1. one input hub
2. many artifact modules
3. configurable pipelines
4. stable outputs
5. a classic server-rendered HTML interface for configuration and execution
6. a template layer that maps resolved inputs into final deliverables

That structure should be enough to rebuild the current artifact flow in a cleaner standalone program if needed.

## Suggested first milestone

Implement one module end-to-end, then add the shared input hub, the server-rendered HTML form, and the template layer; then register the rest of the modules one by one.

## References

- `research/artifact-methodology.md`
- `research/technical-preview.md`
- `research/technical-preview-z-spec.md`
- `research/templates/artifact-outputs-map.md.j2`
- `research/templates/README.md`
- `../build/TECH-TEAM-README.md`
- `../ovation-build-instructions.md`
- `https://github.com/PrincipleLabs67/primary-resources/blob/main/spec-style-guide.md`
