return {
  -- Show available keybindings in a popup as you type.
  -- https://github.com/folke/which-key.nvim
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = 'helix',
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

  -- Automatically install and enable tree-sitter parsers.
  -- https://github.com/arborist-ts/arborist.nvim
  {
    "arborist-ts/arborist.nvim",
    opts = {
      prefer_wasm = false,
    },
  },
}
