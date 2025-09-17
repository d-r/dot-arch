local kit = require "kit"

--------------------------------------------------------------------------------
-- OPTIONS

-- Set leader key to <space>
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- kitty has builtin Nerd Font support
vim.g.have_nerd_font = true

-- Don't show the current mode, since it's already in the statusline provided
-- by mini.statusline
vim.o.showmode = false

-- Enable gutter space for LSP info on the left
vim.o.signcolumn = 'yes'

-- Enable relative line numbers
vim.o.number = true
vim.o.relativenumber = true

-- Highlight the line that the cursor is on
vim.o.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor
vim.o.scrolloff = 10

-- Perform case insensitive search, *unless* the search term contains at least
-- one uppercase character
vim.o.ignorecase = true
vim.o.smartcase = true

-- Transform tabs to spaces
vim.o.expandtab = true

-- Disable swap file, as it's just annoying
vim.o.swapfile = false

-- Auto reload files on change
vim.o.autoread = true

-- Save undo history to disk
vim.o.undofile = true

-- Sync clipboard between the OS and Neovim
-- Schedule the setting after `UiEnter` because it can increase startup-time
vim.schedule(function()
  vim.o.clipboard = "unnamedplus"
end)

--------------------------------------------------------------------------------
-- AUTO COMMANDS (HOOKS)

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight yanked text',
  group = vim.api.nvim_create_augroup('config-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

--------------------------------------------------------------------------------
-- PLUGINS

local plugins = {
  -- LSP setup
  -- https://github.com/neovim/nvim-lspconfig
  --
  -- nvim-lspconfig is a "data only" repo. As a plugin, it doesn't actually *do*
  -- anything, and it has no setup() function.
  --
  -- All it does is provide a bunch of community contributed LSP configurations
  -- that can be enabled with vim.lsp.enable().
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = {
      -- For the picker
      "folke/snacks.nvim",

      -- A window in the bottom right corner that displays LSP progress messages
      -- https://github.com/j-hui/fidget.nvim
      { "j-hui/fidget.nvim", opts = {} },
    },
    opts = {
      servers = {
        -- rust_analyzer is not included here, to let rustaceanvim configure it
        -- the way it wants to.
        "bashls",
        "clangd",
        "janet_lsp",
        "lua_ls",
        "marksman",
        "nushell",
        "wgsl_analyzer",
        "zk",
      },
      keys = {
        -- <c>
        {
          "<c-.>",
          desc = "Code action",
          mode = { "n", "x" },
          vim.lsp.buf.code_action
        },

        -- <leader>
        {
          "<leader>a",
          desc = "Code action",
          mode = { "n", "x" },
          vim.lsp.buf.code_action
        },
        {
          "<leader>r",
          desc = "Rename symbol",
          vim.lsp.buf.rename
        },
        {
          "<leader>=",
          desc = "Format buffer",
          vim.lsp.buf.format
        },
        {
          "<leader>s",
          desc = "Symbols",
          function() Snacks.picker.lsp_symbols() end,
        },
        {
          "<leader>S",
          desc = "Workspace symbols",
          function() Snacks.picker.lsp_workspace_symbols() end,
        },

        -- g (goto)
        {
          "gd",
          desc = "Goto definition",
          function() Snacks.picker.lsp_definitions() end,
        },
        {
          "gD",
          desc = "Goto declaration",
          function() Snacks.picker.lsp_declarations() end,
        },
        {
          "gy",
          desc = "Goto type definition",
          function() Snacks.picker.lsp_type_definitions() end,
        },
        {
          "gr",
          desc = "Goto references",
          nowait = true,
          function() Snacks.picker.lsp_references() end,
        },
        {
          "gi",
          desc = "Goto implementation",
          function() Snacks.picker.lsp_implementations() end,
        },
      },
    },
    config = function(_, opts)
      vim.lsp.enable(opts.servers)

      -- Call this function when an LSP attaches to a buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('config-lsp-attach', { clear = true }),
        callback = function(event)
          kit.bind_keys(opts.keys)
        end
      })
    end,
  },

  -- Rust IDE
  -- https://github.com/mrcjkb/rustaceanvim
  {
    'mrcjkb/rustaceanvim',
    version = '^6',
    lazy = false, -- This plugin is already lazy
  },

  -- Lua Language Server setup for editing the Neovim config
  -- https://github.com/folke/lazydev.nvim
  {
    "folke/lazydev.nvim",
    ft = "lua", -- Only enable for lua files
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        -- (whatever that means)
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
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
          init_selection = "<m-o>",
          node_incremental = "<m-o>",
          scope_incremental = false, -- TODO: What is this?
          node_decremental = "<m-i>",
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

  -- Comment lines
  -- https://github.com/nvim-mini/mini.comment
  {
    "nvim-mini/mini.comment",
    opts = {
      mappings = {
        -- Toggle comment (like `gcip` - comment inner paragraph) for both
        -- Normal and Visual modes
        comment = "",

        -- Toggle comment on current line
        comment_line = "<c-/>",

        -- Toggle comment on visual selection
        comment_visual = "<c-/>",

        -- Define 'comment' textobject (like `dgc` - delete whole comment block)
        -- Works also in Visual mode if mapping differs from `comment_visual`
        textobject = "gc",
      },
    },
  },

  -- Jump around
  -- https://github.com/folke/flash.nvim
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      -- s is for "seek"
      {
        "s",
        desc = "Flash",
        mode = { "n", "x", "o" },
        function() require("flash").jump() end,
      },
      {
        "S",
        desc = "Flash treesitter",
        mode = { "n", "x", "o" },
        function() require("flash").treesitter() end,
      },
      {
        "r",
        desc = "Remote flash",
        mode = "o",
        function() require("flash").remote() end,
      },
      {
        "R",
        desc = "Treesitter search",
        mode = { "o", "x" },
        function() require("flash").treesitter_search() end,
      },
      {
        "<c-s>",
        desc = "Toggle flash search",
        mode = "c",
        function() require("flash").toggle() end,
      },
    }
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
    keys = {
      {
        "<leader><space>",
        desc = "Smart find files",
        function() Snacks.picker.smart() end,
      },
      {
        "<leader>f",
        desc = "Files",
        function() Snacks.picker.files() end,
      },
      {
        "<leader>b",
        desc = "Buffers",
        function() Snacks.picker.buffers() end,
      },
    },
  },

  -- Show next key clues (like which-key)
  -- https://github.com/nvim-mini/mini.clue
  {
    'nvim-mini/mini.clue',
    config = function()
      local mc = require('mini.clue')
      mc.setup {
        triggers = kit.triggers {
          { '<leader>', 'nx' },
          { '<c-x>',    'i' },
          { '<c-w>',    'n' },
          { '<c-r>',    'ic' },
          { "'",        'nx' },
          { '`',        'nx' },
          { '"',        'nx' },
          { 'g',        'nx' },
          { 'z',        'nx' },
          { '[',        'nx' },
          { ']',        'nx' },
        },
        clues = {
          mc.gen_clues.builtin_completion(),
          mc.gen_clues.windows(),
          mc.gen_clues.registers(),
          mc.gen_clues.marks(),
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
        return "%4l:%-3v" -- line:column
      end
    end
  },

  -- Pin buffers
  -- https://github.com/iofq/dart.nvim
  {
    'iofq/dart.nvim',
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
    keys = {
      { "<leader>g", ":Neogit kind=replace<CR>", desc = "Neogit" }
    }
  },

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
}

local theme = "tokyonight-night"

kit.init_lazy {
  spec = plugins,
  install = { colorscheme = { theme } } -- Theme to use when installing plugins
}

vim.cmd.colorscheme(theme)
