return {
  {
    'lewis6991/gitsigns.nvim',
    lazy = false,
    keys = {
      { '[c', '<cmd>Gitsigns prev_hunk<CR>' },
      { ']c', '<cmd>Gitsigns next_hunk<CR>' },
    },
    opts = {},
  },

  { 'sindrets/diffview.nvim', opts = {} },
}
