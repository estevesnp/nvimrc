vim.pack.add({ "https://github.com/andrewferrier/debugprint.nvim" })
require("debugprint").setup()

-- g?p -> print location below, P for above, sp for both
-- g?v -> print variable below, V for above, sv for both

require("debugprint").add_custom_filetypes({
  odin = {
    left = 'fmt.eprintfln("',
    right = '", #location())',
    mid_var = '%v", #location(), ',
    location = "%s",
    right_var = ")",
  },
})
