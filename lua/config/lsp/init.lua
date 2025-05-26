local M = {}

M.servers = require("config.lsp.servers")

function M.setup()
  require("config.lsp.autocmds").setup()
  require("config.lsp.keymaps").setup()
end

return M
