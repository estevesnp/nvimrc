local M = {}

local DISABLE_AUTOFORMAT = "disable_autoformat"

local fmt_configs = {
  enable = {
    message = "Enabled",
    next = "disable",
    config = {
      global_disable_autoformat = false,
      consider_buffer = false,
    },
  },
  disable = {
    message = "Disabled",
    next = "disable_buf",
    config = {
      global_disable_autoformat = true,
      consider_buffer = false,
    },
  },
  disable_buf = {
    message = "Disabled for Buffer",
    next = "enable",
    config = {
      global_disable_autoformat = false,
      buffer_disable_autoformat = true,
      consider_buffer = true,
    },
  },
}

local state = {
  fmt_config = fmt_configs.enable,
  disable_autoformat = false,
}

---@param fmt_config table
---@param disable_buf_autoformat ?boolean
local function apply_format_config(fmt_config, disable_buf_autoformat)
  state.disable_autoformat = fmt_config.global_disable_autoformat
  if fmt_config.consider_buffer then
    local disable = disable_buf_autoformat
    if disable == nil then
      disable = fmt_config.buffer_disable_autoformat
    end

    vim.b[DISABLE_AUTOFORMAT] = disable
  end
end
apply_format_config(state.fmt_config.config)

---@param bufnr number
---@return boolean
function M.format_on_save_disabled(bufnr)
  local consider_buffer = state.fmt_config.config.consider_buffer
  return state.disable_autoformat or (consider_buffer and vim.b[bufnr][DISABLE_AUTOFORMAT])
end

function M.toggle_format_on_save()
  state.fmt_config = fmt_configs[state.fmt_config.next]

  print("Format On Save: " .. state.fmt_config.message)
  apply_format_config(state.fmt_config.config)
end

function M.toggle_format_on_save_buffer()
  local enabled = vim.b[DISABLE_AUTOFORMAT] or false
  local new_val = not enabled

  print("Format On Save Disabled for Buffer:", new_val)
  state.fmt_config = fmt_configs.disable_buf
  apply_format_config(state.fmt_config.config, new_val)
end

return M
