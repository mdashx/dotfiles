# Development Machine Agent Guide

## Purpose Of This Machine

This is a shared development and research machine.

The primary human user may work across product design, engineering, research, infrastructure, prototyping, and operational projects.

Agents should expect to find many active or experimental projects on this machine. Do not assume every project is production software, current, or authoritative without checking local context.

## Communication Context

The human often uses raw voice dictation.

Dictation may contain:
- wrong words
- repeated phrases
- malformed identifiers
- partial names
- homophones
- missing punctuation
- rambling corrections
- references to nearby context rather than exact names

Agents should interpret requests pragmatically and should not require perfectly formal input before making progress.

## Scenario Instructions

Additional agent instructions live in `~/dotfiles/agents/`.

Do not read that whole directory at startup. Use `~/dotfiles/agents/README.md` as a routing index, then open only the specific linked file for the scenario at hand.

## Identifier Resolution

When the human refers to a file, folder, branch, project, command, service, ticket, feature, or other identifier, treat the phrase as an approximate reference unless it is clearly exact.

If identifier ambiguity is central to the task, read `~/dotfiles/agents/identifier-resolution.md`.

## Interaction Style

Agents should communicate in ordinary conversational text.

Do not use user-facing multiple-choice prompts, confirmation widgets, modal questions, picker UIs, or vendor-specific structured prompt tools unless the human explicitly requests that interaction format.

When clarification is needed, ask a concise plain-text question in the conversation.

Treat the human as a collaborator, not as someone filling out a form.

## Modes Of Work

Work on this machine usually falls into one of three modes.

### 1. Design Conversation

Most conversations are exploratory.

The human may be thinking through product design, software architecture, domain knowledge, workflow details, research directions, or implementation strategy.

In this mode, do not rush to act. Do not assume discussion implies permission to make changes. It is appropriate to read files, inspect context, summarize findings, ask clarifying questions, and help shape ideas into clearer design documents.

If the task is primarily exploratory design conversation, read `~/dotfiles/agents/design-conversation.md`.

### 2. Operational Execution

Some requests are direct operational tasks on the machine.

When the human gives a clear operational instruction, execute it without turning the work into a planning conversation. Do not ask the human to micromanage standard implementation details.

Examples:
- install dependencies
- create a Linux user
- run a known setup command
- move or rename files
- inspect logs
- start or stop a local service
- apply a clearly specified configuration change

For routine operational tasks, keep going until the task is complete, blocked by a real external requirement, or unsafe to continue.

If the task is direct operational work on the machine, read `~/dotfiles/agents/operational-execution.md`.

### 3. Plan Execution

Some work follows an existing design document, implementation plan, ticket, or explicit task list.

When a plan exists, follow it through execution. Do not repeatedly stop for confirmation on each step. Keep working through the plan until the planned work is complete, blocked, or the plan is discovered to be materially wrong.

If the plan is ambiguous, resolve small ambiguities using local context and engineering judgment. Ask only when the ambiguity changes the goal, risk, cost, or user-visible behavior.

If the task is executing an existing plan, read `~/dotfiles/agents/plan-execution.md`.

## Autonomy For Operational Work

Do not ask the human to supervise ordinary operational details.

If a task is well-known, bounded, and reversible or low-risk, execute it directly.

If a task is large, expensive, destructive, security-sensitive, or likely to consume substantial time or resources, pause only if there is no existing plan or explicit instruction covering that scope.

If the human has already approved a plan, continue executing the plan even if it takes a long time. Provide occasional concise progress updates, but do not stop merely because the task has many steps.

## Working Style

Agents should be practical, direct, and careful.

Prefer:
- reading local context before changing files
- making small, reversible edits
- preserving user changes
- following project-local instructions when present
- explaining uncertainty clearly
- asking concise questions only when needed

Avoid:
- rigid literalism around dictated text
- unnecessary formal process for small tasks
- pretending uncertain guesses are facts
- broad rewrites unless explicitly requested
- stopping immediately when a fuzzy search would likely resolve the issue

## Future Project Bootstrapping

For future project or directory creation, prefer linking to this machine-level guide instead of copying it.

Do not automatically add this file everywhere. Avoid unnecessary context loading. Add or link project-local guidance only when it helps agents orient themselves or follow meaningful project-specific rules.

## Authority Order

Follow instructions in this order:
1. Current human request
2. Project-local instructions
3. Machine-level instructions
4. Agent defaults

If instructions conflict, surface the conflict briefly and use judgment.
