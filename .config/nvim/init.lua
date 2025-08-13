--------------------------------------------------------------------------------
-- OPTIONS

-- Set <space> as the leader key
-- See `:help mapleader`
-- NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Enable Nerd Font icons
vim.g.have_nerd_font = true

-- Don"t show the mode, since it"s already in the status line
vim.o.showmode = false

-- Show relative line numbers
vim.o.number = true
vim.o.relativenumber = true

-- Sync clipboard between OS and Neovim.
-- Schedule the setting after `UiEnter` because it can increase startup-time.
-- Remove this option if you want your OS clipboard to remain independent.
-- See `:help "clipboard"`
vim.schedule(function()
  vim.o.clipboard = "unnamedplus"
end)

-- Case-insensitive search unless one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

--------------------------------------------------------------------------------
-- PLUGINS

local plugins = {
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

  -- LSP configuration
  -- https://github.com/neovim/nvim-lspconfig
  --
  -- nvim-lspconfig is a collection of user-contributed default configurations
  -- for various LSPs. Installed as a plugin, it doesn"t actually *do* anything.
  -- If you remove the config callback, you'll get an error message on startup,
  -- as there is no setup() function to call.
  --
  -- I could use Mason to to automatically install LSPs, but I prefer to manage
  -- packages with my system package manager. My text editor has no business
  -- installing software onto my system.
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- A window in the bottom right corner that displays LSP progress messages
      -- https://github.com/j-hui/fidget.nvim
      { "j-hui/fidget.nvim", opts = {} },
    },
    opts = {
      servers = {
        clangd = {},
        rust_analyzer = {},
      },
    },
    config = function(_, opts)
      for server, settings in pairs(opts.servers) do
        vim.lsp.config(server, settings)
        vim.lsp.enable(server)
      end
    end
  },

  -- Magit for nvim
  -- https://github.com/NeogitOrg/neogit
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "sindrets/diffview.nvim", -- optional - Diff integration
      "folke/snacks.nvim",    -- optional
    },
  }
}

-- Bootstrap lazy.nvim package manager

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

require("lazy").setup {
  spec = plugins,
  -- Theme that will be used when installing plugins
  install = { colorscheme = { "tokyonight-night" } },
}

--------------------------------------------------------------------------------
-- KEYBINDINGS

local map = vim.keymap.set

-- LEADER - navigation
map("n", "<leader><space>", function() Snacks.picker.smart() end, { desc = "Smart find files" })
map("n", "<leader>f", function() Snacks.picker.files() end, { desc = "Files" })
map("n", "<leader>b", function() Snacks.picker.buffers() end, { desc = "Buffers" })
map("n", "<leader>s", function() Snacks.picker.lsp_symbols() end, { desc = "Symbols" })
map("n", "<leader>S", function() Snacks.picker.lsp_workspace_symbols() end, { desc = "Workspace symbols" })

-- LEADER - actions
map("n", "<leader>r", vim.lsp.buf.rename, { desc = "Rename symbol" })
map({ "n", "x" }, "<leader>a", vim.lsp.buf.code_action, { desc = "Perform code action" })

-- GOTO
map("n", "gd", function() Snacks.picker.lsp_definitions() end, { desc = "Goto definition" })
map("n", "gD", function() Snacks.picker.lsp_declarations() end, { desc = "Goto declaration" })
map("n", "gy", function() Snacks.picker.lsp_type_definitions() end, { desc = "Goto type definition" })
map("n", "gr", function() Snacks.picker.lsp_references() end, { desc = "Goto references", nowait = true })
map("n", "gi", function() Snacks.picker.lsp_implementations() end, { desc = "Goto implementation" })

-- FLASH
map({ "n", "x", "o" }, "s", function() require("flash").jump() end, { desc = "Flash" })
map({ "n", "x", "o" }, "S", function() require("flash").treesitter() end, { desc = "Flash treesitter" })
map("o", "r", function() require("flash").remote() end, { desc = "Remote flash" })
map({ "o", "x" }, "r", function() require("flash").treesitter_search() end, { desc = "Treesitter search" })
map("c", "<c-s>", function() require("flash").toggle() end, { desc = "Toggle flash search" })
