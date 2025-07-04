vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.keymap.set("n", "<leader><leader>x", "<cmd>source %<CR>")
vim.keymap.set("n", "<leader>x", ":.lua<CR>")
vim.keymap.set("v", "<leader>x", ":.lua<CR>")

vim.keymap.set("n", "<leader>rw", vim.cmd.Ex, { desc = "Open Net[R][W]" })
vim.keymap.set("n", "<leader>rl", "<cmd>LspRestart<CR>", { desc = "[R]estart [L]SP" })

vim.keymap.set("i", "<C-c>", "<Esc>", { desc = "Make <C-c> work as <Esc>" })

vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Remove search highlights" })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move lines down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move lines up" })

vim.keymap.set("n", "<leader>o", "o<ESC>", { desc = "Open new line down and stay in normal mode" })
vim.keymap.set("n", "<leader>O", "O<ESC>", { desc = "Open new line up and stay in normal mode" })

vim.keymap.set({ "n", "x" }, "<leader>y", '"+y', { desc = "[y]ank to system clipboard" })
vim.keymap.set("n", "<leader>Y", '"+Y', { desc = "[Y]ank to system clipboard" })

vim.keymap.set("x", "<leader>p", '"_dP', { desc = "Preserve paste register over selection" })

vim.keymap.set({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete to void register" })

-- Append to end of line without moving cursor
vim.keymap.set("n", "J", "mzJ`z", { desc = "Better J" })

-- Leave selection in the middle of screen
vim.keymap.set("n", "n", "nzzzv", { desc = "Better n" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Better N" })

-- Leave cursor in the middle when moving up and down
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Better <C-d>" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Better <C-u>" })

-- Quickfix
vim.keymap.set("n", "co", ":copen<CR>", { desc = "Open Quickfix List" })
vim.keymap.set("n", "cq", ":cclose<CR>", { desc = "Close Quickfix List" })
vim.keymap.set("n", "cn", ":cnext<CR>", { desc = "Next Quickfix Item" })
vim.keymap.set("n", "cp", ":cprev<CR>", { desc = "Previous Quickfix Item" })

-- Diagnostics
vim.keymap.set("n", "<leader>pd", function()
  vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Go to [P]revious [D]iagnostic message" })
vim.keymap.set("n", "<leader>nd", function()
  vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Go to [N]ext [D]iagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Stateful
vim.keymap.set("n", "<leader>td", require("config.custom.diagnostic"), { desc = "[T]oggle [D]iagnostics format" })
vim.keymap.set("n", "<leader>Z", require("config.custom.zen"), { desc = "Toggle [Z]en" })

-- Plenary
vim.keymap.set("n", "<leader>t", "<cmd>PlenaryBustedFile %<CR>", { desc = "Run Tests in current file" })

-- Tabs
vim.keymap.set("n", "<leader><Tab>", "<cmd>tabnext<CR>", { desc = "Go to next tab" })
vim.keymap.set("n", "<leader><S-Tab>", "<cmd>tabprevious<CR>", { desc = "Go to previous tab" })

-- Splits
vim.keymap.set("n", "<C-w>b", "<cmd>split<CR>", { desc = "Split Horizontally" })
vim.keymap.set("n", "<C-w>v", "<cmd>vsplit<CR>", { desc = "Split [V]ertically" })
vim.keymap.set("n", "<C-Up>", "<cmd>resize +1<CR>", { desc = "Increase height" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -1<CR>", { desc = "Decrease height" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -5<CR>", { desc = "Decrease width" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +5<CR>", { desc = "Increase width" })
