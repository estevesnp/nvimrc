return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("fzf-lua.providers.ui_select").register()
    local fzf = require("fzf-lua")
    local utils = require("utils")

    fzf.setup(vim.tbl_deep_extend("force", require("config.custom.old-ivy"), {
      winopts = {
        height = 0.8,
      },
      hls = {
        preview_normal = "Normal",
      },
      files = {
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
                return "Disable Smart Case"
              else
                return "Enable Smart Case"
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
          ["ctrl-b"] = fzf.actions.file_split,
          ["ctrl-v"] = fzf.actions.file_vsplit,
        },
      },
    }))

    local map = utils.namespaced_keymap("FZF")

    -- files/buffers
    map("n", "<leader>sf", fzf.files, "[S]earch [F]iles")
    map("n", "<leader>so", fzf.oldfiles, "[S]earch [O]ld Files")
    map("n", "<leader>st", fzf.treesitter, "[S]earch [T]reesitter")
    map("n", "<leader>sb", fzf.buffers, "[S]earch [B]uffers")
    map("n", "<leader>sq", fzf.quickfix, "[S]earch [Q]uickfix")
    map("n", "<leader>sm", fzf.marks, "[S]earch [M]arks")
    map("n", "<leader>se", fzf.global, "[S]earch [E]verything (Global)")
    map("n", "<leader>sh", function()
      local buf_dir = utils.buf_dir()
      fzf.files({
        header = "Search from " .. buf_dir,
        cwd = buf_dir,
      })
    end, "[S]earch [h]ere, starting from buffer's dir")
    map("n", "<leader>sc", function()
      fzf.files({
        header = "Config Files",
        cwd = "~/.config",
        follow = true,
      })
    end, "[S]earch [C]onfig files")
    map("n", "<leader>sn", function()
      fzf.files({
        header = "Neovim Files",
        cwd = vim.fn.stdpath("config"),
      })
    end, "[S]earch [N]eovim files")
    map("n", "<leader>sl", function()
      local stdlib_lang = utils.get_stdlib_with_fallback()
      if not stdlib_lang then
        return
      end

      fzf.files({
        header = stdlib_lang.lang .. " stdlib files",
        cwd = stdlib_lang.stdlib,
      })
    end, "[S]earch std[L]ib files")

    -- git
    map("n", "<leader>gf", fzf.git_files, "Search [G]it [F]iles")
    map("n", "<leader>gs", fzf.git_status, "Search [G]it [S]tatus")
    map("n", "<leader>gc", fzf.git_bcommits, "Search [G]it buffer [c]ommits")
    map("n", "<leader>gC", fzf.git_commits, "Search [G]it [C]ommits")

    -- grep
    map("n", "<leader>sg", fzf.live_grep, "[S]earch [G]rep")
    map({ "n", "v" }, "<leader>sv", fzf.grep_visual, "[S]earch [V]isual selection")
    map("n", "<leader>/", fzf.lgrep_curbuf, "Search current buffer")
    map("n", "<leader>sw", fzf.grep_cword, "[S]earch current [w]ord")
    map("n", "<leader>sW", fzf.grep_cWORD, "[S]earch current [W]ord")
    map("n", "<leader>gh", function()
      local buf_dir = utils.buf_dir()
      fzf.live_grep({
        winopts = {
          title = "Grep from " .. buf_dir,
        },
        cwd = buf_dir,
      })
    end, "[G]rep [H]ere, starting from buffer's dir")
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
    end, "[G]rep std[L]ib")

    -- misc
    map("n", "<leader>sr", fzf.resume, "[S]earch [R]esume")
    map("n", "<leader>sk", fzf.keymaps, "[S]earch [K]eymaps")
    map("n", "<leader>sH", fzf.helptags, "[S]earch [H]elp")
    map("n", "<leader>sz", fzf.builtin, "[S]earch F[Z]F commands")
  end,
}
