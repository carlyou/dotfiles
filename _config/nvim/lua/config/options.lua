vim.g.mapleader = '\\'
vim.g.maplocalleader = '\\'
vim.g.have_nerd_font = true -- https://github.com/ryanoasis/nerd-fonts

-- UI/GUI settings
if vim.loop.os_uname().sysname == 'Linux' then
  vim.opt.guifont = 'Monaco Nerd Font Mono:h10'
else
  vim.opt.guifont = 'Monaco Nerd Font Mono:h12'
end
vim.opt.winblend = 50

if vim.g.neovide then
  -- Put anything you want to happen only in Neovide here
  vim.g.neovide_input_macos_option_key_is_meta = 'only_left'

  vim.g.neovide_opacity = 0.90
  vim.g.neovide_normal_opacity = 0.90
  vim.g.neovide_show_border = true
  vim.g.neovide_window_blurred = true
  vim.g.neovide_floating_blur_amount_x = 2.0
  vim.g.neovide_floating_blur_amount_y = 2.0

  vim.g.neovide_remember_window_size = true
  vim.g.neovide_remember_window_position = true
  --vim.g.neovide_hide_mouse_when_typing = true
end

-- Tab settings
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.shiftround = true

vim.opt.smarttab = true
vim.opt.smartindent = true
vim.opt.autoindent = true

vim.cmd [[filetype plugin indent on]]
vim.cmd [[syntax on]]

vim.opt.wrap = true
vim.opt.number = true
vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
vim.opt.list = true
vim.opt.listchars = { tab = '▸ ', trail = '·', nbsp = '␣' } --, eol = '¬' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

vim.opt.cmdheight = 0

-- Show which line your cursor is on
vim.opt.cursorline = true
-- set cursor line style to underline

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 5

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.opt.confirm = true

vim.opt.autochdir = true
