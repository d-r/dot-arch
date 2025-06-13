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

export def pick-value []: record -> any {
    let $menu = $in | transpose | table-str
    let $choice = $menu | pick-line --nth 1 --delimiter $COLUMN_SEP
    $choice | split row -r $COLUMN_SEP | get 1
}

export def --wrapped pick-line [...$args]: string -> string {
    let $theme = $THEME | dict-str ":" ","
    $in | sk --color=($theme) --reverse --no-info ...$args
}

export def table-str []: table -> string {
    $in | to tsv --noheaders | column -t -s "\t"
}

export def dict-str [$kv_sep: string, $pair_sep: string]: record -> string {
    $in
        | transpose k v
        | each { [$in.k, $kv_sep, $in.v] | str join }
        | str join $pair_sep
}
