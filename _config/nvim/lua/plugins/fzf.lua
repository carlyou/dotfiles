local function _fzf_grep_path_init()
  local cwd = vim.fn.getcwd()
  local parts = vim.split(cwd, '/')
  local idx = nil
  for i, part in ipairs(parts) do
    if part == 'src' then
      idx = i
      break
    end
  end
  if idx then
    vim.g.fzf_grep_path = '/' .. table.concat(vim.list_slice(parts, 1, idx - 1), '/')
    return vim.g.fzf_grep_path
  end
  return cwd
end

local function _fzf_grep_path_next()
  if not vim.g.fzf_grep_path then
    print 'FzfLua: fzf_grep_path not set, initializing...'
    return _fzf_grep_path_init()
  else
  end

  local path = vim.g.fzf_grep_path
  local git_root = vim.trim(vim.fn.system 'git rev-parse --show-toplevel')
  if path == git_root then
    print 'FzfLua: fzf_grep_path is already at the git root, no upper directory to go to.'
    return path
  end

  local parent = vim.fn.fnamemodify(path, ':h')
  while parent ~= '/' do
    if #vim.fn.readdir(parent) > 1 then
      break
    end
    if parent == git_root then
      break
    end
    parent = vim.fn.fnamemodify(parent, ':h')
  end
  vim.g.fzf_grep_path = parent
  print('FzfLua: fzf_grep_path set to: ' .. parent)
  return parent
end

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
      { '<leader>g', '<cmd>FzfLua git_files<CR>' },
      {
        '<leader><leader>g',
        function()
          vim.g.fzf_grep_path = nil -- reset the path
          local git_root = vim.trim(vim.fn.system 'git rev-parse --show-toplevel')
          require('fzf-lua').live_grep {
            cwd = git_root,
          }
        end,
        mode = 'n',
        desc = 'FzfLua: [G]it [G]rep from current build unit',
      },
      {
        '<leader><leader>G',
        function()
          require('fzf-lua').live_grep {
            cwd = _fzf_grep_path_next(),
          }
        end,
        desc = 'FzfLua: [G]it [G]rep from upper directory',
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
            show_untracked = true,
            file_icons = false,
            git_icons = false,
            git_status_async = true,
            multiprocess = true,
          },
        },
        grep = {
          multiprocess = true,
          file_icons = false,
          git_icons = false,
          hidden = true,
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
