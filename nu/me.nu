# My stuff

#-------------------------------------------------------------------------------
# PROJECTS

# List projects
export def projects [] {
    [
        (project ~/dot)
        (project ~/brain)
        (project ~/lab)
        (project ~/vault obsidian)
        (projects-in ~/src)
    ]
    | flatten
}

def "projects-in" [$dir] {
    let $dir = ($dir | path expand)
    let $dirs = (ls $dir | where type == dir | get name)
    $dirs | each { project $in }
}

def project [$dir, $editor?] {
    let $dir = ($dir | path expand)
    {
        name: ($dir | path basename)
        dir: $dir,
        editor: "code",
    }
}

#-------------------------------------------------------------------------------
# BOOKMARKS

const $BOOKMARK_FILE = '~/brain/data/bookmarks.toml' | path expand

# List bookmarks
export def bookmarks []: nothing -> record {
    open $BOOKMARK_FILE
}

# Save bookmarks to disk
export def save-bookmarks []: record -> nothing {
    $in | to toml | save -f $BOOKMARK_FILE
}

#-------------------------------------------------------------------------------
# MIME TYPES
#
# I wanted to see what *all* of the assigned default applications are, without
# going on a treasure hunt across the file system.
#
# You can use `xdg-mime` to get the default app for one specific MIME type,
# but you can't ask it for a list of *all* defaults, as far as I can tell.
#
# So I hacked together this daft brute-force script that loops through a massive
# list of MIME types, and feeds them one-by-one into `xdg-mime query default`.
#
# I used `mimeo -m` to generate the contents of mime-types.txt.

# List MIME types
export def mime-types []: nothing -> list {
    open ~/dot/assets/mime-types.txt | lines
}

# List MIME associations (MIME type -> application)
# It will take a while.
export def mime-associations []: nothing -> table {
    (mime-types) | each { get-mime-association $in } | sort-by app
}

def get-mime-association [$type] {
    let $app = (xdg-mime query default $type)
    if ($app | is-empty) {
        null
    } else {
        {type: $type, app: $app}
    }
}
