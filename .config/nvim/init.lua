local kit = require "kit"

--------------------------------------------------------------------------------
-- OPTIONS

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = 'yes'
vim.o.ignorecase = true
vim.o.smartcase = true

-- Sync clipboard between OS and Neovim.
-- Schedule the setting after `UiEnter` because it can increase startup-time.
-- Remove this option if you want your OS clipboard to remain independent.
-- See `:help "clipboard"`
vim.schedule(function()
  vim.o.clipboard = "unnamedplus"
end)

vim.lsp.enable {
  "bashls",
  "clangd",
  "janet_lsp",
  "lua_ls",
  "marksman",
  "nushell",
  "rust_analyzer",
  "wgsl_analyzer",
  "zk",
}

--------------------------------------------------------------------------------
-- PLUGINS

kit.init_lazy {
  -- Theme
  -- https://github.com/folke/tokyonight.nvim
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      styles = {
        comments = { italic = false },
        keywords = { italic = false },
      },
    },
  },

  -- Snacks - a collection of small quality-of-life plugins
  -- https://github.com/folke/snacks.nvim
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      picker = {
        enabled = true,
        sources = {
          files = {
            hidden = true,
          },
        },
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

  -- Jump around
  -- https://github.com/folke/flash.nvim
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {},
    -- stylua: ignore
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
        "wgsl",
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

  -- Properly configures Lua Language Server for editing the Neovim config
  -- https://github.com/folke/lazydev.nvim
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },

  -- A window in the bottom right corner that displays LSP progress messages
  -- https://github.com/j-hui/fidget.nvim
  { "j-hui/fidget.nvim", opts = {} },

  -- Magit for nvim
  -- https://github.com/NeogitOrg/neogit
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",  -- required
      "sindrets/diffview.nvim", -- optional - Diff integration
      "folke/snacks.nvim",      -- optional
    },
  },
}

vim.cmd.colorscheme "tokyonight-night"

--------------------------------------------------------------------------------
-- BINDS

local bind = vim.keymap.set
local picker = Snacks.picker
local lsp = vim.lsp.buf

-- LEADER - navigation
bind("n", "<leader><space>", picker.smart, { desc = "Smart find files" })
bind("n", "<leader>f", picker.files, { desc = "Files" })
bind("n", "<leader>b", picker.buffers, { desc = "Buffers" })
bind("n", "<leader>s", picker.lsp_symbols, { desc = "Symbols" })
bind("n", "<leader>S", picker.lsp_workspace_symbols, { desc = "Workspace symbols" })

-- LEADER - actions
bind("n", "<leader>r", lsp.rename, { desc = "Rename symbol" })
bind({ "n", "x" }, "<leader>a", lsp.code_action, { desc = "Perform code action" })
bind("n", "<leader>=", lsp.format, { desc = "Format buffer" })
bind("n", "<leader>g", ":Neogit kind=replace<CR>", { desc = "Neogit" })

-- GOTO
bind("n", "gd", picker.lsp_definitions, { desc = "Goto definition" })
bind("n", "gD", picker.lsp_declarations, { desc = "Goto declaration" })
bind("n", "gy", picker.lsp_type_definitions, { desc = "Goto type definition" })
bind("n", "gr", picker.lsp_references, { desc = "Goto references", nowait = true })
bind("n", "gi", picker.lsp_implementations, { desc = "Goto implementation" })

-- FLASH
bind({ "n", "x", "o" }, "s", function() require("flash").jump() end, { desc = "Flash" })
bind({ "n", "x", "o" }, "S", function() require("flash").treesitter() end, { desc = "Flash treesitter" })
bind("o", "r", function() require("flash").remote() end, { desc = "Remote flash" })
bind({ "o", "x" }, "r", function() require("flash").treesitter_search() end, { desc = "Treesitter search" })
bind("c", "<c-s>", function() require("flash").toggle() end, { desc = "Toggle flash search" })
