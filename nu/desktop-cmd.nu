use kit.nu *
use niri.nu *

# Read .desktop files
export def desktop [] {} {
    help desktop
}

# List GUI applications
export def "desktop apps" []: nothing -> table {
    [
        (desktop entries-in ~/.local/share/applications)
        (desktop entries-in /usr/share/applications)
    ]
    | flatten
    | where ($it.type == "Application" and $it.is_cli == false)
    | reject type is_cli
    | uniq-by name
    | sort-by name
}

# List all entries found inside of a folder
export def "desktop entries-in" [$dir_path: string]: nothing -> table {
    glob ($dir_path | path join "*.desktop") | each { desktop open $in }
}

# Open a .desktop file and parse it into a record
export def "desktop open" [$path: string]: nothing -> record {
    let $e = (open $path | from ini | get "Desktop Entry")
    {
        name: $e.Name
        comment: ($e.Comment? | default "")
        type: $e.Type
        is_cli: ($e.Terminal? | default "false" | into bool)
        desktop_file: $path
    }
}
