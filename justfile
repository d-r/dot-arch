# Link dotfiles
link:
    stow -t ~ -v 2 -R .

# Unlink dotfiles
unlink:
    stow -t ~ -v 2 -D .
