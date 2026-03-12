export use base.nu *
export use _wm.nu *
export use _mime.nu *

export-env {
    let $repos = "~/repos"
    let $clones = "~/clones"

    $env.DOT_REPO_DIR = ($repos | path expand)
    $env.DOT_CLONE_DIR = ($clones | path expand)
    $env.DOT_REPOS = [
        "~/dot"
        "~/churn"
        $"($repos)/*"
        $"($clones)/*"
    ] | each { glob $in } | flatten

    $env.DOT_LINK_FILE = ("~/churn/links.toml" | path expand)
}
