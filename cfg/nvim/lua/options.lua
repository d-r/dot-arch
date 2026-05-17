-- Set <leader> key to <space>.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Enable RGB true color support.
vim.opt.termguicolors = true

-- Use the system clipboard.
vim.opt.clipboard = "unnamedplus"

-- Disable the swap file as it's a source of pointless error messages.
vim.opt.swapfile = false

-- Auto reload a file when it changes on disk.
vim.opt.autoread = true

-- Persist undo history to disk.
vim.opt.undofile = true

-- Enable gutter space for LSP info.
vim.opt.signcolumn = "yes"

-- Enable relative line numbers.
vim.opt.number = true
vim.opt.relativenumber = true

-- Highlight the current line.
vim.opt.cursorline = true

-- Minimum number of lines and columns to keep around the cursor.
vim.opt.scrolloff = 4
vim.opt.sidescrolloff = 8

-- Indent using two spaces.
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.autoindent = true
vim.opt.smartindent = true

-- Open new vertical split below.
vim.opt.splitbelow = true

-- Open new horizontal split on the right.
vim.opt.splitright = true

-- Perform case-insensitive search unless there are capitals in the search string.
vim.opt.ignorecase = true
vim.opt.smartcase = true

