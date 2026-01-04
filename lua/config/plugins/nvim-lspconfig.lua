return {
  "neovim/nvim-lspconfig",
  dependencies = {
    -- lsp status updates
    { "j-hui/fidget.nvim", opts = {} },

    {
      -- for nvim configuration
      "folke/lazydev.nvim",
      ft = "lua",
      opts = {
        library = {
          -- load luvit types when the `vim.uv` word is found
          { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        },
      },
    },
  },

  config = function()
    local lsp = require("config.lsp.servers")

    for server, config in pairs(lsp.configs) do
      vim.lsp.config(server, config)
    end

    vim.lsp.enable(lsp.all_servers())
  end,
}
