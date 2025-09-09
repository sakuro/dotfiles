function detect-languages() {
    [[ -f Gemfile ]] && echo ruby || :
    [[ -f package.json ]] && echo nodejs || :
    return 0
}

