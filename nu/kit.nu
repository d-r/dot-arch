# As set of useful tools

export alias first? = try { first }

export alias alst? = try { last }

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
