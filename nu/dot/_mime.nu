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

export def mime [] {
    help mime
}

# List MIME types
export def "mime t" []: nothing -> list {
    open ~/dot/assets/mime-types.txt | lines
}

# List MIME associations (MIME type -> application)
# It will take a while.
export def "mime a" []: nothing -> table {
    (mime t) | each { get-association $in } | sort-by app
}

def get-association [$type] {
    let $app = (xdg-mime query default $type)
    if ($app | is-empty) {
        null
    } else {
        {type: $type, app: $app}
    }
}
