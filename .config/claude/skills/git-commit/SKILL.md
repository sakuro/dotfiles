---
name: git-commit
description: Helps create git commits following project conventions. Use when the user wants to commit changes, create a commit, or stage files for git.
allowed-tools: [Bash, Read, Grep]
---

# Git Commit Skill

Assists with creating git commits that follow this project's strict conventions for commit messages, file staging, and pre-commit checks.

## Instructions

**IMPORTANT: When using this skill, announce to the user**: "Using git-commit skill to create a commit following project conventions."

### 1. Pre-Commit Checks

ALWAYS run tests and linting before committing:

```bash
# Ruby
rake
# or: bundle exec rspec

# Node.js/JavaScript
npm test
# or: npm run build

# Python
pytest
# or: python -m pytest

# Make-based projects
make test
```

If there are failures:
- Fix linter/formatter issues with auto-fix commands:
  - Ruby: `bundle exec rubocop -A`
  - JavaScript/TypeScript: `eslint --fix` or `prettier --write .`
  - Python: `black .` or `ruff check --fix`
- Fix any test failures
- Re-run your project's test command to verify

### 2. File Staging Rules

**CRITICAL: NEVER use these commands**:
```bash
git add .      # ❌ Adds ALL files in current directory
git add -A     # ❌ Adds ALL tracked and untracked files
git add *      # ❌ Adds files matching shell glob
```

**REQUIRED approach**:
1. Review what changed first:
   ```bash
   git status
   git diff
   ```

2. Add specific files explicitly:
   ```bash
   git add README.md
   git add lib/module/file.ext
   git add test/module/test_file.ext
   ```

3. Review staged changes:
   ```bash
   git diff --cached
   ```

### 3. Commit Message Format

All commits MUST follow this format:

```
:emoji: Subject line in imperative mood

Brief explanation of the main change (optional, keep concise)
- Only key impacts
- Important details only

:robot: Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
```

**Message Content Guidelines**:
- **Be concise**: Focus on WHAT changed and WHY, not HOW
- **Avoid implementation details**: Skip low-level code changes unless critical to understanding
- **No exhaustive lists**: 2-3 bullet points maximum for key impacts
- **Skip tangential information**: Only include directly relevant changes
- **Omit reverted changes**: Don't mention things you undid during development

**Key Rules**:
- **ALWAYS write in English**: All commit messages must be in English
- Start with GitHub emoji code (`:emoji:`), NEVER raw Unicode emojis
- **Use emoji codes everywhere**: Both subject line AND body/footer must use `:emoji:` notation, not raw Unicode
- Space after emoji: `:emoji: Subject` not `:emoji:Subject`
- Imperative mood: "Fix bug" not "Fixed bug" or "Fixes bug"
- No period at end of subject line
- Keep subject line concise and focused
- **Keep detailed explanation brief**: Focus only on the main change, avoid tangential details
- **Don't mention reverted changes**: If you undid something that didn't exist before this commit, don't mention it
- **Skip implementation minutiae**: Avoid low-level details that don't affect the purpose of the change

**Common Emoji Codes**:
- `:zap:` - Performance improvements
- `:bug:` - Bug fixes
- `:sparkles:` - New features
- `:memo:` - Documentation
- `:recycle:` - Refactoring
- `:art:` - Code structure/format improvements
- `:wrench:` - Configuration changes
- `:white_check_mark:` - Adding/updating tests
- `:fire:` - Removing code/files
- `:package:` - Updating dependencies

### 4. Commit Command Format

**MANDATORY: Always use quoted heredoc for multi-line commits**

```bash
git commit -m "$(cat <<'EOF'
:emoji: Subject line describing the change

Optional detailed explanation:
- Key point 1
- Key point 2

:robot: Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"
```

**CRITICAL: Shell Safety Rules**
- ALWAYS use `<<'EOF'` (single quotes) not `<<EOF` or `<<"EOF"`
- Single quotes prevent shell variable expansion and preserve special characters
- This is the ONLY safe way for complex commit messages

### 5. Complete Workflow

Follow this sequence:

```bash
# 1. Run tests and lint (use your project's command)
rake                    # Ruby
npm test                # Node.js
pytest                  # Python
make test               # Make

# 2. Review changes
git status
git diff

# 3. Stage specific files (be explicit!)
git add path/to/changed_file.ext
git add path/to/another_file.ext

# 4. Review staged changes
git diff --cached

# 5. Commit with proper message format
git commit -m "$(cat <<'EOF'
:emoji: Imperative mood subject line

Optional detailed explanation
- Key changes
- Important details

:robot: Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"

# 6. Push if needed
git push
```

## Examples

### Example 1: Bug Fix Commit

```bash
git add lib/module/formatter.ext
git add test/module/formatter_test.ext

git commit -m "$(cat <<'EOF'
:bug: Fix nil handling in Formatter#format

Return empty string for nil inputs instead of raising errors.

:robot: Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"
```

### Example 2: New Feature Commit

```bash
git add lib/intl/number_formatter.ext
git add test/intl/number_formatter_test.ext

git commit -m "$(cat <<'EOF'
:sparkles: Add scientific notation support to NumberFormatter

Enable ECMA-402 compatible scientific notation formatting.

:robot: Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"
```

### Example 3: Documentation Update

```bash
git add README.md

git commit -m "$(cat <<'EOF'
:memo: Update installation instructions in README

Clarify Ruby version requirements and setup steps.

:robot: Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"
```

### Example 4: Simple Commit (No Body Needed)

```bash
git add package.json
# or: pyproject.toml, Cargo.toml, version file, etc.

git commit -m "$(cat <<'EOF'
:package: Bump version to 0.2.0

:robot: Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"
```

**Note**: When the subject line is self-explanatory, you can omit the detailed explanation entirely. Keep it minimal.

## Common Pitfalls to Avoid

1. **Don't use non-English messages**: All commit messages must be in English
2. **Don't use raw emojis**: Use `:bug:` not 🐛
3. **Don't use `git add .`**: Always specify files explicitly
4. **Don't skip pre-commit checks**: Always run your project's test/build command first
5. **Don't use unquoted heredoc**: Always use `<<'EOF'` not `<<EOF`
6. **Don't write in past tense**: Use "Fix" not "Fixed"
7. **Don't mention reverted changes**: If you undid something that didn't exist before this commit, don't mention it
8. **Don't write verbose details**: Keep the body concise - focus on what matters, not how it's implemented
9. **Don't list every small change**: Summarize the key impact, avoid exhaustive lists of minor modifications

## Error Recovery

If commit hook rejects your message:
- Ensure message starts with `:emoji_code:` (colon on both sides)
- Check for raw Unicode emojis and replace with codes
- Verify there's a space after the emoji code

If pre-push hook fails:
- Run your project's test/build command locally to catch issues
- Fix linter/formatter issues:
  - Ruby: `bundle exec rubocop -A`
  - JavaScript/TypeScript: `eslint --fix` or `prettier --write .`
  - Python: `black .` or `ruff check --fix`
- Fix test failures before pushing
