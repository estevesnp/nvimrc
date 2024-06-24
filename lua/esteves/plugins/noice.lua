return {
	"folke/noice.nvim",
	event = "VeryLazy",
	dependencies = {
		"MunifTanjim/nui.nvim",
		"nvim-telescope/telescope.nvim",
		{
			"rcarriga/nvim-notify",
			opts = {
				stages = "static",
				timeout = 3000,
				max_height = function()
					return math.floor(vim.o.lines * 0.75)
				end,
				max_width = function()
					return math.floor(vim.o.columns * 0.75)
				end,
				on_open = function(win)
					vim.api.nvim_win_set_config(win, { zindex = 100 })
				end,
			},
			init = function()
				vim.notify = require("notify")
			end,
		},
	},
	opts = {
		lsp = {
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				["vim.lsp.util.stylize_markdown"] = true,
				["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
			},
			signature = {
				auto_open = {
					enabled = false,
					trigger = false,
				},
			},
		},
		routes = {
			{
				filter = {
					event = "msg_show",
					any = {
						{ find = "%d+L, %d+B" },
						{ find = "; after #%d+" },
						{ find = "; before #%d+" },
					},
				},
				view = "mini",
			},
		},
		presets = {
			bottom_search = true,
			command_palette = true,
			long_message_to_split = true,
			lsp_doc_border = true,
		},
	},
  -- stylua: ignore
  keys = {
    { "<C-r>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Noice: Redirect Cmdline" },
    { "<leader>nl", function() require("noice").cmd("last") end, desc = "Noice: Open last notification" },
    { "<leader>nh", function() require("noice").cmd("history") end, desc = "Noice: Open notification history" },
    { "<leader>ne", function() require("noice").cmd("errors") end, desc = "Noice: Open errors" },
    { "<leader>na", function() require("noice").cmd("all") end, desc = "Noice: Open all" },
    { "<leader>nf", function() require("noice").cmd("pick") end, desc = "Noice: Open in Telescope" },
    { "<leader>nd", function() require("noice").cmd("dismiss") end, desc = "Noice: Dismiss All" },
    { "<C-f>", function() if not require("noice.lsp").scroll(4) then return "<C-f>" end end, silent = true, expr = true, desc = "Noice: Scroll forward", mode = {"i", "n", "s"} },
    { "<C-b>", function() if not require("noice.lsp").scroll(-4) then return "<C-b>" end end, silent = true, expr = true, desc = "Noice: Scroll backward", mode = {"i", "n", "s"}},
  },
}
