vim.pack.add({ "https://github.com/nvim-lualine/lualine.nvim" })

require("lualine").setup({
  options = {
    component_separators = { left = "|", right = "|" },
    section_separators = { left = "", right = "" },
    icons_enabled = false,
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch", "diff", "diagnostics" },
    lualine_c = { { "filename", path = 1 } },
    lualine_x = { "encoding", "fileformat", "filetype" },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { { "filename", path = 1 } },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {},
  },
})
