alias m = micro
alias hx = helix
alias v = nvim
alias yt = yt-dlp
alias c = clear
alias j = just
alias lg = lazygit
alias resume = job unfreeze

alias cb = cargo build
alias cr = cargo run
alias cc = cargo clippy
alias cf = cargo fmt

# The magic rsync incantation I will never remember.
#
# -a = Archive mode. Shortcut for -rlptgoD. Means "copy everything recursively,
#      preserving symlinks, permissions, times, group, owner, and device files".
# -v = Verbose.
# -h = Human readable sizes.
# -P = Progressbar.
alias rs = rsync -avhP

alias h = harsh
alias ha = harsh ask
alias hl = harsh log
alias hs = harsh log stats

alias music = rmpc

alias pick-file = fzf --preview 'bat --color=always {}'

alias tree = ^tree -F --dirsfirst --noreport
alias as-tree = tree --fromfile

# Set context (`task` project)
# def --env cx [$context:string = ""]: nothing -> nothing {
#     $env.CONTEXT = $context
# }

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

# Pick a folder with fzf and hop into it
def --env hop [] {
    cd (fd -td | fzf)
}
