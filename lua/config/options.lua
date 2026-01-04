-- block cursor
vim.o.guicursor = ""
vim.o.cursorline = true

-- relative line number
vim.o.number = true
vim.o.relativenumber = true

-- tab / indentation opts
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.smarttab = true
vim.o.smartindent = true

-- / opts
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.inccommand = "split"

-- ask before erroring (e.g. closing unsaved file)
vim.o.confirm = true

-- always show gutter
vim.o.signcolumn = "yes"

-- disable wrap text
vim.o.wrap = false

-- line at col 80
vim.o.colorcolumn = "80"

-- top and bottom scrollof
vim.o.scrolloff = 5

-- key combination timeout
vim.o.updatetime = 50
vim.o.timeoutlen = 300

-- border around floating windows (e.g. K)
vim.o.winborder = "single"

-- setup diagnostics
require("config.toggles.diagnostics").set_default_diagnostic()

-- folds
vim.o.foldenable = false
vim.o.foldlevel = 99
vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"

-- disable mode on bottom, handled by lualine
vim.o.showmode = false

-- netrw relative line number
vim.g.netrw_bufsettings = "noma nomod nu rnu nobl nowrap ro"
vim.g.netrw_banner = 0

-- undofile
vim.o.swapfile = false
vim.o.backup = false
vim.o.undofile = true
