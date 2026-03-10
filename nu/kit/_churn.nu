const $REPOS = [
    "~/dot"
    "~/churn"
    "~/src/*"
    "~/co/*"
]

const $BOOKMARK_FILE = ("~/churn/bookmarks.toml" | path expand)

export def churn [] {
    help churn
}

export def "churn repos" []: nothing -> list {
    $REPOS | each { glob $in } | flatten
}

export def "churn bookmarks" []: nothing -> record {
    open $BOOKMARK_FILE
}

export def "churn save-bookmarks" [$marks: record]: nothing -> nothing {
    $marks | to toml | save -f $BOOKMARK_FILE
}
