vim.pack.add({
  "https://github.com/stevearc/oil.nvim",
  "https://github.com/refractalize/oil-git-status.nvim",
})

local detail = false
local Oil = require("oil")

Oil.setup({
  default_file_explorer = true,
  skip_confirm_for_simple_edits = true,
  view_options = {
    show_hidden = true,
    is_always_hidden = function(name, _)
      return name == ".."
    end,
  },
  win_options = {
    signcolumn = "yes:2",
  },
  keymaps = {
    ["<C-c>"] = false,
    ["<C-l>"] = false,
    ["<C-h>"] = false,
    ["<M-r>"] = "actions.refresh",
    ["<M-s>"] = "actions.select_split",
    ["<M-b>"] = "actions.select_split",
    ["<M-v>"] = "actions.select_vsplit",
    ["q"] = "actions.close",
    ["td"] = {
      desc = "toggle file detail view",
      callback = function()
        detail = not detail
        if detail then
          Oil.set_columns({ "icon", "permissions", "size", "mtime" })
        else
          Oil.set_columns({ "icon" })
        end
      end,
    },
  },
})

local map = require("config.utils").namespaced_keymap("oil")
map("n", "-", Oil.open, "open file explorer")

require("oil-git-status").setup({})
