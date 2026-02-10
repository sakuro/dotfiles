---
name: start-issue
description: Start working on a GitHub issue. Use when the user wants to work on an issue, start an issue, or begin implementation.
---

# Start Issue

Begin work on a GitHub issue by viewing its details and creating a working branch.

## Workflow

1. View the issue with `gh issue view`
2. Check labels with `gh issue view --json labels`
3. Pull latest main and create a branch

## Branch Naming

Format: `<prefix>/<issue-title-in-kebab-case>`

| Label | Prefix |
|-------|--------|
| `enhancement` | `feature/` |
| `bug` | `fix/` |
| `refactor` | `refactor/` |
| other | `chore/` |
