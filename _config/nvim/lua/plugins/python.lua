return {
  {

    'benlubas/molten-nvim',
    version = '^1.0.0', -- use version <2.0.0 to avoid breaking changes
    build = ':UpdateRemotePlugins',
    init = function()
      vim.g.molten_auto_image_popup = true
      vim.g.molten_auto_open_html_in_browser = true
      vim.g.molten_auto_open_output = true
      vim.g.molten_image_provider = 'image.nvim'
      vim.g.molten_output_show_more = true
      vim.g.molten_output_win_max_height = 20
      vim.g.molten_virt_lines_off_by_1 = true
      vim.g.molten_virt_text_output = true
    end,
    keys = {
      { '<localleader>mi', ':MoltenInit<CR>', desc = '[m]olten [i]nitialize' },
      { '<localleader>me', ':MoltenEvaluateLine<CR>', desc = '[m]olten [e]valuate line' },
      { '<localleader>me', ':<C-u>MoltenEvaluateVisual<CR>', mode = { 'v' }, desc = '[m]olten [e]valuate visual' },
      { '<localleader>mr', ':MoltenReevaluateCell<CR>', desc = '[m]olten [r]eevaluate cell' },
      { '<localleader>mo', ':noautocmd MoltenEnterOutput<CR>', desc = '[m]olten enter [o]utput' },
      { '<localleader>mx', ':MoltenInterrupt<CR>', desc = '[m]olten interrupt' },
      { '<localleader>mn', ':MoltenNext<CR>', desc = '[m]olten [n]ext cell' },
      { '<localleader>mp', ':MoltenPrev<CR>', desc = '[m]olten [p]revious cell' },
    },
    enabled = false,
  },

  {
    '3rd/image.nvim',
    build = false, -- so that it doesn't build the rock https://github.com/3rd/image.nvim/issues/91#issuecomment-2453430239
    lazy = true,
    --ft = { 'markdown', 'vimwiki' }, -- Only load for markdown files
    opts = {
      processor = 'magick_cli',
      backend = 'ueberzug', -- Better compatibility with wezterm
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
        },
      },
      max_width = 100, -- tweak to preference
      max_height = 12, -- ^
      max_height_window_percentage = math.huge, -- this is necessary for a good experience
      max_width_window_percentage = math.huge,
      window_overlap_clear_enabled = true,
      window_overlap_clear_ft_ignore = { 'cmp_menu', 'cmp_docs', '' },
    },
    enabled = function() -- does not work in gui
      return false
      --return vim.fn.has 'gui_running' == 0
    end,
  },

  {
    'GCBallesteros/jupytext.nvim',
    opts = {
      style = 'markdown',
      output_extension = 'md',
      force_ft = 'markdown',
    },
  },

  {
    'quarto-dev/quarto-nvim',
    dependencies = {
      'jmbuhr/otter.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    ft = { 'quarto', 'markdown' },
    config = function()
      require('quarto').setup {
        lspFeatures = {
          -- NOTE: put whatever languages you want here:
          languages = { 'r', 'python', 'rust' },
          chunks = 'all',
          diagnostics = {
            enabled = true,
            triggers = { 'BufWritePost' },
          },
          completion = {
            enabled = true,
          },
        },
        codeRunner = {
          enabled = true,
          default_method = 'molten',
        },
      }
      -- Auto-activate quarto for markdown files with code blocks
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'markdown',
        callback = function()
          local lines = vim.api.nvim_buf_get_lines(0, 0, 50, false)
          for _, line in ipairs(lines) do
            if line:match '^```%w+' then
              require('quarto').activate()
              break
            end
          end
        end,
      })
    end,
    keys = {
      {
        '<localleader>mc',
        function()
          require('quarto.runner').run_cell()
        end,
        desc = '[m]olten [c]ell',
      },
    },
    enabled = false,
  },
}
