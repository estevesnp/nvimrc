return {
	"lewis6991/gitsigns.nvim",
	opts = {
		current_line_blame = false,
		signs = {
			add = { text = "+" },
			change = { text = "~" },
			delete = { text = "_" },
			topdelete = { text = "‾" },
			changedelete = { text = "~" },
		},
		on_attach = function()
			local gitsigns = require("gitsigns")

			local map = require("utils").namespaced_keymap("Gitsigns")

			-- Navigation
			local next_change_key = "<leader>cn"
			local prev_change_key = "<leader>cp"
			map("n", next_change_key, function()
				if vim.wo.diff then
					vim.cmd.normal({ next_change_key, bang = true })
				else
					gitsigns.nav_hunk("next")
				end
			end, "Jump to next git change")

			map("n", prev_change_key, function()
				if vim.wo.diff then
					vim.cmd.normal({ prev_change_key, bang = true })
				else
					gitsigns.nav_hunk("prev")
				end
			end, "Jump to previous git change")
			map("n", "<leader>gq", gitsigns.setqflist, "[g]it set [q]uickfix list")

			-- Actions
			map("v", "<leader>gr", function()
				gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, "[g]it [r]eset hunk")
			map("n", "<leader>gr", gitsigns.reset_hunk, "[g]it [r]eset hunk")
			map("n", "<leader>gR", gitsigns.reset_buffer, "[g]it [R]eset buffer")
			map("n", "<leader>gp", gitsigns.preview_hunk, "[g]it [p]review hunk")
			map("n", "<leader>gb", gitsigns.blame_line, "[g]it [b]lame line")
			map("n", "<leader>gd", gitsigns.diffthis, "[g]it [d]iff against index")
			map("n", "<leader>gD", function()
				gitsigns.diffthis("@")
			end, "[G]it [D]iff against last commit")

			-- Toggles
			map("n", "<leader>gtb", gitsigns.toggle_current_line_blame, "[g]it [t]oggle show [b]lame line")
			map("n", "<leader>gtd", gitsigns.toggle_deleted, "[g]it [t]oggle show [d]eleted")
		end,
	},
}
