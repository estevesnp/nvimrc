vim.pack.add({ "https://github.com/hedyhli/outline.nvim" })
local Outline = require("outline")
Outline.setup({
  keymaps = {
    hover_symbol = "H",
  },
})

local map = require("config.utils").namespaced_keymap("outline")
map("n", "<leader>o", Outline.toggle, "toggle outline")
