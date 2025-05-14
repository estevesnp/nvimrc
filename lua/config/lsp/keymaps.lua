local M = {}

function M.setup()
	local map = require("utils").namespaced_keymap("LSP")

	map("n", "K", vim.lsp.buf.hover, "Hover Documentation")
	map("n", "<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
	map("n", "gqd", vim.lsp.buf.definition, "[G]oto [Q]uickfix [D]efinition")
	map("n", "gqr", vim.lsp.buf.references, "[G]oto [Q]uickfix [R]eferences")
	map("n", "gqi", vim.lsp.buf.implementation, "[G]oto [Q]uickfix [I]mplementation")
	map({ "i", "n" }, "<C-s>", vim.lsp.buf.signature_help, "[S]ignature Help")
	map("n", "<leader>th", function()
		vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
	end, "[T]oggle Inlay [H]ints")

	local fzf = require("fzf-lua")
	map("n", "gd", fzf.lsp_definitions, "[G]oto [D]efinition")
	map("n", "gD", fzf.lsp_declarations, "[G]oto [D]eclaration")
	map("n", "gr", fzf.lsp_references, "[G]oto [R]eferences")
	map("n", "gI", fzf.lsp_implementations, "[G]oto [I]mplementation")
	map("n", "<leader>D", fzf.lsp_typedefs, "Type [D]efinition")
	map("n", "<leader>ds", fzf.lsp_document_symbols, "[D]ocument [S]ymbols")
	map("n", "<leader>ws", fzf.lsp_workspace_symbols, "[W]orkspace [S]ymbols")
	map("n", "<leader>sd", fzf.diagnostics_workspace, "[S]earch workspace [d]iagnostics")
	map("n", "<leader>sD", fzf.diagnostics_document, "[S]earch document [D]iagnostics")
	map("n", "<leader>ca", fzf.lsp_code_actions, "[C]ode [A]ction")
end

return M
