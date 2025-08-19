vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

vim.api.nvim_create_autocmd('FocusLost', {
  desc = 'Set transparency to 20% when losing focus',
  callback = function()
    vim.g.neovide_opacity = 0.6
    vim.g.neovide_normal_opacity = 0.6
  end,
})

vim.api.nvim_create_autocmd('FocusGained', {
  desc = 'Restore transparency when gaining focus',
  callback = function()
    vim.g.neovide_opacity = 0.9
    vim.g.neovide_normal_opacity = 0.9
  end,
})
