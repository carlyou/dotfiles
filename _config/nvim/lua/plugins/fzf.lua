return {
  {
    'ibhagwan/fzf-lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    keys = {
      { '<C-p>', '<cmd>FzfLua builtin<CR>', mode = { 'n', 'v' } },
      { '<leader>b', '<cmd>FzfLua buffers<CR>' },
      { '<leader>r', '<cmd>FzfLua resume<CR>' },
      { '<leader>f', '<cmd>FzfLua files<CR>' },
      { '<leader><leader>f', '<cmd>FzfLua files cwd="~"<CR>' },
      {
        '<leader>g',
        function()
          require('fzf-lua').git_files {
            cmd = 'git ls-files --cached --others --exclude-standard',
          }
        end,
        desc = 'FzfLua: Git Files (with untracked)',
      },
      {
        '<leader><leader>g',
        function()
          require('fzf-lua').live_grep {
            cmd = 'git grep --line-number --column --color=always',
          }
        end,
        desc = 'FzfLua: [G]it [G]rep',
      },
    },
    config = function()
      require('fzf-lua').setup {
        keymap = {
          builtin = {
            ['<C-d>'] = 'preview-half-page-down',
            ['<C-u>'] = 'preview-half-page-up',
          },
        },
        git = {
          files = {
            --cmd = 'git ls-files --exclude-standard --recurse-submodules',
            show_untracked = true, -- Show untracked files in git_files
            file_icons = false, -- Disable file icons in git_files
            git_icons = false, -- Disable git icons in git_files
            git_status_async = true, -- Use async git status for git_files
          },
        },
        winopts = {
          preview = {
            border = 'rounded',
            layout = 'top',
            vertical = 'up:70%',
          },
          on_create = function()
            vim.keymap.set('t', '<D-v>', function()
              vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-\\><C-N>"+pi', true, false, true), 'n', true)
            end, { buffer = true })
          end,
        },
      }
      require('fzf-lua').register_ui_select()
    end,
  },
}
