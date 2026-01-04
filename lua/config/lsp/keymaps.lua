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
  local fzf = require("fzf-lua")

  map("n", "gd", fzf.lsp_definitions, "goto definition (fzf)")
  map("n", "gD", fzf.lsp_declarations, "goto declaration (fzf)")
  map("n", "gr", fzf.lsp_references, "goto references (fzf)")
  map("n", "gI", fzf.lsp_implementations, "goto implementations (fzf)")
  map("n", "<leader>D", fzf.lsp_typedefs, "type definition")
  map("n", "<leader>ds", fzf.lsp_document_symbols, "document symbols")
  map("n", "<leader>ws", fzf.lsp_workspace_symbols, "workspace symbols")
  map("n", "<leader>sd", fzf.diagnostics_document, "document diagnsostics")
  map("n", "<leader>sD", fzf.diagnostics_workspace, "workspace diagnostics")
  map("n", "<leader>ca", fzf.lsp_code_actions, "code action")
end

return M
