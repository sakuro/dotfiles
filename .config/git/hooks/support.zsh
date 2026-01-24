function detect-languages() {
    [[ -f Gemfile ]] && echo ruby || :
    [[ -f package.json ]] && echo nodejs || :
    return 0
}

# Enable tools managed by mise if mise is executable
if (( $+commands[mise] )); then
  # mise tries removing _mise_hook_precmd from hooks, let it work with set -u
  typeset -ag chpwd_functions
  typeset -ag precmd_functions
  eval "$(mise activate zsh)"
fi
