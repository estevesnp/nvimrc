return {
  "mason-org/mason.nvim",
  opts = {
    install_root_dir = vim.env.MASON_LSP_DIR or vim.fs.joinpath(vim.fn.stdpath("data"), "mason"),
    PATH = "append",
  },
}
