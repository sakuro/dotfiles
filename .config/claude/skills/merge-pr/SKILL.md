---
name: merge-pr
description: Safely merges GitHub pull requests using gh CLI. Use when the user wants to merge a PR, merge a pull request, or complete code review.
allowed-tools: [Bash, Read, Grep]
---

# Merge PR Skill

Safely merges GitHub pull requests using the `gh` CLI.

**Announce when using this skill**: "Using merge-pr skill to merge a pull request safely."

## Workflow

### 1. Check status

```bash
gh pr view [PR]
gh pr checks [PR]          # add --watch to wait for CI to finish
```

Confirm before merging:
- All required CI checks pass
- Required approvals are met, with no unresolved change requests
- The PR targets the correct base branch
- You have permission to merge

### 2. Merge

```bash
BRANCH_NAME=$(gh pr view [PR] --json headRepositoryOwner,headRefName -q '.headRepositoryOwner.login + "/" + .headRefName')
gh pr merge [PR] --merge --subject ":inbox_tray: Merge pull request #[PR] from $BRANCH_NAME"
```

- Default strategy is `--merge` (preserves full commit history). Use `--squash` only when the PR has many small/WIP commits to consolidate, `--rebase` only for small PRs where a linear history without a merge commit is wanted.
- Always set `--subject` in the format `:inbox_tray: Merge pull request #[PR] from [BRANCH_NAME]`.
- Never pass `--delete-branch` — branch deletion is controlled by the repository's "Automatically delete head branches" setting, not by this skill.
- Omit `[PR]` in any command above to target the PR of the current branch.
- For auto-merge, add `--auto` and run step 3 once `gh pr view [PR]` shows `MERGED`.

### 3. Update local default branch

```bash
DEFAULT_BRANCH=$(gh repo view --json defaultBranchRef -q .defaultBranchRef.name)
git checkout "$DEFAULT_BRANCH"
git pull
git branch --merged | grep -v "\*" | grep -v "$DEFAULT_BRANCH" | xargs -n 1 git branch -d  # optional: prune merged local branches
```

## Never merge if

- CI checks are failing
- Unresolved change requests exist
- Required approvals are missing
- You lack merge permission
- The PR targets the wrong base branch

## Recovery

**Merge conflicts** — resolve on the PR branch, then retry step 2:
```bash
gh pr checkout [PR]
git fetch origin
DEFAULT_BRANCH=$(gh repo view --json defaultBranchRef -q .defaultBranchRef.name)
git merge "origin/$DEFAULT_BRANCH"
# resolve conflicts, then:
git push
```

**Merged the wrong PR**:
```bash
DEFAULT_BRANCH=$(gh repo view --json defaultBranchRef -q .defaultBranchRef.name)
git checkout "$DEFAULT_BRANCH" && git pull
git log                          # find the merge commit hash
git revert -m 1 [MERGE_COMMIT_HASH]
git push
```

## Project-specific conventions

Before defaulting to `--merge`, check `CONTRIBUTING.md` and the repository's branch protection rules for merge-strategy overrides.
