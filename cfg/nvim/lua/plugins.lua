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
}
