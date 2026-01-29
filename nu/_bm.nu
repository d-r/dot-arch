const $FILE = ('~/data/bookmarks.toml' | path expand)

export def bm [] {
    bm open
}

export def "bm open" []: nothing -> nothing {
    xdg-open (bm read | pick-item)
}

export def "bm qb-open" []: nothing -> nothing {
    (bm read | pick-item) o> /tmp/qb-url
}

export def "bm save" [$url: string]: nothing -> nothing {
    let $marks = bm read
    let $key = ($marks | key-of $url) | default ""

    let $key = gum input --placeholder $"Key for ($url)" --value $key

    if ($key | is-not-empty) {
        ($marks | upsert $key $url) | bm write
        notify-send $"Bookmark ($key) saved"
    }
}

export def "bm read" []: nothing -> record {
    open $FILE
}

export def "bm write" []: record -> nothing {
    $in | to toml | save -f $FILE
}
