vim.pack.add({
  "https://github.com/datsfilipe/vesper.nvim",
})

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
    MiniTrailspace = { bg = colors.error },
    Underlined = {
      underline = false,
      undercurl = false,
    },
  },
})
