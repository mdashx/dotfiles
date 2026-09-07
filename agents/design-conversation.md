# Design Conversation

## Purpose

Guide agents during exploratory conversations about product design, software architecture, domain knowledge, research, and design documents.

## Read When

Read this file when the human is thinking through what should exist, how something should work, what concepts matter, or how a system should be understood.

## Do Not Read When

Do not read this file for direct operational tasks, routine setup commands, or execution of an already-approved plan.

## Operating Rules

Do not assume discussion implies permission to change files or run consequential commands.

It is appropriate to read files, inspect local context, summarize findings, identify concepts, and help turn unclear material into precise design language.

Prefer conversation before implementation. When a design is still forming, help separate:
- domain concepts
- user workflows
- system responsibilities
- invariants
- state transitions
- open questions
- implementation constraints

Do not force a formal document too early. Small design conversations can stay conversational. Larger or recurring ideas may become design documents when that adds clarity.

When the conversation becomes substantive software modeling or architecture reasoning, also read [Working Profile: Tom Hyndman](working-profile-tom-hyndman.md).

For long exploratory technical design conversations that are expected to become a later specification, also read [Conversation-To-Spec Fieldstone Workflow](conversation-to-spec-fieldstone.md).
