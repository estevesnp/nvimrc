local M = {}

M.setup = function()
	local map = require("config.utils").namespaced_keymap("LSP")

	map("n", "K", vim.lsp.buf.hover, "Hover Documentation")
	map("n", "<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
	map("n", "qd", vim.lsp.buf.definition, "[Q]uickfix [D]efinition")
	map("n", "qr", vim.lsp.buf.references, "[Q]uickfix [R]eferences")
	map("n", "qi", vim.lsp.buf.implementation, "[Q]uickfix [I]mplementation")

	local fzf = require("fzf-lua")
	map("n", "gd", fzf.lsp_definitions, "[G]oto [D]efinition")
	map("n", "gD", fzf.lsp_declarations, "[G]oto [D]eclaration")
	map("n", "gr", fzf.lsp_references, "[G]oto [R]eferences")
	map("n", "gI", fzf.lsp_implementations, "[G]oto [I]mplementation")
	map("n", "<leader>D", fzf.lsp_typedefs, "Type [D]efinition")
	map("n", "<leader>ds", fzf.lsp_document_symbols, "[D]ocument [S]ymbols")
	map("n", "<leader>ws", fzf.lsp_workspace_symbols, "[W]orkspace [S]ymbols")
	map("n", "<leader>sd", fzf.diagnostics_document, "[S]earch document [d]iagnostics")
	map("n", "<leader>sD", fzf.diagnostics_workspace, "[S]earch workspace [D]iagnostics")
	map("n", "<leader>ca", fzf.lsp_code_actions, "[C]ode [A]ction")
end

return M
