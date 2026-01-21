local MasonMaps = require("config.lsp.mason-mappings")

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
  "tombi", -- toml
  "yamlls",
  -- web
  "html",
  "cssls",
}

---formatters and linters to have in path, possibly with mason
M.formatters_and_linters = {
  "goimports",
  "gofumpt",
  "golangci-lint",
  "prettierd",
}

---returns a list of all lsp servers to enable
---@return string[]
function M.all_servers()
  return vim.list_extend(vim.fn.keys(M.configs), M.default_servers)
end

---check if a mason spec has an executable in path
---@param spec MasonSpec
---@return boolean
local function spec_in_path(spec)
  for _, bin in ipairs(spec.bins) do
    if vim.fn.executable(bin) == 1 then
      return true
    end
  end
  return false
end

function M.install_not_in_path()
  local executables_to_install = {}
  local mappings = MasonMaps.get_mappings()

  for _, fmt_lint in ipairs(M.formatters_and_linters) do
    if vim.fn.executable(fmt_lint) == 0 then
      table.insert(executables_to_install, fmt_lint)
    end
  end

  for _, server in ipairs(M.all_servers()) do
    local spec = mappings.lspconfig_specs[server]
    if spec and not spec_in_path(spec) then
      table.insert(executables_to_install, spec.mason)
    end
  end

  if #executables_to_install == 0 then
    print("nothing to install")
    return
  end

  print("installing: " .. table.concat(executables_to_install, ", "))
  MasonMaps.install(executables_to_install)
end

return M
