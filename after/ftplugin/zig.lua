vim.g.zig_fmt_parse_errors = 0
vim.g.zig_fmt_autosave = 0

local map = require("utils").namespaced_keymap("Zig")

local ignore_under_cursor = function()
  local word = vim.fn.expandcmd("<cword>")
  local raw_keys = "o_ = " .. word .. ";<ESC>"
  local keys = vim.api.nvim_replace_termcodes(raw_keys, true, false, true)
  vim.api.nvim_feedkeys(keys, "n", false)
end

map("n", "<leader>zi", ignore_under_cursor, "Ignore word under cursor")
