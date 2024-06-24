return {
	"gbprod/yanky.nvim",
	config = function()
		require("yanky").setup({
			highlight = {
				on_put = false,
				on_yank = false,
			},
			system_clipboard = {
				sync_with_ring = false,
			},
		})

		local map = CreateNamedMap("Yanky")

		map({ "n", "x" }, "y", "<Plug>(YankyYank)", "[y]ank text and leave cursor where it was")
		map({ "n", "x" }, "<leader>y", '"+<Plug>(YankyYank)', "[Y]ank text to clipboard and leave cursor where it was")
		map("n", "Y", "V<Plug>(YankyYank)", "[y]ank text and leave cursor where it was")
		map("n", "<leader>Y", 'V"+<Plug>(YankyYank)', "[Y]ank text to clipboard and leave cursor where it was")
		map({ "n", "x" }, "p", "<Plug>(YankyPutAfter)", "Put after cursor and leave cursor before yanked text")
		map({ "n", "x" }, "P", "<Plug>(YankyPutBefore)", "Put before cursor and leave cursor before yanked text")
		map({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)", "Put after cursor and leave cursor after yanked text")
		map({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)", "Put before cursor and leave cursor after yanked text")

		map("n", "<leader>sy", require("telescope").extensions.yank_history.yank_history, "[S]how [Y]ank history")
		map("n", "<leader><", "<Plug>(YankyPreviousEntry)", "Previous yanked text")
		map("n", "<leader>>", "<Plug>(YankyNextEntry)", "Next yanked text")
	end,
}
