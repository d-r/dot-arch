alias l = eza -l --group-directories-first
alias pick-file = fzf --preview 'bat --color=always {}'
alias tree = ^tree -F --dirsfirst --noreport
alias as-tree = tree --fromfile

# The magic rsync incantation I will never remember.
#
# -a = Archive mode. Shortcut for -rlptgoD. Means "copy everything recursively,
#      preserving symlinks, permissions, times, group, owner, and device files".
# -v = Verbose.
# -h = Human readable sizes.
# -P = Progressbar.
alias rs = rsync -avhP

alias m = micro
alias hx = helix
alias v = nvim
alias j = just
alias lg = lazygit

alias xo = xdg-open
alias yt = yt-dlp

alias sc = systemctl
alias scu = systemctl --user
alias soft-reboot = systemctl soft-reboot
alias jc = journalctl

alias insert = sudo mount /dev/sda2 /mnt/drive
alias eject = sudo umount /mnt/drive

alias in = pk in
alias un = pk un
alias up = pk up
alias out = pk out

alias cb = cargo build
alias cr = cargo run
alias cc = cargo clippy
alias cf = cargo fmt

alias resume = job unfreeze

alias h = harsh
alias ha = harsh ask
alias hl = harsh log

# Set CPU governor mode.
def cpu [$mode: string] {
    sudo cpupower frequency-set -g $mode
    cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
}

# Plugged into AC - switch CPU governor to `performance`.
alias ac = cpu performance

# Using battery - switch CPU governor to `powersave`.
alias bt = cpu powersave

def rr [$dir = "."] {
    wm spawn ~/.local/share/JetBrains/Toolbox/apps/rustrover/bin/rustrover ($dir | path expand)
}

# Taskwarrior in context
def --wrapped t [...$args] {
    $env.DOT_TASK_CONTEXT = (wm project)
    task ...$args
}

alias ta = t add

# Wrapper for yazi that changes the current working directory on exit.
# https://yazi-rs.github.io/docs/quick-start/#shell-wrapper
def --env y [...args] {
	let tmp = (mktemp -t "yazi-cwd.XXXXXX")
	^yazi ...$args --cwd-file $tmp
	let cwd = (open $tmp)
	if $cwd != $env.PWD and ($cwd | path exists) {
		cd $cwd
	}
	rm -fp $tmp
}

# Pick a folder with fzf and hop into it.
def --env hop [] {
    cd (fd -td | fzf)
}

# Clone a third-party git repo
def --wrapped clone [...$args] {
    cd $env.DOT_CLONE_DIR
    git clone ...$args
}

# Add the current user to a group.
def add-me-to [$group] {
    sudo usermod -aG $group $env.USER
}

# Clear all nvim state.
def nvim-clear [] {
    rm -rfv ($env.XDG_CACHE_HOME | path join nvim)
    rm -rfv ($env.XDG_STATE_HOME | path join nvim)
    rm -rfv ($env.XDG_DATA_HOME | path join nvim)
}

# Return the current year.
def year []: nothing -> string {
    (date now | format date "%Y")
}

# Return the MIT license.
def mit []: nothing -> string {
    (open ~/dot/assets/mit.txt | str replace "$YEAR" (year))
}

# Save the MIT license to LICENSE.
def "mit save" []: nothing -> nothing {
    (mit) | save -f LICENSE
}

# Create a new Nushell script.
def nusc [$file: path]: nothing -> nothing {
    mktrail $file
    cp ~/dot/assets/script.nu $file
    chmod +x $file
}
