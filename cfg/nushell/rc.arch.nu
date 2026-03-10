alias l = eza -l --group-directories-first
alias xo = xdg-open

alias sc = systemctl
alias scu = systemctl --user
alias jc = journalctl

alias insert = sudo mount /dev/sda2 /media
alias eject = sudo umount /media

const $RUSTROVER = (
    "~/.local/share/JetBrains/Toolbox/apps/rustrover/bin/rustrover" | path expand
)

# RustRover
def --wrapped rr [$path = ".", ...$rest] {
    wm spawn $RUSTROVER ($path | path expand) ...$rest
}

# Reboot the system without going back to BIOS
alias soft-reboot = systemctl soft-reboot

# Add the current user to a group
def add-me-to [$group] {
    sudo usermod -aG $group $env.USER
}
