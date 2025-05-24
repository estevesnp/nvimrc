local M = {}
local JAVA = {}

local cache = {
	sysname = nil,
	jdtls_path = nil,
	equinox_launcher_path = nil,
	java_version = nil,
	is_suitable_for_jdtls = nil,
}

--- Reset local cache
function M.reset_cache()
	for k in pairs(cache) do
		cache[k] = nil
	end
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
	local path_exec = vim.fn.exepath(exe)
	if path_exec == "" then
		return nil
	end

	local path_env_sep = M.sysname() == "win" and ";" or ":"
	local path_dirs = vim.split(vim.env.PATH, path_env_sep, { trimempty = true })

	for _, dir in ipairs(path_dirs) do
		local full_path = vim.fs.joinpath(dir, exe)
		if vim.fn.executable(full_path) == 1 and full_path ~= path_exec then
			return full_path
		end
	end

	return path_exec
end

-------------
-- JAVA UTILS

--- Gets the java version from the path. Returns nil if not found
---@return string|nil version The Java version
function JAVA.get_version()
	if cache.java_version then
		return cache.java_version
	end

	local handle = io.popen("java -version 2>&1")
	if not handle then
		return nil
	end
	local result = handle:read("*a")
	handle:close()

	local version = result:match('openjdk version "([^"]+)"') or result:match('java version "([^"]+)"')

	if not version then
		return nil
	end

	cache.java_version = version
	return cache.java_version
end

--- Returns true if Java version in path is suitable for jdtls (version >= 21)
---@return boolean
function JAVA.is_suitable_for_jdtls()
	if cache.is_suitable_for_jdtls ~= nil then
		return cache.is_suitable_for_jdtls
	end

	local version = JAVA.get_version()
	if not version then
		cache.is_suitable_for_jdtls = false
		return cache.is_suitable_for_jdtls
	end

	local major = tonumber(version:match("^(%d+)"))
	if not major then
		return false
	end

	cache.is_suitable_for_jdtls = major >= 21
	return cache.is_suitable_for_jdtls
end

function JAVA.get_java_path_for_jdtls()
	local java_path = vim.env.JDTLS_JAVA
	if M.string_not_empty(java_path) then
		return java_path
	end

	return JAVA.is_suitable_for_jdtls() and "java" or nil
end

--- Get path to JDTLS. Return nil if not found
---@return string|nil
function JAVA.get_jdtls_path()
	local jdtls_path = vim.env.JDTLS_HOME
	if M.string_not_empty(jdtls_path) then
		return jdtls_path
	end

	if cache.jdtls_path then
		return cache.jdtls_path
	end

	local exe_path = vim.fn.exepath("jdtls")
	if exe_path == "" then
		return nil
	end

	local real_path = vim.uv.fs_realpath(exe_path)
	if not real_path then
		return nil
	end

	cache.jdtls_path = vim.fn.fnamemodify(real_path, ":h")
	return cache.jdtls_path
end

--- Get path to equinox launcher (for JDTLS). Return nil if not found
---@return string|nil
function JAVA.get_equinox_launcher_path()
	if cache.equinox_launcher_path then
		return cache.equinox_launcher_path
	end

	local jdtls_path = JAVA.get_jdtls_path()
	if not jdtls_path then
		return nil
	end

	local pattern = jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar"
	local matches = vim.fn.glob(pattern, false, true)

	if #matches == 0 then
		return nil
	end

	if #matches > 1 then
		vim.notify("Found multiple equinox launchers:\n" .. vim.inspect(matches), vim.log.levels.WARN)
		return nil
	end

	cache.equinox_launcher_path = matches[1]
	return cache.equinox_launcher_path
end

M.java = JAVA

return M
