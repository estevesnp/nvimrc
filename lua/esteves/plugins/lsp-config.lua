return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{ "williamboman/mason.nvim", config = true }, -- NOTE: Must be loaded before dependants
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",

		-- Useful status updates for LSP.
		{ "j-hui/fidget.nvim", opts = {} },

		-- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
		-- used for completion, annotations and signatures of Neovim apis
		{
			"folke/lazydev.nvim",
			ft = "lua",
			opts = {
				library = {
					-- Load luvit types when the `vim.uv` word is found
					{ path = "luvit-meta/library", words = { "vim%.uv" } },
				},
			},
		},
		{ "Bilal2453/luvit-meta", lazy = true },
	},
	config = function()
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
			callback = function(event)
				local map = CreateNamedMap("LSP")
				local telescope = require("telescope.builtin")

				map("n", "K", vim.lsp.buf.hover, "Hover Documentation")
				map("n", "gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
				map("n", "<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
				map("n", "<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
				map({ "i", "n" }, "<C-s>", vim.lsp.buf.signature_help, "[S]ignature Help")
				map("n", "qd", vim.lsp.buf.definition, "[Q]uickfix [D]efinition")
				map("n", "qr", vim.lsp.buf.references, "[Q]uickfix [R]eferences")
				map("n", "qi", vim.lsp.buf.implementation, "[Q]uickfix [I]mplementation")
				map("n", "gd", telescope.lsp_definitions, "[G]oto [D]efinition")
				map("n", "gr", telescope.lsp_references, "[G]oto [R]eferences")
				map("n", "gI", telescope.lsp_implementations, "[G]oto [I]mplementation")
				map("n", "<leader>D", telescope.lsp_type_definitions, "Type [D]efinition")
				map("n", "<leader>ds", telescope.lsp_document_symbols, "[D]ocument [S]ymbols")
				map("n", "<leader>ws", telescope.lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

				-- The following two autocommands are used to highlight references of the
				-- word under your cursor when your cursor rests there for a little while.
				-- When you move your cursor, the highlights will be cleared (the second autocommand).
				local client = vim.lsp.get_client_by_id(event.data.client_id)
				if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
					local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.document_highlight,
					})

					vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.clear_references,
					})

					vim.api.nvim_create_autocmd("LspDetach", {
						group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
						callback = function(event2)
							vim.lsp.buf.clear_references()
							vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
						end,
					})
				end

				-- The following code creates a keymap to toggle inlay hints in your
				-- code, if the language server you are using supports them
				--
				-- This may be unwanted, since they displace some of your code
				if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
					map("n", "<leader>th", function()
						vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
					end, "[T]oggle Inlay [H]ints")
				end
			end,
		})

		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

		local servers = {
			-- See `:help lspconfig-all` for a list of all the pre-configured LSPs
			gopls = {
				settings = {
					gopls = {
						analyses = {
							fieldalignment = false,
							useany = true,
						},
						semanticTokens = true,
						staticcheck = true,
						directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
					},
				},
			},

			zls = {
				settings = {
					enable_build_on_save = true,
					build_on_save_step = "check",
					enable_argument_placeholders = false,
				},
			},

			rust_analyzer = {
				settings = {
					["rust-analyzer"] = {
						cargo = {
							allFeatures = true,
						},
						checkOnSave = {
							command = "clippy",
						},
					},
				},
			},

			clangd = {
				cmd = { "clangd", "--offset-encoding=utf-16" },
			},

			lua_ls = {
				settings = {
					Lua = {
						completion = {
							callSnippet = "Replace",
						},
					},
				},
			},
		}

		require("mason").setup()

		local ensure_installed = vim.tbl_keys(servers or {})
		vim.list_extend(ensure_installed, {
			"stylua",
			"gopls",
			"gofumpt",
			"goimports",
			"golangci-lint",
			"zls",
			"rust_analyzer",
			"clangd",
			"ts_ls",
			"html",
			"cssls",
			"prettierd",
			"jsonls",
			"markdownlint",
		})
		require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

		require("mason-lspconfig").setup({
			handlers = {
				function(server_name)
					local server = servers[server_name] or {}
					-- This handles overriding only values explicitly passed
					-- by the server configuration above. Useful when disabling
					-- certain features of an LSP (for example, turning off formatting for tsserver)
					server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
					require("lspconfig")[server_name].setup(server)
				end,
			},
		})

		require("lspconfig").kotlin_language_server.setup({})
	end,
}
