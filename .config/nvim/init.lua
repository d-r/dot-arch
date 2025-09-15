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
    event = { "BufReadPre", "BufNewFile" },
    main = "nvim-treesitter.configs", -- Sets module to use for opts
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
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<M-k>",
          node_incremental = "<M-k>",
          scope_incremental = false,
          node_decremental = "<M-j>",
        },
      },
    },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "nvim-treesitter/nvim-treesitter-context",
    }
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    lazy = true,
    main = "nvim-treesitter.configs", -- Sets module to use for opts
    opts = {
      textobjects = {
        select = {
          enable = true,
          -- Automatically jump forward to textobj, similar to targets.vim
          -- TODO: Find out what that means.
          lookahead = true,

          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ["a="] = { query = "@assignment.outer", desc = "Select outer part of assignment" },
            ["i="] = { query = "@assignment.inner", desc = "Select inner part of assignment" },
            ["l="] = { query = "@assignment.lhs", desc = "Select left side of assignment" },
            ["r="] = { query = "@assignment.rhs", desc = "Select right side of assignment" },

            ["aa"] = { query = "@parameter.outer", desc = "Select outer part of parameter/argument" },
            ["ia"] = { query = "@parameter.inner", desc = "Select inner part of parameter/argument" },

            ["af"] = { query = "@function.outer", desc = "Select function" },
            ["if"] = { query = "@function.inner", desc = "Select function body" },

            ["ac"] = { query = "@class.outer", desc = "Select class" },
            ["ic"] = { query = "@class.inner", desc = "Select class body" },
          },
        },

        move = {
          enable = true,
          set_jumps = true, -- Whether to set jumps in the jumplist
          goto_next_start = {
            ["]f"] = { query = "@function.outer", desc = "Next function" },
            ["]t"] = { query = "@class.outer", desc = "Next type" },
          },
          goto_previous_start = {
            ["[f"] = { query = "@function.outer", desc = "Previous function" },
            ["[t"] = { query = "@class.outer", desc = "Previous type" },
          },
        },

        swap = {
          enable = true,
          swap_next = {
            ["<leader>na"] = "@parameter.inner", -- swap parameters/argument with next
            ["<leader>nf"] = "@function.outer",  -- swap function with next
          },
          swap_previous = {
            ["<leader>pa"] = "@parameter.inner", -- swap parameters/argument with prev
            ["<leader>pf"] = "@function.outer",  -- swap function with previous
          },
        },
      },
    },
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

-- TODO: Not sure about these...
-- local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
-- bind("nxo", ";", "Repeat last move", ts_repeat_move.repeat_last_move)
-- bind("nxo", ",", "Repeat last move, reversed", ts_repeat_move.repeat_last_move_opposite)
