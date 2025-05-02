return {
	{
		"tpope/vim-fugitive",
		config = function()
			local map = require("utils").namespaced_keymap("Fugitive")
			map("n", "<leader>gi", "<cmd>Git<CR>", "Open fu[gi]tive")
		end,
	},
}
