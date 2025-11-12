const NU_LIB_DIRS = [
    ~/.config/nushell
    ~/dot/nu
]

use kit.nu *
use niri.nu *
use me.nu

source settings.nu
source rc.common.nu
source rc.linux.nu
source rc.arch.nu

# zoxide init nushell | save -f ~/dot/.config/nushell/zoxide.nu
source zoxide.nu

plugin add nu_plugin_formats
