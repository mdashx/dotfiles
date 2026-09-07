# Decision Log

## D-001: Use A Project Workspace Instead Of Immediate Library Edits

Status: settled

The cleanup will be orchestrated from `~/dotfiles/process-library-cleanup/`
before broad changes are made to the final library directories.

Reason: the user wants a repeatable process that can stop, continue, and use
subagents. A project workspace gives the work a durable cursor and lets
classification happen before relocation.

## D-002: Preserve The Distinction Between Instructions And Content

Status: settled

Agent files, prompts, practices, templates, examples, and research notes are
different artifact types. They should not be merged into one instruction dump.

Reason: the user explicitly framed the existing materials as content to clean
up and optimize, not as immediate instructions for the current agent.
