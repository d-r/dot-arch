-- Set <space> as the leader key
-- See `:help mapleader`
-- NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Show relative line number
vim.o.number = true
vim.o.relativenumber = true

-- Sync clipboard between OS and Neovim.
-- Schedule the setting after `UiEnter` because it can increase startup-time.
-- Remove this option if you want your OS clipboard to remain independent.
-- See `:help 'clipboard'`
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

-- Case-insensitive search unless one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Enable Nerd Font icons
vim.g.have_nerd_font = true
