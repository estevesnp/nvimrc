return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    branch = "main",
    build = ":TSUpdate",
    config = function()
      local treesitter = require("nvim-treesitter")

      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = { "*" },
        group = vim.api.nvim_create_augroup("nvim-treesitter_auto-install-and-start", { clear = true }),
        callback = function()
          local lang = vim.treesitter.language.get_lang(vim.bo.filetype)

          if not lang then
            return
          end

          treesitter.install(lang):await(function()
            local installed = vim.list_contains(treesitter.get_installed(), lang)
            if not installed then
              return
            end

            vim.treesitter.start(nil, lang)
          end)
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
