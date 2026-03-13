vim.cmd('hi clear')
if vim.fn.exists('syntax_on') then
  vim.cmd('syntax reset')
end
vim.g.colors_name = 'glum'

local colors = {}

local function hl(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end
