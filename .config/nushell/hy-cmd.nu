export alias hc = hyprctl

export def hy [] {
    help hy
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
export def "hy lws" []: nothing -> table {
    hc workspaces -j | from json
}

# List windows
export def "hy lwin" []: nothing -> table {
    hc clients -j | from json
}

# Execute dispatcher
export def "hy do" [$name, ...$args] {
    hc dispatch $name ...$args
}
