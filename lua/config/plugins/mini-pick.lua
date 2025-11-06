return {
  "nvim-mini/mini.pick",
  version = false,
  config = function()
    local MiniPick = require("mini.pick")
    local map = require("utils").namespaced_keymap("MiniPick")

    MiniPick.setup()
    map("n", "<leader>mf", MiniPick.builtin.files, "Search Files")
    map("n", "<leader>mg", MiniPick.builtin.grep_live, "Live Grep")
    map("n", "<leader>mG", MiniPick.builtin.grep, "Grep")
    map("n", "<leader>mb", MiniPick.builtin.buffers, "Search Buffers")
    map("n", "<leader>mh", MiniPick.builtin.help, "Search Help")
    map("n", "<leader>mr", MiniPick.builtin.resume, "Resume last picker")
  end,
}
