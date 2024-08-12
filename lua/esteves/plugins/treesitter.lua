return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	opts = {
		ensure_installed = {
			"go",
			"zig",
			"rust",
			"c",
			"java",
			"javascript",
			"typescript",
			"html",
			"lua",
			"vim",
			"vimdoc",
		},
		auto_install = true,
		highlight = {
			enable = true,
		},
		indent = { enable = true },
	},
	config = function(_, opts)
		-- Prefer git instead of curl in order to improve connectivity in some environments
		require("nvim-treesitter.install").prefer_git = true
		---@diagnostic disable-next-line: missing-fields
		require("nvim-treesitter.configs").setup(opts)
	end,
}
