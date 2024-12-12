return {
	{
		"rose-pine/neovim",
		as = "rose-pine",
		config = function()
			---@diagnostic disable-next-line: missing-fields
			require("rose-pine").setup({
				styles = { italic = false },
				-- dim_inactive_windows = true,
			})
			vim.cmd("colorscheme rose-pine")
		end,
	},
}
