return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  config = function ()
    local configs = require('nvim-treesitter.configs')
    configs.setup({
        ensure_installed = {
          'bash',
          'c',
          'cmake',
          'cpp',
          'css',
          'fennel',
          'html',
          'javascript',
          'just',
          'lua',
          'luadoc',
          'make',
          'markdown_inline',
          'markdown',
          'nu',
          'objc',
          'query',
          'rust',
          'swift',
          'toml',
          'vim',
          'vimdoc',
          'wgsl',
          'yaml',
        },
        auto_install = true, -- Auto-install languages that are not installed
        highlight = { enable = true },
        indent = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            -- Set to `false` to disable one of the mappings
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
          },
        },
      })
  end
}
