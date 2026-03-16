vim.pack.add({ "https://github.com/bullets-vim/bullets.vim" })

-- i <C-t> -> demote
-- n >>    -> demote
-- v >     -> demote
-- i <C-d> -> promote
-- n <<    -> promote
-- v <     -> promote

vim.g.bullets_outline_levels = { "num", "abc", "std-" }
