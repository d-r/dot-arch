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

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system {
    "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath
  }
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Manage plugins
require("lazy").setup {
  spec = {
    -- Theme
    -- https://github.com/folke/tokyonight.nvim
    {
      "folke/tokyonight.nvim",
      lazy = false,
      priority = 1000,
      config = function()
        require('tokyonight').setup {
          styles = {
            comments = { italic = false },
            keywords = { italic = false },
          },
        }
        vim.cmd.colorscheme "tokyonight-night"
      end
    },

    -- Snacks - a collection of small quality-of-life plugins
    -- https://github.com/folke/snacks.nvim
    {
      "folke/snacks.nvim",
      priority = 1000,
      lazy = false,
      ---@type snacks.Config
      opts = {
        dashboard = { enabled = true },
        picker = { enabled = true },
        input = { enabled = true },
        notifier = { enabled = true },
        notify = { enabled = true },
        bigfile = { enabled = true },
        quickfile = { enabled = true },
        indent = { enabled = true },
        scope = { enabled = true },
      },
      keys = {
        { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart find files" },
        { "<leader>f", function() Snacks.picker.files() end, desc = "Find files" },
        { "<leader>b", function() Snacks.picker.buffers() end, desc = "Buffers" },
        { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },
      },
    }
  },

  -- Theme that will be used when installing plugins
  install = { colorscheme = { "tokyonight-night" } },
}
