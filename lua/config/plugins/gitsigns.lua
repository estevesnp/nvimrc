return {
  "lewis6991/gitsigns.nvim",
  config = function()
    local gitsigns = require("gitsigns")
    gitsigns.setup({
      current_line_blame = false,
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
      signcolumn = false,
    })

    local map = require("utils").namespaced_keymap("gitsigns")

    -- Navigation
    local next_change_key = "]c"
    local prev_change_key = "[c"
    map("n", next_change_key, function()
      if vim.wo.diff then
        vim.cmd.normal({ next_change_key, bang = true })
      else
        gitsigns.nav_hunk("next")
      end
    end, "next git change")

    map("n", prev_change_key, function()
      if vim.wo.diff then
        vim.cmd.normal({ prev_change_key, bang = true })
      else
        gitsigns.nav_hunk("prev")
      end
    end, "previous git change")
    map("n", "<leader>gq", gitsigns.setqflist, "set quickfix list with changes")

    -- Actions
    map("v", "<leader>gr", function()
      gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end, "reset hunk")
    map("n", "<leader>gr", gitsigns.reset_hunk, "reset hunk")
    map("n", "<leader>gR", gitsigns.reset_buffer, "reset buffer")
    map("n", "<leader>gp", gitsigns.preview_hunk, "preview hunk")
    map("n", "<leader>gb", gitsigns.blame_line, "git blame line")
    map("n", "<leader>gd", gitsigns.diffthis, "diff against index")
    map("n", "<leader>gD", function()
      gitsigns.diffthis("@")
    end, "diff against last commit")

    -- Toggles
    map("n", "<leader>tb", gitsigns.toggle_current_line_blame, "toggle blame lines")
    map("n", "<leader>ts", gitsigns.toggle_signs, "toggle git signs")
  end,
}
