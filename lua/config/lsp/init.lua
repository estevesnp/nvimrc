local M = {}

---lsp configs
---@type table<string, table>
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

  bashls = {
    filetypes = { "sh", "bash", "zsh", "zshrc" },
  },

  ---------------------
  -- lspconfig defaults

  -- lua
  lua_ls = {},
  stylua = {},
  -- odin
  ols = {},
  -- typescript/javascript
  ts_ls = {},
  -- python
  pyright = {},
  ruff = {},
  -- shell
  fish_lsp = {},
  -- data
  jsonls = {},
  tombi = {},
  yamlls = {},
  -- web
  html = {},
  emmet_language_server = {},
  cssls = {},
}

-- use zigscient if available in path, else use zls
local zigscient_path = vim.fn.exepath("zigscient")
if zigscient_path ~= "" then
  M.configs.zigscient = {
    cmd = { zigscient_path },
    filetypes = { "zig", "zir" },
    root_markers = { "build.zig", ".git" },
    settings = {
      enable_argument_placeholders = false,
    },
  }
else
  M.configs.zls = {
    settings = {
      enable_argument_placeholders = false,
    },
  }
end

local ok, local_configs = pcall(require, "config.lsp.local")
if ok and local_configs then
  M.configs = vim.tbl_extend("force", M.configs, local_configs)
end

---formatters, debuggers and linters to have in path, possibly with mason
---@type string[]
M.formatters_and_tools = {
  -- go formatting
  "goimports",
  "gofumpt",
  "golangci-lint",
  -- ts/js, md, html, css formatting
  "prettierd",
  -- zig debugging
  "codelldb",
}

return M
