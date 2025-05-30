-- https://github.com/folke/tokyonight.nvim
return {
  'folke/tokyonight.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    require('tokyonight').setup {
      styles = {
        comments = { italic = false },
      },
    }
    vim.cmd.colorscheme 'tokyonight-night'
  end,
}
