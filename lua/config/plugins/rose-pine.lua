return {
  "rose-pine/neovim",
  as = "rose-pine",
  enabled = true,
  config = function()
    require("rose-pine").setup({
      styles = { italic = false },
      highlight_groups = {
        LspSignatureActiveParameter = {
          bg = require("rose-pine.palette").highlight_med,
        },
      },
    })

    vim.cmd("colorscheme rose-pine")
  end,
}
