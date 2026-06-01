#!/usr/bin/env zsh

set -A path ${^${~${(@fe)"$(<$ZDOTDIR/paths)"}}}(N)

# Use Nerd Font icons with zsh Unicode escape sequences
folder_emoji="\uf115"  # Nerd Font folder icon
branch_emoji="\ue725"  # Nerd Font git branch icon
ctx_emoji="\uf1c0"    # Nerd Font database icon
rl_emoji="\uf252"     # Nerd Font hourglass-half icon

# Read JSON input from stdin
input=$(cat)

# Extract current directory from JSON
current_dir=$(echo "$input" | jq -r '.workspace.current_dir // .cwd')
# Change to the working directory to get git info
cd "$current_dir" 2>/dev/null || true

pwd=$(print -P "%~")

branch=$(git symbolic-ref --short HEAD 2>/dev/null)
[[ -z "$branch" ]] && branch=$(git rev-parse --short HEAD 2>/dev/null)

ctx_pct=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
rl5h_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // 0' | cut -d. -f1)

print -n "${folder_emoji} ${pwd}"
[[ -n "$branch" ]] && {
  print -n " ${branch_emoji} ${branch}"
  # Check if repository is dirty
  if ! git diff --quiet 2>/dev/null || ! git diff --cached --quiet 2>/dev/null || [[ -n $(git ls-files --others --exclude-standard 2>/dev/null) ]]; then
    print -n "*"
  fi
}
print -n " ${ctx_emoji} ${ctx_pct}% ${rl_emoji} ${rl5h_pct}%"
