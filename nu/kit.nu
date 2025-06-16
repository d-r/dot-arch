# As set of useful tools

export alias first? = try { first }

export alias last? = try { last }

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

export def dict-str [$kv_sep: string, $pair_sep: string]: record -> string {
    $in
        | transpose k v
        | each { [$in.k, $kv_sep, $in.v] | str join }
        | str join $pair_sep
}

# Because this:
#
#    gather [
#        (entries-in ~/.local/share/application)
#        (entries-in /usr/share/applications)
#    ]
#
# ...looks better than *this*:
#
#    [
#        (entries-in ~/.local/share/application)
#        (entries-in /usr/share/applications)
#    ] | flatten
#
export def gather [$xs] {
    $xs | flatten
}
