local show_virtual_text = true
local show_virtual_lines = not show_virtual_text

return function()
  show_virtual_text = not show_virtual_text
  show_virtual_lines = not show_virtual_lines
  vim.diagnostic.config({
    virtual_text = show_virtual_text,
    virtual_lines = show_virtual_lines,
  })
end
