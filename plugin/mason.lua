vim.pack.add({ "https://github.com/mason-org/mason.nvim" })

require("mason").setup({
  install_root_dir = require("config.mason-helpers").install_dir,
  PATH = "append",
})

vim.api.nvim_create_user_command(
  "MasonPathInstall",
  require("config.mason-helpers").install_not_in_path,
  { desc = "install mason packages missing from path" }
)
