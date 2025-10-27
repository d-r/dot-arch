# Install package(s)
def --wrapped in  [...$args] {
    if ($args | is-empty) {
        paru -S (paru -Slq | fzf --preview 'paru -Si {1}' --preview-window 'down:50%:wrap')
    } else {
        paru -S ...$args
    }
}

# Uninstall a package
alias un = paru -Rs

# Update outdated packages
alias up = paru

# List outdated packages
alias out = paru -Qu

# Sync package database
alias syn = paru -Fy

# Reboot the system without going back to BIOS
alias soft-reboot = systemctl soft-reboot

# Add the current user to a group
def add-me-to [$group] {
    sudo usermod -aG $group $env.USER
}
