return {
	"MagicDuck/grug-far.nvim",
	config = function()
		local grug = require("grug-far")

		grug.setup({
			startInInsertMode = false,
		})

		local map = require("utils").namespaced_keymap("Grug-Far")
		map("n", "<leader>rp", grug.open, "Open Search and [R]e[P]lace")
	end,
}
