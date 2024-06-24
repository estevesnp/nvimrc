vim.g.mapleader = " "

vim.keymap.set("n", "<leader>rw", vim.cmd.Ex, { desc = "Open Net[R][W]" })
vim.keymap.set("n", "<leader>rl", "<cmd>LspRestart<CR>", { desc = "[R]estart [L]SP" })

vim.keymap.set("n", "ç", "<C-e>", { desc = "Scroll Down" })
vim.keymap.set("n", "Ç", "<C-y>", { desc = "Scroll Up" })

vim.keymap.set("i", "<C-c>", "<Esc>", { desc = "Make <C-c> work as <Esc>" })

vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Remove search highlights" })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move lines down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move lines up" })

vim.keymap.set("n", "<leader>o", "o<ESC>", { desc = "Open new line down and stay in normal mode" })
vim.keymap.set("n", "<leader>O", "O<ESC>", { desc = "Open new line up and stay in normal mode" })

vim.keymap.set("n", "n", "nzzzv", { desc = "Better n" })

vim.keymap.set({ "n", "x" }, "<leader>y", '"+y', { desc = "[y]ank to system clipboard" })
vim.keymap.set("n", "<leader>Y", '"+Y', { desc = "[Y]ank to system clipboard" })

vim.keymap.set("x", "<leader>p", '"_dP', { desc = "Preserve paste register over selection" })

vim.keymap.set({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete to void register" })

-- Append to end of line without moving cursor
vim.keymap.set("n", "J", "mzJ`z", { desc = "Better J" })

-- Leave cursor in the middle when moving up and down
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Better <C-d>" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Better <C-u>" })

-- Leave selection in the middle of screen
vim.keymap.set("n", "N", "Nzzzv", { desc = "Better N" })

-- Diagnostics
vim.keymap.set("n", "<leader>pd", vim.diagnostic.goto_prev, { desc = "Go to [P]revious [D]iagnostic message" })
vim.keymap.set("n", "<leader>nd", vim.diagnostic.goto_next, { desc = "Go to [N]ext [D]iagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Splits
vim.keymap.set("n", "<C-w>h", "<cmd>split<CR>", { desc = "Split [H]orizontally" })
vim.keymap.set("n", "<C-w>v", "<cmd>vsplit<CR>", { desc = "Split [V]ertically" })
vim.keymap.set("n", "<C-Up>", "<cmd>resize +1<CR>", { desc = "Increase height" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -1<CR>", { desc = "Decrease height" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -5<CR>", { desc = "Decrease width" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +5<CR>", { desc = "Increase width" })
