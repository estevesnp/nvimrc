return {
	"nvim-tree/nvim-tree.lua",
	config = function()
		require("nvim-tree").setup({
			hijack_netrw = false,
		})
		local map = CreateNamedMap("NvimTree")
		map("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", "Toggle file tree")
	end,
}
