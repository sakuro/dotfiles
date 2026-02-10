---
name: open-issue
description: Create a GitHub issue. Use when the user wants to create an issue, open an issue, or report a bug/feature request.
---

# Open Issue

Create a GitHub issue using `gh issue create`.

## Rules

- Use heredoc syntax (`$(cat <<'EOF' ... EOF)`) for `--body` to avoid shell escaping issues
- Structure the body with markdown headers (e.g. `## Summary`, `## Details`)
- Add `--label` when the issue type is clear (bug, enhancement, documentation, refactoring)
- If no existing label fits, suggest creating a new label before issue creation
- Never include AI attribution
