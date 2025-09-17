return {
  {
    'preservim/nerdtree',
    config = function()
      vim.g.NERDTreeShowHidden = 1
      --vim.g.NERDTreeMinimalUI = 1
      vim.g.NERDTreeIgnore = { '.git$', '__pycache__$', '.DS_Store$' }
    end,
    keys = {
      { '<leader>/', '<cmd>NERDTree .<CR>' },
    },
  },

  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      delete_to_trash = true,
    },
    -- Optional dependencies
    dependencies = { { 'echasnovski/mini.icons', opts = {} } },
    -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,
  },

  {
    'folke/snacks.nvim',
    ---@type snacks.Config
    opts = {
      dashboard = {
        sections = {
          { section = 'header' },
          {
            pane = 2,
            section = 'terminal',
            cmd = 'date +"%A, %B %d, %Y"',
            height = 5,
            padding = 1,
          },
          { section = 'keys', gap = 1, padding = 1 },
          { pane = 2, icon = ' ', title = 'Recent Files', section = 'recent_files', indent = 2, padding = 1 },
          { pane = 2, icon = ' ', title = 'Projects', section = 'projects', indent = 2, padding = 1 },
          {
            pane = 2,
            icon = ' ',
            title = 'Git Status',
            section = 'terminal',
            enabled = function()
              return Snacks.git.get_root() ~= nil
            end,
            cmd = 'git status --short --branch --renames',
            height = 5,
            padding = 1,
            ttl = 5 * 60,
            indent = 3,
          },
          { section = 'startup' },
        },
      },
    },
  },

  -- Session management
  -- NOTE: in snacks dashboard, set session action as:
  -- { "persistence.nvim", ":lua require('persistence').select()" },
  {
    'folke/persistence.nvim',
    event = 'BufReadPre', -- this will only start session saving when an actual file was opened
    opts = {
      -- add any custom options here
    },
  },

  {
    'yuratomo/w3m.vim',
    keys = {
      { '<leader>w', '<cmd>W3mVSplit<CR>', desc = 'Open URL with w3m' },
    },
    enabled = false,
  },
}
