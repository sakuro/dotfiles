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
bindkey '^r' history-incremental-pattern-search-backward

for w in ~/.zsh.d/widgets/*(.); do
  source $w
  zle -N $w:t
done

setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushd_silent

cdpath=( ~ ~/Projects(-/N) ~/Projects/*.*(-/N) )

typeset -aU chpwd_functions
chpwd_functions+=update-tmux-default-path

setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_no_store
setopt hist_reduce_blanks
setopt hist_save_nodups
setopt share_history

HISTFILE=~/.zsh.d/history
typeset -i SAVEHIST=1000000
typeset -i HISTSIZE=1100000

setopt prompt_subst

autoload -U promptinit
promptinit
prompt sakuro

autoload -Uz select-word-style
select-word-style default
zstyle ':zle:*' word-chars " *?_-.[]~=&;!#$%^(){}<>"
zstyle ':zle:*' word-style unspecified

setopt always_to_end
setopt no_list_beep
setopt list_packed

zstyle ':completion:*' completer _expand _complete _correct
zstyle ':completion:*' ignore-parents parent pwd
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' menu select=1
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' cache-path ~/.zsh.d/compcache
zstyle ':completion:*' use-cache true
zstyle ':completion:*' matcher-list 'r:|[:]=* m:{a-z}={A-Z} m:{A-Z}={a-z}'

autoload -U compinit
compinit -u -d ~/.zsh.d/compdump

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

whence mysql5 >/dev/null && alias mysql=mysql5
alias puts='print -l'
alias wget='curl -O'

whence vim >/dev/null && alias vi=vim

if whence dircolors >/dev/null && [[ -f ~/.dircolors ]]; then
  eval $(dircolors -b ~/.dircolors)
  alias ls='ls -F --color'
fi

autoload -U colors
colors

export GREP_COLOR=$color[cyan]
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

chpwd_functions+=update-rbenv-prefix
cd .

unset LC_ALL
unset LC_COLLATE LC_CTYPE  LC_MONETARY LC_NUMERIC
export LC_TIME=C LC_MESSAGES=C
export LANG=ja_JP.UTF-8
