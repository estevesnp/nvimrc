local utils = require("utils")

local M = {}

M.configs = {
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
      enable_argument_placeholders = false,
    },
    cmd = { utils.get_alternate_exec("zls") },
  },

  rust_analyzer = {
    settings = {
      ["rust-analyzer"] = {
        cargo = {
          buildScripts = {
            enable = true,
          },
        },
        procMacro = {
          enable = true,
        },
        check = {
          command = "clippy",
        },
        completion = {
          callable = {
            snippets = "add_parentheses",
          },
        },
      },
    },
  },

  clangd = {
    cmd = { "clangd", "--offset-encoding=utf-16", "--function-arg-placeholders=0" },
  },

  -- TODO: this is a temporary fix for single-file support. tracked at https://github.com/neovim/nvim-lspconfig/issues/4015
  ts_ls = {
    root_dir = function(bufnr, on_dir)
      local root_markers = { "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lockb", "bun.lock" }
      root_markers = vim.fn.has("nvim-0.11.3") == 1 and { root_markers } or root_markers
      local project_root = vim.fs.root(bufnr, root_markers)
      if not project_root then
        on_dir(nil)
      else
        on_dir(project_root)
      end
    end,
  },

  bashls = {
    filetypes = { "sh", "bash", "zsh", "zshrc" },
  },
}

M.ensure_installed = {
  -- LSPs
  "lua_ls",
  "gopls",
  "zls",
  "rust_analyzer",
  "clangd",
  "bashls",
  -- "jdtls", -- currently broken
  "ts_ls",
  "html",
  "cssls",
  "jsonls",
  -- DAP
  "codelldb",
  "delve",
  -- Linters
  "golangci-lint",
  -- Formatters
  "stylua",
  "gofumpt",
  "goimports",
  "prettierd",
}

return M
