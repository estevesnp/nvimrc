-- Cursor settings
vim.opt.guicursor = ""
vim.opt.cursorline = true

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Indentation
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.smartindent = true

-- Search settings
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = "split"

-- Always show the sign column (on the left)
vim.opt.signcolumn = "yes"

-- Disable line wrapping
vim.opt.wrap = false

-- Show 80 character column
vim.opt.colorcolumn = "80"

-- Always keep 10 lines above and below the cursor
vim.opt.scrolloff = 10

-- Set the timeout for key sequences
vim.opt.updatetime = 50
vim.opt.timeoutlen = 300

-- Disable the mode indicator (lualine already shows it)
vim.opt.showmode = false

-- Enable netrw relative line numbers
vim.g.netrw_bufsettings = "noma nomod nu rnu nobl nowrap ro"
vim.g.netrw_banner = 0

-- Disable swap and backup files, use undodir
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- Highlight when yanking text
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Prettier error diagnostics
vim.diagnostic.config({
	float = {
		focusable = false,
		style = "minimal",
		border = "rounded",
		source = true,
		header = "",
		prefix = "",
	},
})
