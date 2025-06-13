const $ACCENT_COLOR = "#7fc8ff"
const $ACTIVE_BG_COLOR = "#1a1a1a"

# TODO: Apply theme inside of the kitty config instead?
const $THEME = {
    prompt: "#555555",
    cursor: $ACCENT_COLOR,
    matched: $ACCENT_COLOR,
    current: "#dddddd",
    current_bg: $ACTIVE_BG_COLOR,
    current_match: $ACCENT_COLOR,
    current_match_bg: $ACTIVE_BG_COLOR,
}

const $COLUMN_SEP = '\s\s+'

export def --wrapped pick [...$args]: table -> record {
    let $i = ($in | pick-index ...$args)
    $in | get $i
}

export def --wrapped pick-index [...$args, --column: string]: table -> int {
    let $nth = if ($column | is-empty) {
        ""
    } else {
        ($in | index-of-column $column) + 1
    }

    let $theme = $THEME | dict-str ":" ","

    let $choice = $in | table-str | (
        sk
        --no-info
        --no-sort
        --delimiter $COLUMN_SEP
        --with-nth "2.."
        --nth $nth
        --color $theme
    )

    $choice | split row -r $COLUMN_SEP | first | into int
}

#-------------------------------------------------------------------------------
# UTILITIES

export def dict-str [$kv_sep: string, $pair_sep: string]: record -> string {
    $in
        | transpose k v
        | each { [$in.k, $kv_sep, $in.v] | str join }
        | str join $pair_sep
}

export def table-str []: table -> string {
    $in | indexed | to tsv --noheaders | column -t -s "\t"
}

# Rename the special `#` column to `index`, to make it part of the table proper.
# See https://www.nushell.sh/book/working_with_tables.html#the-index-column
export def indexed []: table -> table {
    $in | enumerate | flatten
}

export def index-of-column [$name: string]: table -> int {
    $in | columns | index-of $name
}

export def index-of [$v]: list -> int {
    enumerate | where item == $v | get index.0
}
