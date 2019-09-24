#!/bin/zsh

typeset -aU path
PATH=/opt/brew/bin:$PATH # Need to hardcode brew's patha at first
set -A path ${^${~${(@fe)"$(<$ZDOTDIR/paths)"}}}(N)

source $ZDOTDIR/.zplugrc

fpath=(
  $ZDOTDIR/functions $fpath
  /opt/brew/share/zsh/site-functions
  /opt/brew/share/zsh-completions
)
autoload -Uz ${(e)${^$(echo $ZDOTDIR/functions/*(.N))}:t}

source /opt/brew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

setopt auto_resume

setopt correct
setopt print_eight_bit

unsetopt extended_glob
setopt magic_equal_subst
setopt numeric_glob_sort

autoload run-help
bindkey -e
bindkey '^?' cd-up-at-bol-or-backward-delete-char
bindkey '^H' cd-up-at-bol-or-backward-delete-char
bindkey '^M' accept-line-with-hooks
bindkey '^J' accept-line-and-open-in-pane
bindkey '^r' peco-history-search
bindkey '^x^v' interactive-chdir-dirs
bindkey '^x^g' interactive-chdir-projects
bindkey '^x^y' peco-open-bundled-gem
bindkey '^x^k' peco-rake-choose-task
bindkey '^x^b' peco-git-choose-branch

for w in $ZDOTDIR/widgets/*(.); do
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
fpath=($ZDOTDIR/prompts $fpath)

autoload -U promptinit
promptinit

if in-tmux-session; then
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

if is-executable code && [[ -n "$VSCODE_PID" ]]; then
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

setopt completealiases

alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'
alias history='history -i 1'
alias du='du -h'
alias df='df -h'
alias free='free -t -m'
alias -g L="| $PAGER"
is-executable bat && alias -g B="| bat"
alias dirs='dirs -v'

alias puts='print -l'

alias memo='$EDITOR ~/.memo.md'

is-executable nvim && alias vim=nvim
is-executable vim && alias vi=vim

if is-executable dircolors && [[ -f ~/.dircolors ]]; then
  eval $(dircolors -b ~/.dircolors)
  alias ls='ls -F --color=auto'
fi

if is-executable gcal; then
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

# dot
export DOT_REPO=https://github.com/skauro/dotfiles.git
export DOT_DIR=$HOME/.dotfiles

# asdf
if [[ -f /opt/brew/opt/asdf/asdf.sh ]]; then
  source /opt/brew/opt/asdf/asdf.sh
fi

if [[ -f /opt/brew/etc/bash_completion.d/asdf.bash ]]; then
  source /opt/brew/etc/bash_completion.d/asdf.bash
fi


if is-executable gosh; then
  export SCHEME_LIBRARY_PATH=/opt/brew/opt/slib/lib/slib
  rlwrap gosh
fi

[[ -f $ZDOTDIR/.zshrc.local ]] && source $ZDOTDIR/.zshrc.local || :
