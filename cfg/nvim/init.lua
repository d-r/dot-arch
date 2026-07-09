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
  -- https://github.com/romus204/tree-sitter-manager.nvim
  {
    "romus204/tree-sitter-manager.nvim",
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
    config = function ()
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
              ['<Esc>'] = { 'close', mode = { 'n', 'i' } },
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
      -- git
      { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
      { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log" },
      { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
      { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
      { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
      { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
      { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
      -- Grep
      { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
      { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
      { "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep" },
      {
        "<leader>sw",
        function() Snacks.picker.grep_word() end,
        desc = "Visual selection or word",
        mode = { "n", "x" },
      },
      -- Search
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
      { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
      { "<leader>sp", function() Snacks.picker.lazy() end, desc = "Search for Plugin Spec" },
      { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
      { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume" },
      { "<leader>su", function() Snacks.picker.undo() end, desc = "Undo History" },
      { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
      -- LSP
      { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
      { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
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

-- Unbind Ctrl+Z to avoid constantly suspending Neovim by accident.
vim.keymap.set({ "n", "i", "v" }, "<C-z>", "<Nop>")

-- Ctrl+S to save.
vim.keymap.set({ "n", "i", "v" }, "<C-s>", "<cmd>w<cr>")
