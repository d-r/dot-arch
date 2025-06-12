export alias hc = hyprctl

export def hy [] {
    help hy
}

# Get the ID of the active workspace
export def "hy ws-id" []: nothing -> record {
    (hy ws) | get id
}

# Get the active workspace
export def "hy ws" []: nothing -> record {
    hc activeworkspace -j | from json
}

# Get the active window
export def "hy win" []: nothing -> record {
    hc activewindow -j | from json
}

# List workspaces
export def "hy ls-ws" []: nothing -> table {
    hc workspaces -j | from json
}

# List windows
export def "hy ls-win" []: nothing -> table {
    hc clients -j | from json
}

# Execute dispatcher
export def "hy do" [$name, ...$args] {
    hc dispatch $name ...$args
}
