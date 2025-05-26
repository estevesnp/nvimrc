return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",

    "mason-org/mason.nvim",
    "jay-babu/mason-nvim-dap.nvim",
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    require("mason-nvim-dap").setup({ handlers = {} })

    local map = require("utils").namespaced_keymap("DAP")
    map("n", "<F5>", dap.continue, "Start/Continue")
    map("n", "<F1>", dap.step_into, "Step Into")
    map("n", "<F2>", dap.step_over, "Step Over")
    map("n", "<F3>", dap.step_out, "Step Out")
    map("n", "<F7>", dapui.toggle, "See last session result")
    map("n", "<leader>b", dap.toggle_breakpoint, "Toggle Breakpoint")
    map("n", "<leader>B", function()
      dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
    end, "Set Breakpoint")

    dapui.setup()
    dap.listeners.after.event_initialized["dapui_config"] = dapui.open
    dap.listeners.before.event_terminated["dapui_config"] = dapui.close
    dap.listeners.before.event_exited["dapui_config"] = dapui.close
  end,
}
