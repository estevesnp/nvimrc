return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		require("telescope").setup({
			defaults = {
				mappings = {
					n = {
						["<C-x>"] = require("telescope.actions").delete_buffer,
					},
					i = {
						["<C-x>"] = require("telescope.actions").delete_buffer,
					},
				},
			},
		})

		local builtin = require("telescope.builtin")
		local map = CreateNamedMap("Telescope")

		map("n", "<leader>sf", builtin.find_files, "[S]earch [F]iles")
		map("n", "<leader>gf", builtin.git_files, "Search [G]it [F]iles")
		map("n", "<leader>sg", builtin.live_grep, "[S]earch [G]rep")
		map("n", "<leader>sm", builtin.marks, "[S]earch [M]arks")
		map("n", "<leader>sb", builtin.buffers, "[S]earch [B]uffers")
		map("n", "<leader>sk", builtin.keymaps, "[S]earch [K]eymaps")
		map("n", "<leader>ss", builtin.builtin, "[S]earch [S]elect Telescope")
		map("n", "<leader>sw", builtin.grep_string, "[S]earch current [W]ord")
		map("n", "<leader>sd", builtin.diagnostics, "[S]earch [D]iagnostics")
		map("n", "<leader>s.", builtin.oldfiles, '[S]earch Recent Files ("." for repeat)')

		map("n", "<leader>/", function()
			builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
				winblend = 10,
			}))
		end, "[/] Fuzzily search in current buffer")

		map("n", "<leader>sn", function()
			builtin.find_files({
				cwd = vim.fn.stdpath("config"),
				prompt_title = "Neovim Files",
			})
		end, "[S]earch [N]eovim files")
	end,
}
