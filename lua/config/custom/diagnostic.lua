local M = {}

local state = {
  counter = 1,
}

local diagnostic_configs = {
  {
    message = "Default",
    config = {
      virtual_lines = false,
      virtual_text = true,
      underline = true,
    },
  },
  {
    message = "Only Display Errors",
    config = {
      virtual_lines = false,
      virtual_text = {
        severity = { min = vim.diagnostic.severity.ERROR },
      },
      underline = {
        severity = { min = vim.diagnostic.severity.ERROR },
      },
    },
  },
  {
    message = "Virtual Lines",
    config = {
      virtual_lines = true,
      virtual_text = false,
      underline = true,
    },
  },
}

function M.default_diagnostic()
  vim.diagnostic.config(diagnostic_configs[1].config)
  state.counter = 1
end

function M.toggle_diagnostic()
  state.counter = (state.counter % #diagnostic_configs) + 1
  local diag_config = diagnostic_configs[state.counter]

  print("Diagnostic Setting: " .. diag_config.message)

  vim.diagnostic.config(diag_config.config)
end

return M
