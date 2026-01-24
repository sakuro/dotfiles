---
name: prepare-release
description: Prepare a new release by triggering GitHub Actions release workflow. Invoke with /prepare-release VERSION
argument-hint: VERSION
---

# Prepare Release

Prepare release for version $ARGUMENTS.

## Pre-flight Checks

1. **Verify version format**: Ensure $ARGUMENTS follows semantic versioning (X.Y.Z)
2. **Check CHANGELOG.md**: Verify `[Unreleased]` section has content
3. **Check git status**: Ensure working directory is clean
4. **Check current branch**: Should be on main/master branch

## Trigger Release Workflow

Run the release preparation workflow:

```bash
gh workflow run release-preparation.yml -f version=$ARGUMENTS
```

## After Triggering

1. Report the workflow run URL to the user
2. Wait for the workflow to complete, then report the created PR URL
3. After user review and CI passes, use `/merge-pr` to merge
