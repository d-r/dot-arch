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

# Like `touch`, but creates missing directories
def poke [$p: path]: nothing -> nothing {
	let $p = ($p | path expand)
	mkdir ($p | path dirname)
	touch $p
}

# Returns the current year
def year []: nothing -> string {
    (date now | format date "%Y")
}

# Returns the MIT license
def mit []: nothing -> string {
    (open ~/dot/assets/mit.txt | str replace "%YEAR" (year))
}

# Saves the MIT license to LICENSE
def "mit save" []: nothing -> nothing {
    (mit) | save -f LICENSE
}
