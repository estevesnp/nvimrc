return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio",

		"williamboman/mason.nvim",
		"jay-babu/mason-nvim-dap.nvim",

		"leoluz/nvim-dap-go",
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		require("mason-nvim-dap").setup({
			automatic_installation = true,

			handlers = {},

			ensure_installed = {
				"delve",
				"codelldb",
			},
		})

		local map = CreateNamedMap("Debug")

		-- Basic debugging keymaps, feel free to change to your liking!
		map("n", "<F5>", dap.continue, "Start/Continue")
		map("n", "<F1>", dap.step_into, "Step Into")
		map("n", "<F2>", dap.step_over, "Step Over")
		map("n", "<F3>", dap.step_out, "Step Out")
		map("n", "<F7>", dapui.toggle, "See last session result")
		map("n", "<leader>b", dap.toggle_breakpoint, "Toggle Breakpoint")
		map("n", "<leader>B", function()
			dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
		end, "Set Breakpoint")

		---@diagnostic disable-next-line: missing-fields
		dapui.setup({
			layouts = {
				{
					elements = {
						{ id = "scopes", size = 0.25 },
						{ id = "breakpoints", size = 0.25 },
						{ id = "stacks", size = 0.25 },
						{ id = "watches", size = 0.25 },
					},
					position = "left",
					size = 40,
				},
				{
					elements = {
						{ id = "repl", size = 0.5 },
						{ id = "console", size = 0.5 },
					},
					position = "bottom",
					size = 10,
				},
			},
			icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
			---@diagnostic disable-next-line: missing-fields
			controls = {
				icons = {
					pause = "⏸",
					play = "▶",
					step_into = "⏎",
					step_over = "⏭",
					step_out = "⏮",
					step_back = "b",
					run_last = "▶▶",
					terminate = "⏹",
					disconnect = "⏏",
				},
			},
		})

		dap.listeners.after.event_initialized["dapui_config"] = dapui.open
		dap.listeners.before.event_terminated["dapui_config"] = dapui.close
		dap.listeners.before.event_exited["dapui_config"] = dapui.close

		local dap_go = require("dap-go")

		dap_go.setup({
			delve = {
				-- On Windows delve must be run attached or it crashes.
				-- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
				detached = vim.fn.has("win32") == 0,
			},
		})

		map("n", "<leader>Gt", function()
			dap_go.debug_test()
		end, "[G]o debug [T]est")

		map("n", "<leader>Gl", function()
			dap_go.debug_last_test()
		end, "[G]o debug [L]ast test")
	end,
}
