return {
	"nvim-pack/nvim-spectre",
	config = function()
		local map = CreateNamedMap("Spectre")
		local spectre = require("spectre")

		map("n", "<leader>S", spectre.toggle, "Open [S]pectre")
		map("n", "<leader>sc", spectre.open_file_search, "[S]earch [C]urrent File")
	end,
}
