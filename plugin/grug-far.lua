vim.pack.add({ "https://github.com/MagicDuck/grug-far.nvim" })

local Grug = require("grug-far")
Grug.setup({
  startInInsertMode = false,
})

local map = require("config.utils").namespaced_keymap("grug-far")
map("n", "<leader>rp", Grug.open, "search and replace")
