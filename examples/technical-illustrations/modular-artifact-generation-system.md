# Modular Artifact Generation System Technical Illustration

> **Provenance:** Originally written as `Technical Preview`. Principle Labs now
> uses **Technical Illustration** for this concrete but noncommittal artifact.

This document is a **preview**, not a committed design.

## Goal

Repackage the artifact-generation system as a single Go program with:
- one classic server-rendered HTML webpage for input and configuration
- modular artifact generators
- simple file outputs
- optional third-party API integrations

## Core idea

Instead of n8n workflows, the system would be a Go monolith with one module per artifact.

## Proposed structure

- `cmd/server` — main web server
- `internal/config` — API keys, defaults, paths
- `internal/artifacts/citationaudit`
- `internal/artifacts/napreport`
- `internal/artifacts/schema`
- `internal/artifacts/llmstxt`
- `internal/artifacts/agentmd`
- `internal/artifacts/gbpguide`
- `internal/integrations` — OpenAI, Anthropic, SerpAPI, Perplexity, Gemini
- `internal/render` — HTML templates
- `internal/storage` — write files and manage outputs

## Artifact interface

Each artifact module would expose the same basic shape:
- name
- required inputs
- validation
- generate
- outputs

That keeps the system uniform and easy to expand.

## Classic web UI

The interface would be a standard server-rendered HTML page:
- forms for business data
- fields for API keys or config overrides
- a generate button
- a results page with links to outputs

No SPA, no framework required.

## Artifact breakdown

### Citation audit
- **Inputs:** business name, specialty, market, contact name
- **Method:** query AI services, score citations, extract competitors
- **Outputs:** DOCX report and JSON summary
- **Third parties:** OpenAI, Perplexity, Gemini

### NAP report
- **Inputs:** business identity + contact data
- **Method:** compare reference NAP against directory/search results
- **Outputs:** HTML report and JSON summary
- **Third parties:** SerpAPI

### Schema guide
- **Inputs:** business identity, website, CMS, enrichment notes
- **Method:** build schema.org output and implementation guide
- **Outputs:** HTML + JSON
- **Third parties:** Anthropic Claude for optional draft copy

### `llms.txt`
- **Inputs:** business identity, website, enrichment notes
- **Method:** gather profile links, draft a concise AI-facing profile
- **Outputs:** `llms.txt`
- **Third parties:** SerpAPI, Anthropic Claude

### `agent.md`
- **Inputs:** business identity, owner name, enrichment notes
- **Method:** generate AI-agent instructions and recommendation context
- **Outputs:** `agent.md`
- **Third parties:** Anthropic Claude

### GBP guide
- **Inputs:** business identity, specialty, contact details
- **Method:** template-based guide with category mapping
- **Outputs:** HTML guide
- **Third parties:** none required

## Configuration

A basic configuration page would handle:
- API keys
- output directory
- business defaults
- optional enrichment notes

Simplest approach:
- environment variables for server config
- form inputs for per-run business data

## Why this is attractive

- fewer moving parts than workflow automation
- easier to test and version
- easier to run locally or on a server
- clearer artifact boundaries
- easier to add new artifact modules later

## Important note

This is a technical preview only. It is meant to show what a clean Go-based version could look like, not to commit the project to that direction.
