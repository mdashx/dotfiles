# Base-Clean R&D Project Setup

Use this prompt to orient a new agent before creating a machine-local R&D
project that should build on the clean research base rather than the local
NLP/Prolog stack.

```text
We are setting up a new local R&D project on this machine.

First, orient yourself by reading:

- ~/AGENTS.md
- ~/PROJECT.md
- ~/PROJECTS.md
- ~/dotfiles/practices/principlelabs-radpair-rd-branching.md

This project should follow the machine-local project/repo/worktree model:

- project root under ~/projects/<project-slug>/
- source worktrees under ~/worktrees/
- PrincipleLabs RADPAIR repos as the downstream R&D source identity
- upstream RADPAIR comparison only through the explicit sync surface
- project docs, notes, handoffs, research, and links owned by the project root

For this project, assume the base profile is:

base-clean

That means the project should build from the clean R&D base branch, not from the
NLP/Prolog stack branch, unless I later explicitly change that.

Do not create directories or branches yet.

Your first task is only to acknowledge the filesystem layout and the basic setup
plan you infer from the docs. After that, I will provide the project slug,
purpose, needed repos/worktrees, and any project-specific setup details so the
directories can be created cleanly.
```
