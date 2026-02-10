require("config.options")
require("config.keymaps")
require("config.autocmds")

require("config.lazy")

-- local overrides
pcall(require, "config.override")
