# Git Commit Command

Assists with creating git commits.

**IMPORTANT: When using this command, announce to the user**: "Using /commit command to create a commit."

## Workflow

```bash
# 1. Pre-commit checks (skip tests for documentation-only changes)
rake                    # Ruby
npm test                # Node.js
make test               # Make

# 2. Review changes
git status
git diff

# 3. Stage specific files (NEVER use "git add ." or "git add -A")
git add path/to/file.ext
git add path/to/another.ext

# 4. Review staged changes
git diff --cached

# 5. Commit with heredoc format (MUST use <<'EOF' with single quotes)
git commit -m "$(cat <<'EOF'
:emoji: Subject line in imperative mood

Brief explanation (optional)
- Key impact 1
- Key impact 2
EOF
)"

# 6. Push if needed
git push
```

## Key Rules

- Write in English only
- Use `:emoji:` codes (not raw Unicode), with a space after
- Imperative mood: "Fix" not "Fixed"
- No period at end of subject line
- Focus on WHAT and WHY, not HOW
- 2-3 bullet points max in body
- Omit reverted changes and implementation details

## Emoji Codes

- `:zap:` - Performance
- `:bug:` - Bug fix
- `:sparkles:` - Feature
- `:memo:` - Documentation
- `:recycle:` - Refactor
- `:art:` - Structure/format
- `:wrench:` - Configuration
- `:white_check_mark:` - Tests
- `:fire:` - Remove
- `:package:` - Dependencies
