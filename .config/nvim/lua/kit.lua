local M = {}

--------------------------------------------------------------------------------
-- LAZY + PLUGINS

-- Bootstrap and configure the lazy.nvim package manager.
-- See https://lazy.folke.io/configuration for what goes in `opts`.
function M.init_lazy(opts)
  -- Clone the repo into the data directory (typically ~/.local/share/nvim/)
  -- if it's not already in there.
  local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
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

  -- Add lazy to the runtime path so that can we `require` it.
  vim.opt.rtp:prepend(lazy_path)

  -- Configure lazy and sync plugins.
  require("lazy").setup(opts)
end

-- Helper for defining mini.clue triggers.
function M.triggers(entries)
  local triggers = {}
  for _, e in ipairs(entries) do
    local keys = e[1]
    local modes = M.chars(e[2])
    for _, mode in ipairs(modes) do
      table.insert(triggers, { mode = mode, keys = keys } )
    end
  end
  return triggers
end

--------------------------------------------------------------------------------
-- VIM

-- Bind a set of vim keys, specified in the same way as in the `keys` field of
-- lazy's plugin spec format.
function M.bind_keys(entries)
  for _, e in ipairs(entries) do
    local key = e[1]
    local cmd = e[2]
    local mode = e.mode or "n"

    -- Leave only the options.
    M.delete_keys(e, { 1, 2, "mode" })

    vim.keymap.set(mode, key, cmd, e)
  end
end

-- Bind a vim key.
function M.bind(key, mode, desc, cmd, options)
  options = options or {}
  options.desc = desc
  vim.keymap.set(M.chars(mode), key, cmd, options)
end

--------------------------------------------------------------------------------
-- GENERAL

-- Convert a string into a list of characters.
function M.chars(s)
  local t = {}
  for i = 1, #s do
    t[i] = s:sub(i, i)
  end
  return t
end

-- Delete a set of keys from the given table.
function M.delete_keys(t, keys)
  for _, k in ipairs(keys) do
    t[k] = nil
  end
end

--------------------------------------------------------------------------------
return M
