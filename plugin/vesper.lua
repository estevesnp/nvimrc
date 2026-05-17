vim.pack.add({ "https://github.com/datsfilipe/vesper.nvim" })

local colors = require("vesper.colors")

require("vesper").setup({
  italics = {
    comments = false,
    keywords = false,
    functions = false,
    strings = false,
    variables = false,
  },
  overrides = {
    Underlined = {
      underline = false,
      undercurl = false,
    },
    MiniTrailspace = { bg = colors.error },
    IblIndent = { fg = "#3a3c4a" },
  },
})
