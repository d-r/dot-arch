local kit = require 'kit'

local picker = kit.proxy(function() return Snacks.picker end)
local flash = kit.proxy(function() return require 'flash' end)

-- n = normal mode
-- x = visual mode
-- o = operator-pending
-- i = insert mode
-- s = selection mode
-- v = visual + selection mode
-- c = command mode
local nxo = { 'n', 'x', 'o' }
local nx = { 'n', 'x' }
local xo = { 'x', 'o' }
local all_modes = { 'n', 'x', 'o', 's', 'v', 'c' }

--------------------------------------------------------------------------------
-- OPTIONS

-- Set <leader> key to <space>
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- kitty has builtin Nerd Font support
vim.g.have_nerd_font = true

-- Don't show the current mode, since mini.statusline already does that
-- vim.o.showmode = false

-- Enable gutter space for LSP info on the left
vim.o.signcolumn = 'yes'

-- Enable relative line numbers
vim.o.number = true
vim.o.relativenumber = true

-- Highlight the line that the cursor is on
vim.o.cursorline = true

-- Minimum number of screen lines to keep above and below the cursor
vim.o.scrolloff = 10

-- Perform case insensitive search, *unless* the search term contains at least
-- one capital letter
vim.o.ignorecase = true
vim.o.smartcase = true

-- Don't highlight the matches of the previous search
vim.o.hlsearch = false

-- Indent using 4 spaces by default
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.expandtab = true
vim.o.autoindent = true

-- Disable the swap file, as it's a source of pointless error messages
vim.o.swapfile = false

-- Auto reload files whey they change on disk
vim.o.autoread = true

-- Save undo history to disk
vim.o.undofile = true

-- Use the system clipboard
vim.o.clipboard = 'unnamedplus'

-- Enable mouse support
vim.o.mouse = 'a'

--------------------------------------------------------------------------------
-- AUTO COMMANDS (HOOKS)

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight yanked text',
  group = vim.api.nvim_create_augroup('user-highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

--------------------------------------------------------------------------------
-- PLUGINS

local plugins = {
  -- A window in the bottom right corner that displays LSP progress messages
  -- https://github.com/j-hui/fidget.nvim
  { 'j-hui/fidget.nvim', opts = {} },

  -- Rust IDE
  -- https://github.com/mrcjkb/rustaceanvim
  {
    'mrcjkb/rustaceanvim',
    version = '^6',
    lazy = false, -- This plugin is already lazy
  },

  -- Lua Language Server setup for the Neovim config
  -- https://github.com/folke/lazydev.nvim
  {
    'folke/lazydev.nvim',
    ft = 'lua', -- Only enable for .lua files
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        -- (whatever that means)
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },

  -- Completion
  -- https://cmp.saghen.dev/
  {
    'saghen/blink.cmp',
    -- use a release tag to download pre-built binaries
    version = '1.*',
    opts = {
      -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
      -- 'super-tab' for mappings similar to vscode (tab to accept)
      -- 'enter' for enter to accept
      -- 'none' for no mappings
      --
      -- All presets have the following mappings:
      -- C-space: Open menu or open docs if already open
      -- C-n/C-p or Up/Down: Select next/previous item
      -- C-e: Hide menu
      -- C-k: Toggle signature help (if signature.enabled = true)
      --
      -- See :h blink-cmp-config-keymap for defining your own keymap
      keymap = {
        preset = 'default',
      },

      -- (Default) Only show the documentation popup when manually triggered
      completion = { documentation = { auto_show = false } },

      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },

      -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
      -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
      -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
      --
      -- See the fuzzy documentation for more information
      fuzzy = { implementation = 'prefer_rust_with_warning' },
    },
    opts_extend = { 'sources.default' },
  },

  -- Intelligent code formatting
  -- https://github.com/stevearc/conform.nvim
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        lua = { 'stylua' },
        rust = { 'rusfmt' },
      },
    },
    keys = {
      {
        '<leader>=',
        desc = 'Format buffer',
        function() require('conform').format { async = true, lsp_format = 'fallback' } end,
      },
    },
    init = function()
      vim.api.nvim_create_autocmd('BufWritePre', {
        desc = 'Format on save',
        group = vim.api.nvim_create_augroup('user-format-on-save', { clear = true }),
        callback = function(args) require('conform').format { bufnr = args.buf } end,
      })
    end,
  },

  -- Treesitter integration
  -- https://github.com/nvim-treesitter/nvim-treesitter/tree/main
  --
  -- You should have these packages installed on the system:
  -- https://archlinux.org/groups/x86_64/tree-sitter-grammars/
  -- https://archlinux.org/packages/extra/x86_64/tree-sitter-cli/
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      local ts = require 'nvim-treesitter'

      ts.setup {
        -- Directory to install parsers and queries to
        install_dir = vim.fn.stdpath 'data' .. '/treesitter',
      }

      ts.install {
        'bash',
        'c',
        'cpp',
        'css',
        'diff',
        'git_config',
        'git_rebase',
        'gitcommit',
        'gitignore',
        'html',
        'ini',
        'json',
        'json5',
        'kdl',
        'lua',
        'luadoc',
        'markdown_inline',
        'markdown',
        'nu',
        'query',
        'ron',
        'rust',
        'toml',
        'vim',
        'vimdoc',
        'wgsl',
      }

      vim.api.nvim_create_autocmd('FileType', {
        desc = 'Enable treesitter highlighting',
        callback = function(event)
          if pcall(vim.treesitter.start, event.buf) then
            -- Enable folding and indentation.
            -- TODO: Verify that it works.
            -- I don't know what these incantations mean.
            vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },

  -- Syntax aware text-objects, select, move, swap, and peek support
  -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects/tree/main
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    opts = {},
    keys = function()
      local function select(o)
        return function()
          require('nvim-treesitter-textobjects.select').select_textobject(o, 'textobjects')
        end
      end

      local function goto_prev(o)
        return function()
          require('nvim-treesitter-textobjects.move').goto_previous_start(o, 'textobjects')
        end
      end

      local function goto_next(o)
        return function()
          require('nvim-treesitter-textobjects.move').goto_next_start(o, 'textobjects')
        end
      end

      local function swap_prev(o)
        return function() require('nvim-treesitter-textobjects.swap').swap_previous(o) end
      end

      local function swap_next(o)
        return function() require('nvim-treesitter-textobjects.swap').swap_next(o) end
      end

      return {
        -- Select

        { 'aa', desc = 'Argument', mode = xo, select '@parameter.outer' },
        { 'ia', desc = 'Argument', mode = xo, select '@parameter.inner' },

        { 'at', desc = 'Type', mode = xo, select '@class.outer' },
        { 'it', desc = 'Type', mode = xo, select '@class.inner' },

        { 'af', desc = 'Function', mode = xo, select '@function.outer' },
        { 'if', desc = 'Function', mode = xo, select '@function.inner' },

        { 'ac', desc = 'Comment', mode = xo, select '@comment.outer' },
        { 'ic', desc = 'Comment', mode = xo, select '@comment.inner' },

        -- Goto

        { '[t', desc = 'Previous type', mode = nxo, goto_prev '@class.outer' },
        { ']t', desc = 'Next type', mode = nxo, goto_next '@class.outer' },

        { '[f', desc = 'Previous function', mode = nxo, goto_prev '@function.outer' },
        { ']f', desc = 'Next function', mode = nxo, goto_next '@function.outer' },

        { '[c', desc = 'Previous comment', mode = nxo, goto_prev '@comment.outer' },
        { ']c', desc = 'Next comment', mode = nxo, goto_next '@comment.outer' },

        -- Swap

        { '<leader>pa', desc = 'Swap previous argument', swap_prev '@parameter.outer' },
        { '<leader>na', desc = 'Swap next argument', swap_next '@parameter.outer' },

        { '<leader>pf', desc = 'Swap previous function', swap_prev '@function.outer' },
        { '<leader>nf', desc = 'Swap next function', swap_next '@function.outer' },

        { '<leader>pt', desc = 'Swap previous type', swap_prev '@class.outer' },
        { '<leader>nt', desc = 'Swap next type', swap_next '@class.outer' },
      }
    end,
  },

  -- Auto pair delimiters
  -- https://github.com/nvim-mini/mini.pairs
  {
    'nvim-mini/mini.pairs',
    enabled = false,
    opts = {},
  },

  -- Surround selection with delimiters in visual mode
  -- https://github.com/NStefan002/visual-surround.nvim
  --
  -- FIXME: There is a delay when wrapping in [].
  -- TODO: Set use_default_keymaps to false, and bind my own keys?
  -- TODO: I would like to have an "auto unwrap" that just finds the nearest
  -- surrounding characters of whatever is under the cursor, and deletes them.
  {
    'NStefan002/visual-surround.nvim',
    event = 'VeryLazy',
    opts = {
      enable_wrapped_deletion = true,
      exit_visual_mode = true,
    },
  },

  -- Add/delete/replace/find surrounding characters
  -- https://github.com/nvim-mini/mini.pairs
  --
  -- FIXME: Having to type *at least* three characters to wrap something is
  -- cumbersome as hell.
  {
    'nvim-mini/mini.surround',
    enabled = true,
    opts = {
      -- Module mappings. Use `''` (empty string) to disable one.
      -- These are the defaults. Duplicated here for reference.
      mappings = {
        add = 'sa', -- Add surrounding in Normal and Visual modes
        delete = 'sd', -- Delete surrounding
        find = 'sf', -- Find surrounding (to the right)
        find_left = 'sF', -- Find surrounding (to the left)
        highlight = 'sh', -- Highlight surrounding
        replace = 'sr', -- Replace surrounding

        suffix_last = 'l', -- Suffix to search with "prev" method
        suffix_next = 'n', -- Suffix to search with "next" method
      },
    },
    init = function() vim.keymap.set(nx, 's', '<Nop>') end,
  },

  -- Comment lines
  -- https://github.com/nvim-mini/mini.comment
  {
    'nvim-mini/mini.comment',
    opts = {
      mappings = {
        -- Toggle comment (like `gcip` - comment inner paragraph) for both
        -- Normal and Visual modes
        comment = '',

        -- Toggle comment on current line
        comment_line = '<c-/>',

        -- Toggle comment on visual selection
        comment_visual = '<c-/>',

        -- Define 'comment' textobject (like `dgc` - delete whole comment block)
        -- Works also in Visual mode if mapping differs from `comment_visual`
        textobject = 'gc',
      },
    },
  },

  -- Jump around
  -- https://github.com/folke/flash.nvim
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    opts = {
      modes = {
        char = { enabled = false }, -- Don't override f, t, F, T,
      },
    },
    keys = {
      -- m is for "move"
      -- This overwrites the "set mark" bind.
      { 'm', desc = 'Flash', mode = nxo, flash.jump },
      { 'M', desc = 'Flash treesitter', mode = nxo, flash.treesitter },

      -- TODO: Find out what these do:
      { 'r', desc = 'Remote flash', mode = 'o', flash.remote },
      { 'R', desc = 'Treesitter search', mode = xo, flash.treesitter_search },
    },
    init = function() vim.keymap.set('n', 'm', '<Nop>') end,
  },

  -- Snacks - a collection of small quality-of-life plugins
  -- https://github.com/folke/snacks.nvim
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      indent = { enabled = true },
      picker = {
        enabled = true,
        sources = {
          files = {
            hidden = true,
          },
        },
        win = {
          input = {
            keys = {
              ['<Esc>'] = { 'close', mode = { 'n', 'i' } },
            },
          },
        },
      },
    },
    keys = function()
      return {
        { '<c-p>', desc = 'Command palette', picker.commands },
        { '<leader><space>', desc = 'Smart find files', picker.smart },
        { '<leader>f', desc = 'Files', picker.files },
        { '<leader>b', desc = 'Buffers', picker.buffers },
        { '<leader>c', desc = 'Commands', picker.commands },
        { '<leader>d', desc = 'Diagnostics (buffer)', picker.diagnostics_buffer },
        { '<leader>D', desc = 'Diagnostics (global)', picker.diagnostics },
        { '<leader>h', desc = 'Help', picker.help },
        { '<leader>k', desc = 'Keymaps', picker.keymaps },
        { '<leader>/', desc = 'Grep in workspace', picker.grep },
      }
    end,
  },

  -- Detect TODO comments
  -- https://github.com/folke/todo-comments.nvim
  {
    'folke/todo-comments.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'folke/snacks.nvim', -- For the picker
    },
    opts = {
      signs = false, -- Don't put icons in the sign column
      highlight = {
        keyword = 'fg', -- Colorize the keyword
        -- after = "",     -- Don't colorize the rest of the line
      },
    },
    keys = {
      { '<leader>t', desc = 'TODO comments', picker.todo_comments },
    },
  },

  -- Show available keybinds in a popup as you type
  -- https://github.com/folke/which-key.nvim
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
      preset = 'helix', -- Single column list in the bottom right corner
      icons = { mappings = false }, -- Disable icons
    },
  },

  -- File type icons
  -- https://github.com/nvim-mini/mini.icons
  {
    'nvim-mini/mini.icons',
    opts = {},
  },

  -- Minimal and fast statusline with opinionated default look
  -- https://github.com/nvim-mini/mini.statusline
  {
    'nvim-mini/mini.statusline',
    enabled = false,
    config = function()
      local sl = require 'mini.statusline'
      sl.setup()
      sl.section_location = function()
        return '%4l:%-3v' -- line:column
      end
    end,
  },

  -- Pin buffers
  -- https://github.com/iofq/dart.nvim
  {
    'iofq/dart.nvim',
    enabled = false,
    opts = {},
  },

  -- Magit for nvim
  -- https://github.com/NeogitOrg/neogit
  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim', -- Required for... *something*
      'sindrets/diffview.nvim', -- Diff integration
      'folke/snacks.nvim', -- Picker
    },
    keys = {
      { '<leader>g', ':Neogit kind=replace<CR>', desc = 'Neogit' },
    },
  },

  -- An "angry fruit salad" color scheme that insists on giving every single
  -- fucking token a different color.
  -- But all the major themes do that, and I prefer this one to most.
  --
  -- TODO: Replace this with my own theme.
  --
  -- https://github.com/folke/tokyonight.nvim
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    opts = {
      styles = {
        comments = { italic = false },
        keywords = { italic = false },
      },
    },
  },
}

local theme = 'tokyonight-night'

kit.init_lazy {
  spec = plugins,
  install = { colorscheme = { theme } }, -- Theme to use when installing plugins
}

vim.cmd.colorscheme(theme)

--------------------------------------------------------------------------------
-- LSP

vim.lsp.enable {
  -- rust_analyzer is left for rustaceanvim to configure
  'clangd',
  'lua_ls',
  'marksman',
  'nushell',
  'wgsl_analyzer',
  'zk',
}

vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'Add LSP-related keybinds when an LSP attaches to a buffer',
  group = vim.api.nvim_create_augroup('user-lsp-attach', { clear = true }),
  callback = function(_)
    kit.bind_keys {
      { '<c-.>', desc = 'Code action', mode = nx, vim.lsp.buf.code_action },

      { '<leader>a', desc = 'Code action', mode = nx, vim.lsp.buf.code_action },
      { '<leader>r', desc = 'Rename symbol', vim.lsp.buf.rename },
      { '<leader>=', desc = 'Format buffer', vim.lsp.buf.format },
      { '<leader>s', desc = 'Symbols', picker.lsp_symbols },
      { '<leader>S', desc = 'Workspace symbols', picker.lsp_workspace_symbols },

      { 'gd', desc = 'Goto definition', picker.lsp_definitions },
      { 'gD', desc = 'Goto declaration', picker.lsp_declarations },
      { 'gy', desc = 'Goto type definition', picker.lsp_type_definitions },
      { 'gr', desc = 'Goto references', nowait = true, picker.lsp_references },
      { 'gi', desc = 'Goto implementation', picker.lsp_implementations },
    }
  end,
})

--------------------------------------------------------------------------------
-- BINDS

-- Disabled because it inteferes with flash
-- Make ESC close floating windows
-- vim.keymap.set('n', '<esc>', function()
--   for _, win in ipairs(vim.api.nvim_list_wins()) do
--     if vim.api.nvim_win_get_config(win).relative == 'win' then
--       vim.api.nvim_win_close(win, false)
--     end
--   end
-- end)

kit.bind_keys {
  { '<c-s>', desc = 'Save', mode = all_modes, ':write<CR>' },
  { '<c-q>', desc = 'Quit', mode = all_modes, ':quit!<CR>' },
}
