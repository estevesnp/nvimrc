return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "go",
        "zig",
        "rust",
        "c",
        "html",
        "lua",
        "vim",
        "vimdoc",
        "diff",
        "git_rebase",
        "gitcommit",
      },
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
    },

    config = function(_, opts)
      require("nvim-treesitter.install").prefer_git = true
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      local treesitter_context = require("treesitter-context")
      treesitter_context.setup({
        enable = true,
        max_lines = 0,
        min_window_height = 0,
        line_numbers = true,
        multiline_threshold = 20,
        trim_scope = "outer",
        mode = "cursor",
        separator = nil,
        zindex = 20,
        on_attach = nil,
      })

      local map = require("utils").namespaced_keymap("Treesitter-Context")
      map("n", "<leader>ts", treesitter_context.toggle, "Toggle Context")
    end,
  },
}
