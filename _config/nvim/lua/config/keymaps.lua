vim.keymap.set('n', '<leader>e', function()
  vim.cmd(':lua vim.print(' .. vim.fn.getreg '+' .. ')')
end, { noremap = true, silent = true, desc = '[e]xecute and print yanked command' })

vim.keymap.set('n', '<leader>w', function()
  vim.wo.wrap = not vim.wo.wrap
end, { noremap = true, silent = true, desc = 'Toggle line [w]rapping' })

-- prevent backspace from exiting commenting
vim.keymap.set('c', '<BS>', function()
  if vim.fn.getcmdline() == '' then
    return ''
  else
    return '<BS>'
  end
end, { expr = true, noremap = true })

vim.keymap.set('v', 'Y', '"+y')
vim.keymap.set('n', '<Space>', '<cmd>nohlsearch<cr>')
vim.keymap.set('n', 'n', 'nzz', { noremap = true, silent = true })
vim.keymap.set('n', 'N', 'Nzz', { noremap = true, silent = true })
vim.keymap.set('n', '*', '*zz', { noremap = true, silent = true })
vim.keymap.set('n', '#', '#zz', { noremap = true, silent = true })

--vim.keymap.set({ 'n', 'v' }, '0', '^')

vim.keymap.set('n', '-', '<C-w><', { noremap = true, silent = true, desc = 'Narrower window' })
vim.keymap.set('n', '+', '<C-w>>', { noremap = true, silent = true, desc = 'Wider window' })

--vim.keymap.set('v', 'J', ":m '>+1<cr>gv=gv", { noremap = true, silent = true })
--vim.keymap.set('v', 'K', ":m '<-2<cr>gv=gv", { noremap = true, silent = true })

-- Common shortcuts with command modifier
-- 1. copy/paste with command+c/v
vim.g.neovide_input_use_logo = 1
vim.keymap.set('n', '<D-v>', '"+p', { noremap = true, silent = true })
vim.keymap.set('v', '<D-c>', '"+y', { noremap = true, silent = true })

-- this prevents vim's auto commenting when pasting
vim.keymap.set('i', '<D-v>', function()
  vim.opt.paste = true
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-R>+', true, false, true), 'n', true)
  vim.defer_fn(function()
    vim.opt.paste = false
  end, 10)
end, { noremap = true, silent = true })

-- force redraw after pasting in command mode to display pasted text
vim.keymap.set('c', '<D-v>', function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-R>+', true, false, true), 'n', true)
  vim.cmd 'redraw' -- force UI update
end, { noremap = true, silent = true })

-- 2. tab create/close/select
vim.keymap.set('n', '<D-t>', '<cmd>tabnew<cr>', { noremap = true, silent = true })
-- Close tab with command+w, but if only one tab is open, close window within the tab instead
vim.keymap.set('n', '<D-w>', function()
  local tab_count = vim.fn.tabpagenr '$'
  if tab_count > 1 then
    vim.cmd 'tabclose'
  else
    vim.cmd 'q'
  end
end, { noremap = true, silent = true })

vim.keymap.set('n', '<D-1>', '1gt', { noremap = true, silent = true })
vim.keymap.set('n', '<D-2>', '2gt', { noremap = true, silent = true })
vim.keymap.set('n', '<D-3>', '3gt', { noremap = true, silent = true })
vim.keymap.set('n', '<D-4>', '4gt', { noremap = true, silent = true })
vim.keymap.set('n', '<D-5>', '5gt', { noremap = true, silent = true })
vim.keymap.set('n', '<D-6>', '6gt', { noremap = true, silent = true })
vim.keymap.set('n', '<D-7>', '7gt', { noremap = true, silent = true })
vim.keymap.set('n', '<D-8>', '8gt', { noremap = true, silent = true })
vim.keymap.set('n', '<D-9>', '9gt', { noremap = true, silent = true })
vim.keymap.set('n', '<D-[>', '<cmd>tabprevious<cr>', { noremap = true, silent = true })
vim.keymap.set('n', '<D-]>', '<cmd>tabnext<cr>', { noremap = true, silent = true })

-- 3. Zoom in/out
vim.keymap.set('n', '<D-=>', function()
  vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1
end, { noremap = true, silent = true, desc = '[Zoom] Increase Neovide scale factor' })
vim.keymap.set('n', '<D-->', function()
  vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1
end, { noremap = true, silent = true, desc = '[Zoom] Decrease Neovide scale factor' })
vim.keymap.set('n', '<D-0>', function()
  vim.g.neovide_scale_factor = 1.0
end, { noremap = true, silent = true, desc = '[Zoom] Reset Neovide scale factor' })

-- Terminal
-- keymap to open a terminal in a split window, or just to the buffer if it already exists
vim.keymap.set('n', '<leader>t', function()
  if vim.fn.bufexists 'term://*' == 1 then
    vim.cmd 'b term://*'
  else
    vim.cmd 'vs'
    vim.cmd 'terminal'
  end
end, { noremap = true, silent = true, desc = '[T]erminal' })
vim.keymap.set('n', '<leader><leader>t', '<cmd>vs<cr><cmd>terminal<cr>', { noremap = true, silent = true, desc = 'Open [t]erminal in split on right' })

-- Diagnostic
vim.keymap.set('n', '<leader><leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<C-z>', '<C-\\><C-n><C-w><C-w>', { noremap = true, silent = true })
vim.keymap.set('t', '<C-w><C-w>', '<C-\\><C-n><C-w><C-w>', { noremap = true, silent = true })
vim.keymap.set('t', '<C-p>', '<Up>', { noremap = true, silent = true })
vim.keymap.set('t', '<C-n>', '<Down>', { noremap = true, silent = true })
vim.keymap.set('t', '<C-f>', '<Right>', { noremap = true, silent = true })
vim.keymap.set('t', '<C-b>', '<Left>', { noremap = true, silent = true })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', 'HH', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', 'LL', '<C-w><C-l>', { desc = 'Move focus to the right window' })
