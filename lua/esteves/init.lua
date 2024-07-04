--- @param sect string
--- @return function
function CreateNamedMap(sect)
	--- @param mode string|string[]: The mode(s) for the keymap ('n', 'v', { 'n', 'i' }, etc.).
	--- @param keys string: The keys to map.
	--- @param func function|string: The function to call when the keymap is triggered.
	--- @param desc string|nil: Optional description for the keymap.
	--- @param opts table|nil: Optional options for the keymap.
	return function(mode, keys, func, desc, opts)
		local finalOpts = vim.deepcopy(opts or {})

		if desc and not finalOpts.desc then
			finalOpts.desc = sect .. ": " .. desc
		end

		vim.keymap.set(mode, keys, func, finalOpts)
	end
end

---@param str string
---@return boolean
local function isEnabled(str)
	return string.lower(os.getenv("NVIM_" .. string.upper(str)) or "") == "true"
end

---@type string[]
local toCheck = { "rust", "java", "git" }

---@type table<string, boolean>
EnabledFeats = {}

for _, v in pairs(toCheck) do
	EnabledFeats[v] = isEnabled(v)
end

require("esteves.options")
require("esteves.keymaps")
require("esteves.lazy")
require("esteves.lazy-plugins")
