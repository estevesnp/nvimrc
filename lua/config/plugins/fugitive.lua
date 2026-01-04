return {
  "tpope/vim-fugitive",
  config = function()
    local map = require("utils").namespaced_keymap("fugitive")
    map("n", "<leader>gi", "<cmd>Git<CR>", "open fugitive")
  end,
}
