return {
	{
		"ellisonleao/gruvbox.nvim",
		config = function()
			local bg_color = "#5b524c"
			require("gruvbox").setup({
				italic = {
					strings = false,
					emphasis = false,
					comments = false,
					operators = false,
					folds = false,
				},
				overrides = {
					LspReferenceText = { bg = bg_color },
					LspReferenceRead = { bg = bg_color },
					LspReferenceWrite = { bg = bg_color },
				},
			})

			vim.cmd("colorscheme gruvbox")
		end,
	},
}
