return {
  "saghen/blink.cmp",

  version = "1.*",

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {

    appearance = {
      nerd_font_variant = "mono",
    },

    fuzzy = { implementation = "prefer_rust_with_warning" },

    completion = {
      trigger = {
        prefetch_on_insert = true,
        show_in_snippet = false,
        show_on_backspace = false,
        show_on_backspace_in_keyword = false,
        show_on_backspace_after_accept = false,
        show_on_backspace_after_insert_enter = false,
        show_on_keyword = false,
        show_on_trigger_character = false,
        show_on_insert = false,
        show_on_blocked_trigger_characters = { " ", "\n", "\t" },
        show_on_accept_on_trigger_character = false,
        show_on_insert_on_trigger_character = false,
        show_on_x_blocked_trigger_characters = { "'", '"', "(" },
      },

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
        snippets = {
          opts = {
            friendly_snippets = false,
          },
        },
      },
    },

    keymap = {
      preset = "none",
      ["<C-f>"] = { "accept" },
      ["<C-p>"] = { "select_prev", "fallback_to_mappings" },
      ["<C-n>"] = { "select_next", "fallback_to_mappings" },

      ["<C-k>"] = { "show_and_insert", "show_documentation", "hide_documentation" },
      ["<M-u>"] = { "scroll_documentation_up", "fallback" },
      ["<M-d>"] = { "scroll_documentation_down", "fallback" },

      ["<C-l>"] = { "snippet_forward", "fallback" },
      ["<C-h>"] = { "snippet_backward", "fallback" },

      ["<C-q>"] = { "cancel" },
    },
  },
  opts_extend = { "sources.default" },
}
