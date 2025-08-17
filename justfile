set shell := ["nu", "-c"]

# Install (create/update symlinks)
in:
    stow -t ~ -v 2 -R .
    zoxide init nushell | save -f ~/.cache/zoxide.nu

# Uninstall (delete symlinks)
un:
    stow -t ~ -v 2 -D .

# Create a new Nushell script in bin/
bin name:
    cp assets/script.nu bin/{{name}}
    chmod +x bin/{{name}}
