-- Much of this was lifted from:
-- https://github.com/nvim-lua/kickstart.nvim/blob/master/init.lua

-- Set <space> as the leader key
-- See `:help mapleader`
-- NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Enable Nerd Font icons
vim.g.have_nerd_font = true

-- Enable relative line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Enable mouse mode
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim
-- Schedule the setting after `UiEnter` because it can increase startup-time
-- See `:help 'clipboard'`
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- Persist undo history between sessions
vim.opt.undofile = true

-- Case-insensitive searching unless \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Open new horizontal split to the right, and vertical split below
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Highlight the line the cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor
vim.opt.scrolloff = 10
