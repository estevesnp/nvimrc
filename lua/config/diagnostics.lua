local M = {}

local state = {
  counter = 1,
}

local diagnostic_configs = {
  {
    message = "display none",
    config = {
      severity_sort = true,
      virtual_text = false,
      underline = false,
    },
  },
  {
    message = "only display errors",
    config = {
      severity_sort = true,
      virtual_text = {
        severity = { min = vim.diagnostic.severity.ERROR },
      },
      underline = {
        severity = { min = vim.diagnostic.severity.ERROR },
      },
    },
  },
  {
    message = "display all levels",
    config = {
      severity_sort = true,
      virtual_text = true,
      underline = true,
    },
  },
}

function M.set_default_diagnostic()
  vim.diagnostic.config(diagnostic_configs[1].config)
  state.counter = 1
end

function M.toggle_diagnostics()
  state.counter = (state.counter % #diagnostic_configs) + 1
  local diag_config = diagnostic_configs[state.counter]

  print("diagnostic setting: " .. diag_config.message)

  vim.diagnostic.config(diag_config.config)
end

return M
