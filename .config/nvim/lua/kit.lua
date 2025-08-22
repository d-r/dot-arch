local M = {}

function M.init_lazy(plugins)
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system {
      "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath
    }
    if vim.v.shell_error ~= 0 then
      vim.api.nvim_echo({
        { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
        { out,                            "WarningMsg" },
        { "\nPress any key to exit..." },
      }, true, {})
      vim.fn.getchar()
      os.exit(1)
    end
  end
  vim.opt.rtp:prepend(lazypath)

  require("lazy").setup(plugins)
end

function M.chars(s)
  local t = {}
  for i = 1, #s do
      t[i] = s:sub(i, i)
  end
  return t
end

function M.bind(mode, key, desc, cmd, options)
  mode = M.chars(mode)
  options = options or {}
  options["desc"] = desc
  vim.keymap.set(mode, key, cmd, options)
end

return M
