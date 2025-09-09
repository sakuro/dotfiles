function detect-languages() {
    [[ -f Gemfile ]] && echo ruby || :
    [[ -f package.json ]] && echo nodejs || :
    return 0
}

function command-in-path() {
  (( $# )) || return 1
  (( $+commands[$1] ))
}
