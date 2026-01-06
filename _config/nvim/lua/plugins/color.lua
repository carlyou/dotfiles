return {
  -- TODO: test
  -- TODO: test 2
  -- TODO@2: test
  -- NOTE: asdfasdf
  -- note: asdf
  -- todo: test
  -- fix: fix this
  -- warn: this is a warning
  -- warning: this is a warning
  -- WARN: this is a warning
  -- WARNING: this is a warning
  {
    'folke/todo-comments.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      signs = false,
      keywords = {
        FIX = { icon = ' ', color = 'error', alt = { 'fix', 'FIXME', 'fixme' } },
        TODO = { icon = ' ', color = 'info', alt = { 'todo' } },
        WARN = { icon = ' ', color = 'warning', alt = { 'warn', 'WARNING', 'warning' } },
        NOTE = { icon = ' ', color = 'hint', alt = { 'note' } },
      },
      highlight = {
        pattern = [[.*<(KEYWORDS)\S*:]],
      },
    },
  },

  { 'norcalli/nvim-colorizer.lua', opts = {} },
  -- color schemas
  { 'rebelot/kanagawa.nvim', opts = {}, enabled = false },

  { 'bluz71/vim-moonfly-colors', name = 'moonfly' },
  { 'rmehri01/onenord.nvim' },
  { 'shaunsingh/nord.nvim' },
  { 'EdenEast/nightfox.nvim' },
  {
    'marko-cerovac/material.nvim',
    init = function()
      vim.g.material_style = 'deep ocean'
    end,
  },

  { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is.
    --
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
    'folke/tokyonight.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('tokyonight').setup {
        transparent = true,
        style = 'moon',
        styles = {
          comments = { italic = false }, -- Disable italics in comments
        },
        on_colors = function(colors)
          colors.bg = '#1a1b26'
          colors.bg_dark = '#16161e'
          colors.bg_dark1 = '#0C0E14'
          colors.bg_highlight = '#292e42'
        end,
      }

      -- Load the colorscheme here.
      -- Like many other themes, this one has different styles, and you could load
      -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
      vim.cmd.colorscheme 'tokyonight-night'
    end,
  },
}
