alias cls = clear
alias m = micro
alias v = nvim
alias ng = nvim +Neogit
alias yt = yt-dlp
alias c = cargo
alias j = just
alias lg = lazygit
alias t = task
alias ta = task add
alias tt = taskwarrior-tui

# Wrapper for yazi that changes the current working directory on exit.
# https://yazi-rs.github.io/docs/quick-start/#shell-wrapper
def --env y [...args] {
    let tmp = (mktemp -t "yazi-cwd.XXXXXX")
    yazi ...$args --cwd-file $tmp
    let cwd = (open $tmp)
    if $cwd != "" and $cwd != $env.PWD {
        cd $cwd
    }
    rm -fp $tmp
}

# Create all directories on the path to the given file
def mktrail [$file: path]: nothing -> nothing {
    mkdir ($file | path dirname)
}

# Like `touch`, but creates missing directories
def poke [$file: path]: nothing -> nothing {
    mktrail $file
    touch $file
}

# Return the current year
def year []: nothing -> string {
    (date now | format date "%Y")
}

# Return the MIT license
def mit []: nothing -> string {
    (open ~/dot/assets/mit.txt | str replace "$YEAR" (year))
}

# Save the MIT license to LICENSE
def "mit save" []: nothing -> nothing {
    (mit) | save -f LICENSE
}

# Create a new Nushell script
def nusc [$file: path]: nothing -> nothing {
    mktrail $file
    cp ~/dot/assets/script.nu $file
    chmod +x $file
}
