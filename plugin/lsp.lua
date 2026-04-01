vim.pack.add({
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/folke/lazydev.nvim",
  "https://github.com/j-hui/fidget.nvim",
})

require("lazydev").setup({
  library = {
    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
  },
})

require("fidget").setup({})

local Lsp = require("config.lsp")

for server, config in pairs(Lsp.configs) do
  vim.lsp.config(server, config)
end

vim.lsp.enable(Lsp.all_servers())
