-- Unbind Ctrl+Z to avoid constantly suspending Neovim by accident.
vim.keymap.set({ "n", "i", "v" }, "<C-z>", "<Nop>")
