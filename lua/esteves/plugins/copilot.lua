return {
	"github/copilot.vim",
	config = function()
		vim.g.copilot_enabled = false

		local function toggle_copilot()
			vim.g.copilot_enabled = not vim.g.copilot_enabled
			vim.notify(
				"Copilot " .. (vim.g.copilot_enabled and "Enabled" or "Disabled"),
				vim.log.levels.INFO,
				{ title = "Copilot" }
			)
		end

		vim.api.nvim_create_user_command("CopilotToggle", toggle_copilot, {
			desc = "Toggle Copilot",
		})

		local map = CreateNamedMap("Copilot")
		map("n", "<leader>cop", toggle_copilot, "Toggle Copilot")
	end,
}
