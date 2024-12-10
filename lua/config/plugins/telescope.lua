return {
  {
    'nvim-telescope/telescope.nvim', 
    tag = '0.1.8',
    dependencies = { 
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }
    },
    config = function() 

      require("telescope").setup {
        defaults = {
          mappings = {
            n = {
              ["<C-x>"] = require("telescope.actions").delete_buffer,
            },
            i = {
              ["<C-x>"] = require("telescope.actions").delete_buffer,
            },
          },
        },
        extensions = {
          fzf = {},
        },
      }

      require('telescope').load_extension('fzf')

      local builtin = require("telescope.builtin")
      local map = require("config.utils").namespaced_keymap("Telescope")

      map("n", "<leader>sf", builtin.find_files, "[S]earch [F]iles")
      map("n", "<leader>gf", builtin.git_files, "Search [G]it [F]iles")
      map("n", "<leader>sg", builtin.live_grep, "[S]earch [G]rep")
      map("n", "<leader>sd", builtin.diagnostics, "[S]earch [D]iagnostics")
      map("n", "<leader>sk", builtin.keymaps, "[S]earch [K]eymaps")
      map("n", "<leader>sb", builtin.buffers, "[S]earch [B]uffers")
      map("n", "<leader>sm", builtin.marks, "[S]earch [M]arks")
      map("n", "<leader>sw", builtin.grep_string, "[S]earch current [W]ord")
      map("n", "<leader>so", builtin.oldfiles, "[S]earch [O]ld Files")
      map("n", "<leader>ss", builtin.builtin, "[S]earch [S]elect Telescope")

      map("n", "<leader>/", function()
        builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown {
          winblend = 10,
        })
      end, "[/] Fuzzily search in current buffer")

      map("n", "<leader>sn", function()
        builtin.find_files({
          cwd = vim.fn.stdpath("config"),
          prompt_title = "Neovim Files",
        })
      end, "[S]earch [N]eovim files")

    end,
  }
}
