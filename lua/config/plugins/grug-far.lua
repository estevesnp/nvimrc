return {
  "MagicDuck/grug-far.nvim",
  config = function()
    local grug = require("grug-far")

    grug.setup({
      startInInsertMode = false,
    })

    local map = require("utils").namespaced_keymap("grug-far")
    map("n", "<leader>rp", grug.open, "search and replace")
  end,
}
