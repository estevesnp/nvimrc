require("lazy").setup({

	----------------------------
	-- LSP / LINTER / FORMATTING

	-- neovim/nvim-lspconfig
	require("esteves/plugins/lsp-config"),

	-- hrsh7th/nvim-cmp
	require("esteves/plugins/cmp"),

	-- stevearc/conform.nvim
	require("esteves/plugins/conform"),

	-- crispgm/nvim-go
	require("esteves/plugins/golang") or {},

	-- saecki/crates.nvim
	EnabledFeats.rust and require("esteves/plugins/crates") or {},

	-- mfussenegger/nvim-jdtls
	EnabledFeats.java and require("esteves/plugins/jdtls") or {},

	-------
	-- UTIL

	-- christoomey/vim-tmux-navigator
	require("esteves/plugins/tmux-navigator"),

	-- nvim-telescope/telescope.nvim
	require("esteves/plugins/telescope"),

	-- ThePrimeagen/harpoon
	require("esteves/plugins/harpoon"),

	-- stevearc/oil.nvim
	require("esteves/plugins/oil"),

	-- gbprod/yanky.nvim
	require("esteves/plugins/yanky"),

	-- jiaoshijie/undotree
	require("esteves/plugins/undotree"),

	-- tpope/vim-commentary
	require("esteves/plugins/commentary"),

	-- tpop/vim-surround
	require("esteves/plugins/surround"),

	-- windwp/nvim-autopairs
	require("esteves/plugins/autopairs"),

	-- lewis6991/gitsigns.nvim
	EnabledFeats.git and require("esteves/plugins/gitsigns") or {},

	-- refractalize/oil-git-status.nvim
	EnabledFeats.git and require("esteves/plugins/oil-git") or {},

	---------
	-- VISUAL

	-- nvim-treesitter/nvim-treesitter
	require("esteves/plugins/treesitter"),

	-- nvim-lualine/lualine.nvim
	require("esteves/plugins/lualine"),

	-- rose-pine/neovim
	require("esteves/plugins/rose-pine"),
})
