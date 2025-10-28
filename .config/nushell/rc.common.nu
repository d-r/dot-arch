alias m = micro
alias hx = helix
alias v = nvim
alias ng = nvim +Neogit
alias yt = yt-dlp
alias c = clear
alias j = just
alias lg = lazygit
alias resume = job unfreeze

alias cr = cargo run

alias cp = cp -v
alias mv = mv -v

alias h = harsh
alias ha = harsh ask
alias hl = harsh log
alias hs = harsh log stats

alias music = rmpc

# Set context (`task` project)
def --env cx [$context:string = ""]: nothing -> nothing {
    $env.CONTEXT = $context
}

# task
def --wrapped t [...$args] {
    let $p = $env.CONTEXT?
    if ($p | is-empty) {
        task ...$args
    } else {
        task $"pro:($p)" ...$args
    }
}

# task add
alias ta = t add

# taskwarrior-tui
alias tt = taskwarrior-tui

# Clear all nvim state
def nvim-clear [] {
    rm -rfv ($env.XDG_CACHE_HOME | path join nvim)
    rm -rfv ($env.XDG_STATE_HOME | path join nvim)
    rm -rfv ($env.XDG_DATA_HOME | path join nvim)
}

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

# Clone a git repo into ~/src
def --wrapped clone [...$args] {
    cd ~/src
    git clone ...$args
}
