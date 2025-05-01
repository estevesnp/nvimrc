return {
	{
		"ibhagwan/fzf-lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local fzf = require("fzf-lua")

			fzf.setup({
				"ivy",
				winopts = {
					height = 0.8,
				},
				hls = {
					preview_normal = "Normal",
				},
				keymap = {
					builtin = {
						true,
						["<C-Esc>"] = "hide",
						["<C-d>"] = "preview-page-down",
						["<C-u>"] = "preview-page-up",
					},
					fzf = {
						true,
						["ctrl-d"] = "preview-page-down",
						["ctrl-u"] = "preview-page-up",
					},
				},
				actions = {
					files = {
						true,
						["ctrl-b"] = fzf.actions.file_split,
						["ctrl-v"] = fzf.actions.file_vsplit,
					},
				},
			})

			local map = require("config.utils").namespaced_keymap("FZF")

			-- files/buffers
			map("n", "<leader>sf", fzf.files, "[S]earch [F]iles")
			map("n", "<leader>so", fzf.oldfiles, "[S]earch [O]ld Files")
			map("n", "<leader>st", fzf.treesitter, "[S]earch [T]reesitter")
			map("n", "<leader>sb", fzf.buffers, "[S]earch [B]uffers")
			map("n", "<leader>sq", fzf.quickfix, "[S]earch [Q]uickfix")
			map("n", "<leader>sm", fzf.marks, "[S]earch [M]arks")
			map("n", "<leader>sc", function()
				fzf.files({
					header = "Config Files",
					cwd = "~/.config",
					follow = true,
				})
			end, "[S]earch [C]onfig files")
			map("n", "<leader>sn", function()
				fzf.files({
					header = "Neovim Files",
					cwd = vim.fn.stdpath("config"),
				})
			end, "[S]earch [N]eovim files")

			-- git
			map("n", "<leader>gf", fzf.git_files, "Search [G]it [F]iles")
			map("n", "<leader>gs", fzf.git_status, "Search [G]it [S]tatus")
			map("n", "<leader>gc", fzf.git_bcommits, "Search [G]it buffer [c]ommits")
			map("n", "<leader>gC", fzf.git_commits, "Search [G]it [C]ommits")

			-- grep
			map("n", "<leader>sg", fzf.live_grep, "[S]earch [G]rep")
			map({ "n", "v" }, "<leader>sv", fzf.grep_visual, "[S]earch [V]isual selection")
			map("n", "<leader>/", fzf.lgrep_curbuf, "Search current buffer")
			map("n", "<leader>sw", fzf.grep_cword, "[S]earch current [w]ord")
			map("n", "<leader>sW", fzf.grep_cWORD, "[S]earch current [W]ord")

			-- misc
			map("n", "<leader>sk", fzf.keymaps, "[S]earch [K]eymaps")
			map("n", "<leader>sh", fzf.helptags, "[S]earch [H]elp")
			map("n", "<leader>sz", fzf.builtin, "[S]earch F[Z]F commands")
		end,
	},
}
