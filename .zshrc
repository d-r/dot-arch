#-------------------------------------------------------------------------------
# SETTINGS

autoload -Uz compinit
compinit

zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
zstyle ':completion:*:git:*' group-order 'main commands' 'alias commands' 'external commands'

HISTFILE=~/.zhistory
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_SAVE_NO_DUPS

PROMPT="%F{blue}%~>%f " # the current path in blue

#-------------------------------------------------------------------------------
# ALIASES

alias c='clear'
alias ls='eza -al --group-directories-first'
alias j='just'
alias t='task'
alias yt='yt-dlp'

alias e=$EDITOR
alias hx='helix'
alias m='micro'
alias rr='rustrover'

alias in='yay -Sy' # install
alias un='yay -Rs' # uninstall
alias up='yay' # update

# Wrapper around yazi that changes the current working directory on exit.
# https://yazi-rs.github.io/docs/quick-start/#shell-wrapper
function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    yazi "$@" --cwd-file="$tmp"
    IFS= read -r -d '' cwd < "$tmp"
    [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
    rm -f -- "$tmp"
}

#-------------------------------------------------------------------------------
# INTEGRATIONS

source <(carapace _carapace)
eval "$(zoxide init zsh)"
