-- Set <space> as the leader key
-- See `:help mapleader`
-- NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Enable Nerd Font icons
vim.g.have_nerd_font = true

-- Don't show the mode, since it's already in the status line
vim.o.showmode = false

-- Show relative line numbers
vim.o.number = true
vim.o.relativenumber = true

-- Sync clipboard between OS and Neovim.
-- Schedule the setting after `UiEnter` because it can increase startup-time.
-- Remove this option if you want your OS clipboard to remain independent.
-- See `:help 'clipboard'`
vim.schedule(function()
  vim.o.clipboard = "unnamedplus"
end)

-- Case-insensitive search unless one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

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
      { out,                            "WarningMsg" },
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
        require("tokyonight").setup {
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
        {
          "<leader><space>",
          function() Snacks.picker.smart() end,
          desc = "Smart find files"
        },
        {
          "<leader>f",
          function() Snacks.picker.files() end,
          desc = "Find files"
        },
        {
          "<leader>b",
          function() Snacks.picker.buffers() end,
          desc = "Buffers"
        },
        {
          "<leader>/",
          function() Snacks.picker.grep() end,
          desc = "Grep"
        },
      },
    },

    -- Show available keybindings as you type
    -- https://github.com/folke/which-key.nvim
    {
      "folke/which-key.nvim",
      event = "VeryLazy",
      opts = {
        -- Single column list in the bottom right corner
        preset = "helix",
        -- Disable icons
        icons = { mappings = false },
      },
    },

    -- Collection of various small independent plugins/modules
    -- https://github.com/echasnovski/mini.nvim
    {
      "echasnovski/mini.nvim",
      config = function()
        -- File type icons
        -- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-icons.md
        require("mini.icons").setup()

        -- Minimal statusline
        -- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-statusline.md
        local statusline = require "mini.statusline"
        statusline.setup()
        statusline.section_location = function()
          -- Set location to LINE:COLUMN
          return "%2l:%-2v"
        end
      end,
    },

    -- Jump around
    -- https://github.com/folke/flash.nvim
    {
      "folke/flash.nvim",
      event = "VeryLazy",
      ---@type Flash.Config
      opts = {},
      -- stylua: ignore
      keys = {
        {
          "s",
          mode = { "n", "x", "o" },
          function() require("flash").jump() end,
          desc = "Flash"
        },
        {
          "S",
          mode = { "n", "x", "o" },
          function() require("flash").treesitter() end,
          desc = "Flash Treesitter"
        },
        {
          "r",
          mode = "o",
          function() require("flash").remote() end,
          desc = "Remote Flash"
        },
        {
          "R",
          mode = { "o", "x" },
          function() require("flash").treesitter_search() end,
          desc = "Treesitter Search"
        },
        {
          "<c-s>",
          mode = { "c" },
          function() require("flash").toggle() end,
          desc = "Toggle Flash Search"
        },
      },
    },

    -- Treesitter
    -- https://github.com/nvim-treesitter/nvim-treesitter
    --
    -- You should have these packages installed:
    -- https://archlinux.org/groups/x86_64/tree-sitter-grammars/
    -- https://archlinux.org/packages/extra/x86_64/tree-sitter-cli/
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      main = "nvim-treesitter.configs", -- Sets main module to use for opts
      opts = {
        ensure_installed = {
          "bash",
          "c",
          "cpp",
          "css",
          "diff",
          "git_config",
          "git_rebase",
          "gitcommit",
          "gitignore",
          "html",
          "ini",
          "json",
          "json5",
          "kdl",
          "lua",
          "luadoc",
          "markdown_inline",
          "markdown",
          "nu",
          "query",
          "ron",
          "rust",
          "toml",
        },
        -- Auto install languages that are not installed
        auto_install = true,
        highlight = {
          enable = true,
        },
        indent = { enable = true },
      },
      -- There are additional nvim-treesitter modules that you can use to interact
      -- with nvim-treesitter. You should go explore a few and see what interests you:
      --
      -- - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
      -- - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
      -- - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    },
  },

  -- Theme that will be used when installing plugins
  install = { colorscheme = { "tokyonight-night" } },
}
