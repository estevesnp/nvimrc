return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    branch = "main",
    build = ":TSUpdate",
    config = function()
      local treesitter = require("nvim-treesitter")

      -- if this becomes too slow, consider manually maintaining a list, or installing all
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "*" },
        group = vim.api.nvim_create_augroup("nvim-treesitter_auto-install", { clear = true }),
        callback = function()
          local lang = vim.treesitter.language.get_lang(vim.bo.filetype)

          if not lang then
            return
          end

          treesitter.install(lang)
        end,
      })
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
