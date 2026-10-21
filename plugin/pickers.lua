local Utils = require("config.utils")

local function fff_pack_cb()
  require("fff.download").download_or_build_binary()
end

Utils.register_pack_cb("fff", {
  install = fff_pack_cb,
  update = fff_pack_cb,
})

vim.pack.add({
  "https://github.com/ibhagwan/fzf-lua",
  "https://github.com/dmtrKovalenko/fff",
})

--- configs

vim.g.fff = {
  prompt = "> ",
  layout = {
    width = 1,
    height = 1,
    prompt_position = "top",
    preview_position = "top",
    show_path_first = true,
  },
  follow_symlinks = true,
  prompt_vim_mode = true,
  hl = {
    normal = "Normal",
    border = "Normal",
  },
  select = {
    ---@diagnostic disable-next-line: unused-local
    select_window = function(_buf, _action)
      -- empty body to always open picked file in the current window
      -- needed for oil
    end,
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
  ui_select = {},
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

local split_and_call = Utils.split_and_call

--- fzf keybinds

-- lsp
fzf_map("n", "gd", FZF.lsp_definitions, "goto definition (lsp)")
fzf_map("n", "gsd", Utils.split_and_call(FZF.lsp_definitions), "goto definition in new split (lsp)")
fzf_map("n", "gD", FZF.lsp_declarations, "goto declaration (lsp)")
fzf_map("n", "gsD", split_and_call(FZF.lsp_declarations), "goto declaration in new split (lsp)")
fzf_map("n", "gr", FZF.lsp_references, "goto references (lsp)", { nowait = true })
fzf_map("n", "gsr", split_and_call(FZF.lsp_references), "goto references in new split (lsp)", { nowait = true })
fzf_map("n", "gI", FZF.lsp_implementations, "goto implementations (lsp)")
fzf_map("n", "gsI", split_and_call(FZF.lsp_implementations), "goto implementations in new split (lsp)")
fzf_map("n", "gt", FZF.lsp_typedefs, "type definition (lsp)")
fzf_map("n", "gst", split_and_call(FZF.lsp_typedefs), "type definition in new split (lsp)")
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
fzf_map("n", "<leader>si", function()
  FZF.files({ fd_opts = "--no-ignore-vcs " .. FZF.defaults.files.fd_opts })
end, "search files inlcuding gitignored")
fzf_map("n", "<leader>gi", function()
  FZF.live_grep({ rg_opts = "--no-ignore " .. FZF.defaults.grep.rg_opts })
end, "grep files inlcuding gitignored")

-- misc
fzf_map("n", "<leader>sp", FZF.registers, "search registers")
fzf_map("n", "<leader>sm", FZF.marks, "search marks")
fzf_map("n", "<leader>sq", FZF.quickfix, "search quickfix")
fzf_map("n", "<leader>st", FZF.treesitter, "search treesitter")
fzf_map("n", "<leader>sb", FZF.buffers, "search buffers")
fzf_map("n", "<leader>so", FZF.oldfiles, "search old files")
fzf_map("n", "<leader>sk", function()
  FZF.keymaps({ show_details = false })
end, "search keymaps")
fzf_map("n", "<leader>sH", FZF.helptags, "search help")
fzf_map("n", "<leader>sz", FZF.builtin, "search fzf commands")

--- fff and fallback keybinds

---@class MapInDirOpts
---@field dir_fetcher fun(): {dir: string, title: string} | nil
---@field fff_keybind string
---@field fzf_keybind string
---@field description string

---@param opts MapInDirOpts
local function map_in_dir(opts)
  fff_map("n", opts.fff_keybind, function()
    local fetched = opts.dir_fetcher()
    if fetched then
      require("fff").find_files({ title = fetched.title, cwd = fetched.dir })
    end
  end, opts.description)

  fzf_map("n", opts.fzf_keybind, function()
    local fetched = opts.dir_fetcher()
    if fetched then
      FZF.files({ prompt = fetched.title, cwd = fetched.dir })
    end
  end, opts.description)
end

-- files
fff_map("n", "<leader>sf", function()
  require("fff").find_files()
end, "search files")
fzf_map("n", "<leader>af", FZF.files, "search files")

map_in_dir({
  fff_keybind = "<leader>sh",
  fzf_keybind = "<leader>ah",
  description = "search here, starting from buffer's dir",
  dir_fetcher = function()
    local buf_dir = Utils.buf_dir()
    return { dir = buf_dir, title = "search from " .. buf_dir }
  end,
})

map_in_dir({
  fff_keybind = "<leader>sc",
  fzf_keybind = "<leader>ac",
  description = "search config files",
  dir_fetcher = function()
    return { dir = "~/.config", title = "config" }
  end,
})

map_in_dir({
  fff_keybind = "<leader>s.",
  fzf_keybind = "<leader>a.",
  description = "search dotfiles",
  dir_fetcher = function()
    return { dir = "~/.dotfiles", title = "dotfiles" }
  end,
})

map_in_dir({
  fff_keybind = "<leader>sn",
  fzf_keybind = "<leader>an",
  description = "search neovim files",
  dir_fetcher = function()
    return { dir = vim.fn.stdpath("config"), title = "neovim files" }
  end,
})

map_in_dir({
  fff_keybind = "<leader>sl",
  fzf_keybind = "<leader>al",
  description = "search stdlib files",
  dir_fetcher = function()
    local stdlib_lang = Utils.get_stdlib_with_fallback()
    if not stdlib_lang then
      return nil
    end
    return { dir = stdlib_lang.stdlib, title = stdlib_lang.lang .. " stdlib files" }
  end,
})

-- grep
fff_map("n", "<leader>sg", function()
  require("fff").live_grep()
end, "search grep")
fzf_map("n", "<leader>ag", FZF.live_grep, "search grep")

fff_map({ "n", "x" }, "<leader>gw", function()
  require("fff").live_grep_under_cursor()
end, "grep current word")

fff_map("n", "<leader>gh", function()
  local buf_dir = Utils.buf_dir()
  require("fff").live_grep({
    cwd = buf_dir,
    title = "Grep from " .. buf_dir,
  })
end, "grep here, starting from buffer's dir")

fff_map("n", "<leader>gl", function()
  local stdlib_lang = Utils.get_stdlib_with_fallback()
  if stdlib_lang then
    require("fff").live_grep({
      cwd = stdlib_lang.stdlib,
      title = "Grep " .. stdlib_lang.lang .. " stdlib",
    })
  end
end, "grep stdlib")

-- resume picker
fff_map("n", "<leader>sr", function()
  require("fff").resume()
end, "resume picker")
fzf_map("n", "<leader>ar", FZF.resume, "resume picker")
