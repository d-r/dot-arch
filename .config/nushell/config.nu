source ~/.common/nushell/config.nu

alias pac = sudo pacman
alias pin = sudo pacman -Sy # install
alias pun = sudo pacman -Rs # uninstall
alias pif = pacman -Si # package info
source $"($nu.home-path)/.cargo/env.nu"
