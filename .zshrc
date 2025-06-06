autoload -Uz compinit
compinit

zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
zstyle ':completion:*:git:*' group-order 'main commands' 'alias commands' 'external commands'
source <(carapace _carapace)

HISTFILE=~/.zhistory
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_SAVE_NO_DUPS

PROMPT="%F{blue}%~>%f " # the current path in blue

alias ls='eza -al --group-directories-first'
alias c='clear'
alias j='just'
alias yt='yt-dlp'
alias e=$EDITOR
alias hx='helix'
alias m='micro'
