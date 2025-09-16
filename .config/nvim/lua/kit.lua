local M = {}

-- Bootstrap and configure the lazy.nvim package manager.
-- See https://lazy.folke.io/configuration for what goes in `opts`.
function M.init_lazy(opts)
  local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

  -- Clone the lazy repo into the data directory (typically ~/.local/share/nvim/),
  -- if it's not already in there.
  if not (vim.uv or vim.loop).fs_stat(lazy_path) then
    local out = vim.fn.system {
      "git",
      "clone",
      "--filter=blob:none",
      "--branch=stable",
      "https://github.com/folke/lazy.nvim.git",
      lazy_path
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

  -- Add lazy to the runtime path, so that that can we `require` it.
  vim.opt.rtp:prepend(lazy_path)

  -- Configure lazy and sync plugins.
  require("lazy").setup(opts)
end

-- Convert a string into a list of characters
function M.chars(s)
  local t = {}
  for i = 1, #s do
    t[i] = s:sub(i, i)
  end
  return t
end

-- Bind a key
function M.bind(key, mode, desc, cmd, options)
  options = options or {}
  options["desc"] = desc
  vim.keymap.set(M.chars(mode), key, cmd, options)
end

return M
