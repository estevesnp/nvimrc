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

---@class LspMappings
---@field mason_to_lspconfig table<string, string>
---@field lspconfig_to_mason table<string, string>

---@return LspMappings
local function get_mappings()
  local mason_to_lspconfig = {}
  local lspconfig_to_mason = {}

  local specs = require("mason-registry").get_all_package_specs()

  for _, spec in ipairs(specs) do
    local mason = spec.name
    local lspconfig = vim.tbl_get(spec, "neovim", "lspconfig")

    mason_to_lspconfig[mason] = lspconfig
    if lspconfig then
      lspconfig_to_mason[lspconfig] = mason
    end
  end

  return {
    mason_to_lspconfig = mason_to_lspconfig,
    lspconfig_to_mason = lspconfig_to_mason,
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

---get the mapping for an lsp from mason to lspconfig
---mason plugin must have already been loaded
---@param mason_name string
---@return string|nil
function M.mason_to_lspconfig(mason_name)
  return M.get_mappings().mason_to_lspconfig[mason_name]
end

---get the mapping for an lsp from mason to lspconfig
---mason plugin must have already been loaded
---@param lspconfig_name string
---@return string|nil
function M.lspconfig_to_mason(lspconfig_name)
  return M.get_mappings().lspconfig_to_mason[lspconfig_name]
end

---install provided servers with MasonInstall
---mason plugin must have already been loaded
---@param servers string|string[]
function M.mason_install(servers)
  servers = vim._ensure_list(servers) --[[@as string[] ]]

  local mappings = M.get_mappings()

  local servers_to_install = {}
  local skipped_servers = {}

  for _, server in ipairs(servers) do
    local server_to_install = server

    if vim.fn.has_key(mappings.mason_to_lspconfig, server_to_install) == 0 then
      print("no match, fetching alt")
      server_to_install = mappings.lspconfig_to_mason[server]
    end

    if server_to_install then
      print("installing " .. server_to_install)
      table.insert(servers_to_install, server_to_install)
    else
      table.insert(skipped_servers, server)
    end
  end

  if #skipped_servers > 0 then
    vim.notify(
      "couldn't get mappings for servers, skipping: " .. table.concat(skipped_servers, ", "),
      vim.log.levels.WARN
    )
  end

  if #servers_to_install == 0 then
    return
  end
  mason_cmd.MasonInstall(servers_to_install)
end

---print whether lsp_name is a mason or lspconfig name, and print it's related mapping
---@param lsp_name string
function M.print_mapping(lsp_name)
  local mappings = M.get_mappings()

  if vim.fn.has_key(mappings.mason_to_lspconfig, lsp_name) == 1 then
    local lspconfig_name = mappings.mason_to_lspconfig[lsp_name] or "<nil>"
    print("mason name '" .. lsp_name .. "' maps to lspconfig name '" .. lspconfig_name .. "'")
    return
  elseif vim.fn.has_key(mappings.lspconfig_to_mason, lsp_name) == 1 then
    local mason_name = mappings.lspconfig_to_mason[lsp_name] or "<nil>"
    print("lspconfig name '" .. lsp_name .. "' maps to mason name '" .. mason_name .. "'")
    return
  else
    print("no mason or lspconfig match for name '" .. lsp_name .. "'")
  end
end

return M
