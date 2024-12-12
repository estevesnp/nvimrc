local M = {}

M.configs = {
  -- See `:help lspconfig-all` for a list of all the pre-configured LSPs
  gopls = {
    settings = {
      gopls = {
        analyses = {
          fieldalignment = false,
          useany = true,
        },
        semanticTokens = true,
        staticcheck = true,
        directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
      },
    },
  },

  zls = {
    settings = {
      enable_build_on_save = true,
      build_on_save_step = "check",
      enable_argument_placeholders = false,
    },
  },

  rust_analyzer = {
    settings = {
      ["rust-analyzer"] = {
        cargo = {
          allFeatures = true,
        },
        checkOnSave = {
          command = "clippy",
        },
      },
    },
  },

  clangd = {
    cmd = { "clangd", "--offset-encoding=utf-16" },
  },

  lua_ls = {
    settings = {
      Lua = {
        completion = {
          callSnippet = "Replace",
        },
      },
    },
  },
}

M.ensure_installed = vim.tbl_keys(M.configs or {})
vim.list_extend(M.ensure_installed, {
  -- LSPs
  "lua_ls",
  "gopls",
  "zls",
  "rust_analyzer",
  "clangd",
  "ts_ls",
  "html",
  "cssls",
  "jsonls",
  -- DAP
  "codelldb",
  "delve",
  -- Linters
  "golangci-lint",
  "markdownlint",
  -- Formatters
  "stylua",
  "gofumpt",
  "goimports",
  "prettierd",
})

return M
