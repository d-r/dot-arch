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
  purple = '#c594c5',
  blue = '#8ca6bf',
  green = '#98c379',
  orange = '#ff9e64',
  lavender = '#bb9af7',
  teal = "#7fa396",
  cyan = "#9eb1ff",
  cyan2 = "#56b6c2",

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
hl('Keyword', { fg = colors.teal })
hl('Comment', { fg = colors.comment })
hl('String', { fg = colors.purple })
hl('Character', { fg = colors.green })
hl('Number', { fg = colors.lavender })
hl('Boolean', { fg = colors.lavender })
hl('Float', { fg = colors.lavender })
hl('Constant', { fg = colors.fg })  -- Regular constants (not highlighted)
hl('Function', { fg = colors.fg })  -- Function definitions
hl('Operator', { fg = colors.teal })
hl('Type', { fg = colors.fg })  -- Not highlighted
hl('Identifier', { fg = colors.fg })
hl('Special', { fg = colors.orange })  -- Escape sequences
hl('Delimiter', { fg = colors.punctuation })

-- Types
hl('@type.builtin', { fg = colors.teal })

hl('@type', { fg = colors.blue })
hl('@type.qualifier', { fg = colors.blue })  -- mut, const
hl('@lsp.type.type', { fg = colors.blue })
hl('@lsp.type.struct', { fg = colors.blue })
hl('@lsp.type.enum', { fg = colors.blue })

-- Treesitter
hl('@comment', { link = 'Comment' })
hl('@comment.documentation', { fg = colors.comment })  -- Doc comments

-- Strings and escapes
hl('@string', { link = 'String' })
hl('@string.escape', { fg = colors.teal })
hl('@string.special', { fg = colors.teal })

-- Numbers and constants
hl('@number', { link = 'Number' })
hl('@boolean', { fg = colors.lavender })
hl('@constant.builtin', { fg = colors.lavender })  -- true, false, None
hl('@constant', { fg = colors.fg })  -- Regular constants

-- Keywords and operators
hl('@keyword', { link = 'Keyword' })
hl('@keyword.function', { link = 'Keyword' })
hl('@keyword.operator', { link = 'Keyword' })
hl('@keyword.return', { link = 'Keyword' })
hl('@operator', { link = 'Operator' })

-- Attributes and macros
hl('@attribute', { fg = colors.blue })
hl('@macro', { fg = colors.lavender })

-- Variables (not highlighted)
hl('@variable', { fg = colors.fg })
hl('@variable.builtin', { fg = colors.teal })  -- self, super
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

-- LSP Semantic Tokens (override LSP's defaults)
hl('@lsp.type.comment.documentation', { fg = colors.comment })
hl('@lsp.typemod.comment.documentation', { fg = colors.comment })
hl('@lsp.mod.documentation', { fg = colors.comment })

hl('@constructor.lua', { link = '' } ) -- I don't want orange punctuation
