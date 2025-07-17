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

# Be verbose. I like getting feedback on my actions.
alias cp='cp -v'
alias mv='mv -v'
alias rm='rm -v'
alias ln='ln -v'

alias c='clear'
alias ls='ls -l -F --group-directories-first --si --color'
alias j='just'
alias t='task'
alias yt='yt-dlp'
alias qb='qutebrowser'

alias e=$EDITOR
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
# EXTENSIONS

# Completions
# https://carapace.sh/
source <(carapace _carapace)

# The `z` command - better `cd`
# https://github.com/ajeetdsouza/zoxide
eval "$(zoxide init zsh)"

# Syntax highlighting of commands
# https://github.com/zsh-users/zsh-syntax-highlighting/tree/master
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
