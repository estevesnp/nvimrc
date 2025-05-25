local utils = require("utils")

local M = {}

local MIN_JAVA_VERSION = 21
local cache = {
	config = nil,
}

function M.reset_cache()
	for k in pairs(cache) do
		cache[k] = nil
	end
end

---@param java_exe string
---@return integer|nil
local function get_java_major(java_exe)
	local handle = io.popen(java_exe .. " -version 2>&1")
	if not handle then
		return nil
	end
	local result = handle:read("*a")
	handle:close()

	local major = result:match([[[%w]+ version "([%d]+)]])
	return tonumber(major)
end

---@return string|nil
local function get_jdtls_home_path()
	local jdtls_path = vim.env.JDTLS_HOME
	if utils.string_not_empty(jdtls_path) then
		return jdtls_path
	end

	local exe_path = vim.fn.exepath("jdtls")
	if exe_path == "" then
		return nil
	end

	local real_path = vim.uv.fs_realpath(exe_path)
	if not real_path then
		return nil
	end

	return vim.fn.fnamemodify(real_path, ":h")
end

---@param jdtls_path string
---@return string|nil
local function get_equinox_launcher_path(jdtls_path)
	local pattern = jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar"
	local matches = vim.fn.glob(pattern, false, true)

	if #matches ~= 1 then
		return nil
	end

	return matches[1]
end

---@return string
local function get_jdtls_config_path()
	local config_path = vim.env.JDTLS_CONFIG
	if utils.string_not_empty(config_path) then
		return config_path
	end

	return vim.env.HOME .. "/.jdtls"
end

---@param jdtls_config_path string
---@return string[]|nil
local function get_bundles(jdtls_config_path)
	local debug_glob = "/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar"
	local test_glob = "/vscode-java-test/server/*.jar"

	local bundles = vim.fn.glob(jdtls_config_path .. debug_glob, false, true)
	vim.list_extend(bundles, vim.fn.glob(jdtls_config_path .. test_glob, false, true))

	return #bundles > 0 and bundles or nil
end

---Get config for JDTLS.
---@return table|nil
function M.get_config()
	if cache.config then
		return cache.config
	end

	local java_exe = utils.get_orelse(vim.env.JDTLS_JAVA, "java")

	local java_major = get_java_major(java_exe)
	if not java_major then
		vim.notify("Couldn't parse Java major from " .. java_exe, vim.log.levels.WARN)
		return nil
	end

	if java_major < MIN_JAVA_VERSION then
		vim.notify(
			"Java version "
				.. java_major
				.. " not compatible with JDTLS. Define 'JDTLS_JAVA' env var or make sure Java version >= "
				.. MIN_JAVA_VERSION
				.. " is in your Path",
			vim.log.levels.WARN
		)
		return nil
	end

	local jdtls_home_path = get_jdtls_home_path()
	if not jdtls_home_path then
		vim.notify("Couldn't get JDTLS home path. Define 'JDTLS_HOME' env var", vim.log.levels.WARN)
		return nil
	end

	local equinox_launcher_path = get_equinox_launcher_path(jdtls_home_path)
	if not equinox_launcher_path then
		vim.notify("Error finding org.eclipse.equinox.launcher_*.jar in JDTLS home", vim.log.levels.WARN)
		return nil
	end

	local jdtls_config_path = get_jdtls_config_path()

	local bundles = get_bundles(jdtls_config_path)
	if not bundles then
		vim.notify("Couldn't find any bundles in JDTLS config path. Check 'jdtls-bundles.sh'", vim.log.levels.WARN)
		return nil
	end

	local root_dir = vim.fs.root(0, { ".git", "mvnw", "gradlew" })
	if not root_dir then
		vim.notify("Couldn't find root dir for file", vim.log.levels.WARN)
	end

	local lombok_path = jdtls_home_path .. "/lombok.jar"
	if not vim.uv.fs_stat(lombok_path) then
		vim.notify("Couldn't find Lombok JAR", vim.log.levels.WARN)
		return nil
	end

	local config_path = jdtls_home_path .. "/config_" .. utils.sysname()
	if not vim.uv.fs_stat(config_path) then
		vim.notify("Couldn't find config file", vim.log.levels.WARN)
		return nil
	end

	local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
	local workspace_dir = jdtls_config_path .. "/workspaces/" .. project_name

	cache.config = {
		cmd = {
			java_exe,

			"-Declipse.application=org.eclipse.jdt.ls.core.id1",
			"-Dosgi.bundles.defaultStartLevel=4",
			"-Declipse.product=org.eclipse.jdt.ls.core.product",
			"-Dlog.protocol=true",
			"-Dlog.level=ALL",
			"-Xmx1g",
			"--add-modules=ALL-SYSTEM",
			"--add-opens",
			"java.base/java.util=ALL-UNNAMED",
			"--add-opens",
			"java.base/java.lang=ALL-UNNAMED",

			"-javaagent:" .. lombok_path,

			"-jar",
			equinox_launcher_path,

			"-configuration",
			config_path,
			"-data",
			workspace_dir,
		},

		root_dir = root_dir,

		-- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
		-- for a list of options
		settings = {
			java = {},
		},

		init_options = {
			bundles = bundles,
		},
	}

	return cache.config
end

return M
