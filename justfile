set shell := ["nu", "-c"]

# Install (create/update symlinks)
in:
    stow -t ~ -v 2 -R .

# Uninstall (delete symlinks)
un:
    stow -t ~ -v 2 -D .

# Commit update to .common submodule
bump:
    git add .common
    git commit -m 'Bump .common'
