require("config.options")
require("config.keymaps")
require("config.autocmds")

pcall(require, "config.override")

-- TODO: fff (main picker), dap, markdown
