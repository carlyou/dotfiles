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

  {
    'sindrets/diffview.nvim',
    opts = {},
    keys = {
      {
        '<leader>dfo',
        function()
          require('diffview').open()
        end,
        desc = 'Open Diffview',
      },
      {
        '<leader>dfc',
        function()
          require('diffview').close()
        end,
        desc = 'Close Diffview',
      },
    },
  },
}
