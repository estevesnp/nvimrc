vim.pack.add({
  "https://github.com/jiaoshijie/undotree",
})

local UndoTree = require("undotree")
UndoTree.setup({})

local map = require("config.utils").namespaced_keymap("undotree")

map("n", "<leader>u", UndoTree.toggle, "toggle undo tree")
