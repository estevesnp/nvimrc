local utils = require("utils")

return {
  {
    "dmtrKovalenko/fff.nvim",
    build = function()
      require("fff.download").download_or_build_binary()
    end,
    config = function()
      local FFF = require("fff")

      FFF.setup({
        prompt = "> ",
        keymaps = {
          close = { "<Esc>", "<C-c>" },
        },
        layout = {
          width = 1,
          height = 1.01, -- to cover the whole background
          prompt_position = "top",
          preview_position = "top",
        },
      })

      local map = utils.namespaced_keymap("picker(fff)")

      -- search
      map("n", "<leader>sf", FFF.find_files, "search files")
      map("n", "<leader>gf", FFF.find_in_git_root, "search git files")
      map("n", "<leader>sg", FFF.live_grep, "grep files")
    end,
  },

  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local FZF = require("fzf-lua")

      FZF.setup({
        "ivy",
        ui_select = true,
        ---@diagnostic disable-next-line: missing-fields
        hls = {
          preview_normal = "Normal",
          ---@diagnostic disable-next-line: missing-fields
          fzf = {},
        },
        files = {
          -- exclude .jj
          fd_opts = [[--color=never --hidden --type f --type l --exclude .git --exclude .jj]],
          rg_opts = [[--color=never --hidden --files -g "!.git" -g "!.jj"]],
          find_opts = [[-type f \! -path '*/.git/*' \! -path '*/.jj/*']],
        },
        grep = {
          actions = {
            ["ctrl-i"] = {
              fn = function(_, opts)
                FZF.actions.toggle_flag(
                  _,
                  vim.tbl_extend("force", opts, {
                    toggle_flag = "--smart-case",
                  })
                )
              end,
              desc = "toggle-flags",
              header = function(o)
                local flag = o.toggle_smart_case_flag or "--smart-case"
                if o.cmd and o.cmd:match(FZF.utils.lua_regex_escape(flag)) then
                  return "disable smart case"
                else
                  return "enable smart case"
                end
              end,
            },
          },
        },
        git = {
          status = {
            actions = {
              ["left"] = false,
              ["right"] = false,
              ["ctrl-h"] = { fn = FZF.actions.git_stage, reload = true },
              ["ctrl-l"] = { fn = FZF.actions.git_unstage, reload = true },
              ["ctrl-x"] = { fn = FZF.actions.git_reset, reload = true },
            },
          },
        },
        keymaps = {
          show_details = false,
        },
        keymap = {
          builtin = {
            true,
            ["<C-r>"] = "hide",
            ["<M-u>"] = "preview-page-up",
            ["<M-d>"] = "preview-page-down",
          },
          fzf = {
            true,
            ["alt-u"] = "preview-page-up",
            ["alt-d"] = "preview-page-down",
            ["ctrl-q"] = "select-all+accept",
          },
        },
        actions = {
          files = {
            true,
            ["ctrl-s"] = FZF.actions.file_split,
            ["ctrl-b"] = FZF.actions.file_split,
            ["ctrl-v"] = FZF.actions.file_vsplit,
          },
        },
      })

      require("config.lsp.keymaps").setup_fzf_keymaps()

      local map = utils.namespaced_keymap("picker(fzf)")

      -- files/buffers
      map("n", "<leader>af", FZF.files, "search files")
      map("n", "<leader>so", FZF.oldfiles, "search old files")
      map("n", "<leader>st", FZF.treesitter, "search treesitter")
      map("n", "<leader>sb", FZF.buffers, "search buffers")
      map("n", "<leader>sq", FZF.quickfix, "search quickfix")
      map("n", "<leader>sm", FZF.marks, "search marks")
      map("n", "<leader>se", FZF.global, "search everything (Global)")
      map("n", "<leader>sh", function()
        local buf_dir = utils.buf_dir()
        FZF.files({
          header = "search from " .. buf_dir,
          cwd = buf_dir,
        })
      end, "search here, starting from buffer's dir")
      map("n", "<leader>sc", function()
        FZF.files({
          header = "config files",
          cwd = "~/.config",
          follow = true,
        })
      end, "search config files")
      map("n", "<leader>sn", function()
        FZF.files({
          header = "neovim files",
          cwd = vim.fn.stdpath("config"),
        })
      end, "search neovim files")
      map("n", "<leader>sl", function()
        local stdlib_lang = utils.get_stdlib_with_fallback()
        if not stdlib_lang then
          return
        end

        FZF.files({
          header = stdlib_lang.lang .. " stdlib files",
          cwd = stdlib_lang.stdlib,
        })
      end, "search stdlib files")

      -- git
      map("n", "<leader>afg", FZF.git_files, "search git files")
      map("n", "<leader>gs", FZF.git_status, "search git status")
      map("n", "<leader>gc", FZF.git_bcommits, "search git buffer commits")
      map("n", "<leader>gC", FZF.git_commits, "search git commits")

      -- grep
      map("n", "<leader>ag", FZF.live_grep, "search grep")
      map({ "n", "v" }, "<leader>sv", FZF.grep_visual, "search visual selection")
      map("n", "<leader>/", FZF.lgrep_curbuf, "search current buffer")
      map("n", "<leader>sw", FZF.grep_cword, "search current word")
      map("n", "<leader>sW", FZF.grep_cWORD, "search current word")
      map("n", "<leader>gh", function()
        local buf_dir = utils.buf_dir()
        FZF.live_grep({
          winopts = {
            title = "Grep from " .. buf_dir,
          },
          cwd = buf_dir,
        })
      end, "grep here, starting from buffer's dir")
      map("n", "<leader>gl", function()
        local stdlib_lang = utils.get_stdlib_with_fallback()
        if not stdlib_lang then
          return
        end

        FZF.live_grep({
          winopts = {
            title = "Grep " .. stdlib_lang.lang .. " stdlib",
          },
          cwd = stdlib_lang.stdlib,
        })
      end, "grep stdlib")

      -- misc
      map("n", "<leader>sr", FZF.resume, "search resume")
      map("n", "<leader>sk", FZF.keymaps, "search keymaps")
      map("n", "<leader>sH", FZF.helptags, "search help")
      map("n", "<leader>sz", FZF.builtin, "search fzf commands")
    end,
  },
}
