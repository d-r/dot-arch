use kit.nu *

# Communicate with niri
export def wm [] {
    help wm
}

#-------------------------------------------------------------------------------
# ACTIONS

alias act = niri msg action

# Spawn a command
export def --wrapped "wm spawn" [...$cmd] {
    act spawn -- ...$cmd
}

# Spawn a command or focus existing window
export def --wrapped "wm spawn-or-focus" [$app_id, ...$cmd] {
    let $w = (wm windows | where app_id == $app_id | first?)
    if ($w | is-empty) {
        act spawn -- ...$cmd
    } else if $w.is_focused {
        wm focus-previous-window
    } else {
        wm focus-window $w.id
    }
}

# Focus the previously focused window
export def "wm focus-previous-window" [] {
    act focus-window-previous
}

# Focus a window by ID
export def "wm focus-window" [$id] {
    act focus-window --id $id
}

# Close a window by ID
export def "wm close-window" [$id] {
    act close-window --id $id
}

# Focus the previously focused workspace
export def "wm focus-previous-workspace" [] {
    act focus-workspace-previous
}

# Focus the last (and always empty) workspace
export def "wm focus-last-workspace" [] {
    let $ws = (wm workspaces | last)
    wm focus-workspace $ws.id
}

# Focus a workspace by index/name
export def "wm focus-workspace" [$ref] {
    act focus-workspace $ref
}

#-------------------------------------------------------------------------------
# QUERIES

def --wrapped msg [...$args] {
    niri msg -j ...$args | from json
}

# Get the focused window
export def "wm focused-window" [] {
    wm windows-in-focused-workspace | where is_focused == true | first?
}

# List windows in the focused workspace
export def "wm windows-in-focused-workspace" [] {
    wm windows | where workspace_id == (wm focused-workspace).id
}

# List windows
export def "wm windows" [] {
    msg windows | sort-by id
}

# Get the focused workspace
export def "wm focused-workspace" [] {
    wm workspaces | where is_focused == true | first
}

# List workspaces
export def "wm workspaces" [] {
    msg workspaces | sort-by idx
}
