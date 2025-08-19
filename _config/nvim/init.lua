vim.g.mapleader = '\\'
vim.g.maplocalleader = '\\'
vim.g.have_nerd_font = true -- https://github.com/ryanoasis/nerd-fonts

require 'config.options'
require 'config.autocmds'
require 'config.keymaps'
require 'config.lazy'

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
