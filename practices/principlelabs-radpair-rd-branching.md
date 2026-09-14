# PrincipleLabs RADPAIR R&D Branching

## Purpose

Maintain clean research and development lines for a downstream RADPAIR-derived
workspace while keeping upstream integration deliberate.

The model exists for projects that need to experiment with local capabilities,
such as an NLP/Prolog stack, before those capabilities are accepted into the
production upstream line.

## Read When

Read this when creating or orienting a new R&D project that works against a
clean downstream RADPAIR backend or frontend clone, especially when the project
may need reusable research infrastructure that should not be assumed by every
feature branch.

Do not read this for ordinary feature work in a single repository, or for
upstream release preparation after a specific export plan already exists.

## Repository Boundary

Use two source-control identities:

- upstream RADPAIR repositories are the external source line;
- PrincipleLabs repositories are the independent R&D line.

Permanent downstream worktrees should have a single `origin` remote pointing to
the PrincipleLabs repository. Do not add the upstream RADPAIR repository as an
ambient remote in those worktrees. Upstream comparison, import, and export should
go through an explicit sync cache or another clearly named integration surface.

This keeps daily research branches from accidentally mixing product work,
machine operations, upstream release mechanics, and local experiments.

## Durable Branches

Use two durable R&D base branches when the local semantic stack is not yet part
of the production baseline:

```text
main
  clean downstream copy of the RADPAIR line

research/base-clean
  R&D base after repo-resident agent, ops, or machine-specific baggage has been
  removed or neutralized

research/nlp-prolog-stack
  research/base-clean plus the reusable NLP/Prolog services, helpers, fixtures,
  tests, and local runtime integration

research/<project>
  project branch based on either research/base-clean or
  research/nlp-prolog-stack
```

`research/base-clean` is for projects that need RADPAIR product code but should
not inherit the semantic stack.

`research/nlp-prolog-stack` is for projects where the semantic stack is part of
the assumed local platform.

Project branches should make their base explicit in the project record. If the
base changes later, record the migration and the reason.

## Branch Creation Rule

Before creating a project branch, choose the base profile:

```text
base-clean
  Use when the project is product research, reverse specification, UI study,
  or ordinary app development that does not require NLP/Prolog runtime support.

nlp-prolog-stack
  Use when the project depends on voice typing validation, semantic parsing,
  Prolog-backed relation checks, linguistic services, or related fixtures.
```

Then create a named worktree from the selected branch:

```text
worktrees/<repo>-<project-slug>
projects/<project-slug>/
```

The project root owns orientation, notes, research, handoffs, and links to the
worktrees. The repository worktree owns source changes and executable evidence.

## Upstream Hygiene

Do not treat upstream synchronization as a background habit.

For imports:

- compare upstream in the isolated sync surface;
- create an explicit proposed integration branch or patch;
- inspect and test before it enters a durable R&D base.

For exports:

- select the intended commits;
- remove machine-local assumptions and research-only scaffolding unless they are
  part of the proposed product change;
- produce a reviewable branch, patch series, or bundle;
- push only through the agreed upstream process.

Runtime `.env` files, secrets, local service names, Tailscale routes, temporary
uploads, and machine inventories do not belong in the portable branch model.

## Example: Current Local Pattern

On a machine that has independent PrincipleLabs RADPAIR clones, the permanent
repos may live under a local workspace such as:

```text
principlelabs67-radpair/backend
principlelabs67-radpair/frontend
```

Active project worktrees may live under:

```text
worktrees/principlelabs67-radpair-backend-<project-slug>
worktrees/principlelabs67-radpair-frontend-<project-slug>
```

Machine-local project records may live under:

```text
projects/<project-slug>/PROJECT.md
```

Those paths are examples, not portable requirements. The durable rule is the
separation among project purpose, repository identity, worktree checkout, and
upstream sync surface.

## Acceptance Checklist

A new R&D project is correctly set up when:

- the project record states its base profile;
- backend and frontend worktrees, if needed, are named by project slug;
- permanent worktrees have only the downstream `origin` remote;
- upstream RADPAIR comparison happens only through the explicit sync surface;
- research, operations, and implementation artifacts have clear ownership;
- the semantic stack exists only on branches that intentionally inherit it;
- local secrets and runtime files remain uncommitted.
