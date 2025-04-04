local M = {}

--- Creates a mapping function with a namespace prepended in the description
--- @param namespace string: The namespace for the mappings.
--- @return function: The vim.keymap.set function with the namespace in the description.
function M.namespaced_keymap(namespace)
	--- @param mode string|string[]: The mode(s) for the keymap ('n', 'v', { 'n', 'i' }, etc.).
	--- @param keys string: The keys to map.
	--- @param func function|string: The function to call when the keymap is triggered.
	--- @param desc string|nil: Optional description for the keymap.
	--- @param opts table|nil: Optional options for the keymap.
	return function(mode, keys, func, desc, opts)
		local finalOpts = vim.deepcopy(opts or {})

		if desc and not finalOpts.desc then
			finalOpts.desc = namespace .. ": " .. desc
		end

		vim.keymap.set(mode, keys, func, finalOpts)
	end
end

--- Returns the first alternate executable path to the passed if it exists.
--- If no alternate exists, returns the original.
--- If no executable exists, returns nil.
--- @param exe string: The name of the executable to search for
--- @return string|nil: The full path to the first alternate executable
function M.get_alternate_exec(exe)
	local path_exec = vim.fn.exepath(exe)
	if path_exec == "" then
		return nil
	end

	local path_dirs = vim.split(vim.env.PATH, ":", { trimempty = true })

	for _, dir in ipairs(path_dirs) do
		local full_path = dir .. "/" .. exe
		if vim.fn.executable(full_path) == 1 and full_path ~= path_exec then
			return full_path
		end
	end

	return path_exec
end

return M
