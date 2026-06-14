return {
  {
    'lewis6991/gitsigns.nvim',
    lazy = false,
    keys = {
      { '[c', '<cmd>Gitsigns prev_hunk<CR>' },
      { ']c', '<cmd>Gitsigns next_hunk<CR>' },
      { '<leader>c[', '<cmd>Gitsigns change_base HEAD<CR>', desc = 'Gitsigns base: HEAD (incl. staged)' },
      { '<leader>c]', '<cmd>Gitsigns change_base<CR>', desc = 'Gitsigns base: index (unstaged only)' },
    },
    opts = {
      base = 'HEAD',
    },
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
