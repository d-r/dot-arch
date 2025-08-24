local kit = require "kit"

--------------------------------------------------------------------------------
-- OPTIONS

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

vim.opt.swapfile = false
vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = 'yes'
vim.o.ignorecase = true
vim.o.smartcase = true

-- Don"t show the mode, since it"s already in the status line
vim.o.showmode = false

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

  -- A collection of small, focused plugins
  -- https://github.com/echasnovski/mini.nvim
  {
    'echasnovski/mini.nvim',
    config = function()
      -- File type icons
      -- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-icons.md
      require("mini.icons").setup()

      -- Statusline
      -- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-statusline.md
      local sl = require "mini.statusline"
      sl.setup()
      sl.section_location = function()
        return "%2l:%-2v" -- LINE:COLUMN
      end
    end,
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
        "vim",
        "vimdoc",
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

  -- Pin buffers
  -- https://github.com/iofq/dart.nvim
  {
    'iofq/dart.nvim',
    opts = {}
  }
}

vim.cmd.colorscheme "tokyonight-night"

--------------------------------------------------------------------------------
-- BINDS

local bind = kit.bind
local picker = Snacks.picker
local lsp = vim.lsp.buf

-- <leader>
bind("n", "<leader><space>", "Smart find files", picker.smart)
bind("n", "<leader>f", "Files", picker.files)
bind("n", "<leader>b", "Buffers", picker.buffers)
bind("n", "<leader>s", "Symbols", picker.lsp_symbols)
bind("n", "<leader>S", "Workspace symbols", picker.lsp_workspace_symbols)
bind("n", "<leader>r", "Rename symbol", lsp.rename)
bind("nx", "<leader>a", "Perform code action", lsp.code_action)
bind("n", "<leader>=", "Format buffer", lsp.format)
bind("n", "<leader>g", "Neogit", ":Neogit kind=replace<CR>")

-- g (goto)
bind("n", "gd", "Goto definition", picker.lsp_definitions)
bind("n", "gD", "Goto declaration", picker.lsp_declarations)
bind("n", "gy", "Goto type definition", picker.lsp_type_definitions)
bind("n", "gr", "Goto references", picker.lsp_references, { nowait = true })
bind("n", "gi", "Goto implementation", picker.lsp_implementations)

-- s (flash)
bind("nxo", "s", "Flash", function() require("flash").jump() end)
bind("nxo", "S", "Flash treesitter", function() require("flash").treesitter() end)
bind("o", "r", "Remote flash", function() require("flash").remote() end)
bind("ox", "R", "Treesitter search", function() require("flash").treesitter_search() end)
bind("c", "<c-s>", "Toggle flash search", function() require("flash").toggle() end)
