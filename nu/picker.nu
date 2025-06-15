use ~/dot/nu/kit.nu *

const $COLUMN_SEP = "\t"

export def pick [...$columns: string, --match-column: string]: table -> record {
    let $nth = if ($match_column | is-empty) {
        ""
    } else {
        ($in | index-of-column $match_column) + 1
    }
    let $choice = $in | select ...$columns | indexed | table-str | (
        sk
        --delimiter $COLUMN_SEP
        --with-nth 2.. # Exclude the index column
        --nth $nth
    )
    let $i = $choice | split row -r $COLUMN_SEP | first | into int
    $in | get $i
}

export def table-str []: table -> string {
    $in | to tsv --noheaders | column --table --separator "\t" --output-separator $COLUMN_SEP
}
