vim.pack.add({ "https://github.com/bullets-vim/bullets.vim" })

-- i <C-t> -> demote
-- n >>    -> demote
-- v >     -> demote
-- i <C-d> -> promote
-- n <<    -> promote
-- v <     -> promote

-- 1. first parent
--   a. child bullet [ <cr><C-t> ]
--     - unordered bullet [ <cr><C-t> ]
--   b. second child bullet [ <cr><C-d> ]
-- 2. second parent [ <cr><C-d> ]
vim.g.bullets_outline_levels = { "num", "abc", "std-" }
