-- Suppress vim.tbl_flatten deprecation warning from plugins
-- Replace with modern vim.iter().flatten() for Neovim 0.10+
if vim.tbl_flatten and not vim.deprecate_has_shown then
  ---@diagnostic disable-next-line: deprecated
  local tbl_flatten = vim.tbl_flatten
  vim.tbl_flatten = function(t)
    return vim.iter(t):flatten(math.huge):totable()
  end
end

require 'config.envs'
require 'config.options'
require 'config.autocmds'
require 'config.keymaps'
require 'config.lazy'

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
