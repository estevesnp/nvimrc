return {
	"saecki/crates.nvim",
	event = { "BufRead Cargo.toml" },
	dependencies = { "hrsh7th/nvim-cmp" },
	config = function()
		local crates = require("crates")
		local opts = { silent = true }
		local map = CreateNamedMap("Crates")

		vim.api.nvim_create_autocmd("BufRead", {
			group = vim.api.nvim_create_augroup("CmpSourceCargo", { clear = true }),
			pattern = "Cargo.toml",
			callback = function()
				require("cmp").setup.buffer({ sources = { { name = "crates" } } })
			end,
		})
		crates.setup({
			completion = {
				cmp = { enabled = true },
			},
		})

		map("n", "<leader>ct", crates.toggle, "Toggle Crates", opts)
		map("n", "<leader>cr", crates.reload, "Reload Crates", opts)

		map("n", "<leader>cv", crates.show_versions_popup, "Show Versions", opts)
		map("n", "<leader>cf", crates.show_features_popup, "Show Features", opts)
		map("n", "<leader>cd", crates.show_dependencies_popup, "Show Dependencies", opts)

		map("n", "<leader>cu", crates.update_crate, "Update Crate", opts)
		map("v", "<leader>cu", crates.update_crates, "Update Crates", opts)
		map("n", "<leader>ca", crates.update_all_crates, "Update All Crates", opts)
		map("n", "<leader>cU", crates.upgrade_crate, "Upgrade Crate", opts)
		map("v", "<leader>cU", crates.upgrade_crates, "Upgrade Crates", opts)
		map("n", "<leader>cA", crates.upgrade_all_crates, "Upgrade All Crates", opts)

		map("n", "<leader>cx", crates.expand_plain_crate_to_inline_table, "Expand Crate", opts)
		map("n", "<leader>cX", crates.extract_crate_into_table, "Extract Crate Info", opts)

		map("n", "<leader>cH", crates.open_homepage, "Open Crate Homepage", opts)
		map("n", "<leader>cR", crates.open_repository, "Open Crate Repo", opts)
		map("n", "<leader>cD", crates.open_documentation, "Open Crate Documentation", opts)
		map("n", "<leader>cC", crates.open_crates_io, "Open crates.io Page", opts)
	end,
}
