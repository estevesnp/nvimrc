return {
  "rose-pine/neovim",
  as = "rose-pine",
  config = function()
    local palette = require("rose-pine.palette")

    ---@diagnostic disable-next-line: missing-fields
    require("rose-pine").setup({
      styles = { italic = false },
      highlight_groups = {
        LspSignatureActiveParameter = { bg = palette.highlight_med },
      },
    })

    -- vim.cmd("colorscheme rose-pine")
  end,
}
