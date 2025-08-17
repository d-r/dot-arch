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
def mktrail [$p: path]: nothing -> nothing {
    mkdir ($p | path dirname)
}

# Like `touch`, but creates missing directories
def poke [$p: path]: nothing -> nothing {
    mktrail $p
	touch $p
}

# Return the current year
def year []: nothing -> string {
    (date now | format date "%Y")
}

# Return the MIT license
def mit []: nothing -> string {
    (open ~/dot/assets/mit.txt | str replace "$YEAR" (year))
}

# Create a new file
def new []: nothing -> nothing {
    help new
}

# Create a new Nushell script
def "new script" [$p: path]: nothing -> nothing {
    mktrail $p
    cp ~/dot/assets/script.nu $p
    chmod +x $p
}

# Write the MIT license to LICENSE
def "new license" []: nothing -> nothing {
    (mit) | save -f LICENSE
}
