return {
	"github/copilot.vim",
	config = function()
		local map = CreateNamedMap("Copilot")
		vim.g.copilot_enabled = true

		map("n", "<leader>cop", function()
			vim.g.copilot_enabled = not vim.g.copilot_enabled
			vim.notify("Copilot " .. (vim.g.copilot_enabled and "Enabled" or "Disabled"), "info", { title = "Copilot" })
		end, "Toggle Copilot")
	end,
}
