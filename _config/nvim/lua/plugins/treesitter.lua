-- nvim-treesitter v1.0 rewrite (main branch) for Neovim 0.12+
-- Requires `tree-sitter-cli` installed via Homebrew (NOT npm):
--   brew install tree-sitter

local PARSERS = {
  'bash',
  'c',
  'diff',
  'html',
  'lua',
  'luadoc',
  'markdown',
  'markdown_inline',
  'query',
  'vim',
  'vimdoc',
  'python',
  'typescript',
  'tsx',
  'javascript',
}

-- Filetypes (NOT parser names) to enable treesitter highlighting/indent for.
local FILETYPES = {
  'bash',
  'sh',
  'c',
  'diff',
  'html',
  'lua',
  'markdown',
  'query',
  'vim',
  'help',
  'python',
  'typescript',
  'typescriptreact',
  'javascript',
  'javascriptreact',
}

return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false, -- rewrite does not support lazy-loading
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter').setup {
        install_dir = vim.fn.stdpath('data') .. '/site',
      }
      require('nvim-treesitter').install(PARSERS)

      vim.api.nvim_create_autocmd('FileType', {
        pattern = FILETYPES,
        callback = function(ev)
          pcall(vim.treesitter.start, ev.buf)
          vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('nvim-treesitter-textobjects').setup {
        select = { lookahead = true },
        move = { set_jumps = true },
      }

      local swap = require('nvim-treesitter-textobjects.swap')
      local move = require('nvim-treesitter-textobjects.move')

      vim.keymap.set('n', '<leader><leader>s', function()
        swap.swap_next('@parameter.inner')
      end, { desc = 'Swap with next parameter' })
      vim.keymap.set('n', '<leader><leader>S', function()
        swap.swap_previous('@parameter.inner')
      end, { desc = 'Swap with previous parameter' })

      vim.keymap.set({ 'n', 'x', 'o' }, ']m', function()
        move.goto_next_start('@function.outer', 'textobjects')
      end, { desc = 'Next function start' })
      vim.keymap.set({ 'n', 'x', 'o' }, ']]', function()
        move.goto_next_start('@class.outer', 'textobjects')
      end, { desc = 'Next class start' })
      vim.keymap.set({ 'n', 'x', 'o' }, ']o', function()
        move.goto_next_start({ '@loop.inner', '@loop.outer' }, 'textobjects')
      end, { desc = 'Next loop' })
      vim.keymap.set({ 'n', 'x', 'o' }, ']s', function()
        move.goto_next_start('@local.scope', 'locals')
      end, { desc = 'Next scope' })
      vim.keymap.set({ 'n', 'x', 'o' }, ']z', function()
        move.goto_next_start('@fold', 'folds')
      end, { desc = 'Next fold' })

      vim.keymap.set({ 'n', 'x', 'o' }, ']M', function()
        move.goto_next_end('@function.outer', 'textobjects')
      end)
      vim.keymap.set({ 'n', 'x', 'o' }, '][', function()
        move.goto_next_end('@class.outer', 'textobjects')
      end)

      vim.keymap.set({ 'n', 'x', 'o' }, '[m', function()
        move.goto_previous_start('@function.outer', 'textobjects')
      end)
      vim.keymap.set({ 'n', 'x', 'o' }, '[[', function()
        move.goto_previous_start('@class.outer', 'textobjects')
      end)

      vim.keymap.set({ 'n', 'x', 'o' }, '[M', function()
        move.goto_previous_end('@function.outer', 'textobjects')
      end)
      vim.keymap.set({ 'n', 'x', 'o' }, '[]', function()
        move.goto_previous_end('@class.outer', 'textobjects')
      end)

      vim.keymap.set({ 'n', 'x', 'o' }, ']d', function()
        move.goto_next('@conditional.outer', 'textobjects')
      end)
      vim.keymap.set({ 'n', 'x', 'o' }, '[d', function()
        move.goto_previous('@conditional.outer', 'textobjects')
      end)
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter-context',
    opts = {
      max_lines = 7,
    },
  },
}
