vim.bo.tabstop = 2
vim.bo.softtabstop = 2
vim.bo.shiftwidth = 2

vim.opt_local.wrap = true
vim.opt_local.linebreak = true

vim.keymap.set({ "n", "v" }, "j", "gj", { buffer = true, silent = true })
vim.keymap.set({ "n", "v" }, "k", "gk", { buffer = true, silent = true })
