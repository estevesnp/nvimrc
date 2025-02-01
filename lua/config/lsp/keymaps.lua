local M = {}

M.setup = function()
	local map = require("config.utils").namespaced_keymap("LSP")

	map("n", "K", vim.lsp.buf.hover, "Hover Documentation")
	map("n", "gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
	map("n", "<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
	map("n", "<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
	map({ "i", "n" }, "<C-s>", vim.lsp.buf.signature_help, "[S]ignature Help")
	map("n", "qd", vim.lsp.buf.definition, "[Q]uickfix [D]efinition")
	map("n", "qr", vim.lsp.buf.references, "[Q]uickfix [R]eferences")
	map("n", "qi", vim.lsp.buf.implementation, "[Q]uickfix [I]mplementation")

	local telescope = require("telescope.builtin")
	map("n", "gd", telescope.lsp_definitions, "[G]oto [D]efinition")
	map("n", "gr", telescope.lsp_references, "[G]oto [R]eferences")
	map("n", "gI", telescope.lsp_implementations, "[G]oto [I]mplementation")
	map("n", "<leader>D", telescope.lsp_type_definitions, "Type [D]efinition")
	map("n", "<leader>ds", telescope.lsp_document_symbols, "[D]ocument [S]ymbols")
	map("n", "<leader>ws", telescope.lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
end

return M
