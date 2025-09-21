-- https://github.com/luals/lua-language-server
---@type vim.lsp.Config
return {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = {
    '.luarc.json',
    '.luarc.jsonc',
    '.luacheckrc',
    '.stylua.toml',
    'stylua.toml',
    'selene.toml',
    'selene.yml',
    '.git',
  },
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      telemetry = { enable = false },
      diagnostics = {
        globals = { 'vim', 'require', 'pcall', 'pairs' },
      },
      workspace = {
        library = {
          vim.api.nvim_get_runtime_file('', true),
          vim.fn.stdpath 'data' .. '/lazy',
          '${3rd}/luv/library',
        },
        checkThirdParty = false,
      },
      completion = {
        workspaceWord = true,
        callSnippet = 'Replace',
      },
      hint = {
        enable = true,
      },
      format = { enable = false }, -- Leave formatting to stylua
    },
  },
}
