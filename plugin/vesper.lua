vim.pack.add({
  "https://github.com/datsfilipe/vesper.nvim",
})

require("vesper").setup({
  italics = {
    comments = false,
    keywords = false,
    functions = false,
    strings = false,
    variables = false,
  },
})

-- TODO: remove underscores; check why there are issues with mini-trailspace
