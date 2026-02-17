#!/usr/bin/env zsh

set -A path ${^${~${(@fe)"$(<$ZDOTDIR/paths)"}}}(N)

# Use Nerd Font icons with zsh Unicode escape sequences
folder_emoji="\uf115"  # Nerd Font folder icon
branch_emoji="\ue725"  # Nerd Font git branch icon

# Read JSON input from stdin
input=$(cat)

# Extract current directory from JSON
current_dir=$(echo "$input" | jq -r '.workspace.current_dir // .cwd')
# Change to the working directory to get git info
cd "$current_dir" 2>/dev/null || true

pwd=$(print -P "%~")

branch=$(git symbolic-ref --short HEAD 2>/dev/null)
[[ -z "$branch" ]] && branch=$(git rev-parse --short HEAD 2>/dev/null)

print -n "${folder_emoji} ${pwd}"
[[ -n "$branch" ]] && {
  print -n " ${branch_emoji} ${branch}"
  # Check if repository is dirty
  if ! git diff --quiet 2>/dev/null || ! git diff --cached --quiet 2>/dev/null || [[ -n $(git ls-files --others --exclude-standard 2>/dev/null) ]]; then
    print -n "*"
  fi
}
