local M = {}

local map = require("utils").namespaced_keymap("lsp")

---setup keymaps that don't depend on fzf
function M.setup_bare_keymaps()
  map("n", "K", vim.lsp.buf.hover, "hover documentation")
  map("n", "<leader>rn", vim.lsp.buf.rename, "rename")
  map("n", "gqd", vim.lsp.buf.definition, "goto definition (quickfix)")
  map("n", "gqr", vim.lsp.buf.references, "goto references (quickfix)")
  map("n", "gqi", vim.lsp.buf.implementation, "goto implementations (quickfix)")
  map({ "i", "n" }, "<C-s>", vim.lsp.buf.signature_help, "signature help")
  map("n", "<leader>th", function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
  end, "toggle inlay hints")
end

---setup keymaps that depend on fzf
function M.setup_fzf_keymaps()
  local FZF = require("fzf-lua")

  map("n", "gd", FZF.lsp_definitions, "goto definition (fzf)")
  map("n", "gD", FZF.lsp_declarations, "goto declaration (fzf)")
  map("n", "gr", FZF.lsp_references, "goto references (fzf)")
  map("n", "gI", FZF.lsp_implementations, "goto implementations (fzf)")
  map("n", "<leader>D", FZF.lsp_typedefs, "type definition")
  map("n", "<leader>ss", FZF.lsp_document_symbols, "document symbols")
  map("n", "<leader>sS", FZF.lsp_workspace_symbols, "workspace symbols")
  map("n", "<leader>sd", FZF.diagnostics_document, "document diagnosstics")
  map("n", "<leader>sD", FZF.diagnostics_workspace, "workspace diagnostics")
  map("n", "<leader>ca", FZF.lsp_code_actions, "code action")
end

return M
