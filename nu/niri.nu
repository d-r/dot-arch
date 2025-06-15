use kit.nu *

# Communicate with niri
export def ni [] {
    help ni
}

#-------------------------------------------------------------------------------
# ACTIONS

alias act = niri msg action

# Spawn a command
export def --wrapped "ni spawn" [...$cmd] {
    act spawn -- ...$cmd
}

# Focus the previously focused window
export def "ni focus-previous-window" [] {
    act focus-window-previous
}

# Focus a window by ID
export def "ni focus-window" [$id] {
    act focus-window --id $id
}

# Focus the previously focused workspace
export def "ni focus-previous-workspace" [] {
    act focus-workspace-previous
}

# Focus the last (and always empty) workspace
export def "ni focus-last-workspace" [] {
    let $ws = (ni workspaces | last)
    ni focus-workspace $ws.id
}

# Focus a workspace by index/name
export def "ni focus-workspace" [$ref] {
    act focus-workspace $ref
}

#-------------------------------------------------------------------------------
# QUERIES

export def --wrapped msg [...$args] {
    niri msg -j ...$args | from json
}

# Get the focused window
export def "ni focused-window" [] {
    ni windows-in-focused-workspace | where is_focused == true | first?
}

# List windows in the focused workspace
export def "ni windows-in-focused-workspace" [] {
    ni windows | where workspace_id == (ni focused-workspace).id
}

# List windows
export def "ni windows" [] {
    msg windows | sort-by id
}

# Get the focused workspace
export def "ni focused-workspace" [] {
    ni workspaces | where is_focused == true | first
}

# List workspaces
export def "ni workspaces" [] {
    msg workspaces | sort-by idx
}
