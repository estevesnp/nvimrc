vim.pack.add({ "https://github.com/martindur/zdiff.nvim" })

local map = require("config.utils").namespaced_keymap("zdiff")

vim.api.nvim_create_autocmd("FileType", {
  pattern = "zdiff",
  callback = function(event)
    local opts = { buffer = event.buf, silent = true }

    map("n", "<CR>", "<cmd>ZdiffOpen<cr>", "open file in editor", opts)
    map("n", "<Tab>", "<cmd>ZdiffToggle<cr>", "toggle file view", opts)
    map("n", "R", "<cmd>ZdiffRefresh<cr>", "refresh files", opts)
    map("n", "q", "<cmd>bdelete<cr>", "close zdiff buffer", opts)

    map("n", "m", function()
      if vim.b.zdiff.base == "" then
        vim.cmd("Zdiff main")
      else
        vim.cmd("Zdiff")
      end
    end, "toggle index between unstaged changes and main", opts)
  end,
})
