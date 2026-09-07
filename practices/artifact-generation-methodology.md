# Artifact Generation Methodology

Source pattern: Principle Labs `research/artifact-methodology.md` files.

## Purpose

Describe a repeatable way to produce a family of deliverables from shared input
data, templates, and generation rules.

## Artifact Record

For each artifact, record:

- input data required;
- creation method;
- output format;
- third-party services or external dependencies;
- generation or validation command;
- review criteria;
- known limitations.

## Shared Map

Maintain an artifact-output map when several deliverables are produced from the
same source package.

The map should connect:

```text
artifact
  -> generator/template
  -> required data
  -> output path
  -> validation or review step
```

Use `templates/research/example-workbench.md` or a project-specific output map
when examples and expected outputs need to be inspected together.
