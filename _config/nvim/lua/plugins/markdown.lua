return {
  {
    'OXY2DEV/markview.nvim',
    preview = {
      icon_provider = 'devicons', -- "internal", "mini" or "devicons"
    },
    keys = {
      {
        '<leader>m',
        '<cmd>Markview Toggle<cr>',
        desc = 'Toggle Markdown Preview',
      },
      {
        '<leader><leader>m',
        '<cmd>Markview splitToggle<cr>',
        desc = 'Toggle Markdown Preview',
      },
    },
    lazy = false,
    priority = 49, -- For `nvim-treesitter` users.
  },
}
