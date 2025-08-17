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
$env.config.color_config.separator = "dark_gray"
$env.config.color_config.header = "dark_gray"
$env.config.color_config.row_index = "dark_gray"

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

$env.PROMPT_COMMAND_RIGHT = {|| $env.CONTEXT?}

#-------------------------------------------------------------------------------
# ALIASES AND COMMANDS

use kit.nu *
use niri.nu *
use me.nu

alias cls = clear
alias yt = yt-dlp
alias xo = xdg-open
alias say = notify-send

alias l = ^ls -lAF --group-directories-first --si --color
alias tree = ^tree -F --dirsfirst --noreport

alias m = micro
alias v = nvim
alias ng = nvim +Neogit

alias c = cargo
alias j = just

alias lg = lazygit

alias t = task
alias ta = task add
alias tt = taskwarrior-tui

alias bw = wm spawn flatpak run com.bitwig.BitwigStudio

# Install a package
alias in = paru -S

# Uninstall a package
alias un = paru -Rs

# Update outdated packages
alias up = paru

# List outdated packages
alias out = paru -Qu

# Sync package database
alias syn = paru -Fy

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

# Like `touch`, but creates missing directories
def poke [$p: path]: nothing -> nothing {
	let $p = ($p | path expand)
	mkdir ($p | path dirname)
	touch $p
}

# Returns the current year
def year []: nothing -> string {
    (date now | format date "%Y")
}

# Returns the MIT license
def mit []: nothing -> string {
    (open ~/dot/assets/mit.txt | str replace "%YEAR" (year))
}

# Saves the MIT license to LICENSE
def "mit save" []: nothing -> nothing {
    (mit) | save -f LICENSE
}

#-------------------------------------------------------------------------------
# THIRD-PARTY

source ~/.cache/zoxide.nu

# carapace _carapace nushell | save -f carapace.nu
# source carapace.nu
