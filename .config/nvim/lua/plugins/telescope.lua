-- https://github.com/nvim-telescope/telescope.nvim
return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.8',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function ()
    local ts = require('telescope.builtin')
    vim.keymap.set('n', '<leader>ff', ts.find_files, { desc = 'Telescope find files' })
    vim.keymap.set('n', '<leader>fg', ts.live_grep, { desc = 'Telescope live grep' })
    vim.keymap.set('n', '<leader>fb', ts.buffers, { desc = 'Telescope buffers' })
    vim.keymap.set('n', '<leader>fh', ts.help_tags, { desc = 'Telescope help tags' })
  end
}
