return {
	{ -- Adds git related signs to the gutter, as well as utilities for managing changes
		"lewis6991/gitsigns.nvim",
		opts = {
			current_line_blame = true,
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
			on_attach = function()
				local gitsigns = require("gitsigns")

				local map = CreateNamedMap("Gitsigns")

				-- Navigation
				local nextChangeBind = "<leader>cn"
				local prevChangeBind = "<leader>cp"
				map("n", nextChangeBind, function()
					if vim.wo.diff then
						vim.cmd.normal({ nextChangeBind, bang = true })
					else
						gitsigns.nav_hunk("next")
					end
				end, "Jump to next git change")

				map("n", prevChangeBind, function()
					if vim.wo.diff then
						vim.cmd.normal({ prevChangeBind, bang = true })
					else
						gitsigns.nav_hunk("prev")
					end
				end, "Jump to previous git change")

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
	},
}
