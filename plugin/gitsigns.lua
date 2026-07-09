vim.pack.add({ "https://github.com/lewis6991/gitsigns.nvim" })

local Gitsigns = require("gitsigns")
Gitsigns.setup({
  signcolumn = true,
  current_line_blame = false,
  signs = {
    add = { text = "+" },
    change = { text = "~" },
    delete = { text = "_" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
  },
})

local map = require("config.utils").namespaced_keymap("gitsigns")

-- Navigation
local next_change_key = "]c"
local prev_change_key = "[c"
map("n", next_change_key, function()
  if vim.wo.diff then
    vim.cmd.normal({ next_change_key, bang = true })
  else
    Gitsigns.nav_hunk("next")
  end
end, "next git change")

map("n", prev_change_key, function()
  if vim.wo.diff then
    vim.cmd.normal({ prev_change_key, bang = true })
  else
    Gitsigns.nav_hunk("prev")
  end
end, "previous git change")
map("n", "<leader>gq", Gitsigns.setqflist, "set quickfix list with changes")

-- Actions
map("v", "<leader>gr", function()
  Gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
end, "reset hunk")
map("n", "<leader>gr", Gitsigns.reset_hunk, "reset hunk")
map("n", "<leader>gR", Gitsigns.reset_buffer, "reset buffer")
map("n", "<leader>gp", Gitsigns.preview_hunk, "preview hunk")
map("n", "<leader>gb", Gitsigns.blame_line, "git blame line")
map("n", "<leader>gd", Gitsigns.diffthis, "diff against index")
map("n", "<leader>gD", function()
  Gitsigns.diffthis("@")
end, "diff against last commit")

-- Toggles
map("n", "<leader>tb", Gitsigns.toggle_current_line_blame, "toggle blame lines")
map("n", "<leader>ts", Gitsigns.toggle_signs, "toggle git signs")

local diff_against_different_base = false

map("n", "<leader>td", function()
  diff_against_different_base = not diff_against_different_base
  if diff_against_different_base then
    Gitsigns.change_base("main", true)
    vim.notify("gitsigns: diffing vs main", vim.log.levels.INFO)
  else
    Gitsigns.reset_base(true)
    vim.notify("gitsigns: diffing vs index", vim.log.levels.INFO)
  end
end, "gitsigns: toggle diff vs main")

vim.api.nvim_create_user_command("DiffBase", function(args)
  if args.args ~= "" then
    diff_against_different_base = true
    Gitsigns.change_base(args.args, true)
    vim.notify("gitsigns: diffing vs " .. args.args, vim.log.levels.INFO)
  else
    diff_against_different_base = false
    Gitsigns.reset_base(true)
    vim.notify("gitsigns: diffing vs index", vim.log.levels.INFO)
  end
end, { desc = "gitsigns: set diff base", nargs = "?" })
