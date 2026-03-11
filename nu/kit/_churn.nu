const $REPOS = [
    "~/dot"
    "~/churn"
    "~/src/*"
    "~/co/*"
]

const $LINK_FILE = ("~/churn/links.toml" | path expand)

export def churn [] {
    help churn
}

export def "churn repos" []: nothing -> list {
    $REPOS | each { glob $in } | flatten
}

export def "churn links" []: nothing -> record {
    open $LINK_FILE
}

export def "churn save-links" [$links: record]: nothing -> nothing {
    $links | to toml | save -f $LINK_FILE
}
