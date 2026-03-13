vim.cmd('hi clear')
if vim.fn.exists('syntax_on') then
  vim.cmd('syntax reset')
end
vim.g.colors_name = 'glum'

local colors = {
  -- Background/UI
  bg = '#181818',
  fg = '#b6b6b6',
  white = '#e0e0e0',
  comment = '#777777',
  punctuation = '#606060',

  -- Syntax colors
  purple = '#c594c5',    -- keywords, operators
  blue = '#8ca6bf',      -- doc comments, attributes
  green = '#98c379',     -- strings
  orange = '#ff9e64',    -- numbers, escapes, booleans
  magenta = '#e096c7',   -- macros (placeholder, adjust if needed)

  -- UI colors
  border = '#404040',
  selection = '#3d3559',  -- Darkened purple for visual mode
  cursor_line = '#202020',
  line_nr = '#606060',
}

local function hl(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- Editor UI
hl('Normal', { fg = colors.fg, bg = colors.bg })
hl('NormalFloat', { fg = colors.fg, bg = colors.bg })
hl('Cursor', { fg = colors.bg, bg = colors.white })
hl('CursorLine', { bg = colors.cursor_line })
hl('CursorLineNr', { fg = colors.fg, bold = true })
hl('LineNr', { fg = colors.line_nr })
hl('SignColumn', { bg = colors.bg })
hl('Visual', { bg = colors.selection })
hl('VisualNOS', { bg = colors.selection })
hl('Search', { bg = colors.blue, fg = colors.bg })
hl('IncSearch', { bg = colors.orange, fg = colors.bg })

-- Borders and separators
hl('VertSplit', { fg = colors.border })
hl('WinSeparator', { fg = colors.border })
hl('FloatBorder', { fg = colors.border })

-- Statusline
hl('StatusLine', { fg = colors.fg, bg = colors.cursor_line })
hl('StatusLineNC', { fg = colors.comment, bg = colors.bg })

-- Basic syntax
hl('Comment', { fg = colors.comment })
hl('String', { fg = colors.green })
hl('Character', { fg = colors.green })
hl('Number', { fg = colors.orange })
hl('Boolean', { fg = colors.orange })
hl('Float', { fg = colors.orange })
hl('Constant', { fg = colors.fg })  -- Regular constants (not highlighted)
hl('Function', { fg = colors.white })  -- Function definitions
hl('Keyword', { fg = colors.purple })
hl('Operator', { fg = colors.purple })
hl('Type', { fg = colors.fg })  -- Not highlighted
hl('Identifier', { fg = colors.fg })
hl('Special', { fg = colors.orange })  -- Escape sequences
hl('Delimiter', { fg = colors.punctuation })

-- Treesitter
hl('@comment', { link = 'Comment' })
hl('@comment.documentation', { fg = colors.blue })  -- Doc comments

-- Strings and escapes
hl('@string', { link = 'String' })
hl('@string.escape', { fg = colors.orange })
hl('@string.special', { fg = colors.orange })

-- Numbers and constants
hl('@number', { link = 'Number' })
hl('@boolean', { fg = colors.orange })
hl('@constant.builtin', { fg = colors.orange })  -- true, false, None
hl('@constant', { fg = colors.fg })  -- Regular constants

-- Functions
hl('@function', { fg = colors.white })
hl('@function.builtin', { fg = colors.white })
hl('@function.call', { fg = colors.fg })  -- Function calls NOT highlighted
hl('@function.macro', { fg = colors.magenta })  -- Macro invocations
hl('@function.method', { fg = colors.white })
hl('@function.method.call', { fg = colors.fg })

-- Keywords and operators
hl('@keyword', { link = 'Keyword' })
hl('@keyword.function', { link = 'Keyword' })
hl('@keyword.operator', { link = 'Keyword' })
hl('@keyword.return', { link = 'Keyword' })
hl('@operator', { link = 'Operator' })

-- Types (not highlighted)
hl('@type', { fg = colors.fg })
hl('@type.builtin', { fg = colors.fg })
hl('@type.qualifier', { fg = colors.purple })  -- mut, const

-- Attributes and macros
hl('@attribute', { fg = colors.blue })
hl('@macro', { fg = colors.magenta })

-- Variables (not highlighted)
hl('@variable', { fg = colors.fg })
hl('@variable.builtin', { fg = colors.purple })  -- self, super
hl('@parameter', { fg = colors.fg })
hl('@property', { fg = colors.fg })
hl('@field', { fg = colors.fg })

-- Punctuation
hl('@punctuation.delimiter', { fg = colors.punctuation })
hl('@punctuation.bracket', { fg = colors.punctuation })
hl('@punctuation.special', { fg = colors.punctuation })

-- Markdown
hl('@markup.heading', { fg = colors.white, bold = true })
hl('@markup.strong', { bold = true })
hl('@markup.italic', { italic = true })
hl('@markup.link', { fg = colors.blue })
hl('@markup.raw', { fg = colors.green })  -- Inline code
hl('@markup.list', { fg = colors.purple })

-- Diagnostics
hl('DiagnosticError', { fg = colors.orange })
hl('DiagnosticWarn', { fg = colors.orange })
hl('DiagnosticInfo', { fg = colors.blue })
hl('DiagnosticHint', { fg = colors.green })

-- Diff
hl('DiffAdd', { fg = colors.green })
hl('DiffChange', { fg = colors.blue })
hl('DiffDelete', { fg = colors.orange })
hl('DiffText', { fg = colors.orange, bold = true })

-- Git signs (if using gitsigns.nvim)
hl('GitSignsAdd', { fg = colors.green })
hl('GitSignsChange', { fg = colors.blue })
hl('GitSignsDelete', { fg = colors.orange })
