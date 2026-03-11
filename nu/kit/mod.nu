export use tools.nu *
export use _wm.nu *
export use _mime.nu *
export use _churn.nu *

export-env {
    let $clone_dir = "~/co"

    $env.DOT_REPOS = [
        "~/dot"
        "~/churn"
        "~/src/*"
        $"($clone_dir)/*"
    ] | each { glob $in } | flatten

    $env.DOT_CLONE_DIR = ($clone_dir | path expand)

    $env.DOT_LINK_FILE = ("~/churn/links.toml" | path expand)
}
