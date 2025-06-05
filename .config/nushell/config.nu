#-------------------------------------------------------------------------------
# SETTINGS

$env.config.show_banner = false
$env.config.use_kitty_protocol = true
$env.config.filesize.unit = "metric"

$env.PROMPT_COMMAND_RIGHT = ""

#-------------------------------------------------------------------------------
# ALIASES AND COMMANDS

use hy-cmd.nu *

alias c = clear
alias e = ^($env.EDITOR)
alias hx = helix
alias l = eza -al --group-directories-first
alias j = just
alias t = task
alias yt = yt-dlp
alias rr = rustrover

alias pac = sudo pacman
alias pin = sudo pacman -Sy # install
alias pun = sudo pacman -Rs # uninstall
alias pif = pacman -Si # package info

# Wrapper for yazi that changes the current working directory on exit.
# https://yazi-rs.github.io/docs/quick-start/#shell-wrapper
def --env y [...args] {
	let tmp = (mktemp -t "yazi-cwd.XXXXXX")
	yazi ...$args --cwd-file $tmp
	let cwd = (open $tmp)
	if $cwd != "" and $cwd != $env.PWD {
		cd $cwd
	}
	rm -fp $tmp
}

#-------------------------------------------------------------------------------
# THIRD-PARTY

source $"($nu.home-path)/.cargo/env.nu"

# zoxide init nushell | save -f zoxide.nu
source "zoxide.nu"

# carapace _carapace nushell | save -f carapace.nu
source "carapace.nu"
