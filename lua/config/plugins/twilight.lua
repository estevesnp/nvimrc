local utils = require("utils")

return {
	{
		"folke/twilight.nvim",
		opts = {
			dimming = {
				inactive = true,
			},
		},
		config = function()
			local map = utils.namespaced_keymap("Twilight")
			map("n", "<leader>tt", ":Twilight<CR>", "Toggle Twilight")
		end,
	},
}
