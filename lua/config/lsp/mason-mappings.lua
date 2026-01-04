local M = {}

local cache = {
  mappings = nil,
}

---reset local cache
function M.reset_cache()
  for k in pairs(cache) do
    cache[k] = nil
  end
end

local function get_mappings()
  -- TODO - implement basing on https://github.com/mason-org/mason-lspconfig.nvim/blob/main/lua/mason-lspconfig/mappings.lua
end

function M.get_mappings()
  if cache.mappings == nil then
    cache.mappings = get_mappings()
  end
  return cache.mappings
end

return M
