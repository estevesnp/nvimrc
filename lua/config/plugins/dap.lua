return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    dapui.setup()

    dap.listeners.before.attach.dapui_config = dapui.open
    dap.listeners.before.launch.dapui_config = dapui.open
    dap.listeners.before.event_terminated.dapui_config = dapui.close
    dap.listeners.before.event_exited.dapui_config = dapui.close

    local map = require("utils").namespaced_keymap("dap")

    map("n", "<F5>", dap.continue, "start/continue")
    map("n", "<F1>", dap.step_into, "step into")
    map("n", "<F2>", dap.step_over, "step over")
    map("n", "<F3>", dap.step_out, "step out")
    map("n", "<F7>", dapui.toggle, "see last session result")

    map("n", "<leader>b", dap.toggle_breakpoint, "toggle breakpoint")
    map("n", "<leader>B", function()
      local ok, condition = pcall(vim.fn.input, "breakpoint condition: ")
      if not ok or condition == "" then
        return
      end

      dap.set_breakpoint(condition)
    end, "set conditional breakpoint")
  end,
}
