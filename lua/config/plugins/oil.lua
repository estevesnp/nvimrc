return {
	{
		"stevearc/oil.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local detail = false
			local oil = require("oil")
			oil.setup({
				default_file_explorer = true,
				skip_confirm_for_simple_edits = true,
				view_options = {
					show_hidden = true,
					is_always_hidden = function(name, _)
						return name == ".." or name == ".git"
					end,
				},
				win_options = {
					signcolumn = "yes:2",
				},
				keymaps = {
					["<C-c>"] = false,
					["<C-l>"] = false,
					["<C-h>"] = false,
					["<M-l>"] = "actions.refresh",
					["<M-h>"] = "actions.select_split",
					["<M-v>"] = "actions.select_vsplit",
					["<C-s>"] = ":w<CR>",
					["q"] = "actions.close",
					["gd"] = {
						desc = "Toggle file detail view",
						callback = function()
							detail = not detail
							if detail then
								require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
							else
								require("oil").set_columns({ "icon" })
							end
						end,
					},
				},
			})

			local set = require("config.utils").namespaced_set("Oil")

			set("n", "-", oil.open, "Open parent directory")
			set("n", "<leader>-", oil.toggle_float, "Toggle oil float")
		end,
	}
}
