function detect-languages() {
    [[ -f Gemfile ]] && echo ruby || :
    [[ -f package.json ]] && echo nodejs || :
    return 0
}

# Enable tools managed by mise if mise is executable
if (( $+commands[mise] )); then
  eval "$(mise activate zsh)"
fi
