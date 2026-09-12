# Agent Instruction Library

This directory contains scenario-specific guidance for coding agents working on a development machine.

Do not read every file in this directory at startup. Use this file as a routing index and open only the linked document that matches the current task.

For reusable content that is not standing instruction, use:

- `../prompts/` for mid-conversation prompt frames;
- `../practices/` for process methods and best-practice writeups;
- `../templates/` for fillable artifact skeletons;
- `../examples/` for completed reference artifacts.

## How To Use This Directory

Each scenario document should be written so it can stand alone.

Agents should:
- read this index only when looking for scenario-specific guidance
- follow links only when the trigger clearly matches the current request
- avoid loading unrelated guidance into context
- prefer project-local instructions when a project has more specific rules

New documents should include:
- purpose
- read when
- do not read when
- concrete operating rules

## Scenario Documents

### [Working Profile: Tom Hyndman](working-profile-tom-hyndman.md)

Read when the task is a substantive software design, architecture, modeling, explanation, reverse-engineering, or domain-reasoning conversation.

Do not read for routine shell tasks, mechanical edits, or short operational requests.

### [Conversation Fieldstone Workflow](conversation-to-spec-fieldstone.md)

Read during a long exploratory research or technical design conversation where durable facts should be quietly accumulated for later artifacts or decisions.

Do not read for ordinary implementation tasks, short explanations, or final spec writing.

### [Specification Writing](specification-writing.md)

Read when the human asks to write, produce, revise, or finalize a technical specification from a design conversation, fieldstones, source evidence, or an existing design vision.

Do not read merely because a conversation might someday become a spec.

### [Design Conversation](design-conversation.md)

Read when the human is exploring product design, software architecture, domain modeling, research direction, implementation strategy, or a design document.

Do not read when the human has already given a direct operational instruction.

### [Identifier Resolution](identifier-resolution.md)

Read when a request depends on resolving a possibly-dictated or approximate identifier such as a file, folder, branch, ticket, service, command, project, or feature name.

Do not read when all identifiers are exact and already located.

### [Operational Execution](operational-execution.md)

Read when the human gives a clear instruction to perform a bounded operational task on the machine.

Do not read for exploratory conversations where the human is still deciding what should happen.

### [Plan Execution](plan-execution.md)

Read when the task is to execute an existing plan, design document, ticket, checklist, or explicit sequence of steps.

Do not read when the work is still in design conversation mode.
