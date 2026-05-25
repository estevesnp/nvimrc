local Utils = require("config.utils")

local function fff_pack_cb()
  require("fff.download").download_or_build_binary()
end

Utils.register_pack_cb("fff.nvim", {
  install = fff_pack_cb,
  update = fff_pack_cb,
})

vim.pack.add({
  "https://github.com/ibhagwan/fzf-lua",
  "https://github.com/dmtrKovalenko/fff.nvim",
})

--- fzf

local FZF = require("fzf-lua")

local function flag_toggle_opts(flag, header_name)
  return {
    fn = function(_, opts)
      FZF.actions.toggle_flag(_, vim.tbl_extend("force", opts, { toggle_flag = flag }))
    end,
    desc = header_name,
    header = function(o)
      local cmd = o._cmd or o.cmd
      if cmd and cmd:match(FZF.utils.lua_regex_escape(flag)) then
        return "disable " .. flag
      else
        return "enable " .. flag
      end
    end,
  }
end

FZF.setup({
  "ivy",
  ui_select = true,
  ---@diagnostic disable-next-line: missing-fields
  hls = {
    preview_normal = "Normal",
  },
  grep = {
    actions = {
      ["ctrl-i"] = flag_toggle_opts("--smart-case"),
      ["ctrl-h"] = flag_toggle_opts("--hidden"),
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
fzf_map("n", "gsd", Utils.split_and_call(FZF.lsp_definitions), "goto definition in new split (lsp)")
fzf_map("n", "gD", FZF.lsp_declarations, "goto declaration (lsp)")
fzf_map("n", "gsD", Utils.split_and_call(FZF.lsp_declarations), "goto declaration in new split (lsp)")
fzf_map("n", "gr", FZF.lsp_references, "goto references (lsp)", { nowait = true })
fzf_map("n", "gI", FZF.lsp_implementations, "goto implementations (lsp)")
fzf_map("n", "<leader>D", FZF.lsp_typedefs, "type definition (lsp)")
fzf_map("n", "<leader>ss", FZF.lsp_document_symbols, "document symbols (lsp)")
fzf_map("n", "<leader>sS", FZF.lsp_workspace_symbols, "workspace symbols (lsp)")
fzf_map("n", "<leader>sd", FZF.diagnostics_document, "document diagnostics (lsp)")
fzf_map("n", "<leader>sD", FZF.diagnostics_workspace, "workspace diagnostics (lsp)")
fzf_map("n", "<leader>ca", FZF.lsp_code_actions, "code action (lsp)")

-- files/buffers
fzf_map("n", "<leader>sf", FZF.files, "search files")
fzf_map("n", "<leader>sF", function()
  FZF.files({ follow = true })
end, "search files (follow symlinks)")
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
fzf_map("n", "<leader>s.", function()
  FZF.files({
    header = "dotfiles",
    cwd = "~/.dotfiles",
  })
end, "search dotfiles")
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
fzf_map("n", "<leader>so", FZF.oldfiles, "search old files")
fzf_map("n", "<leader>st", FZF.treesitter, "search treesitter")
fzf_map("n", "<leader>sb", FZF.buffers, "search buffers")
fzf_map("n", "<leader>sq", FZF.quickfix, "search quickfix")
fzf_map("n", "<leader>sm", FZF.marks, "search marks")
fzf_map("n", "<leader>se", FZF.global, "search everything (Global)")

-- git
fzf_map("n", "<leader>gf", FZF.git_files, "search git files")
fzf_map("n", "<leader>gs", FZF.git_status, "search git status")
fzf_map("n", "<leader>gc", FZF.git_bcommits, "search git buffer commits")
fzf_map("n", "<leader>gC", FZF.git_commits, "search git commits")

-- grep
fzf_map("n", "<leader>sg", FZF.live_grep, "search grep")
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
fzf_map({ "n", "v" }, "<leader>sv", FZF.grep_visual, "search visual selection")
fzf_map("n", "<leader>/", FZF.lgrep_curbuf, "search current buffer")
fzf_map("n", "<leader>sw", FZF.grep_cword, "search current word")
fzf_map("n", "<leader>sW", FZF.grep_cWORD, "search current word")

-- misc
fzf_map("n", "<leader>sr", FZF.resume, "search resume")
fzf_map("n", "<leader>sk", function()
  FZF.keymaps({ show_details = false })
end, "search keymaps")
fzf_map("n", "<leader>sH", FZF.helptags, "search help")
fzf_map("n", "<leader>sz", FZF.builtin, "search fzf commands")

-- fff

vim.g.fff = {
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
  follow_symlinks = true,
}

local fff_map = Utils.namespaced_keymap("picker(fff)")

fff_map("n", "<leader>af", function()
  require("fff").find_files()
end, "search files")
fff_map("n", "<leader>Sh", function()
  require("fff").find_files_in_dir(Utils.buf_dir())
end, "search here")
fff_map("n", "<leader>ag", function()
  require("fff").live_grep()
end, "grep files")
fff_map("n", "<leader>Gh", function()
  require("fff").live_grep({
    cwd = Utils.buf_dir(),
    title = "Live Grep here",
  })
end, "grep here")
