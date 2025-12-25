alias l = ^ls -lAF --group-directories-first --si --color
alias tree = ^tree -F --dirsfirst --noreport
alias xo = xdg-open

alias sc = systemctl
alias jc = journalctl

const $RUSTROVER = (
    "~/.local/share/JetBrains/Toolbox/apps/rustrover/bin/rustrover" | path expand
)

# RustRover
def --wrapped rr [$path = ".", ...$rest] {
    wm spawn $RUSTROVER ($path | path expand) ...$rest
}
