return {
  {
    'nvzone/showkeys',
    cmd = 'ShowkeysToggle',
    opts = {
      timeout = 1,
      maxkeys = 5,
      -- more opts
    },
  },

  {
    'folke/which-key.nvim',
    lazy = false,
    keys = {
      { '<leader>?', '<cmd>WhichKey<cr>', mode = { 'n', 'v' }, desc = 'Show which-key[?]' },
    },
    opts = {
      -- delay between pressing a key and opening which-key (milliseconds)
      -- this setting is independent of vim.o.timeoutlen
      delay = 0,
      icons = {
        -- set icon mappings to true if you have a Nerd Font
        mappings = vim.g.have_nerd_font,
        -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
        -- default which-key.nvim defined Nerd Font icons, otherwise define a string table
        keys = {},
      },
    },
  },
}
