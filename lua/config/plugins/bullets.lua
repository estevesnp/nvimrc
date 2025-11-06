return {
  "bullets-vim/bullets.vim",
  -- i <C-t> -> demote
  -- n >>    -> demote
  -- v >     -> demote
  -- i <C-d> -> promote
  -- n <<    -> promote
  -- v <     -> promote
  config = function()
    vim.g.bullets_outline_levels = { "num", "abc", "std-" }
  end,
}
