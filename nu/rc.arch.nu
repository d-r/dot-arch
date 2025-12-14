# Install package(s)
def --wrapped in [...$args] {
    if ($args | is-empty) {
        # Use pacman to list packages, as `paru -Slq` falls apart and starts
        # printing garbage.
        # TODO: Handle AUR packages.
        paru -S (pacman -Slq | fzf --preview 'paru -Si {}' --preview-window 'down:50%:wrap')
    } else {
        paru -S ...$args
    }
}

# Uninstall package(s)
def --wrapped un [...$args] {
    if ($args | is-empty) {
        # -Qe = list packages that were explicitly installed
        paru -Rs (paru -Qeq | fzf --preview 'paru -Si {}' --preview-window 'down:50%:wrap')
    } else {
        paru -Rs ...$args
    }
}

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
