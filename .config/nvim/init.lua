local kit = require 'kit'

-- n = normal mode
-- x = visual mode
-- o = operator-pending
-- i = insert mode
-- s = selection mode
-- v = visual + selection mode
local nxo = { 'n', 'x', 'o' }
local nx = { 'n', 'x' }
local xo = { 'x', 'o' }

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
-- one uppercase character
vim.o.ignorecase = true
vim.o.smartcase = true

-- Don't highlight the matches of the previous search
vim.o.hlsearch = false

-- Transform tabs to spaces
vim.o.expandtab = true

-- Disable the swap file, as it's a source of pointless error messages
vim.o.swapfile = false

-- Auto reload files whey they change on disk
vim.o.autoread = true

-- Save undo history to disk
vim.o.undofile = true

-- Use the system clipboard
-- Schedule the setting after `UiEnter` because it can increase startup time
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

--------------------------------------------------------------------------------
-- AUTO COMMANDS (HOOKS)

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight yanked text',
  group = vim.api.nvim_create_augroup('user-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

vim.api.nvim_create_autocmd('BufWritePre', {
  desc = 'Format on save',
  group = vim.api.nvim_create_augroup('user-format-on-save', { clear = true }),
  callback = function(args)
    require('conform').format { bufnr = args.buf }
  end,
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
        rust = { 'rusfmt', lsp_format = 'fallback' },
      },
    },
    keys = {
      {
        '<leader>=',
        desc = 'Format buffer',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
      },
    },
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
        return function()
          require('nvim-treesitter-textobjects.swap').swap_previous(o)
        end
      end

      local function swap_next(o)
        return function()
          require('nvim-treesitter-textobjects.swap').swap_next(o)
        end
      end

      return {
        -- Select
        {
          'aa',
          desc = 'Argument',
          mode = xo,
          select '@parameter.outer',
        },
        {
          'ia',
          desc = 'Argument',
          mode = xo,
          select '@parameter.inner',
        },
        {
          'ac',
          desc = 'Class',
          mode = xo,
          select '@class.outer',
        },
        {
          'ic',
          desc = 'Class',
          mode = xo,
          select '@class.inner',
        },
        {
          'af',
          desc = 'Function',
          mode = xo,
          select '@function.outer',
        },
        {
          'if',
          desc = 'Function',
          mode = xo,
          select '@function.inner',
        },

        -- Goto
        {
          '[c',
          desc = 'Previous class',
          mode = nxo,
          goto_prev '@class.outer',
        },
        {
          ']c',
          desc = 'Next class',
          mode = nxo,
          goto_next '@class.outer',
        },
        {
          '[f',
          desc = 'Previous function',
          mode = nxo,
          goto_prev '@function.outer',
        },
        {
          ']f',
          desc = 'Next function',
          mode = nxo,
          goto_next '@function.outer',
        },

        -- Swap
        {
          '<leader>pa',
          desc = 'Swap previous argument',
          swap_prev '@parameter.outer',
        },
        {
          '<leader>na',
          desc = 'Swap next argument',
          swap_next '@parameter.outer',
        },
        {
          '<leader>pf',
          desc = 'Swap previous function',
          swap_prev '@function.outer',
        },
        {
          '<leader>nf',
          desc = 'Swap next function',
          swap_next '@function.outer',
        },
        {
          '<leader>pc',
          desc = 'Swap previous class',
          swap_prev '@class.outer',
        },
        {
          '<leader>nc',
          desc = 'Swap next class',
          swap_next '@class.outer',
        },
      }
    end,
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
      char = { enable = false }, -- Don't override f, t, F, T
    },
    keys = {
      -- s is for "seek"
      {
        's',
        desc = 'Flash',
        mode = nxo,
        function()
          require('flash').jump()
        end,
      },
      {
        'S',
        desc = 'Flash treesitter',
        mode = nxo,
        function()
          require('flash').treesitter()
        end,
      },
      {
        'r',
        desc = 'Remote flash',
        mode = 'o',
        function()
          require('flash').remote()
        end,
      },
      {
        'R',
        desc = 'Treesitter search',
        mode = xo,
        function()
          require('flash').treesitter_search()
        end,
      },
      {
        '<c-s>',
        desc = 'Toggle flash search',
        mode = 'c',
        function()
          require('flash').toggle()
        end,
      },
    },
  },

  -- Snacks - a collection of small quality-of-life plugins
  -- I only use the picker. It's the best one I've tried.
  -- https://github.com/folke/snacks.nvim
  -- https://github.com/folke/snacks.nvim/blob/main/docs/picker.md
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    opts = {
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
    keys = {
      -- <c>
      {
        '<c-p>',
        desc = 'Command palette',
        function()
          Snacks.picker.commands()
        end,
      },

      -- <leader>
      {
        '<leader><space>',
        desc = 'Smart find files',
        function()
          Snacks.picker.smart()
        end,
      },
      {
        '<leader>f',
        desc = 'Files',
        function()
          Snacks.picker.files()
        end,
      },
      {
        '<leader>b',
        desc = 'Buffers',
        function()
          Snacks.picker.buffers()
        end,
      },
      {
        '<leader>c',
        desc = 'Commands',
        function()
          Snacks.picker.commands()
        end,
      },
      {
        '<leader>d',
        desc = 'Diagnostics (buffer)',
        function()
          Snacks.picker.diagnostics_buffer()
        end,
      },
      {
        '<leader>D',
        desc = 'Diagnostics (global)',
        function()
          Snacks.picker.diagnostics()
        end,
      },
      {
        '<leader>h',
        desc = 'Help',
        function()
          Snacks.picker.help()
        end,
      },
      {
        '<leader>k',
        desc = 'Keymaps',
        function()
          Snacks.picker.keymaps()
        end,
      },
    },
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
      {
        '<leader>t',
        desc = 'TODO comments',
        function()
          Snacks.picker.todo_comments()
        end,
      },
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

  -- Minimal and fast statusline with opinionated default look
  -- https://github.com/nvim-mini/mini.statusline
  {
    'nvim-mini/mini.statusline',
    enabled = false,
    dependencies = {
      { 'nvim-mini/mini.icons', opts = {} },
    },
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
  'janet_lsp',
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
    local picker = Snacks.picker

    kit.bind_keys {
      -- <c>
      {
        '<c-.>',
        desc = 'Code action',
        mode = nx,
        vim.lsp.buf.code_action,
      },

      -- <leader>
      {
        '<leader>a',
        desc = 'Code action',
        mode = nx,
        vim.lsp.buf.code_action,
      },
      {
        '<leader>r',
        desc = 'Rename symbol',
        vim.lsp.buf.rename,
      },
      {
        '<leader>=',
        desc = 'Format buffer',
        vim.lsp.buf.format,
      },
      {
        '<leader>s',
        desc = 'Symbols',
        picker.lsp_symbols,
      },
      {
        '<leader>S',
        desc = 'Workspace symbols',
        picker.lsp_workspace_symbols,
      },

      -- g
      {
        'gd',
        desc = 'Goto definition',
        picker.lsp_definitions,
      },
      {
        'gD',
        desc = 'Goto declaration',
        picker.lsp_declarations,
      },
      {
        'gy',
        desc = 'Goto type definition',
        picker.lsp_type_definitions,
      },
      {
        'gr',
        desc = 'Goto references',
        nowait = true,
        picker.lsp_references,
      },
      {
        'gi',
        desc = 'Goto implementation',
        picker.lsp_implementations,
      },
    }
  end,
})

--------------------------------------------------------------------------------
-- BINDS

kit.bind_keys {
  { "<c-s>", desc = "Save", ":write<CR>" },
  { "<c-q>", desc = "Quit", ":quit!<CR>" },
}
