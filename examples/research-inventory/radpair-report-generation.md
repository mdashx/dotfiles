# RADPAIR report-generation resource inventory

**Date:** 2026-09-07
**Status:** empirical inventory; architectural interpretation is provisional
**Scope:** RADPAIR backend, report-related seed data and migrations, the
`radpair_dev_backup.dump` database snapshot, and adjacent template-generation
repositories.

## Executive model

RADPAIR does not have one report-generation system. It has several overlapping
representations of report behavior:

```text
study / subspecialty / scope
        |
        +--> report templates and template overrides
        +--> report rules, levels, directives, and keyword groups
        +--> impression preferences and system settings
        +--> user/org instructions
        +--> LLM prompt builders and model-routing policy
        |
        v
  selected rules + assembled prompts + generated report text
```

The important architectural fact is that the database rows, prompts, and
templates currently carry both *meaning* and *realization policy*. They are not
yet cleanly separated into a canonical report plan/AST and rendering steps.
That makes them valuable evidence for the report-generation domain, but unsafe
as the domain model by themselves.

## Inventory by responsibility

### 1. Backend domain and persistence model

The backend's primary report resources are:

| Resource | Location (relative to `backend/`) | Role |
| --- | --- | --- |
| Report template | `db/models/report_template.py` | Persistent study/org/user template; current schema has template data, field maps, custom instructions, generation mode, ownership/default scope, and study relationships. |
| Report rule | `db/models/report_rule.py` | Persistent rule fragment selected for a report; carries level, sequence, data, categories/variants, localized or structured data, scope, studies, directives, and keyword groups as the schema evolved. |
| Rule level | `db/models/report_rule_level.py` | Orders and names rule families/levels used by rule selection. |
| Report study | `db/models/report_study.py` | Associates report behavior with a study and user/org scope. |
| Template study/default/override | `db/models/report_template_study.py`, `db/models/org_template_default.py`, `db/models/template_scope_override.py` | Many-to-many study applicability, defaults, and scoped exceptions. |
| Report and report events | `db/models/report.py`, related report routes/services | Consumers of the selected template/rules and the generated report. |

The schema history is itself evidence of the evolving ontology. Relevant
migrations add JSON rule data, field maps, localized rule data, rule-study
many-to-many scope, template-study many-to-many scope, custom template
instructions, generation mode, keyword groups, scope columns, directives,
decimal rule sequencing, and template-scope overrides. The current migration
line therefore describes a transition from flat text fragments toward scoped,
structured, and policy-bearing resources.

### 2. Runtime selection, composition, and report processing

The principal backend behavior is distributed across:

- `app/services/rule_selection/engine.py`, `gates.py`, `conflicts.py`,
  `reduction.py`, `resolution.py`, `model_routing.py`, and `types.py`;
- `app/services/report_plan.py` and
  `app/services/reporting_service/service.py`;
- `app/services/combined_normal_generation.py`,
  `app/services/impression_compose_service.py`, and
  `app/services/override_rule_service.py`;
- `app/helpers/radpair_prompt_builder.py`,
  `app/helpers/json_mode_prompt_builder.py`,
  `app/helpers/subspecialty_impression_prompt_builder.py`,
  `app/helpers/intgt_reporting/normal_report_processor.py`, and
  `app/helpers/intgt_reporting/normal_report_prompt.py`;
- `app/helpers/template_helpers.py`, `template_instructions.py`,
  `template_macros_manager.py`, and `study_template_finder.py`;
- template/rule administration and preview routes under
  `app/routes/v2/`, `app/routes/admin/`, `app/routes/template_overrides.py`,
  and `app/services/prompt_preview.py`.

Conceptually, these modules implement a pipeline of study lookup, scope and
ownership resolution, rule selection, prompt assembly, model routing, LLM
generation, and report/impression composition. The code does not expose one
small interface for this pipeline; policy is spread between selectors,
helpers, services, database fields, and prompt text.

### 3. Committed seed data and configuration

The current backend's committed report-generation inputs include:

- `db/alembic/seed_data/subspecialty_impression/rules.json`: eleven
  subspecialty/impression rule families containing report guidance fragments;
- `db/alembic/seed_data/subspecialty_impression/study_family_map.json`: maps
  studies into those families;
- `db/alembic/versions/2026_07_18_2100-c4f8a21d9e6b_seed_subspecialty_impression_rules.py`:
  installs those rules;
- `app/config/subspecialty_impression/system_prompt.txt`: the associated
  system-level instruction text;
- `app/config/settings_definitions.json`: startup/system-setting definitions,
  including embedded model and report-processing messages;
- `app/config/settings_definitions_schemas/`: schemas constraining setting
  values by type.

These are deployment-time defaults, not merely test fixtures. A change here
can alter the prompts or report behavior of a newly initialized environment.

### 4. Historical database snapshot and extracted evidence

The Drive file is `radpair_dev_backup.dump`. It is available through the
machine's configured `gdrive:` remote. A derived, readable extraction is
already present at:

`/home/raddev/getting-started/RADPAIR/backend/research/db-text-export/`

The extraction README records the source as a PostgreSQL 17.5 custom archive,
created 2025-08-02, and notes that its schema predates current HEAD. Relevant
row counts are:

| Table | Rows | Report-generation significance |
| --- | ---: | --- |
| `report_templates` | 483 | Older persistent report-template records. |
| `report_rules` | 66 | Rule fragments across 20 rule levels. |
| `report_rule_levels` | 20 | Historical rule hierarchy. |
| `enhanced_report_rules` | 66 | Older enhanced-rule representation. |
| `templates` | 196 | Legacy templates with `prompt`, `succinct`, `detailed`, and `pair` fields. |
| `system_settings` | 37 | Historical model, prompt, and report-processing settings. |
| `templates_v2` | 0 | Newer table existed in the dump schema but was unused in this snapshot. |

The extraction is organized into `report-templates.md`, `report-rules.md`,
`enhanced-report-rules.md`, `legacy-templates-prompts.md`,
`llm-system-settings.md`, `oncology-report-structure-and-prompts.md`, and
`sample-report-llm-io.md`. These are the best local evidence for how the
production-ish data actually combined templates, rules, prompts, and generated
reports at that point in time.

### 5. Template conversion and adjacent realization systems

The adjacent `TemplateConverter` repository is a separate realization path:

- `conversion_instructions_backup.txt`,
  `reference/webapp/conversion_instructions.txt`, and
  `webapp/conversion_instructions.txt` contain substantial LLM instructions
  for converting imported XML/DOCX/AutoText templates into a structured form;
- `styleguide.md` is primarily a visual/CSS and presentation guide, not a
  clinical reporting style guide;
- `sample/` contains imported template artifacts and conversion examples.

The older `template-engine` repository contains a separate template-processing
service with `report_template.py`, `template_v2.py`, input parsing,
formatting, mapping, and a template-processing workflow. It should be treated
as historical/adjacent architecture until its relationship to current backend
generation is established.

## Study lookup: not RadLex matching

The current study lookup path is catalog/name based, not ontology based:

1. If an inbound report already carries a `study_id`, the backend follows the
   `reports.study_id -> report_studies.id` relation directly.
2. Otherwise `StudyExtractor` first tries an organization-specific
   `study_mappings` entry. The source value is selected by an organization
   setting, looked up by normalized source study description in Redis/Postgres,
   and resolved to an exact allowed catalog study name.
3. If there is no custom mapping, metadata is normalized into a study string
   from `study_name`/`studyDescription`, modality, and body-part fields.
4. `ReportStudyPredictor` builds the allowed study catalog, optionally filters
   it by modality/prefix, and asks an LLM to choose one exact name from that
   finite list. It then resolves that returned name to a `ReportStudy` row.
5. A small hard-coded alias map handles known naming variants, and Redis caches
   transcript-to-study-name predictions for seven days.

The modality normalization is small and explicit (`RG`, `DX`, and `CR` become
`XR`; `XA` and `RF` become `IR`). It is not RadLex concept normalization.
Administrative study-mapping tools also offer fuzzy suggestions, but runtime
resolution still requires an exact catalog target after mapping.

RadLex appears in a different responsibility: `RadlexLoader`, the
hallucination fixer, keyword analyzer, and report validator use a normalized
RadLex term list to check transcript/report vocabulary and possible dropped or
unsupported findings. That is a report-fidelity/verification function, not
study identification. The subspecialty impression family bindings likewise
use `study_id` and study name, not RadLex identifiers.

The resulting conceptual distinction is:

```text
external study description
  -> source mapping or LLM choice from the allowed ReportStudy catalog
  -> ReportStudy.id

report text / findings
  -> RadLex term checks for verification and fidelity
```

### Transcript-specific selection

For the `/predict/study` endpoint, the request supplies either a transcript or
a report ID whose transcript is loaded. `ReportStudyPredictor.predict_study`
then uses the transcript as the LLM user message. The system message says to
select the appropriate study from a supplied list; tool-based model
configurations additionally receive a function whose `study` argument is an
enum containing the exact allowed catalog names.

Before the model call, the predictor builds the usable study catalog according
to user/org permissions and collapses duplicate names by priority (user,
cascaded organization, system). It narrows that catalog by an explicit
modality when one is available; otherwise it inspects the first word of the
transcript for prefixes such as `CT`, `MR`, `CTA`, `XR`, `US`, or `NM`. If no
modality can be inferred, it sends the full catalog.

The returned text is lowercased and must equal a catalog name. A small fixed
alias map is checked only if the model's text is not an exact catalog key. An
unmapped answer is rejected and the configured predictor models are tried in
fallback order. When modality was not explicitly supplied, failure with the
prefix-filtered catalog causes a second attempt using the full catalog. A
successful transcript-to-study-name result is cached in Redis for seven days.

Thus the semantic step is an LLM classification constrained by a database
catalog, not a deterministic RadLex parser:

```text
transcript
  -> optional lexical modality narrowing
  -> LLM chooses one allowed ReportStudy.name
  -> exact name/alias resolution
  -> ReportStudy.id
```

## Analysis: what the inventory says

### Report meaning is currently distributed

The same report behavior may be represented in a template's text/data, a rule's
data or directive, an impression preference, a system setting, a user/org
instruction, or an LLM prompt. Therefore a search for “the style guide” or
“the report template” will produce a family of partial authorities rather than
one canonical artifact.

### Scope and precedence are first-class semantics

Study, subspecialty family, user, organization, system/default, and override
scope all participate in selection. The rule-selection services and the
successive migrations adding scope, study links, defaults, and overrides imply
an unresolved precedence relation:

```text
candidate resources × scope × applicability × sequence
        -> selected obligations and realization instructions
```

That relation should eventually be made explicit and testable. It should not be
left implicit in database query order or prompt concatenation.

### Rules are closer to report obligations than templates are

Rules contain ordering, categories, variants, gates, conflicts, directives, and
keyword groups. They therefore look like a constrained report-planning layer.
Templates are more directly concerned with surface organization and reusable
language. The current implementation mixes these layers, but future modeling
should distinguish:

1. source-grounded findings and clinical semantics;
2. report obligations and selection constraints;
3. document structure and rhetorical ordering;
4. surface realization instructions;
5. generated language and validation evidence.

### Prompts are executable policy, not canonical meaning

Prompt builders encode formatting, omission, uncertainty, model mode, and
sometimes clinical/reporting behavior. They are important runtime resources,
but prompt text should compile from a report plan and validated semantic input;
it should not be the only place where an obligation exists.

### The database snapshot is historically valuable but not schema-authoritative

The dump confirms real data patterns and legacy coexistence, especially the
parallel `report_templates`, `report_rules`, `enhanced_report_rules`, and
`templates` representations. Its schema lacks several fields now present in
current HEAD, so it cannot be used as the current persistence contract without
cross-checking migrations and models.

## Initial ontology / vocabulary

The following distinctions appear necessary for later report-generation work:

- **Finding/evidence:** source-grounded semantic content available to the
  generator;
- **Report obligation:** a required, optional, or forbidden communicative act;
- **Rule:** a scoped condition or policy that derives/selects obligations;
- **Template:** reusable structural or linguistic realization material;
- **Directive:** an explicit instruction controlling selection or realization;
- **Style guide:** conventions governing terminology, structure, tone, and
  formatting; currently distributed across several resource types;
- **Prompt:** an executable instruction envelope for a model call;
- **Report plan/AST:** the missing canonical intermediate representation
  between selected meaning and rendered language;
- **Validation evidence:** checks showing fidelity, completeness, contradiction
  avoidance, uncertainty preservation, and absence of unsupported assertions.

## Provisional fieldstones

### Fieldstone 1

**Status:** settled empirical fact
**Contribution:** assistant-led
**Summary:** RADPAIR has multiple overlapping report-resource systems rather
than one template/prompt authority.
**Why it matters:** inventory and future design must preserve provenance and
precedence instead of flattening all text into a single style guide.

### Fieldstone 2

**Status:** provisional
**Contribution:** assistant-led
**Summary:** report rules are the strongest existing candidate for a report
obligation/selection layer; templates and prompts are realization layers.
**Why it matters:** this separation offers a path from current code to a
canonical report plan without discarding existing data.

### Fieldstone 3

**Status:** open
**Contribution:** assistant-led
**Summary:** the exact precedence relation among system, subspecialty, study,
organization, user, template, rule, and override resources is not yet stated
as a single invariant.
**Why it matters:** generation can be nondeterministic or difficult to explain
until selection and conflict resolution are explicit.

### Fieldstone 4

**Status:** settled empirical fact
**Contribution:** assistant-led
**Summary:** study identification is catalog/name prediction with optional
organization mappings; RadLex is used for downstream report verification, not
for selecting the `ReportStudy`.
**Why it matters:** a future ontology-backed study resolver would be a new
capability, not a description of the current implementation.

### Fieldstone 5

**Status:** settled empirical fact
**Contribution:** assistant-led
**Summary:** transcript study selection is a permission-scoped, modality-
filtered LLM choice over `ReportStudy.name` values, with exact post-resolution
and fallback models.
**Why it matters:** the catalog is the output vocabulary and primary guardrail;
the LLM supplies classification, but does not create a new study concept.

### Fieldstone 6

**Status:** provisional, human-led hypothesis
**Contribution:** human-led
**Summary:** the RAD-NLP pipeline may be able to identify a study more
reliably than the current unconstrained semantic work is delegated to an LLM,
provided it can canonicalize modality, anatomy, procedure/protocol, contrast,
and other study-defining evidence against the allowed catalog.
**Why it matters:** study identification could become an evidence-producing
NLP/ontology resolution stage, with the LLM retained for ambiguity or fallback
rather than serving as the primary resolver.

## Candidate replacement architecture for study resolution

The likely improvement is not “replace the LLM with string matching.” It is to
make the resolver evidence-producing and explicit:

```text
transcript
  -> linguistic/semantic extraction
  -> normalized study features and evidence spans
  -> ontology/catalog candidate generation
  -> deterministic compatibility scoring and constraints
  -> unique ReportStudy.id, or an ambiguity set
  -> LLM clarification/reranking only when unresolved
```

Useful evidence dimensions include modality, anatomy/body region, procedure or
protocol, contrast, laterality where relevant, and institution-specific aliases.
The resolver should retain the evidence and score for the selected candidate,
not only emit a name. If two catalog entries remain compatible, the correct
result is an explicit ambiguity or review state—not an invented study choice.

The current LLM predictor remains useful as a baseline and fallback because it
handles free-form descriptions and local naming variation. Its weakness is
that it returns a catalog string without a structured account of why that study
was selected, making errors difficult to detect or explain.

## Next research passes

1. Trace one concrete study end-to-end from study lookup through rule
   selection, prompt assembly, model call, and final report validation.
2. Build a resource/provenance matrix for every prompt and style-bearing field.
3. Extract representative rules/templates from the dump and classify their
   contents as obligation, structure, language, or formatting.
4. State the selection/precedence relation and identify tests that currently
   enforce it implicitly.
5. Propose a minimal report-plan/AST vocabulary and map each existing resource
   into it without treating any prompt as canonical meaning.
