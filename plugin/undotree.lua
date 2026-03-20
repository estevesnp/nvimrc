vim.pack.add({
  "https://github.com/jiaoshijie/undotree",
})

require("undotree").setup({})

local map = require("config.utils").namespaced_keymap("undotree")
map("n", "<leader>u", require("undotree").toggle, "toggle undo tree")
