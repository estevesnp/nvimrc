return {
  "saghen/blink.cmp",
  dependencies = { "rafamadriz/friendly-snippets" },

  version = "1.*",

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    appearance = {
      nerd_font_variant = "mono",
    },

    fuzzy = { implementation = "prefer_rust_with_warning" },

    completion = {
      documentation = {
        auto_show = false,
      },
      menu = {
        max_height = 25,
      },
    },

    sources = {
      default = { "lsp", "path", "snippets", "buffer" },

      providers = {
        buffer = {
          min_keyword_length = 3,
        },
      },
    },

    keymap = {
      preset = "none",
      ["<C-f>"] = { "accept" },
      ["<C-p>"] = { "select_prev", "fallback_to_mappings" },
      ["<C-n>"] = { "select_next", "fallback_to_mappings" },

      ["<C-k>"] = { "show", "show_documentation", "hide_documentation" },
      ["<M-u>"] = { "scroll_documentation_up", "fallback" },
      ["<M-d>"] = { "scroll_documentation_down", "fallback" },

      ["<C-l>"] = { "snippet_forward", "fallback" },
      ["<C-h>"] = { "snippet_backward", "fallback" },

      ["<C-q>"] = { "hide" },
    },
  },
  opts_extend = { "sources.default" },
}
