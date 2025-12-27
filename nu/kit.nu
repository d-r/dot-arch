# A set of useful tools

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
    let $row = (kv | pick --column k --no-headers)
    $row.v
}

export def pick [...$columns: string, --column: string, --no-headers]: table -> record {
    let $menu = $in | select ...$columns | indexed
    let $menu_str = $menu | table-str --no-headers=($no_headers)
    let $hl = if $no_headers { 0 } else { 1 }
    let $choice = if ($column | is-empty) {
        $menu_str | pick-line $hl
    } else {
        let $n = ($menu | index-of-column $column) + 1
        $menu_str | pick-line $hl --nth $n
    }
    let $i = $choice | split row -r $COLUMN_SEP | first | into int
    $in | get $i
}

def --wrapped pick-line [$hl, ...$args]: string -> string {
    fzf --header-lines $hl --delimiter $COLUMN_SEP --with-nth 2.. ...$args
}

export def table-str [--no-headers]: table -> string {
    let $tsv = $in | to tsv --noheaders=($no_headers)
    $tsv | column --table --separator "\t" --output-separator $COLUMN_SEP
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

#------------------------------------------------------------------------------
# FILES

# Create all directories on the path to the given file
export def mktrail [$file: path]: nothing -> nothing {
    mkdir ($file | path dirname)
}

# Like `touch`, but creates missing directories
export def poke [$file: path]: nothing -> nothing {
    mktrail $file
    touch $file
}
