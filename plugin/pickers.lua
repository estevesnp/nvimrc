local Utils = require("config.utils")

local function pack_cb()
  require("fff.download").download_or_build_binary()
end

Utils.register_pack_cb("fff.nvim", {
  install = pack_cb,
  update = pack_cb,
})

vim.pack.add({
  "https://github.com/ibhagwan/fzf-lua",
  "https://github.com/dmtrKovalenko/fff.nvim",
})

-- fff

local FFF = require("fff")
FFF.setup({
  prompt = "> ",
  keymaps = {
    close = { "<Esc>", "<C-c>" },
  },
  layout = {
    width = 1,
    height = 1,
    prompt_position = "top",
    preview_position = "top",
  },
})

local fff_map = Utils.namespaced_keymap("picker(fff)")
fff_map("n", "<leader>sf", FFF.find_files, "search files")
fff_map("n", "<leader>sg", FFF.live_grep, "grep files")

--- fzf

local FZF = require("fzf-lua")
FZF.setup({
  "ivy",
  ui_select = true,
  ---@diagnostic disable-next-line: missing-fields
  hls = {
    preview_normal = "Normal",
  },
  grep = {
    actions = {
      ["ctrl-i"] = {
        fn = function(_, opts)
          FZF.actions.toggle_flag(_, vim.tbl_extend("force", opts, { toggle_flag = "--smart-case" }))
        end,
        desc = "toggle-flags",
        header = function(o)
          local cmd = o._cmd or o.cmd
          if cmd and cmd:match("%-%-smart%-case") then
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

local fzf_map = Utils.namespaced_keymap("picker(fzf)")

-- lsp
fzf_map("n", "gd", FZF.lsp_definitions, "goto definition (lsp)")
fzf_map("n", "gD", FZF.lsp_declarations, "goto declaration (lsp)")
fzf_map("n", "gr", FZF.lsp_references, "goto references (lsp)", { nowait = true })
fzf_map("n", "gI", FZF.lsp_implementations, "goto implementations (lsp)")
fzf_map("n", "<leader>D", FZF.lsp_typedefs, "type definition (lsp)")
fzf_map("n", "<leader>ss", FZF.lsp_document_symbols, "document symbols (lsp)")
fzf_map("n", "<leader>sS", FZF.lsp_workspace_symbols, "workspace symbols (lsp)")
fzf_map("n", "<leader>sd", FZF.diagnostics_document, "document diagnostics (lsp)")
fzf_map("n", "<leader>sD", FZF.diagnostics_workspace, "workspace diagnostics (lsp)")
fzf_map("n", "<leader>ca", FZF.lsp_code_actions, "code action (lsp)")

-- files/buffers
fzf_map("n", "<leader>Sf", FZF.files, "search files")
fzf_map("n", "<leader>so", FZF.oldfiles, "search old files")
fzf_map("n", "<leader>st", FZF.treesitter, "search treesitter")
fzf_map("n", "<leader>sb", FZF.buffers, "search buffers")
fzf_map("n", "<leader>sq", FZF.quickfix, "search quickfix")
fzf_map("n", "<leader>sm", FZF.marks, "search marks")
fzf_map("n", "<leader>se", FZF.global, "search everything (Global)")
fzf_map("n", "<leader>sh", function()
  local buf_dir = Utils.buf_dir()
  FZF.files({
    header = "search from " .. buf_dir,
    cwd = buf_dir,
  })
end, "search here, starting from buffer's dir")
fzf_map("n", "<leader>sc", function()
  FZF.files({
    header = "config files",
    cwd = "~/.config",
    follow = true,
  })
end, "search config files")
fzf_map("n", "<leader>sn", function()
  FZF.files({
    header = "neovim files",
    cwd = vim.fn.stdpath("config"),
  })
end, "search neovim files")
fzf_map("n", "<leader>sl", function()
  local stdlib_lang = Utils.get_stdlib_with_fallback()
  if not stdlib_lang then
    return
  end

  FZF.files({
    header = stdlib_lang.lang .. " stdlib files",
    cwd = stdlib_lang.stdlib,
  })
end, "search stdlib files")

-- git
fzf_map("n", "<leader>gf", FZF.git_files, "search git files")
fzf_map("n", "<leader>gs", FZF.git_status, "search git status")
fzf_map("n", "<leader>gc", FZF.git_bcommits, "search git buffer commits")
fzf_map("n", "<leader>gC", FZF.git_commits, "search git commits")

-- grep
fzf_map("n", "<leader>Sg", FZF.live_grep, "search grep")
fzf_map({ "n", "v" }, "<leader>sv", FZF.grep_visual, "search visual selection")
fzf_map("n", "<leader>/", FZF.lgrep_curbuf, "search current buffer")
fzf_map("n", "<leader>sw", FZF.grep_cword, "search current word")
fzf_map("n", "<leader>sW", FZF.grep_cWORD, "search current word")
fzf_map("n", "<leader>gh", function()
  local buf_dir = Utils.buf_dir()
  FZF.live_grep({
    winopts = {
      title = "Grep from " .. buf_dir,
    },
    cwd = buf_dir,
  })
end, "grep here, starting from buffer's dir")
fzf_map("n", "<leader>gl", function()
  local stdlib_lang = Utils.get_stdlib_with_fallback()
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
fzf_map("n", "<leader>sr", FZF.resume, "search resume")
fzf_map("n", "<leader>sk", FZF.keymaps, "search keymaps")
fzf_map("n", "<leader>sH", FZF.helptags, "search help")
fzf_map("n", "<leader>sz", FZF.builtin, "search fzf commands")
