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
bindkey '^r' interactive-history-search
bindkey '^x^v' interactive-chdir-dirs
bindkey '^x^g' interactive-chdir-projects
bindkey '^x^y' interactive-open-bundled-gem
bindkey '^x^k' interactive-choose-rake-task
bindkey '^x^b' interactive-choose-git-branch

for w in $ZDOTDIR/widgets/*(@,.); do
  source $w
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

HISTFILE=$ZDOTDIR/history
typeset -i SAVEHIST=1000000
typeset -i HISTSIZE=1100000

setopt prompt_subst
fpath=(
  $ZDOTDIR/prompts
  $fpath
)

autoload -U promptinit
promptinit
if [[ -n "$TMUX" ]]; then
  prompt tmux
else
  prompt sakuro
fi

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
zstyle ':completion:*' cache-path $ZDOTDIR/compcache
zstyle ':completion:*' use-cache true
zstyle ':completion:*' matcher-list 'r:|[:]=* m:{a-z}={A-Z} m:{A-Z}={a-z}'

if is-executable -p code; then
  EDITOR="code -w"
elif is-executable -p vim; then
  EDITOR=vim
else
  EDITOR=vi
fi

export EDITOR

if is-executable -p less; then
  PAGER=less
  export LESS="-inmXRz-4"
  export LESSHISTFILE=-
else
  PAGER=more
fi

export PAGER
export READNULLCMD=$PAGER

if is-executable -p explorer.exe; then
  alias open=explorer.exe
fi

setopt completealiases

alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'
alias history='history -i 1'
alias du='du -h'
alias df='df -h'
alias free='free -t -m'
alias -g L="| $PAGER"
alias dirs='dirs -v'
alias -g Q='1>/dev/null 2>&1'
alias puts='print -l'

is-executable nvim && alias vim=nvim
is-executable vim && alias vi=vim

() {
  local dircolors_path=$XDG_CONFIG_HOME/themes/nord/dircolors/src/dir_colors
  if is-executable dircolors && [[ -f $dircolors_path ]]; then
    eval $(dircolors -b $dircolors_path)
    alias ls='ls -F --color=auto'
  fi
}

if is-executable zcal; then
  alias cal=zcal
elif is-executable gcal; then
  alias cal='gcal --starting-day=1 --type=standard --cc-holidays=JP'
fi

autoload -U colors
colors

export GREP_COLOR=$color[cyan]
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

# direnv
is-executable direnv && eval "$(direnv hook zsh)"

if is-executable gosh; then
  rlwrap gosh
fi

[[ -f $ZDOTDIR/.zshrc.local ]] && source $ZDOTDIR/.zshrc.local || :
