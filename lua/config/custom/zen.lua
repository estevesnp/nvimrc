local zen_enabled = false

return function()
  local ts_ctx = require("treesitter-context")

  zen_enabled = not zen_enabled

  if zen_enabled then
    ts_ctx.disable()
    vim.cmd("TwilightEnable")
  else
    ts_ctx.enable()
    vim.cmd("TwilightDisable")
  end
end
