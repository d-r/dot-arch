export use base.nu *
export use _wm.nu *
export use _mime.nu *

export-env {
    let $repos = "~/src"
    let $clones = "~/co"

    $env.DOT_REPO_DIR = ($repos | path expand)
    $env.DOT_CLONE_DIR = ($clones | path expand)
    $env.DOT_REPOS = [
        "~/dot"
        "~/churn"
        "~/.config/harsh"
        $"($repos)/*"
        $"($clones)/*"
    ] | each { glob $in } | flatten

    $env.DOT_LINK_FILE = ("~/churn/links.yaml" | path expand)
    $env.DOT_SNIPPET_FILE = ("~/churn/snippets.yaml" | path expand)
}
