vim.pack.add({ "https://github.com/MeanderingProgrammer/render-markdown.nvim" })
require("render-markdown").setup({
  completions = { lsp = { enabled = true } },
  overrides = {
    buftype = {
      nofile = { enabled = false },
    },
  },
  -- to maintain lsp hover behaviour
  ignore = function(buf)
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_get_buf(win) == buf and pcall(vim.api.nvim_win_get_var, win, "lsp_floating_bufnr") then
        return true
      end
    end
    return false
  end,
})
