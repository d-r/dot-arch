export use base.nu *
export use _wm.nu *
export use _mime.nu *

export-env {
    let $clone_dir = "~/clones"

    $env.DOT_REPOS = [
        "~/dot"
        "~/churn"
        "~/src/*"
        $"($clone_dir)/*"
    ] | each { glob $in } | flatten

    $env.DOT_CLONE_DIR = ($clone_dir | path expand)

    $env.DOT_LINK_FILE = ("~/churn/links.toml" | path expand)
}
