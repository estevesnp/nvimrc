vim.pack.add({
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/nvim-treesitter/nvim-treesitter-context",
})

local Treesitter = require("nvim-treesitter")
local Parsers = require("nvim-treesitter.parsers")

Treesitter.install({
  -- vim
  "vim",
  "vimdoc",
  -- git
  "diff",
  "gitcommit",
  "git_config",
  "gitignore",
  -- markdown
  "markdown",
  "markdown_inline",
  -- data
  "json",
  "toml",
  "yaml",
  "csv",
  -- languages
  "lua",
  "zig",
  "c",
  "go",
  "rust",
  "javascript",
  "typescript",
  "python",
  "bash",
  "zsh",
  "sql",
})

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("nvim-treesitter_auto-install-and-start", { clear = true }),
  callback = function(args)
    local buf = args.buf
    local lang = vim.treesitter.language.get_lang(args.match)

    if not lang or not Parsers[lang] then
      return
    end

    Treesitter.install(lang):await(function()
      if not vim.list_contains(Treesitter.get_installed(), lang) then
        return
      end

      if not vim.api.nvim_buf_is_loaded(buf) then
        return
      end

      pcall(vim.treesitter.start, buf, lang)
    end)
  end,
})

local TreesitterContext = require("treesitter-context")
TreesitterContext.setup({
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

local map = require("config.utils").namespaced_keymap("treesitter-context")
map("n", "<leader>tt", TreesitterContext.toggle, "toggle context")
