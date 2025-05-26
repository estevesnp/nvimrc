return {
  {
    "folke/twilight.nvim",
    opts = {
      dimming = {
        inactive = true,
      },
    },
    config = function()
      local map = require("utils").namespaced_keymap("Twilight")
      map("n", "<leader>tt", ":Twilight<CR>", "Toggle Twilight")
    end,
  },
}
