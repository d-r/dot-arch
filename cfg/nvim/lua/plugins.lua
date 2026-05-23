return {
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
}
