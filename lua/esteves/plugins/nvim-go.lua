return {
	"crispgm/nvim-go",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	ft = "go",
	-- If there's an error installing quicktype, you can install it manually:
	-- sudo npm install -g quicktype
	build = ":GoInstallBinaries",
	config = function()
		require("go").setup({
			tags_options = {},
			-- already managed by conform
			auto_format = false,
			auto_lint = false,
		})
		local map = CreateNamedMap("Go")

		map("n", "<leader>ife", "<cmd>GoIfErr<CR>", "Add if err check")
		map("n", "<leader>tj", "<cmd>GoAddTags json<CR>", "Add json struct tags")
		map("n", "<leader>ty", "<cmd>GoAddTags yaml<CR>", "Add yaml struct tags")
		map("n", "<leader>trj", "<cmd>GoRemoveTags json<CR>", "Remove json struct tags")
		map("n", "<leader>try", "<cmd>GoRemoveTags yaml<CR>", "Remove yaml struct tags")
		map("n", "<leader>tc", "<cmd>GoClearTags<CR>", "Clear struct tags")
	end,
}
