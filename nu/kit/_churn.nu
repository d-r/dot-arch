export def churn [] {
    help churn
}

export def "churn repos" []: nothing -> list {
    $env.DOT_REPOS
}

export def "churn links" []: nothing -> record {
    open $env.DOT_LINK_FILE
}

export def "churn save-links" [$links: record]: nothing -> nothing {
    $links | to toml | save -f $env.DOT_LINK_FILE
}
