#!/usr/bin/env zsh

# Read JSON input from stdin
input=$(cat)

# Extract current directory from JSON
current_dir=$(echo "$input" | jq -r '.workspace.current_dir // .cwd')

# Simple path shortening: replace home with ~ and show basename if too long
simple_path() {
    local dir="$1"
    # Replace home directory with ~
    dir="${dir/#$HOME/~}"

    # If path is too long, just show the basename
    if [[ ${#dir} -gt 40 ]]; then
        echo "...$(basename "$dir")"
    else
        echo "$dir"
    fi
}

# Get git branch using git command directly
git_branch() {
    local branch
    branch=$(/opt/homebrew/bin/git symbolic-ref --short HEAD 2>/dev/null)
    if [[ -z "$branch" ]]; then
        branch=$(/opt/homebrew/bin/git rev-parse --short HEAD 2>/dev/null)
    fi
    if [[ -n "$branch" ]]; then
        # Check if repository is dirty
        local dirty=""
        if ! /opt/homebrew/bin/git diff --quiet 2>/dev/null || ! /opt/homebrew/bin/git diff --cached --quiet 2>/dev/null || [[ -n $(/opt/homebrew/bin/git ls-files --others --exclude-standard 2>/dev/null) ]]; then
            dirty="%f%B*%b"
        fi
        echo "${branch}${dirty}"
    fi
}

# Change to the working directory to get git info
cd "$current_dir" 2>/dev/null || true

# Build status line with emoji using Unicode escape sequences
path=$(simple_path "$current_dir")
branch=$(git_branch)

# Use Nerd Font icons with zsh Unicode escape sequences
folder_emoji="\uf115"  # Nerd Font folder icon
branch_emoji="\ue725"  # Nerd Font git branch icon

if [[ -n "$branch" ]]; then
    print -Pn "%F{magenta}${folder_emoji} ${path}%f %F{cyan}${branch_emoji} ${branch}%f"
else
    print -Pn "%F{magenta}${folder_emoji} ${path}%f"
fi
