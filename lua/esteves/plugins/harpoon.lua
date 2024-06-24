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

		local map = CreateNamedMap("Harpoon")

		map("n", "<leader>h", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end, "Toggle Harpoon Menu")

		map("n", "<leader>H", function()
			harpoon:list():add()
		end, "Add File to Harpoon")

		for i = 1, 5 do
			map("n", "<leader>" .. i, function()
				harpoon:list():select(i)
			end, "Switch to Harpoon File " .. i)
		end
	end,
}
