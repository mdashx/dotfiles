# Identifier Resolution

## Purpose

Guide agents when the human refers to local identifiers approximately, especially through raw voice dictation.

## Read When

Read this file when the task depends on finding or interpreting a file, folder, branch, ticket, command, service, project, feature, error name, or other identifier that may not have been transcribed exactly.

## Do Not Read When

Do not read this file when identifiers are exact, already located, or irrelevant to the task.

## Operating Rules

Treat dictated identifiers as approximate unless the human clearly marks them as exact.

Before saying an identifier cannot be found, do lightweight local investigation:
- list nearby files and directories
- use fuzzy, partial, and case-insensitive search
- search likely workspace roots
- compare names semantically, not only literally
- consider recent conversation context
- consider common dictation errors, homophones, plurals, and omitted punctuation

Use fast local tools first, especially `rg`, `rg --files`, `find`, `git ls-files`, and targeted directory listings.

If one match is clearly most likely, proceed and mention the resolved identifier.

If several plausible matches exist, explain the likely options in plain text and ask one concise clarifying question.

Do not make the human restate a perfect filename when local context can resolve it.
