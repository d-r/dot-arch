return {
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

  -- A window in the bottom right corner that displays LSP progress messages.
  -- https://github.com/j-hui/fidget.nvim
  {
    'j-hui/fidget.nvim',
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

  -- Show available keybindings in a popup as you type.
  -- https://github.com/folke/which-key.nvim
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = 'helix',
      delay = 500,
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },

  -- A collection of small Quality Of Life plugins.
  -- https://github.com/folke/snacks.nvim
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      -- Fuzzy matching picker.
      picker = { enabled = true },

      -- Animated indent guides with scope highlighting.
      indent = { enabled = true },

      -- Highlights other occurrences of the word under the cursor.
      words = { enabled = true },

      -- Pretty vim.notify.
      notifier = { enabled = true },

      -- Nicer line number / sign column layout.
      statuscolumn = { enabled = true },
    },
  },
}
