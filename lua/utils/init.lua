local M = {}

local cache = {
  sysname = nil,
  stdlib = {
    zig = nil,
    go = nil,
    rust = nil,
  },
}

---reset local cache
function M.reset_cache()
  for k in pairs(cache) do
    cache[k] = nil
  end
end

---log error
---@param msg string
function M.log_err(msg)
  vim.notify(msg, vim.log.levels.ERROR)
end

---get sysname: linux, mac or win
---@return "linux"|"mac"|"win"|nil
function M.sysname()
  if cache.sysname then
    return cache.sysname
  end

  local uname = vim.uv.os_uname()

  if uname.sysname == "Linux" then
    cache.sysname = "linux"
  elseif uname.sysname == "Darwin" then
    cache.sysname = "mac"
  elseif uname.sysname == "Windows_NT" then
    cache.sysname = "win"
  else
    return nil
  end

  return cache.sysname
end

---runs args and returns the trimmed output, or nil if exit code != 0 or result is empty
---@param args string[]
---@return string|nil result non empty string or nil
local function run(args)
  local res = vim.system(args):wait()
  if res.code ~= 0 then
    return nil
  end

  local trimmed = vim.trim(res.stdout)
  if trimmed == "" then
    return nil
  end

  return trimmed
end

local STDLIB_FALLBACK = "zig"

-- the key should be the filetype, and the function should return either string or nil
local stdlib_fetch_table = {
  zig = function()
    local zig_env = run({ "zig", "env" })
    if not zig_env then
      return nil
    end

    return zig_env:match([[std_dir[^:=]*[^"]*"([^"]+)"]])
  end,
  go = function()
    local goroot = run({ "go", "env", "GOROOT" })
    if not goroot then
      return nil
    end

    return vim.fs.joinpath(goroot, "src")
  end,
  rust = function()
    local sysroot = run({ "rustc", "--print", "sysroot" })
    if not sysroot then
      return nil
    end

    return vim.fs.joinpath(sysroot, "lib", "rustlib", "src", "rust", "library")
  end,
}

--- Get path to the stdlib for a provided language. Return nil if not supported.
---@param lang string filetype of the language
---@return string|nil
function M.stdlib_path(lang)
  if not lang then
    return nil
  end

  local stdlib_fetcher = stdlib_fetch_table[lang]
  if not stdlib_fetcher then
    return nil
  end

  if not cache.stdlib[lang] then
    cache.stdlib[lang] = stdlib_fetcher()
  end

  return cache.stdlib[lang]
end

---aggregated stdlib path and language
---@class utils.StdlibLang
---@field stdlib string path to stdlib
---@field lang string programming language of the stdlib

---get path for the stdlib of the language in the current buffer.
---if none is found, default to a fallback (currently zig).
---logs error and returns nil if none is found
---@return utils.StdlibLang | nil
function M.get_stdlib_with_fallback()
  local buf_lang = vim.bo.filetype
  local lang = buf_lang
  local path = M.stdlib_path(lang)

  if not path and buf_lang ~= STDLIB_FALLBACK then
    lang = STDLIB_FALLBACK
    path = M.stdlib_path(STDLIB_FALLBACK)
  end

  if not path then
    local msg
    if buf_lang == STDLIB_FALLBACK then
      msg = "could not get stdlib for '" .. STDLIB_FALLBACK .. "'"
    else
      msg = "could not get stdlib for '" .. buf_lang .. "' or fallback '" .. STDLIB_FALLBACK .. "'"
    end
    M.log_err(msg)
    return nil
  end

  return { stdlib = path, lang = lang }
end

---returns the current buffer's dir, even if in an oil buffer
---@return string curr_dir normalized current buffer's dir
function M.buf_dir()
  local cur_buf_dir = vim.fn.expand("%:p:h")
  local trimmed_dir = cur_buf_dir:gsub("^oil://", "")
  return trimmed_dir
end

---creates a mapping function with a namespace prepended in the description
---@param namespace string the namespace for the mappings.
---@return function map the vim.keymap.set function with the namespace in the description.
function M.namespaced_keymap(namespace)
  --- @param mode string|string[] the mode(s) for the keymap ('n', 'v', { 'n', 'i' }, etc.).
  --- @param keys string the keys to map
  --- @param func function|string the keymap action
  --- @param desc string|nil optional description for the keymap
  --- @param opts table|nil optional options for the keymap
  return function(mode, keys, func, desc, opts)
    opts = vim.deepcopy(opts or {})

    if not opts.desc then
      if desc then
        opts.desc = namespace .. ": " .. desc
      else
        opts.desc = namespace
      end
    end

    vim.keymap.set(mode, keys, func, opts)
  end
end

return M
