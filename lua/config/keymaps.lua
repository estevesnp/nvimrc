vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local map = vim.keymap.set

-- ctrl+c and esc
map("i", "<C-c>", "<Esc>", { desc = "exit insert mode" })
map("n", "<Esc>", function()
  vim.cmd("nohlsearch")
  vim.snippet.stop()
  vim.lsp.buf.clear_references()
end, { desc = "remove search, snippet and lsp highlights" })

-- select last changed text
map("n", "gV", "`[v`]", { desc = "select last changed text" })

-- clipboard / paste buffer
map({ "n", "x" }, "<leader>y", '"+y', { desc = "yank to system clipboard" })
map({ "n", "x" }, "<leader>d", '"_d', { desc = "delete to void register" })
map({ "n", "x" }, "<leader>c", '"_c', { desc = "change preserving paste buffer" })
map("x", "<leader>p", '"_dP', { desc = "paste preserving paste buffer" })

-- quickfix list
map("n", "<leader>qo", ":copen<CR>", { desc = "open quickfix list" })
map("n", "<leader>qc", ":cclose<CR>", { desc = "close quickfix list" })

-- jump tabs
map("n", "]t", "<cmd>tabnext<CR>", { desc = "next tab" })
map("n", "[t", "<cmd>tabprevious<CR>", { desc = "previous tab" })

-- center after navigation
map("n", "n", "nzzzv", { desc = "next search and center cursor" })
map("n", "N", "Nzzzv", { desc = "previous search and center cursor" })
map("n", "<C-d>", "<C-d>zz", { desc = "half page down and center cursor" })
map("n", "<C-u>", "<C-u>zz", { desc = "half page up and center cursor" })

-- split horizontally to match tmux. still have <C-w>v for vertical and <C-w>s for horizontal
map("n", "<C-w>b", ":split<CR>", { desc = "split buffer horizontally" })

-- netrw (overwritten by oil)
map("n", "<leader>rw", "<cmd>Ex<CR>", { desc = "open netrw" })

-- source lua
map({ "n", "x" }, "<leader>x", ":.lua<CR>", { desc = "source lua selection" })
map("n", "<leader>X", "<cmd>source %<CR>", { desc = "source lua file" })

-- diagnostics
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "show diagnostic message" })
map("n", "<leader>qd", vim.diagnostic.setqflist, { desc = "open diagnostic quickfix list" })
map("n", "]e", function()
  vim.diagnostic.jump({ severity = vim.diagnostic.severity.ERROR, count = vim.v.count1 })
end, { desc = "jump to next error" })
map("n", "[e", function()
  vim.diagnostic.jump({ severity = vim.diagnostic.severity.ERROR, count = -vim.v.count1 })
end, { desc = "jump to previous error" })
map("n", "<leader>tD", require("config.diagnostics").toggle_diagnostics, { desc = "toggle diagnostics" })

-- undotree
vim.cmd("packadd nvim.undotree")
map("n", "<leader>u", ":Undotree<CR>", { desc = "toggle undotree" })

-- lsp (check plugin/pickers.lua for rest of keymaps)
map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "lsp: rename" })
map("n", "gqd", vim.lsp.buf.definition, { desc = "lsp: goto definition (quickfix)" })
map("n", "gqr", vim.lsp.buf.references, { desc = "lsp: goto references (quickfix)" })
map("n", "gqi", vim.lsp.buf.implementation, { desc = "lsp: goto implementations (quickfix)" })
map({ "i", "n" }, "<C-s>", vim.lsp.buf.signature_help, { desc = "lsp: signature help" })
map("n", "<leader>l", vim.lsp.buf.document_highlight, { desc = "lsp: highlight reference" })
map("n", "<leader>th", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "lsp: toggle inlay hints" })

-- term
map("t", "<C-[>", [[<C-\><C-n>]], { desc = "exit term mode" })
map("n", "<leader>T", ":tab term<CR>", { desc = "open terminal in new tab" })
map("n", "<leader>R", function()
  vim.ui.input({ prompt = "run: " }, function(cmd)
    if cmd and cmd ~= "" then
      vim.cmd("vnew")
      vim.fn.jobstart(cmd, { term = true })
    end
  end)
end, { desc = "run shell command in a new split" })

-- :h cmdatom-macro
-- Track the last 20 atoms.
local atom_ring = {} ---@type vim.event.cmdatom.data[]
vim.api.nvim_create_autocmd("CmdAtom", {
  callback = function(ev)
    -- Skip this mapping itself, and cmdwin edits.
    if ev.data.lhs ~= " " and vim.fn.getcmdwintype() == "" then
      atom_ring[#atom_ring + 1] = ev.data
      if #atom_ring > 20 then
        table.remove(atom_ring, 1)
      end
    end
  end,
})
-- [count]<space> shows a cmdwin where the user can edit/save the last [count] atoms as a "macro".
-- <space> (no count) replays it.
map("n", "<Space>", function()
  local count = vim.v.count
  -- CmdAtom is deferred; schedule it so pending events land in the ring first.
  vim.schedule(function()
    count = math.min(count, #atom_ring)
    if count == 0 then -- Replay the saved macro.
      for _, step in ipairs(vim.g.atom_macro or {}) do
        vim.api.nvim_feedkeys(vim.keycode(step.keys or step.lhs), step.keys and "n" or "m", false)
      end
      return
    end
    local parts = {}
    for i = #atom_ring - count + 1, #atom_ring do
      local a = atom_ring[i]
      local keys = a.keys or ("%s%s"):format(a.count or "", a.lhs)
      local field = a.keys and "keys" or "lhs"
      parts[#parts + 1] = ("{%s=%q},"):format(field, vim.fn.keytrans(keys))
    end
    local cmd = ("lua vim.g.atom_macro = { %s }"):format(table.concat(parts, " "))
    -- Draft it on the cmdline; CTRL-F opens the cmdwin to edit it.
    vim.api.nvim_feedkeys((":%s%s"):format(cmd, vim.keycode("<C-f>")), "n", false)
  end)
end, { desc = "cmdatom-macro" })
