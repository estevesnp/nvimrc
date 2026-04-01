vim.pack.add({ "https://github.com/mason-org/mason.nvim" })

local MasonHelper = require("config.mason-helpers")

require("mason").setup({
  install_root_dir = MasonHelper.install_dir,
  PATH = "append",
})

vim.api.nvim_create_user_command(
  "MasonPathInstall",
  MasonHelper.install_not_in_path,
  { desc = "install mason packages missing from path" }
)
