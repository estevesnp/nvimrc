local utils = require("utils")

local M = {}

M.configs = {
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
			enable_argument_placeholders = false,
		},
		cmd = { utils.get_alternate_exec("zls") },
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

	bashls = {
		filetypes = { "sh", "bash", "zsh", "zshrc" },
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

M.ensure_installed = {
	-- LSPs
	"lua_ls",
	"gopls",
	"zls",
	"rust_analyzer",
	"clangd",
	"bashls",
	"ts_ls",
	"html",
	"cssls",
	"jsonls",
	-- DAP
	"codelldb",
	"delve",
	-- Linters
	"golangci-lint",
	"markdownlint",
	-- Formatters
	"stylua",
	"gofumpt",
	"goimports",
	"prettierd",
}

return M
