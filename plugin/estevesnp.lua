local Utils = require("config.utils")

local function cs_pack_cb()
  require("cs.lib.build").build_cswalk(true)
end

Utils.register_pack_cb("cs", {
  install = cs_pack_cb,
  update = cs_pack_cb,
})

vim.pack.add({
  "https://github.com/estevesnp/jq.nvim",
  "https://github.com/estevesnp/cs",
})

local map = Utils.namespaced_keymap("cs")
map("n", "<leader>cs", function()
  require("cs").search_projects()
end, "open project")

map("n", "<leader>cv", function()
  require("cs").search_projects({ action = "vsplit", prompt = "choose a project (vsplit)> " })
end, "open project in new vsplit")

map("n", "<leader>ct", function()
  require("cs").search_projects({ action = "tab", prompt = "choose a project (tab)> " })
end, "open project in new tab")
