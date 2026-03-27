vim.pack.add({
  -- fzf-lua
  -- oil
  -- lualine
  "https://github.com/nvim-tree/nvim-web-devicons",
  -- harpoon
  -- undotree
  "https://github.com/nvim-lua/plenary.nvim",
})

local map = require("config.utils").namespaced_keymap("plenary")
map("n", "<leader>T", "<cmd>PlenaryBustedFile %<CR>", "run plenary tests in current file")
