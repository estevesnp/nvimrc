vim.pack.add({
  {
    src = "https://github.com/rose-pine/neovim",
    name = "rose-pine",
  },
})

local palette = require("rose-pine.palette")

require("rose-pine").setup({
  styles = { italic = false },
  highlight_groups = {
    LspSignatureActiveParameter = { bg = palette.highlight_med },
    StatusLineTerm = { fg = palette.gold, bg = palette.overlay },
    StatusLineTermNC = { fg = palette.gold, bg = palette.overlay, blend = 60 },
  },
})
