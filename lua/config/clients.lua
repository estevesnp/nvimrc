if vim.g.neovide then
  vim.g.neovide_scroll_animation_length = 0
  vim.g.neovide_hide_mouse_when_typing = true
  vim.g.neovide_position_animation_length = 0
  vim.g.neovide_progress_bar_animation_speed = 1000
  vim.g.neovide_progress_bar_hide_delay = 0.1

  local function copy()
    vim.cmd([[normal! "+y]])
  end
  local function paste()
    vim.api.nvim_paste(vim.fn.getreg("+"), true, -1)
  end

  vim.keymap.set("v", "<S-C-c>", copy, { silent = true, desc = "Copy" })
  vim.keymap.set({ "n", "i", "v", "c", "t" }, "<S-C-v>", paste, { silent = true, desc = "Paste" })
end

-- workaround for https://github.com/alexrlocke/neorex/issues/27
if vim.g.neorex then
  local function unborder()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local config = vim.api.nvim_win_get_config(win)
      if config.external and config.border ~= "none" then
        vim.api.nvim_win_set_config(win, { border = "none" })
      end
    end
  end
  vim.api.nvim_create_autocmd({ "WinResized", "UIEnter" }, { callback = unborder })
  unborder()
end
