vim.pack.add({
  {
    src = "https://github.com/ThePrimeagen/harpoon",
    version = "harpoon2",
  },
})

local Harpoon = require("harpoon")

Harpoon:setup({
  settings = {
    save_on_toggle = true,
  },
})

local map = require("config.utils").namespaced_keymap("harpoon")

map("n", "<leader>h", function()
  Harpoon.ui:toggle_quick_menu(Harpoon:list())
end, "toggle harpoon menu")

map("n", "<leader>H", function()
  Harpoon:list():add()
end, "add file to harpoon")

for i = 1, 5 do
  map("n", "<leader>" .. i, function()
    Harpoon:list():select(i)
  end, "switch to harpoon file " .. i)
end
