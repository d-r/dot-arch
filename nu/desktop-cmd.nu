use kit.nu *
use picker.nu *
use niri.nu *

# Read .desktop files
export def desktop [] {} {
    help desktop
}

# List GUI applications
export def "desktop apps" []: nothing -> table {
    desktop entries
        | where ($it.type == "Application" and $it.is_cli == false)
        | reject type is_cli
}

# List relevant entries found on the system
export def "desktop entries" []: nothing -> table {
    gather [
        (desktop entries-in ~/.local/share/applications)
        (desktop entries-in /usr/share/applications)
    ]
}

# List all entries found inside of a folder
export def "desktop entries-in" [$dir_path: string]: nothing -> table {
    let $p = ($dir_path | path expand | path join "*.desktop")
    glob $p | each { desktop open $in }
}

# Open a .desktop file and parse it into a record
export def "desktop open" [$path: string]: nothing -> record {
    let $e = (open $path | from ini | get "Desktop Entry")
    {
        name: $e.Name
        comment: ($e.Comment? | default "")
        type: $e.Type
        is_cli: (($e.Terminal? | default "false") | into bool)
        desktop_file: $path
    }
}
