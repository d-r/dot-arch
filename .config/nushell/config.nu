const NU_LIB_DIRS = [
    ~/.config/nushell
    ~/dot/nu
    ~/lab
]

plugin add nu_plugin_formats

#-------------------------------------------------------------------------------
# SETTINGS

$env.config.show_banner = false
$env.config.use_kitty_protocol = true
$env.config.filesize.unit = "metric"

$env.PROMPT_COMMAND_RIGHT = {|| $env.CONTEXT?}

#-------------------------------------------------------------------------------
# ALIASES AND COMMANDS

use kit.nu *
use desktop-cmd.nu *
use mime-types.nu *
use hypr.nu *
use niri.nu *

alias c = clear
alias e = ^($env.EDITOR)
alias hx = helix
alias l = eza -l --group-directories-first
alias j = just
alias t = task
alias tt = taskwarrior-tui
alias yt = yt-dlp
alias rr = rustrover

alias in = yay -S # install
alias un = yay -Rs # uninstall
alias up = yay # update

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

# zoxide init nushell | save -f zoxide.nu
source zoxide.nu

# carapace _carapace nushell | save -f carapace.nu
source carapace.nu
