return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{ "mason-org/mason.nvim", config = true },
		{ "mason-org/mason-lspconfig.nvim" },
		{ "WhoIsSethDaniel/mason-tool-installer.nvim" },

		{ "saghen/blink.cmp" },

		-- LSP Status Updates
		{ "j-hui/fidget.nvim", opts = {} },

		{
			"folke/lazydev.nvim",
			ft = "lua",
			opts = {
				library = {
					-- Load luvit types when the `vim.uv` word is found
					{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				},
			},
		},
	},
	config = function()
		local lsp = require("config.lsp")
		local servers = lsp.servers
		lsp.setup()

		local exclude = vim.fn.keys(servers.configs)
		table.insert(exclude, "jdtls")

		require("mason-tool-installer").setup({ ensure_installed = servers.ensure_installed })
		require("mason-lspconfig").setup({
			ensure_installed = nil,
			automatic_enable = {
				exclude = exclude,
			},
		})

		local blink = require("blink.cmp")
		for server_name, server in pairs(servers.configs) do
			server.capabilities = blink.get_lsp_capabilities(server.capabilities)

			vim.lsp.config(server_name, server)
			vim.lsp.enable(server_name)
		end
	end,
}
