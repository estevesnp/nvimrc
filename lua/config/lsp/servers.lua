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
}

---servers to enable without a configuration
M.default_servers = {
  -- lua
  "lua_ls",
  "stylua",
  -- typescript/javascript
  "ts_ls",
  --python
  "basedpyright",
  "ruff",
  -- gh actions
  "gh_actions_ls",
  -- data
  "jsonls",
  "taplo", -- toml
  "yamlls",
  -- web
  "html",
  "cssls",
}

---returns a list of all lsp servers to enable
---@return string[]
function M.all_servers()
  return vim.list_extend(vim.fn.keys(M.configs), M.default_servers)
end

return M
