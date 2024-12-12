return {
	{
		"tpope/vim-fugitive",
		config = function()
			local map = require("config.utils").namespaced_keymap("Fugitive")
			map("n", "<leader>fg", "<cmd>Git<CR>", "Open [f]u[g]itive")
		end,
	},
}
