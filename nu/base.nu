# As set of useful tools

export alias say = notify-send

#------------------------------------------------------------------------------
# COLLECTIONS

export alias first? = try { first }

export alias last? = try { last }

export alias kv = transpose k v

# Rename the special `#` column to `index`, to make it part of the table proper.
# See https://www.nushell.sh/book/working_with_tables.html#the-index-column
export def indexed []: table -> table {
    enumerate | flatten
}

export def index-of-column [$name: string]: table -> int {
    columns | index-of $name
}

export def index-of [$v]: list -> int {
    enumerate | where item == $v | get index.0
}

export def key-of [$v]: record -> any {
    kv | where v == $v | get k | first?
}

#------------------------------------------------------------------------------
# PICKER

const $COLUMN_SEP = "\t"

export def pick-item []: record -> any {
    let $row = (kv | pick --match-column k)
    $row.v
}

export def pick [...$columns: string, --match-column: string]: table -> record {
    let $nth = if ($match_column | is-empty) {
        ""
    } else {
        ($in | index-of-column $match_column) + 1
    }
    let $menu = ($in | select ...$columns | indexed | table-str)
    let $choice = $menu | (
        sk
        --delimiter $COLUMN_SEP
        --with-nth 2.. # Exclude the index column
        --nth $nth
    )
    let $i = $choice | split row -r $COLUMN_SEP | first | into int
    $in | get $i
}

export def table-str []: table -> string {
    to tsv --noheaders | column --table --separator "\t" --output-separator $COLUMN_SEP
}

export def dict-str [$kv_sep: string, $pair_sep: string]: record -> string {
    kv
        | each { [$in.k, $kv_sep, $in.v] | str join }
        | str join $pair_sep
}

#------------------------------------------------------------------------------
# PREDICATES

export def is-url []: any -> bool {
    let $url = try { url parse }
    ($url | is-not-empty)
}
