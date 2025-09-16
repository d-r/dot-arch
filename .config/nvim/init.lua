local kit = require "kit"

--------------------------------------------------------------------------------
-- OPTIONS

-- Set leader key to <space>
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- kitty has builtin Nerd Font support
vim.g.have_nerd_font = true

-- Disable swap file, as it's just annoying
vim.opt.swapfile = false

-- Enable relative line numbers
vim.o.number = true
vim.o.relativenumber = true

-- Enable gutter space for LSP info on the left
vim.o.signcolumn = 'yes'

-- Perform case insensitive search, *unless* the search term contains at least
-- one uppercase character
vim.o.ignorecase = true
vim.o.smartcase = true

-- Don't show the current mode, since it's already in the status line provided
-- by mini.statusline
vim.o.showmode = false

-- Sync clipboard between the OS and Neovim
-- Schedule the setting after `UiEnter` because it can increase startup-time
vim.schedule(function()
  vim.o.clipboard = "unnamedplus"
end)

-- Enable LSPs
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

local plugins = {
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
  -- I only use the picker. It's better than mini.pick.
  -- https://github.com/folke/snacks.nvim
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
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

  -- Jump around
  -- https://github.com/folke/flash.nvim
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
  },

  -- Extend f, F, t, T to jump across multiple lines
  -- https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-jump.md
  {
    "nvim-mini/mini.jump",
    opts = {},
  },

  -- Minimal and fast statusline with opinionated default look
  -- https://github.com/nvim-mini/mini.statusline
  {
    "nvim-mini/mini.statusline",
    dependencies = {
      "nvim-mini/mini.icons"
    },
    config = function()
      local sl = require "mini.statusline"
      sl.setup()
      sl.section_location = function()
        return "%2l:%-2v" -- line:column
      end
    end
  },

  -- Show next key clues (like which-key)
  -- https://github.com/nvim-mini/mini.clue
  {
    'nvim-mini/mini.clue',
    config = function()
      local mc = require('mini.clue')
      mc.setup {
        triggers = {
          -- Leader
          { mode = 'n', keys = '<Leader>' },
          { mode = 'x', keys = '<Leader>' },

          -- Built-in completion
          { mode = 'i', keys = '<C-x>' },

          -- Marks
          { mode = 'n', keys = "'" },
          { mode = 'n', keys = '`' },
          { mode = 'x', keys = "'" },
          { mode = 'x', keys = '`' },

          -- Registers
          { mode = 'n', keys = '"' },
          { mode = 'x', keys = '"' },
          { mode = 'i', keys = '<C-r>' },
          { mode = 'c', keys = '<C-r>' },

          -- Window commands
          { mode = 'n', keys = '<C-w>' },

          -- g
          { mode = 'n', keys = 'g' },
          { mode = 'x', keys = 'g' },

          -- z
          { mode = 'n', keys = 'z' },
          { mode = 'x', keys = 'z' },

          -- [
          { mode = 'n', keys = '[' },
          { mode = 'x', keys = '[' },

          -- ]
          { mode = 'n', keys = ']' },
          { mode = 'x', keys = ']' },
        },
        clues = {
          mc.gen_clues.builtin_completion(),
          mc.gen_clues.marks(),
          mc.gen_clues.registers(),
          mc.gen_clues.windows(),
          mc.gen_clues.g(),
          mc.gen_clues.z(),
        },
        window = {
          delay = 100, -- Milliseconds
          config = {
            width = "auto",
          },
        },
      }
    end,
  },

  -- Treesitter integration
  -- https://github.com/nvim-treesitter/nvim-treesitter
  --
  -- You should have these packages installed on the system:
  -- https://archlinux.org/groups/x86_64/tree-sitter-grammars/
  -- https://archlinux.org/packages/extra/x86_64/tree-sitter-cli/
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPre", "BufNewFile" },
    main = "nvim-treesitter.configs", -- Module to use for opts
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
      auto_install = true,
      highlight = {
        enable = true,
      },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<M-o>",
          node_incremental = "<M-o>",
          scope_incremental = false, -- TODO: What is this?
          node_decremental = "<M-i>",
        },
      },
    },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "nvim-treesitter/nvim-treesitter-context", -- TODO: What is this?
    }
  },

  -- Syntax aware text-objects, select, move, swap, and peek support
  -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    lazy = true,
    main = "nvim-treesitter.configs", -- Module to use for opts
    opts = {
      textobjects = {
        select = {
          enable = true,
          lookahead = true, -- TODO: What is this?
          keymaps = {
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
          set_jumps = true, -- Write to jump list
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
            ["<leader>na"] = "@parameter.inner",
            ["<leader>nf"] = "@function.outer",
          },
          swap_previous = {
            ["<leader>pa"] = "@parameter.inner",
            ["<leader>pf"] = "@function.outer",
          },
        },
      },
    },
  },

  -- Properly configures Lua Language Server for editing the Neovim config
  -- https://github.com/folke/lazydev.nvim
  {
    "folke/lazydev.nvim",
    ft = "lua", -- Only load on lua files
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },

  -- A window in the bottom right corner that displays LSP progress messages
  -- https://github.com/j-hui/fidget.nvim
  {
    "j-hui/fidget.nvim",
    opts = {}
  },

  -- Magit for nvim
  -- https://github.com/NeogitOrg/neogit
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",  -- Required for... *something*
      "sindrets/diffview.nvim", -- Diff integration
      "folke/snacks.nvim",      -- Picker
    },
  },

  -- Pin buffers
  -- https://github.com/iofq/dart.nvim
  {
    'iofq/dart.nvim',
    opts = {}
  }
}

local theme = "tokyonight-night"

kit.init_lazy {
  spec = plugins,
  install = { colorscheme = { theme } } -- Theme to use when installing plugins
}

vim.cmd.colorscheme(theme)

--------------------------------------------------------------------------------
-- BINDS

local bind = kit.bind
local picker = Snacks.picker
local lsp = vim.lsp.buf

-- <leader>
bind("<leader><space>", "n", "Smart find files", picker.smart)
bind("<leader>f", "n", "Files", picker.files)
bind("<leader>b", "n", "Buffers", picker.buffers)
bind("<leader>s", "n", "Symbols", picker.lsp_symbols)
bind("<leader>S", "n", "Workspace symbols", picker.lsp_workspace_symbols)
bind("<leader>r", "n", "Rename symbol", lsp.rename)
bind("<leader>a", "nx", "Perform code action", lsp.code_action)
bind("<leader>=", "n", "Format buffer", lsp.format)
bind("<leader>g", "n", "Neogit", ":Neogit kind=replace<CR>")

-- g (goto)
bind("gd", "n", "Goto definition", picker.lsp_definitions)
bind("gD", "n", "Goto declaration", picker.lsp_declarations)
bind("gy", "n", "Goto type definition", picker.lsp_type_definitions)
bind("gr", "n", "Goto references", picker.lsp_references, { nowait = true })
bind("gi", "n", "Goto implementation", picker.lsp_implementations)

-- s ("seek" with flash)
bind("s", "nxo", "Flash", function() require("flash").jump() end)
bind("S", "nxo", "Flash treesitter", function() require("flash").treesitter() end)
bind("r", "o", "Remote flash", function() require("flash").remote() end)
bind("R", "ox", "Treesitter search", function() require("flash").treesitter_search() end)
bind("<c-s>", "c", "Toggle flash search", function() require("flash").toggle() end)

-- TODO: Not sure about these...
-- local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
-- bind("nxo", ";", "Repeat last move", ts_repeat_move.repeat_last_move)
-- bind("nxo", ",", "Repeat last move, reversed", ts_repeat_move.repeat_last_move_opposite)
