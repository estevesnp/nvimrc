vim.pack.add({ "https://github.com/datsfilipe/vesper.nvim" })

local colors = require("vesper.colors")
local mix = require("vesper.utils").mix

require("vesper").setup({
  italics = {
    comments = false,
    keywords = false,
    functions = false,
    strings = false,
    variables = false,
  },
  overrides = {
    SnippetTabstopActive = {},
    Underlined = { underline = false, undercurl = false },

    ColorColumn = { bg = mix(colors.primary, colors.bg, 0.18) },

    MatchParen = { bg = colors.primary, fg = colors.fgSelection, bold = true },

    DiffAdd = { bg = mix(colors.green, colors.bg, 0.20), fg = colors.fg },
    DiffChange = { bg = mix(colors.orange, colors.bg, 0.20), fg = colors.fg },
    DiffDelete = { bg = mix(colors.red, colors.bg, 0.20), fg = colors.fg },
    DiffText = { bg = mix(colors.symbol, colors.bg, 0.35), fg = colors.fg },

    MiniTrailspace = { bg = colors.error },
    IblIndent = { fg = "#3a3c4a" },
  },
})
