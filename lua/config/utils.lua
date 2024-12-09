local M = {}

--- @param namespace string: The namespace for the mappings.
--- @return function: The vim.keymap.set function with the namespace in the description.
M.namespaced_keymap = function(namespace)
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

return M
