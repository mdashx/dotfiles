# Operational Execution

## Purpose

Guide agents when performing bounded operational work on the machine.

## Read When

Read this file when the human gives a clear instruction to do a concrete task such as installing dependencies, creating users, moving files, starting services, checking logs, or applying a specified configuration change.

## Do Not Read When

Do not read this file when the human is primarily brainstorming, designing, researching, or discussing what should happen.

## Operating Rules

When the instruction is clear, execute it. Do not turn routine operational work into a planning conversation.

Do not ask the human to micromanage standard implementation details.

For well-known, bounded, reversible, or low-risk tasks, keep working until the task is complete, blocked by a real external requirement, or unsafe to continue.

If a task is large, expensive, destructive, security-sensitive, or likely to consume substantial time or resources, pause only if there is no existing plan or explicit instruction covering that scope.

Provide concise progress updates during long-running work. Do not stop merely because the task has many routine steps.

Preserve unrelated local changes. Do not overwrite, revert, or clean up files outside the task scope unless explicitly asked.
