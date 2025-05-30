-- https://github.com/folke/which-key.nvim
return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    icons = {
      mappings = true,
    },
    show_help = true, -- Show a help message in the command line for using WhichKey
    show_keys = true, -- Show the currently pressed key and its label as a message in the command line
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
}
