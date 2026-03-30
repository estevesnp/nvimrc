local Lsp = require("config.lsp")

local M = {}

M.install_dir = vim.env.MASON_LSP_DIR or vim.fs.joinpath(vim.fn.stdpath("data"), "mason")

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

---check if a mason spec has an executable in path
---@param spec MasonSpec
---@return boolean
local function spec_in_path(spec)
  for _, bin in ipairs(spec.bins) do
    if vim.fn.executable(bin) == 1 then
      return true
    end
  end
  return false
end

function M.install_not_in_path()
  local executables_to_install = {}
  local mappings = M.get_mappings()

  for _, fmt_lint in ipairs(Lsp.formatters_and_tools) do
    if vim.fn.executable(fmt_lint) == 0 then
      table.insert(executables_to_install, fmt_lint)
    end
  end

  for _, server in ipairs(Lsp.all_servers()) do
    local spec = mappings.lspconfig_specs[server]
    if spec and not spec_in_path(spec) then
      table.insert(executables_to_install, spec.mason)
    end
  end

  if #executables_to_install == 0 then
    print("nothing to install")
    return
  end

  print("installing: " .. table.concat(executables_to_install, ", "))
  require("mason.api.command").MasonInstall(executables_to_install)
end

return M
