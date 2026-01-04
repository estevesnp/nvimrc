return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")

    harpoon:setup({
      settings = {
        save_on_toggle = true,
      },
    })

    local map = require("utils").namespaced_keymap("harpoon")

    map("n", "<leader>h", function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, "toggle harpoon menu")

    map("n", "<leader>H", function()
      harpoon:list():add()
    end, "add file to harpoon")

    for i = 1, 5 do
      map("n", "<leader>" .. i, function()
        harpoon:list():select(i)
      end, "switch to harpoon file " .. i)
    end
  end,
}
