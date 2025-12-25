alias l = ^ls -lAF --group-directories-first --si --color
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

# Install package(s)
def --wrapped in [...$args] {
    if ($args | is-empty) {
        yay -S (yay -Slq | fzf --preview 'yay -Si {}' --preview-window 'down:50%:wrap')
    } else {
        yay -S ...$args
    }
}

# Uninstall package(s)
def --wrapped un [...$args] {
    if ($args | is-empty) {
        # -Qe = list packages that were explicitly installed
        yay -Rs (yay -Qeq | fzf --preview 'yay -Si {}' --preview-window 'down:50%:wrap')
    } else {
        yay -Rs ...$args
    }
}

# Update outdated packages
alias up = yay

# List outdated packages
alias out = yay -Qu

# Sync package database
alias syn = yay -Fy

# Reboot the system without going back to BIOS
alias soft-reboot = systemctl soft-reboot

# Add the current user to a group
def add-me-to [$group] {
    sudo usermod -aG $group $env.USER
}
