#!/bin/zsh

setopt auto_resume

setopt correct
setopt print_eight_bit

unsetopt extended_glob
setopt magic_equal_subst
setopt numeric_glob_sort

autoload run-help
bindkey -e
bindkey '^?' backward-delete-char
bindkey '^M' accept-line-with-hooks
bindkey '^J' accept-line-and-open-in-pane
bindkey '^r' peco-history-search
bindkey '^x^v' peco-chdir-dirs
bindkey '^x^g' peco-chdir-ghq-list

for w in $ZDOTDIR/widgets/*(.); do
  source $w
  zle -N $w:t
done

setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushd_silent

cdpath=( ~ ~/Projects(-/N) ~/Projects/*.*(-/N) )

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
zstyle ':completion:*' cache-path $ZDOTDIR/compcache
zstyle ':completion:*' use-cache true
zstyle ':completion:*' matcher-list 'r:|[:]=* m:{a-z}={A-Z} m:{A-Z}={a-z}'

autoload -U compinit
compinit -u -d $ZDOTDIR/compdump

if whence -p vim > /dev/null; then
  EDITOR=vim
else
  EDITOR=vi
fi

export EDITOR

if whence -p lv > /dev/null; then
  PAGER=lv
  export LV=-dc
elif whence -p less > /dev/null; then
  PAGER=less
  export LESS=-im
else
  PAGER=more
fi

export PAGER
export READNULLCMD=$PAGER

setopt completealiases

unalias -m '*'

alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'
alias history='history -i 1'
alias du='du -h'
alias df='df -h'
alias free='free -t -m'
alias -g V='| view -'
alias -g L="| $PAGER"
alias -g uniq='LC_COLLATE=C uniq'
alias -g sort='LC_COLLATE=C sort'
alias -g grep='LC_COLLATE=C grep'
alias -g egrep='LC_COLLATE=C egrep'
alias -g fgrep='LC_COLLATE=C fgrep'
alias dirs='dirs -v'

alias puts='print -l'
alias port='with-subcommand port'

whence vim >/dev/null && alias vi=vim

if whence dircolors >/dev/null && [[ -f ~/.dircolors ]]; then
  eval $(dircolors -b ~/.dircolors)
  alias ls='ls -F --color=auto'
fi

if whence hub >/dev/null; then
  eval "$(hub alias -s)"
fi

autoload -U colors
colors

export GREP_COLOR=$color[cyan]
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

autoload -Uz add-zsh-hook
add-zsh-hook chpwd update-rbenv-prefix

cd .

unset LC_ALL
unset LC_COLLATE LC_CTYPE  LC_MONETARY LC_NUMERIC
export LC_TIME=C LC_MESSAGES=C
export LANG=ja_JP.UTF-8
