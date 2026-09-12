vim.pack.add({
  "https://github.com/tpope/vim-surround",
  "https://github.com/tpope/vim-fugitive",
})

local map = require("config.utils").namespaced_keymap("fugitive")
map("n", "<leader>fg", "<cmd>Git<CR>", "open fugitive")
