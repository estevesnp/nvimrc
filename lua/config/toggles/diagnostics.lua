local M = {}

local state = {
  counter = 1,
}

local diagnostic_configs = {
  {
    message = "display all levels",
    config = {
      virtual_text = true,
      underline = true,
    },
  },
  {
    message = "only display errors",
    config = {
      virtual_text = {
        severity = { min = vim.diagnostic.severity.ERROR },
      },
      underline = {
        severity = { min = vim.diagnostic.severity.ERROR },
      },
    },
  },
  {
    message = "display none",
    config = {
      virtual_text = false,
      underline = false,
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
