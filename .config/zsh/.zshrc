#!/bin/zsh

setopt auto_resume

setopt correct
setopt print_eight_bit

unsetopt extended_glob
setopt magic_equal_subst
setopt numeric_glob_sort

autoload run-help
bindkey -e
bindkey '^M' accept-line-with-hooks
add-hook accept_line accept-line-uri-download
add-hook accept_line accept-line-uri-github-clone
add-hook accept_line accept-line-uri-open
bindkey '^r' interactive-history-search
bindkey '^x^b' interactive-choose-git-branch # replaces vi-match-bracket
bindkey '^x^d' interactive-chdir-dirs
bindkey '^x^e' interactive-choose-gemoji
bindkey '^x^f' interactive-compare-git-commits # replaces vi-find-next-char
bindkey '^x^g' interactive-open-bundled-gem
bindkey '^x^i' interactive-choose-k8s-ingress
bindkey '^x^l' interactive-choose-git-managed-file
bindkey '^x^p' interactive-chdir-projects
bindkey '^x^t' interactive-choose-rake-task
bindkey '^x^w' interactive-choose-chrome-tab

fpath=(
  $ZDOTDIR/widgets
  $fpath
)
for w in $ZDOTDIR/widgets/*(@,.); do
  autoload $w:t
  zle -N $w:t
done

setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushd_silent

cdpath=( ~ ~/*.*/*(-/N) )

setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_no_store
setopt hist_reduce_blanks
setopt hist_save_nodups
setopt share_history

export HISTFILE=$XDG_CACHE_HOME/zsh/history
[[ -d $HISTFILE:h ]] || mkdir -p $HISTFILE:h
typeset -i SAVEHIST=1000000
typeset -i HISTSIZE=1100000

setopt prompt_subst
fpath=(
  $ZDOTDIR/prompts
  $fpath
)

autoload -U promptinit
promptinit
prompt sakuro

autoload -Uz select-word-style
select-word-style default
zstyle ':zle:*' word-chars " *?_-.[]~=/&;!#$%^(){}<>"
zstyle ':zle:*' word-style unspecified

setopt always_to_end
setopt no_list_beep
setopt list_packed

zstyle ':completion:*' completer _expand _complete _correct
zstyle ':completion:*' ignore-parents parent pwd
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' menu select=1
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' cache-path $XDG_CACHE_HOME/zsh/compcache
zstyle ':completion:*' use-cache true
zstyle ':completion:*' matcher-list 'r:|[:]=* m:{a-z}={A-Z} m:{A-Z}={a-z}'

if is-executable -p nvim; then
  EDITOR=nvim
elif is-executable -p nvim; then
  EDITOR=vim
else
  EDITOR=vi
fi

export EDITOR

if is-executable -p less; then
  PAGER=less
  export LESS="--ignore-case --line-numbers --long-prompt --no-init --quit-if-one-screen --RAW-CONTROL-CHARS --window=-4"
  export LESSHISTFILE=/dev/null
else
  PAGER=more
fi

export PAGER
export READNULLCMD=$PAGER

setopt completealiases

alias rm='rm --interactive=once'
alias mv='mv --interactive'
alias cp='cp --interactive'
alias history='history -i 1'
alias du='du --human-readable'
alias df='df --human-readable'
alias free='free -t -m'
alias dirs='dirs -v'
alias puts='print -l'
alias mktree='mkdir -p'

alias -g L="| $PAGER"
alias -g G="| grep"
alias -g Q='1>/dev/null 2>&1'
alias -g J="| jq"
alias -g C="| pbcopy"
alias -g P="| pbpaste"
alias -g GF="| gemoji filter"
alias -g GFL="| gemoji filter | $PAGER"

if is-executable -p nvim; then
  alias vim=nvim
  alias vi=nvim
  alias view='nvim -R'
elif is-executable -p vim; then
  alias vi=vim
  alias view='vim -R'
fi

# Aliases for Windows
is-executable -p clip.exe && alias pbcopy=clip.exe
is-executable -p powershell.exe && alias pbpaste='powershell.exe -Command Get-Clipboard'

() {
  local dircolors_path=$XDG_CONFIG_HOME/themes/nord/dircolors/src/dir_colors
  if is-executable dircolors && [[ -f $dircolors_path ]]; then
    eval $(dircolors -b $dircolors_path)
    alias ls='ls --classify --color=auto'
  fi
}

if is-executable zcal; then
  alias cal=zcal
elif is-executable gcal; then
  alias cal='gcal --starting-day=1 --type=standard --cc-holidays=JP'
fi

autoload -U colors
colors

export GREP_COLORS="ms=${color[bold]};${color[cyan]}:mc=${color[bold]};${color[cyan]}:sl=:cx=:fn=${color[magenta]}:ln=${color[green]}:bn=${color[green]}:se=${color[blue]}"
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

autoload -Uz add-zsh-hook

unset LC_ALL
unset LC_CTYPE LC_MONETARY LC_NUMERIC
export LC_COLLATE=C LC_TIME=C LC_MESSAGES=C
export LANG=ja_JP.UTF-8

export TIME_STYLE=long-iso
export QUOTING_STYLE=literal

limit coredumpsize 0

() {
  local script prefix
  for script in syntax-highlighting autosuggestions; do
    for prefix in /opt/homebrew/share /usr/share; do
      local full_path="$prefix/zsh-$script/zsh-$script.zsh"
      [[ -f "$full_path" ]] || continue
      source "$full_path"
      break
    done
  done

  if [[ -n $ZSH_AUTOSUGGEST_CLEAR_WIDGETS ]]; then
    ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=accept-line-with-hooks
  fi
  ZSH_HIGHLIGHT_HIGHLIGHTERS=(main regexp)
  if [[ -n ZSH_HIGHLIGHT_REGEXP ]]; then
    ZSH_HIGHLIGHT_REGEXP+=('(https?://([^ ]+[.])+([^ ]+))' fg=cyan)
  fi
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=white,bg=cyan'
  ZSH_AUTOSUGGEST_STRATEGY=(history completion)
}

function git-status-short()
{
  upfind -q .git && git status --short --branch
}
add-zsh-hook chpwd git-status-short

function set-program-name()
{
  # second arg contains the actual command to be executed as a single-line string
  set -- ${=2}
  if [[ $1 = "env" ]]; then
    shift
  fi
  while [[ $# -gt 0 ]]; do
    [[ "$1" =~ "^[A-Z0-9_]+=" ]] || break
    shift
  done
  wezterm:set-user-var WEZTERM_PROG "${1##*/}"
}
add-zsh-hook preexec set-program-name

function unset-program-name()
{
  wezterm:set-user-var WEZTERM_PROG "${SHELL##*/}"
}
add-zsh-hook precmd unset-program-name

function set-working-directory()
{
  wezterm:set-working-directory
}
add-zsh-hook chpwd set-working-directory

[[ -f $ZDOTDIR/.zshrc.local ]] && source $ZDOTDIR/.zshrc.local || :
