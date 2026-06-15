local Utils = require("config.utils")

--- use fff as main picker
local main_fff = true

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

--- configs

vim.g.fff = {
  prompt = "> ",
  layout = {
    width = 1,
    height = 1,
    prompt_position = "top",
    preview_position = "top",
  },
  follow_symlinks = true,
  prompt_vim_mode = true,
  hl = {
    normal = "Normal",
    border = "Normal",
  },
}

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

local fff_map = Utils.namespaced_keymap("picker(fff)")
local fzf_map = Utils.namespaced_keymap("picker(fzf)")

--- fzf keybinds

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

-- git
fzf_map("n", "<leader>gf", FZF.git_files, "search git files")
fzf_map("n", "<leader>gs", FZF.git_status, "search git status")
fzf_map("n", "<leader>gc", FZF.git_bcommits, "search git buffer commits")
fzf_map("n", "<leader>gC", FZF.git_commits, "search git commits")

-- misc
fzf_map("n", "<leader>so", FZF.oldfiles, "search old files")
fzf_map("n", "<leader>st", FZF.treesitter, "search treesitter")
fzf_map("n", "<leader>sb", FZF.buffers, "search buffers")
fzf_map("n", "<leader>sq", FZF.quickfix, "search quickfix")
fzf_map("n", "<leader>sm", FZF.marks, "search marks")
fzf_map("n", "<leader>se", FZF.global, "search everything (global)")
fzf_map("n", "<leader>sk", function()
  FZF.keymaps({ show_details = false })
end, "search keymaps")
fzf_map("n", "<leader>sH", FZF.helptags, "search help")
fzf_map("n", "<leader>sz", FZF.builtin, "search fzf commands")
fzf_map({ "n", "v" }, "<leader>sv", FZF.grep_visual, "search visual selection")
fzf_map("n", "<leader>/", FZF.lgrep_curbuf, "search current buffer")
fzf_map("n", "<leader>sw", FZF.grep_cword, "search current word")
fzf_map("n", "<leader>sW", FZF.grep_cWORD, "search current WORD")

--- mixed bindings

-- files
fff_map("n", main_fff and "<leader>sf" or "<leader>af", function()
  require("fff").find_files()
end, "search files")
fzf_map("n", main_fff and "<leader>af" or "<leader>sf", FZF.files, "search files")
fzf_map("n", main_fff and "<leader>aF" or "<leader>sF", function()
  FZF.files({ follow = true })
end, "search files (follow symlinks)")

-- search here
fff_map("n", main_fff and "<leader>sh" or "<leader>Sh", function()
  local buf_dir = Utils.buf_dir()
  require("fff").find_files({
    title = "search from " .. buf_dir,
    cwd = buf_dir,
  })
end, "search here, starting from buffer's dir")
fzf_map("n", main_fff and "<leader>Sh" or "<leader>sh", function()
  local buf_dir = Utils.buf_dir()
  FZF.files({
    header = "search from " .. buf_dir,
    cwd = buf_dir,
  })
end, "search here, starting from buffer's dir")

-- config files
fff_map("n", main_fff and "<leader>sc" or "<leader>Sc", function()
  require("fff").find_files({
    title = "config files",
    cwd = "~/.config",
  })
end, "search config files")
fzf_map("n", main_fff and "<leader>Sc" or "<leader>sc", function()
  FZF.files({
    header = "config files",
    cwd = "~/.config",
    follow = true,
  })
end, "search config files")

-- dotfiles
fff_map("n", main_fff and "<leader>s." or "<leader>S.", function()
  require("fff").find_files({
    title = "dotfiles",
    cwd = "~/.dotfiles",
  })
end, "search dotfiles")
fzf_map("n", main_fff and "<leader>S." or "<leader>s.", function()
  FZF.files({
    header = "dotfiles",
    cwd = "~/.dotfiles",
  })
end, "search dotfiles")

-- neovim files
fff_map("n", main_fff and "<leader>sn" or "<leader>Sn", function()
  require("fff").find_files({
    title = "neovim files",
    cwd = vim.fn.stdpath("config"),
  })
end, "search neovim files")
fzf_map("n", main_fff and "<leader>Sn" or "<leader>sn", function()
  FZF.files({
    header = "neovim files",
    cwd = vim.fn.stdpath("config"),
  })
end, "search neovim files")

-- stdlib files
fff_map("n", main_fff and "<leader>sl" or "<leader>Sl", function()
  local stdlib_lang = Utils.get_stdlib_with_fallback()
  if stdlib_lang then
    require("fff").find_files({
      title = stdlib_lang.lang .. " stdlib files",
      cwd = stdlib_lang.stdlib,
    })
  end
end, "search stdlib files")
fzf_map("n", main_fff and "<leader>Sl" or "<leader>sl", function()
  local stdlib_lang = Utils.get_stdlib_with_fallback()
  if stdlib_lang then
    FZF.files({
      header = stdlib_lang.lang .. " stdlib files",
      cwd = stdlib_lang.stdlib,
    })
  end
end, "search stdlib files")

-- grep
fff_map("n", main_fff and "<leader>sg" or "<leader>ag", function()
  require("fff").live_grep()
end, "search grep")
fzf_map("n", main_fff and "<leader>ag" or "<leader>sg", FZF.live_grep, "search grep")

-- grep here
fff_map("n", main_fff and "<leader>gh" or "<leader>Gh", function()
  local buf_dir = Utils.buf_dir()
  require("fff").live_grep({
    cwd = buf_dir,
    title = "Grep from " .. buf_dir,
  })
end, "grep here, starting from buffer's dir")
fzf_map("n", main_fff and "<leader>Gh" or "<leader>gh", function()
  local buf_dir = Utils.buf_dir()
  FZF.live_grep({
    winopts = { title = "Grep from " .. buf_dir },
    cwd = buf_dir,
  })
end, "grep here, starting from buffer's dir")

-- grep stdlib
fff_map("n", main_fff and "<leader>gl" or "<leader>Gl", function()
  local stdlib_lang = Utils.get_stdlib_with_fallback()
  if stdlib_lang then
    require("fff").live_grep({
      cwd = stdlib_lang.stdlib,
      title = "Grep " .. stdlib_lang.lang .. " stdlib",
    })
  end
end, "grep stdlib")
fzf_map("n", main_fff and "<leader>Gl" or "<leader>gl", function()
  local stdlib_lang = Utils.get_stdlib_with_fallback()
  if stdlib_lang then
    FZF.live_grep({
      winopts = { title = "Grep " .. stdlib_lang.lang .. " stdlib" },
      cwd = stdlib_lang.stdlib,
    })
  end
end, "grep stdlib")

-- resume picker
fff_map("n", main_fff and "<leader>sr" or "<leader>sR", function()
  require("fff").resume()
end, "resume picker")
fzf_map("n", main_fff and "<leader>sR" or "<leader>sr", FZF.resume, "resume picker")
