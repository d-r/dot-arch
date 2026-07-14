export use base.nu *
export use _wm.nu *
export use _mime.nu *

export-env {
    $env.DOT_LINK_FILE = ("~/churn/links.yaml" | path expand)
    $env.DOT_SNIPPET_FILE = ("~/churn/snippets.yaml" | path expand)
}
