vim.pack.add({
  "https://codeberg.org/mfussenegger/nvim-dap",
  "https://github.com/igorlfs/nvim-dap-view",
})

local Dap = require("dap")
local DapView = require("dap-view")

local mason_install_dir = require("config.mason-helpers").install_dir

Dap.adapters.codelldb = {
  type = "server",
  port = "${port}",
  executable = {
    command = vim.fs.joinpath(mason_install_dir, "bin", "codelldb"),
    args = { "--port", "${port}" },
  },
}

Dap.configurations.zig = {
  {
    name = "Launch",
    type = "codelldb",
    request = "launch",
    program = "${workspaceFolder}/zig-out/bin/${workspaceFolderBasename}",
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
    args = {},
  },
}

DapView.setup({
  winbar = {
    controls = {
      enabled = true,
    },
  },
})

local map = require("config.utils").namespaced_keymap("dap")

map("n", "<leader>vc", Dap.continue, "start/continue")
map("n", "<leader>vv", Dap.step_over, "step over")
map("n", "<leader>vi", Dap.step_into, "step into")
map("n", "<leader>vo", Dap.step_out, "step out")
map("n", "<leader>vq", Dap.disconnect, "step out")
map("n", "<leader>vt", DapView.toggle, "toggle view")

map("n", "<leader>b", Dap.toggle_breakpoint, "toggle breakpoint")
map("n", "<leader>B", function()
  local ok, condition = pcall(vim.fn.input, "breakpoint condition: ")
  if not ok or condition == "" then
    return
  end

  Dap.set_breakpoint(condition)
end, "set conditional breakpoint")
