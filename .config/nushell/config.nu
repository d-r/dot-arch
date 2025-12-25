const NU_LIB_DIRS = [~/dot/nu]

use kit.nu *
use niri.nu *
use me.nu

source rc.common.nu
source rc.arch.nu

# zoxide init nushell | save -f ~/dot/.config/nushell/zoxide.nu
source zoxide.nu

plugin add nu_plugin_formats

#-------------------------------------------------------------------------------

const $LS_TYPES = {
    file: "fi"
    dir: "di"
    exe: "ex"
    pipe: "pi"
    socket: "so"
    block-device: "bo"
    char-device: "cd"
    link: "ln"
    orphan: "or"
}

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

#-------------------------------------------------------------------------------

$env.config.show_banner = false
$env.config.use_kitty_protocol = true
$env.config.filesize.unit = "metric"

$env.config.table.mode = "single" # No rounded corners
$env.config.color_config.separator = "dark_gray"
$env.config.color_config.header = "dark_gray"
$env.config.color_config.row_index = "dark_gray"

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
