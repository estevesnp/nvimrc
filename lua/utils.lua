local M = {}

local cache = {
  sysname = nil,
  stdlib = {
    zig = nil,
    go = nil,
  },
}

--- Reset local cache
function M.reset_cache()
  for k in pairs(cache) do
    cache[k] = nil
  end
end

--- Log error
---@param msg string
function M.log_err(msg)
  vim.notify(msg, vim.log.levels.ERROR)
end

--- Get sysname: linux, mac or win
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

local default_stdlib_lang = "zig"

-- the key should be the filetype, and the function should return either string or nil
local stdlib_fetcher = {
  zig = function()
    local res = vim.system({ "zig", "env" }):wait()

    if res.code ~= 0 then
      return nil
    end

    return res.stdout:match([[std_dir[^:=]*[^"]*"([^"]+)"]])
  end,
  go = function()
    local res = vim.system({ "go", "env", "GOROOT" }):wait()
    if res.code ~= 0 then
      return nil
    end

    local goroot = vim.trim(res.stdout)
    if goroot == "" then
      return nil
    end

    return vim.fs.joinpath(goroot, "src")
  end,
  rust = function()
    local res = vim.system({ "rustc", "--print", "sysroot" }):wait()
    if res.code ~= 0 then
      return nil
    end

    local sysroot = vim.trim(res.stdout)
    if sysroot == "" then
      return nil
    end

    return vim.fs.joinpath(sysroot, "lib", "rustlib", "src", "rust", "library")
  end,
}

--- Get path to the stdlib for a provided language. Return nil if not supported.
---@param lang string filetype of the language
---@return string|nil
function M.stdlib_path(lang)
  local supported_langs = vim.tbl_keys(stdlib_fetcher)
  if not vim.tbl_contains(supported_langs, lang) then
    return nil
  end

  if not cache.stdlib[lang] then
    cache.stdlib[lang] = stdlib_fetcher[lang]()
  end

  return cache.stdlib[lang]
end

--- Aggregated stdlib path and
---@class utils.StdlibLang
---@field stdlib string path to stdlib
---@field lang string programming language of the stdlib

--- Get path for the stdlib of the language in the current buffer.
--- If none is found, default to a fallback (currently zig).
--- Logs error and returns nil if none is found
---@return utils.StdlibLang | nil
function M.get_stdlib_with_fallback()
  local buf_lang = vim.bo.filetype
  local lang = buf_lang
  local path = M.stdlib_path(lang)

  if not path and buf_lang ~= default_stdlib_lang then
    lang = default_stdlib_lang
    path = M.stdlib_path(default_stdlib_lang)
  end

  if not path then
    local msg
    if buf_lang == default_stdlib_lang then
      msg = "could not get stdlib for " .. default_stdlib_lang
    else
      msg = "could not get stdlib for " .. buf_lang .. " or fallback " .. default_stdlib_lang
    end
    M.log_err(msg)
    return nil
  end

  return { stdlib = path, lang = lang }
end

--- Return true if string is not nil nor empty
---@param str string|nil
---@return boolean
function M.string_not_empty(str)
  return str ~= nil and str ~= ""
end

--- Get a string if it's not nil or empty. Else, returns a fallback string
--- or the result of a supplier function
---@param str string|nil String to try fetching
---@param fallback string|function Fallback string or function
---@return string
function M.get_orelse(str, fallback)
  if str and str ~= "" then
    return str
  end

  if type(fallback) == "function" then
    return fallback()
  end

  return fallback
end

--- Returns the current buffer's dir, even if in an Oil buffer
--- @return string curr_dir The current buffer's dir
function M.buf_dir()
  local cur_buf_dir = vim.fn.expand("%:p:h")
  local trimmed_dir = cur_buf_dir:gsub("^oil://", "")
  return trimmed_dir
end

--- Creates a mapping function with a namespace prepended in the description
--- @param namespace string The namespace for the mappings.
--- @return function map The vim.keymap.set function with the namespace in the description.
function M.namespaced_keymap(namespace)
  --- @param mode string|string[] The mode(s) for the keymap ('n', 'v', { 'n', 'i' }, etc.).
  --- @param keys string The keys to map.
  --- @param func function|string The function to call when the keymap is triggered.
  --- @param desc string|nil Optional description for the keymap.
  --- @param opts table|nil Optional options for the keymap.
  return function(mode, keys, func, desc, opts)
    local finalOpts = vim.deepcopy(opts or {})

    if desc and not finalOpts.desc then
      finalOpts.desc = namespace .. ": " .. desc
    end

    vim.keymap.set(mode, keys, func, finalOpts)
  end
end

--- Returns the first alternate path to the provided executable if it exists.
--- If no alternate exists, returns the original.
--- If no executable exists, returns nil.
--- @param exe string The name of the executable to search for
--- @return string|nil exe_path The full path to the first alternate executable
function M.get_alternate_exec(exe)
  local exec_full_path = vim.fn.exepath(exe)
  if exec_full_path == "" then
    return nil
  end

  local path_exec = vim.fs.joinpath(vim.fs.dirname(exec_full_path), exe)

  local path_env_sep = M.sysname() == "win" and ";" or ":"
  local path_dirs = vim.split(vim.env.PATH, path_env_sep, { trimempty = true })

  for _, dir in ipairs(path_dirs) do
    if dir == "" then
      goto continue
    end

    local full_path = vim.fs.joinpath(dir, exe)
    if vim.fn.executable(full_path) == 1 and full_path ~= path_exec then
      return full_path
    end

    ::continue::
  end

  return path_exec
end

return M
