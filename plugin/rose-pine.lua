vim.pack.add({
  {
    name = "rose-pine",
    src = "https://github.com/rose-pine/neovim",
  },
})

require("rose-pine").setup({
  styles = { italics = false },
  highlight_groups = {
    LspSignatureActiveParameter = {
      bg = require("rose-pine.palette").highlight_med,
    },
  },
})

vim.cmd("colorscheme rose-pine")
