# Dotfiles Repository Agent Guide

This repository manages user-level dotfiles and machine bootstrap helpers.

Follow the machine-level agent guide at `dotfiles/AGENTS.md` for general development-machine behavior.

Scenario-specific coding-agent guidance lives in `agents/README.md`. Do not read the whole `agents/` directory at startup; use the index and follow only the links relevant to the current task.

## Routine Updates

When making a routine, low-risk update in this repository, commit the relevant change and push it to GitHub after validation.

Routine updates include:
- editing dotfile contents
- adding or updating agent instruction files
- updating bootstrap scripts
- adding small reference notes or helper scripts

Unrelated local modifications may be included when they are clearly innocuous dotfiles cleanup. In this repository, such changes are usually not part of another project or workstream; they are often ordinary tidying that should be preserved in git history.

Prefer keeping git history, directory contents, file permissions, symlinks, and bootstrap state tidy. If an unrelated change looks routine and low-risk, include it in the commit with the rest of the dotfiles maintenance work.

Do not include unrelated local modifications that are risky, unclear, secret-bearing, destructive, or plausibly part of another active task.

## Branch Conflicts

If the current branch cannot be pushed cleanly because the remote has diverged or the branch is otherwise blocked, create a new branch for the completed work and push that branch to GitHub.

Use a short descriptive branch name. Do not overwrite remote history or force-push unless the human explicitly asks for it.
