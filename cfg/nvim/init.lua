-- Set <leader> key to <space>.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

--------------------------------------------------------------------------------
-- OPTIONS

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

-- Disable line-wrapping.
vim.opt.wrap = false

-- Don't split words.
vim.opt.linebreak = true

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

--------------------------------------------------------------------------------
-- PLUGINS

local theme = "tokyonight-night"

local plugins = {
  -- An "angry fruit salad" color scheme that insists on giving every single
  -- token a different color.
  -- But all the major themes do that, and I prefer this one to most.
  --
  -- TODO: Replace this with my own theme.
  --
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

  -- Manage tree-sitter parsers.
  -- Tree-sitter CLI must be installed.
  -- https://github.com/arborist-ts/arborist.nvim
  {
    "arborist-ts/arborist.nvim",
    opts = {
      prefer_wasm = false,
    },
  },

  -- Auto detect indentation size
  -- https://github.com/NMAC427/guess-indent.nvim
  {
    "NMAC427/guess-indent.nvim",
    opts = {},
  },

  -- Formatter.
  -- https://github.com/stevearc/conform.nvim
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        rust = { "rustfmt" },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
    },
  },

  -- Auto completion engine.
  -- https://github.com/saghen/blink.cmp
  {
    "saghen/blink.cmp",
    -- optional: provides snippets for the snippet source
    dependencies = { "rafamadriz/friendly-snippets" },

    -- use a release tag to download pre-built binaries
    version = "1.*",
    -- AND/OR build from source
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source with:
    -- build = 'nix run .#build-plugin',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
      -- 'super-tab' for mappings similar to vscode (tab to accept)
      -- 'enter' for enter to accept
      -- 'none' for no mappings
      --
      -- All presets have the following mappings:
      -- C-space: Open menu or open docs if already open
      -- C-n/C-p or Up/Down: Select next/previous item
      -- C-e: Hide menu
      -- C-k: Toggle signature help (if signature.enabled = true)
      --
      -- See :h blink-cmp-config-keymap for defining your own keymap
      keymap = { preset = "enter" },

      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = "mono",
      },

      -- (Default) Only show the documentation popup when manually triggered
      completion = { documentation = { auto_show = false } },

      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },

      -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
      -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
      -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
      --
      -- See the fuzzy documentation for more information
      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
    opts_extend = { "sources.default" },
  },

  -- A window in the bottom right corner that displays LSP progress messages.
  -- https://github.com/j-hui/fidget.nvim
  {
    "j-hui/fidget.nvim",
    opts = {
      notification = {
        window = {
          -- No width limit so that lines will not get wrapped.
          max_width = 0,
        },
      },
    },
  },

  -- Properly configure LuaLS for editing your Neovim config.
  -- https://github.com/folke/lazydev.nvim
  {
    "folke/lazydev.nvim",
    ft = "lua", -- Only load on lua files.
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found.
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },

  -- Rust IDE.
  -- https://github.com/mrcjkb/rustaceanvim
  {
    "mrcjkb/rustaceanvim",
    -- To avoid being surprised by breaking changes,
    -- I recommend you set a version range
    version = "^9",
    -- This plugin implements proper lazy-loading (see :h lua-plugin-lazy).
    -- No need for lazy.nvim to lazy-load it.
    lazy = false,
    config = function()
      vim.g.rustaceanvim = {
        server = {
          settings = {
            ["rust-analyzer"] = {
              check = { command = "clippy" },
            },
          },
        },
      }
    end,
  },

  -- Show available keybinds in a popup as you type.
  -- https://github.com/folke/which-key.nvim
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
      delay = 500,
    },
    keys = {
      {
        "<leader>?",
        function() require("which-key").show { global = false } end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },

  -- A collection of small quality of life plugins.
  -- https://github.com/folke/snacks.nvim
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      -- Fuzzy matching picker.
      picker = {
        enabled = true,
        win = {
          input = {
            keys = {
              ["<Esc>"] = { "close", mode = { "n", "i" } },
            },
          },
        },
      },

      -- Animated indent guides with scope highlighting.
      indent = { enabled = true },

      -- Highlights other occurrences of the word under the cursor.
      words = { enabled = true },

      -- Pretty vim.notify.
      notifier = { enabled = true },

      -- Nicer line number / sign column layout.
      statuscolumn = { enabled = true },
    },
    keys = {
      -- Top Pickers & Explorer
      { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
      { "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },
      { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
      { "<leader>n", function() Snacks.picker.notifications() end, desc = "Notification History" },
      { "<leader>e", function() Snacks.explorer() end, desc = "File Explorer" },

      -- Find
      { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
      {
        "<leader>fc",
        function() Snacks.picker.files { cwd = vim.fn.stdpath "config" } end,
        desc = "Find Config File",
      },
      { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
      { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Git Files" },
      { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
      { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },

      -- Search
      { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
      { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
      { "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep" },
      {
        "<leader>sw",
        function() Snacks.picker.grep_word() end,
        desc = "Visual selection or word",
        mode = { "n", "x" },
      },
      { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
      { "<leader>s/", function() Snacks.picker.search_history() end, desc = "Search History" },
      { "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
      { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
      { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
      { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
      { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
      { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
      { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
      { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },
      { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
      { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps" },
      { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
      { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List" },
      { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
      { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
      { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume" },
      { "<leader>su", function() Snacks.picker.undo() end, desc = "Undo History" },
      { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
      { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
      { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },

      -- LSP
      { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
      { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
      { "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
      { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
      { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
      { "gai", function() Snacks.picker.lsp_incoming_calls() end, desc = "C[a]lls Incoming" },
      { "gao", function() Snacks.picker.lsp_outgoing_calls() end, desc = "C[a]lls Outgoing" },
    },
  },

  -- Highlight TODO comments.
  -- https://github.com/folke/todo-comments.nvim
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },

  -- Auto pair delimiters
  -- https://github.com/nvim-mini/mini.pairs
  {
    "nvim-mini/mini.pairs",
    enabled = true,
    opts = {},
  },

  -- Add/delete/replace/find surrounding characters
  -- https://github.com/nvim-mini/mini.surround
  {
    "nvim-mini/mini.surround",
    opts = {
      -- Module mappings. Use `''` (empty string) to disable one.
      mappings = {
        add = "ys", -- Add surrounding in Normal and Visual modes
        delete = "ds", -- Delete surrounding
        find = "", -- Find surrounding (to the right)
        find_left = "", -- Find surrounding (to the left)
        highlight = "", -- Highlight surrounding
        replace = "cs", -- Replace surrounding
      },
    },
  },

  -- Text objects.
  -- https://github.com/nvim-mini/mini.ai
  {
    "nvim-mini/mini.ai",
    version = false,
    config = function()
      local ai = require "mini.ai"
      local ts_spec = ai.gen_spec.treesitter

      ai.setup {
        n_lines = 100,
        custom_textobjects = {
          f = ts_spec { a = "@function.outer", i = "@function.inner" },
          t = ts_spec { a = "@type.outer", i = "@type.inner" },
          a = ts_spec { a = "@parameter.outer", i = "@parameter.inner" },
          c = ts_spec { a = "@comment.outer", i = "@comment.outer" },
        },
      }
    end,
  },
}

--------------------------------------------------------------------------------
-- LAZY.NVIM SETUP

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system { "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath }
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

require("lazy").setup {
  spec = plugins,
  install = { colorscheme = { theme } },
}

vim.cmd.colorscheme(theme)

--------------------------------------------------------------------------------
-- AUTOCOMMANDS

-- Enable treesitter.
vim.api.nvim_create_autocmd("FileType", {
  callback = function(ev) pcall(vim.treesitter.start, ev.buf) end,
})

-- Enable folding for Markdown.
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "markdown",
--   callback = function()
--     vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
--     vim.wo[0][0].foldmethod = "expr"
--   end,
-- })

--------------------------------------------------------------------------------
-- LSP

vim.lsp.enable {
  -- Let rustaceanvim configure rust_analyzer.
  -- 'rust_analyzer',
  "clangd",
  "lua_ls",
  "nushell",
  "wgsl_analyzer",
  "zk",
}

--------------------------------------------------------------------------------
-- BINDS

-- Clear search highlights with <Esc>.
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Unbind Ctrl+Z to avoid constantly suspending Neovim by accident.
vim.keymap.set({ "n", "i", "v" }, "<C-z>", "<Nop>")

-- Ctrl+S to save.
vim.keymap.set({ "n", "i", "v" }, "<C-s>", "<cmd>w<cr>")
