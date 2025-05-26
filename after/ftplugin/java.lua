vim.b.disable_autoformat = true

local config = require("config.lsp.jdtls").get_config()
if not config then
  return
end

require("jdtls").start_or_attach(config)
