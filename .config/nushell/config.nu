const NU_LIB_DIRS = [
    ~/.config/nushell
    ~/dot/nu
]

use base.nu *
use niri.nu *
use me.nu

source settings.nu
source rc.common.nu
source rc.linux.nu
source rc.arch.nu
source ~/.cache/zoxide.nu

plugin add nu_plugin_formats
