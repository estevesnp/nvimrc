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
    message = "Virtual Lines",
    config = {
      virtual_lines = true,
      virtual_text = false,
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
}

local counter = 1
local max_value = #diagnostic_configs

return function()
  counter = (counter % max_value) + 1
  local diag_config = diagnostic_configs[counter]

  print("Diagnostic Setting: " .. diag_config.message)

  vim.diagnostic.config(diag_config.config)
end
