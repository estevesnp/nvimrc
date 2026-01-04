return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local fzf = require("fzf-lua")
    local utils = require("utils")

    fzf.setup({
      "ivy",
      ui_select = true,
      hls = {
        preview_normal = "Normal",
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
              fzf.actions.toggle_flag(
                _,
                vim.tbl_extend("force", opts, {
                  toggle_flag = "--smart-case",
                })
              )
            end,
            desc = "toggle-flags",
            header = function(o)
              local flag = o.toggle_smart_case_flag or "--smart-case"
              if o.cmd and o.cmd:match(fzf.utils.lua_regex_escape(flag)) then
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
            ["ctrl-h"] = { fn = fzf.actions.git_stage, reload = true },
            ["ctrl-l"] = { fn = fzf.actions.git_unstage, reload = true },
            ["ctrl-x"] = { fn = fzf.actions.git_reset, reload = true },
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
          ["ctrl-s"] = fzf.actions.file_split,
          ["ctrl-b"] = fzf.actions.file_split,
          ["ctrl-v"] = fzf.actions.file_vsplit,
        },
      },
    })

    require("config.lsp.keymaps").setup_fzf_keymaps()

    local map = utils.namespaced_keymap("fzf")

    -- files/buffers
    map("n", "<leader>sf", fzf.files, "search files")
    map("n", "<leader>so", fzf.oldfiles, "search old files")
    map("n", "<leader>st", fzf.treesitter, "search treesitter")
    map("n", "<leader>sb", fzf.buffers, "search buffers")
    map("n", "<leader>sq", fzf.quickfix, "search quickfix")
    map("n", "<leader>sm", fzf.marks, "search marks")
    map("n", "<leader>se", fzf.global, "search everything (Global)")
    map("n", "<leader>sh", function()
      local buf_dir = utils.buf_dir()
      fzf.files({
        header = "search from " .. buf_dir,
        cwd = buf_dir,
      })
    end, "search here, starting from buffer's dir")
    map("n", "<leader>sc", function()
      fzf.files({
        header = "config files",
        cwd = "~/.config",
        follow = true,
      })
    end, "search config files")
    map("n", "<leader>sn", function()
      fzf.files({
        header = "neovim files",
        cwd = vim.fn.stdpath("config"),
      })
    end, "search neovim files")
    map("n", "<leader>sl", function()
      local stdlib_lang = utils.get_stdlib_with_fallback()
      if not stdlib_lang then
        return
      end

      fzf.files({
        header = stdlib_lang.lang .. " stdlib files",
        cwd = stdlib_lang.stdlib,
      })
    end, "search stdlib files")

    -- git
    map("n", "<leader>gf", fzf.git_files, "search git files")
    map("n", "<leader>gs", fzf.git_status, "search git status")
    map("n", "<leader>gc", fzf.git_bcommits, "search git buffer commits")
    map("n", "<leader>gC", fzf.git_commits, "search git commits")

    -- grep
    map("n", "<leader>sg", fzf.live_grep, "search grep")
    map({ "n", "v" }, "<leader>sv", fzf.grep_visual, "search visual selection")
    map("n", "<leader>/", fzf.lgrep_curbuf, "search current buffer")
    map("n", "<leader>sw", fzf.grep_cword, "search current word")
    map("n", "<leader>sW", fzf.grep_cWORD, "search current word")
    map("n", "<leader>gh", function()
      local buf_dir = utils.buf_dir()
      fzf.live_grep({
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

      fzf.live_grep({
        winopts = {
          title = "Grep " .. stdlib_lang.lang .. " stdlib",
        },
        cwd = stdlib_lang.stdlib,
      })
    end, "grep stdlib")

    -- misc
    map("n", "<leader>sr", fzf.resume, "search resume")
    map("n", "<leader>sk", fzf.keymaps, "search keymaps")
    map("n", "<leader>sH", fzf.helptags, "search help")
    map("n", "<leader>sz", fzf.builtin, "search fzf commands")
  end,
}
