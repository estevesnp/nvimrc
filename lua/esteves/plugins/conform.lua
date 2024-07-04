return {
	"stevearc/conform.nvim",
	lazy = false,
	config = function()
		require("conform").setup({
			notify_on_error = false,
			format_on_save = function(bufnr)
				-- For FormatDisable and FormatEnable commands
				if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
					return
				end
				-- Disable "format_on_save lsp_fallback" for languages that don't
				-- have a well standardized coding style.
				local disable_filetypes = { c = true, cpp = true }
				return {
					timeout_ms = 500,
					lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
				}
			end,
			formatters_by_ft = {
				lua = { "stylua" },
				go = { "goimports", "gofumpt" },
			},
		})

		vim.api.nvim_create_user_command("FormatDisable", function(args)
			if args.bang then
				-- FormatDisable! will disable formatting just for this buffer
				vim.b.disable_autoformat = true
			else
				vim.g.disable_autoformat = true
			end
		end, {
			desc = "Disable autoformat-on-save",
			bang = true,
		})
		vim.api.nvim_create_user_command("FormatEnable", function()
			vim.b.disable_autoformat = false
			vim.g.disable_autoformat = false
		end, {
			desc = "Re-enable autoformat-on-save",
		})

		local map = CreateNamedMap("Conform")
		map("n", "<leader>f", function()
			require("conform").format({ async = true, lsp_fallback = true })
		end, "[F]ormat bufer")
	end,
}
