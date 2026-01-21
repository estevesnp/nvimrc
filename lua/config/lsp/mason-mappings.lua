local mason_cmd = require("mason.api.command")

local M = {}

local cache = {
  ---@type LspMappings|nil
  mappings = nil,
}

---reset local cache
function M.reset_cache()
  for k in pairs(cache) do
    cache[k] = nil
  end
end

---@class MasonSpec
---@field mason string
---@field lspconfig string
---@field bins string[]

---@class LspMappings
---@field mason_specs table<string, MasonSpec>
---@field lspconfig_specs table<string, MasonSpec>

---@return LspMappings
local function get_mappings()
  local mason_specs = {}
  local lspconfig_specs = {}

  local specs = require("mason-registry").get_all_package_specs()

  for _, spec in ipairs(specs) do
    local mason = spec.name
    local lspconfig = vim.tbl_get(spec, "neovim", "lspconfig")
    local bins = vim.tbl_keys(spec.bin or {})

    local simple_spec = {
      mason = mason,
      lspconfig = lspconfig,
      bins = bins,
    }

    mason_specs[spec.name] = simple_spec
    if lspconfig then
      lspconfig_specs[lspconfig] = simple_spec
    end
  end

  return {
    mason_specs = mason_specs,
    lspconfig_specs = lspconfig_specs,
  }
end

---get lsp mappings between mason and lspconfig
---mason plugin must have already been loaded
---@return LspMappings
function M.get_mappings()
  if cache.mappings == nil then
    cache.mappings = get_mappings()
  end
  return cache.mappings
end

---alias for MasonInstall
M.install = mason_cmd.MasonInstall

return M
