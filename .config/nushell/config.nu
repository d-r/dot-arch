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

$env.config.table.mode = "single" # No rounded corners
$env.config.color_config.separator = "black" # Table borders

#-------------------------------------------------------------------------------
# ENVIRONMENT

# const LS_TYPES = {
# 	file: "fi"
# 	dir: "di"
# 	exe: "ex"
# 	pipe: "pi"
# 	socket: "so"
# 	block-device: "bo"
# 	char-device: "cd"
# 	link: "ln"
# 	orphan: "or"
# }

const $BLACK = "30"
const $RED = "31"
const $GREEN = "32"
const $YELLOW = "33"
const $BLUE = "34"
const $MAGENTA = "35"
const $CYAN = "36"
const $WHITE = "37"

def ls_colors [$map: record] {
    $map
        | transpose k v
        | each { [$in.k, "=", $in.v] | str join }
        | str join ":"
}

$env.LS_COLORS = ls_colors {
	fi: $WHITE
	di: $BLUE
	ex: $GREEN
	pi: $WHITE
	so: $WHITE
	bd: $WHITE
	cd: $WHITE
	ln: $CYAN
	or: $RED
}

$env.EZA_COLORS = "reset:" ++ (ls_colors {
	da: $WHITE  # date

	uu: $WHITE  # a user that's me
	un: $YELLOW # a user that’s someone else
	uR: $RED    # a user that's root

	gu: $WHITE  # a group I'm in
	gn: $YELLOW # a group I'm not in
	gR: $RED    # a group related to root

	ur: $WHITE  # user read permissions
	gr: $WHITE  # group read permission
	tr: $WHITE  # other's read permissions
})

$env.PROMPT_COMMAND_RIGHT = {|| $env.CONTEXT?}

#-------------------------------------------------------------------------------
# ALIASES AND COMMANDS

use kit.nu *
use niri.nu *
use me.nu

alias l = eza -l --group-directories-first
alias gls = ^ls -l --file-type --group-directories-first --human-readable --color

alias c = clear
alias m = micro
alias nv = nvim
alias j = just
alias t = task
alias tt = taskwarrior-tui
alias yt = yt-dlp

alias bw = wm spawn flatpak run com.bitwig.BitwigStudio

alias in = yay -S # install
alias un = yay -Rc # uninstall
alias up = yay # update
alias cl = yay -Yc # clean

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
