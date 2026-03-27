vim.pack.add({ "https://github.com/stevearc/conform.nvim" })

local Conform = require("conform")

Conform.setup({
  notify_on_error = false,
  formatters_by_ft = {
    lua = { "stylua" },
    go = { "goimports", "gofumpt" },
    markdown = { "prettierd" },
    javascript = { "prettierd" },
    typescript = { "prettierd" },
    javascriptreact = { "prettierd" },
    typescriptreact = { "prettierd" },
    html = { "prettierd" },
    css = { "prettierd" },
  },
})

local map = require("config.utils").namespaced_keymap("conform")

map("n", "<leader>f", function()
  Conform.format({ async = true, lsp_fallback = true })
end, "format buffer")
