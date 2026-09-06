# Dotfiles Repository Agent Guide

This repository manages user-level dotfiles and machine bootstrap helpers.

Follow the machine-level agent guide at `dotfiles/AGENTS.md` for general RADPAIR development-machine behavior.

## Routine Updates

When making a routine, low-risk update in this repository, commit the relevant change and push it to GitHub after validation.

Routine updates include:
- editing dotfile contents
- adding or updating agent instruction files
- updating bootstrap scripts
- adding small reference notes or helper scripts

Do not include unrelated local modifications in the commit.

## Branch Conflicts

If the current branch cannot be pushed cleanly because the remote has diverged or the branch is otherwise blocked, create a new branch for the completed work and push that branch to GitHub.

Use a short descriptive branch name. Do not overwrite remote history or force-push unless the human explicitly asks for it.
