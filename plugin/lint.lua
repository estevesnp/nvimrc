vim.pack.add({ "https://github.com/mfussenegger/nvim-lint" })

local lint = require("lint")
lint.linters_by_ft = {
  go = { "golangcilint" },
}

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
  callback = function()
    lint.try_lint()
  end,
})
