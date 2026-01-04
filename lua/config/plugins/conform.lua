return {
  "stevearc/conform.nvim",
  lazy = false,
  config = function()
    local conform = require("conform")
    local fmt = require("config.toggles.formatting")
    conform.setup({
      notify_on_error = false,
      format_on_save = function(bufnr)
        if fmt.format_on_save_disabled(bufnr) then
          return
        end
        return {
          timeout_ms = 500,
          lsp_fallback = true,
        }
      end,
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
