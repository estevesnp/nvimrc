vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local map = vim.keymap.set

-- ctrl+c and esc
map("i", "<C-c>", "<Esc>", { desc = "exit insert mode" })
map("n", "<Esc>", function()
  vim.cmd("nohlsearch")
  vim.snippet.stop()
  vim.lsp.buf.clear_references()
end, { desc = "remove search, snippet and lsp highlights" })

-- clipboard / paste buffer
map({ "n", "x" }, "<leader>y", '"+y', { desc = "yank to system clipboard" })
map({ "n", "x" }, "<leader>d", '"_d', { desc = "delete to void register" })
map({ "n", "x" }, "<leader>c", '"_c', { desc = "change preserving paste buffer" })
map("x", "<leader>p", '"_dP', { desc = "paste preserving paste buffer" })

-- quickfix list
map("n", "<leader>qo", ":copen<CR>", { desc = "open quickfix list" })
map("n", "<leader>qc", ":cclose<CR>", { desc = "close quickfix list" })

-- jump tabs
map("n", "]t", "<cmd>tabnext<CR>", { desc = "next tab" })
map("n", "[t", "<cmd>tabprevious<CR>", { desc = "previous tab" })

-- center after navigation
map("n", "n", "nzzzv", { desc = "next search and center cursor" })
map("n", "N", "Nzzzv", { desc = "previous search and center cursor" })
map("n", "<C-d>", "<C-d>zz", { desc = "half page down and center cursor" })
map("n", "<C-u>", "<C-u>zz", { desc = "half page up and center cursor" })

-- split horizontally to match tmux. still have <C-w>v for vertical and <C-w>s for horizontal
map("n", "<C-w>b", ":split<CR>", { desc = "split buffer horizontally" })

-- netrw (overwritten by oil)
map("n", "<leader>rw", "<cmd>Ex<CR>", { desc = "open netrw" })

-- source lua
map({ "n", "x" }, "<leader>x", ":.lua<CR>", { desc = "source lua selection" })
map("n", "<leader>X", "<cmd>source %<CR>", { desc = "source lua file" })

-- diagnostics
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "show diagnostic message" })
map("n", "<leader>qd", vim.diagnostic.setqflist, { desc = "open diagnostic quickfix list" })
map("n", "<leader>td", require("config.diagnostics").toggle_diagnostics, { desc = "toggle diagnostics" })

-- undotree
vim.cmd("packadd nvim.undotree")
map("n", "<leader>u", ":Undotree<CR>", { desc = "toggle undotree" })

-- lsp
map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "lsp: rename" })
map("n", "gqd", vim.lsp.buf.definition, { desc = "lsp: goto definition (quickfix)" })
map("n", "gqr", vim.lsp.buf.references, { desc = "lsp: goto references (quickfix)" })
map("n", "gqi", vim.lsp.buf.implementation, { desc = "lsp: goto implementations (quickfix)" })
map({ "i", "n" }, "<C-s>", vim.lsp.buf.signature_help, { desc = "lsp: signature help" })
map("n", "<leader>l", vim.lsp.buf.document_highlight, { desc = "lsp: highlight reference" })
map("n", "<leader>th", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "lsp: toggle inlay hints" })
