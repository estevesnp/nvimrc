vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local map = vim.keymap.set

-- ctrl+c and esc
map("i", "<C-c>", "<Esc>", { desc = "exit insert mode" })
map("n", "<Esc>", function()
  vim.snippet.stop()
  vim.cmd("nohlsearch")
end, { desc = "remove search and snippet highlights" })

-- lsp (without fzf keymaps)
require("config.lsp.keymaps").setup_bare_keymaps()

-- clipboard / paste buffer
map({ "n", "x" }, "<leader>y", '"+y', { desc = "yank to system clipboard" })
map({ "n", "x" }, "<leader>d", '"_d', { desc = "delete to void register" })
map({ "n", "x" }, "<leader>c", '"_c', { desc = "change preserving paste buffer" })
map("x", "<leader>p", '"_dP', { desc = "paste preserving paste buffer" })

-- toggle formatting
map("n", "<leader>tf", require("config.toggles.formatting").toggle_format_on_save, { desc = "toggle format on save" })

-- diagnostics
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "show diagnostic message" })
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "open diagnostic quickfix list" })
map("n", "<leader>td", require("config.toggles.diagnostics").toggle_diagnostics, { desc = "toggle diagnostics" })

-- quickfix list
map("n", "co", ":copen<CR>", { desc = "open quickfix list" })
map("n", "cq", ":cclose<CR>", { desc = "close quickfix list" })

-- jump tabs
map("n", "]t", "<cmd>tabnext<CR>", { desc = "next tab" })
map("n", "[t", "<cmd>tabprevious<CR>", { desc = "previous tab" })

-- center after navigation
map("n", "n", "nzzzv", { desc = "next search and center cursor" })
map("n", "N", "Nzzzv", { desc = "previous search and center cursor" })
map("n", "<C-d>", "<C-d>zz", { desc = "half page down and center cursor" })
map("n", "<C-u>", "<C-u>zz", { desc = "half page up and center cursor" })

-- netrw (overwritten by oil)
map("n", "<leader>rw", "<cmd>Ex<CR>", { desc = "open netrw" })

-- source lua
map("n", "<leader><leader>x", "<cmd>source %<CR>", { desc = "source lua file" })
map({ "n", "x" }, "<leader>x", ":.lua<CR>", { desc = "source lua selection" })

-- plenary (assumes plenary is installed)
map("n", "<leader>T", "<cmd>PlenaryBustedFile %<CR>", { desc = "run plenary tests in current file" })
