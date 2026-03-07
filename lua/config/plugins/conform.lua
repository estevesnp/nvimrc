return {
  "stevearc/conform.nvim",
  lazy = false,
  config = function()
    local conform = require("conform")
    conform.setup({
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

    local map = require("utils").namespaced_keymap("Conform")
    map("n", "<leader>f", function()
      conform.format({ async = true, lsp_fallback = true })
    end, "[F]ormat bufer")
  end,
}
