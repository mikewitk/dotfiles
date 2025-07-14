-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
-- Yank diagonstics to clipboard
vim.keymap.set("n", "<leader>zy", function ()
  local line = vim.api.nvim_win_get_cursor(0)[1]
  local diagonstics = vim.diagnostic.get(0, {lnum = line - 1})

  -- empty the register first
  vim.fn.setreg('+', {}, 'V')

  for _, diagnostic in ipairs(diagonstics) do
    vim.fn.setreg('+', vim.fn.getreg('+') .. diagnostic["message"], 'V')
  end
end, {desc = "Copy current line diagonstics"})
