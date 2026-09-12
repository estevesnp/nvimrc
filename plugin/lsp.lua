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

for server, config in pairs(require("config.lsp").configs) do
  if not vim.tbl_isempty(config) then
    vim.lsp.config(server, config)
  end
  vim.lsp.enable(server)
end
