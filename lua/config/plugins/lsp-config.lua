return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "mason-org/mason.nvim", config = true, version = "^1.0.0" }, -- NOTE: Must be loaded before dependants
			{ "mason-org/mason-lspconfig.nvim", version = "^1.0.0" },
			"WhoIsSethDaniel/mason-tool-installer.nvim",

			"saghen/blink.cmp",

			-- LSP Status Updates
			{ "j-hui/fidget.nvim", opts = {} },

			-- Neovim configuration for lua_ls
			{
				"folke/lazydev.nvim",
				ft = "lua", -- only load on lua files
				opts = {
					library = {
						-- See the configuration section for more details
						-- Load luvit types when the `vim.uv` word is found
						{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
					},
				},
			},
		},
		config = function()
			local lsp = require("config.lsp")
			lsp.setup()

			require("mason").setup()
			require("mason-tool-installer").setup({ ensure_installed = lsp.servers.ensure_installed })
			require("mason-lspconfig").setup({
				ensure_installed = nil,
				automatic_installation = false,
				handlers = {
					function(server_name)
						local server = lsp.servers.configs[server_name] or {}
						server.capabilities = require("blink.cmp").get_lsp_capabilities(server.capabilities or {})

						vim.lsp.config(server_name, server)
						vim.lsp.enable(server_name)
					end,
				},
			})
		end,
	},
}
