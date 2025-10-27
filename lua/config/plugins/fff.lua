return {
  "dmtrKovalenko/fff.nvim",
  build = function()
    require("fff.download").download_or_build_binary()
  end,
  config = function()
    local fff = require("fff")
    local utils = require("utils")

    fff.setup({
      prompt = "> ",
      keymaps = {
        close = { "<Esc>", "<C-c>" },
      },
      layout = {
        height = 1,
        width = 1,
        prompt_position = "top",
        preview_position = "top",
      },
    })

    local map = utils.namespaced_keymap("fff")

    map("n", "<leader>af", fff.find_files, "Se[A]rch [F]iles")
    map("n", "<leader>ag", fff.find_in_git_root, "Se[A]rch [G]it Files")
    map("n", "<leader>ah", function()
      fff.find_files_in_dir(utils.buf_dir())
    end, "Se[A]rch Files [H]ere")
  end,
}
