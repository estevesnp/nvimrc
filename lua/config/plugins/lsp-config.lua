return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "williamboman/mason.nvim", config = true }, -- NOTE: Must be loaded before dependants
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",

			{ "saghen/blink.cmp" },

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
			require("config.lsp.autocmds").setup()

			local servers = require("config.lsp.servers")

			require("mason").setup()
			require("mason-tool-installer").setup({ ensure_installed = servers.ensure_installed })
			require("mason-lspconfig").setup({
				ensure_installed = nil,
				automatic_installation = false,
				handlers = {
					function(server_name)
						local server = servers.configs[server_name] or {}
						server.capabilities = require("blink.cmp").get_lsp_capabilities(server.capabilities)
						require("lspconfig")[server_name].setup(server)
					end,
				},
			})
		end,
	},
}
