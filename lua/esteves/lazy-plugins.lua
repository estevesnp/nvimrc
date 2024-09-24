require("lazy").setup({

	----------------------------
	-- LSP / LINTER / FORMATTING

	-- neovim/nvim-lspconfig
	require("esteves/plugins/lsp-config"),

	-- mfussenegger/nvim-lint
	require("esteves/plugins/lint"),

	-- hrsh7th/nvim-cmp
	require("esteves.plugins.cmp"),

	-- stevearc/conform.nvim
	require("esteves/plugins/conform"),

	-- mfussenegger/nvim-dap
	require("esteves/plugins/dap"),

	-- crispgm/nvim-go
	require("esteves/plugins/golang"),

	-- saecki/crates.nvim
	require("esteves/plugins/crates"),

	-- mfussenegger/nvim-jdtls
	require("esteves/plugins/jdtls"),

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

	-- refractalize/oil-git-status.nvim
	require("esteves/plugins/oil-git"),

	-- lewis6991/gitsigns.nvim
	require("esteves/plugins/gitsigns"),

	-- gbprod/yanky.nvim
	require("esteves/plugins/yanky"),

	-- jiaoshijie/undotree
	require("esteves/plugins/undotree"),

	-- github/copilot.vim
	require("esteves/plugins/copilot"),

	-- tpope/vim-commentary
	require("esteves/plugins/commentary"),

	-- tpop/vim-surround
	require("esteves/plugins/surround"),

	-- windwp/nvim-autopairs
	require("esteves/plugins/autopairs"),

	-- nvim-neo-tree/neo-tree.nvim
	require("esteves/plugins/neo-tree"),

	---------
	-- VISUAL

	-- nvim-treesitter/nvim-treesitter
	require("esteves/plugins/treesitter"),

	-- nvim-treesitter/nvim-treesitter-context
	require("esteves/plugins/treesitter-context"),

	-- nvim-lualine/lualine.nvim
	require("esteves/plugins/lualine"),

	-- lukas-reineke/indent-blankline.nvim
	require("esteves/plugins/indent"),

	-- iamcco/markdown-preview.nvim
	require("esteves/plugins/markdown-preview"),

	-- meanderingprogrammer/render-markdown.nvim
	require("esteves/plugins/render-markdown"),

	-- rose-pine/neovim
	require("esteves/plugins/rose-pine"),
})
