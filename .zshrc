autoload -Uz compinit
compinit

PROMPT="%F{blue}%~>%f " # the current path in blue

HISTFILE=~/.zhistory
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_SAVE_NO_DUPS

alias ls='eza -al --group-directories-first'
alias c='clear'
alias j='just'
alias yt='yt-dlp'
alias e=$EDITOR
alias m='micro'
