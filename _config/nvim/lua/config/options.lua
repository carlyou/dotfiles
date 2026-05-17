vim.g.mapleader = '\\'
vim.g.maplocalleader = '\\'
vim.g.have_nerd_font = true -- https://github.com/ryanoasis/nerd-fonts

-- UI/GUI settings
-- guifont is rendered by the local Neovide GUI (the Mac), even when nvim runs
-- remotely via `neovide --server`. Keep a single size so local and SSH match;
-- nvim's own OS (Linux on the remote) is irrelevant to the rendered size.
vim.opt.guifont = 'Monaco Nerd Font Mono:h12'

-- Disable italic fonts
vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = '*',
  callback = function()
    -- Get all highlight groups and remove italic
    for _, group in ipairs(vim.fn.getcompletion('', 'highlight')) do
      local hl = vim.api.nvim_get_hl(0, { name = group })
      if hl.italic then
        hl.italic = false
        vim.api.nvim_set_hl(0, group, hl)
      end
    end
  end,
})

vim.opt.winblend = 20

-- Apply Neovide settings on UIEnter, not at startup. With `neovide --server`
-- (vim_connect / `vc`), the remote nvim starts headless in tmux, so
-- `vim.g.neovide` is still nil when this file runs and the settings would be
-- skipped. UIEnter fires when the GUI actually attaches (both for embedded
-- `neovide --fork` and `--server` mode), so `vim.g.neovide` is reliably set
-- by then -- making local and SSH behave identically.
vim.api.nvim_create_autocmd('UIEnter', {
  desc = 'Apply Neovide-only settings when the GUI attaches',
  callback = function()
    if not vim.g.neovide then
      return
    end
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
  end,
})

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
vim.opt.swapfile = false

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
