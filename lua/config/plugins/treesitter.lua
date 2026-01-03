return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local treesitter = require("nvim-treesitter")
      local parsers = require("nvim-treesitter.parsers")

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("nvim-treesitter_auto-install-and-start", { clear = true }),
        callback = function(args)
          local buf = args.buf
          local lang = vim.treesitter.language.get_lang(args.match)

          if not lang or not parsers[lang] then
            return
          end

          treesitter.install(lang):await(function()
            if not vim.list_contains(treesitter.get_installed(), lang) then
              return
            end

            if not vim.api.nvim_buf_is_loaded(buf) then
              return
            end

            pcall(vim.treesitter.start, buf, lang)
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
