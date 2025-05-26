# Install (create/update symlinks)
in:
    stow -t ~ -v 2 -R .

# Uninstall (delete symlinks)
un:
    stow -t ~ -v 2 -D .
