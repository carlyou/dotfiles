return {
  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }
      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      --require('mini.surround').setup()
      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      local statusline = require 'mini.statusline'

      -- Git repo name (directory containing .git), cached per buffer.
      local function git_root(buf)
        local cached = vim.b[buf].git_root
        if cached ~= nil then
          return cached ~= '' and cached or nil
        end
        local path = vim.api.nvim_buf_get_name(buf)
        local root = path ~= '' and vim.fs.root(buf, '.git') or nil
        vim.b[buf].git_root = root or ''
        return root
      end

      local function section_repo()
        local root = git_root(0)
        if not root then
          return ''
        end
        local icon = vim.g.have_nerd_font and ' ' or ''
        return icon .. vim.fn.fnamemodify(root, ':t')
      end

      -- File path relative to git root (falls back to default when outside a repo).
      local function section_filename_gitroot()
        if vim.bo.buftype == 'terminal' then
          return '%t'
        end
        local path = vim.api.nvim_buf_get_name(0)
        if path == '' then
          return '%f%r'
        end
        local root = git_root(0)
        if not root then
          return '%f%r'
        end
        return path:sub(#root + 2) .. '%r'
      end

      -- Snapshot the undo sequence at save-time so we can count pending changes.
      local saved_seq_group = vim.api.nvim_create_augroup('StatuslineSavedSeq', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufReadPost', 'BufNewFile', 'BufFilePost' }, {
        group = saved_seq_group,
        callback = function(ev)
          vim.b[ev.buf].saved_seq = (vim.fn.undotree(ev.buf).seq_cur or 0)
        end,
      })

      -- `[+N]` / `[-N]` when modified (N = edits ahead/behind last save), empty when clean.
      local function section_modified()
        if not vim.bo.modified then
          return ''
        end
        local cur = vim.fn.undotree().seq_cur or 0
        local saved = vim.b.saved_seq or 0
        local delta = cur - saved
        if delta > 0 then
          return string.format('[+%d]', delta)
        elseif delta < 0 then
          return string.format('[%d]', delta)
        end
        return '[+]'
      end

      -- Minimal fileinfo: filetype icon + filetype name (no encoding/format/size).
      local function section_fileinfo()
        local ft = vim.bo.filetype
        if ft == '' then
          return ''
        end
        if vim.g.have_nerd_font then
          local ok, icons = pcall(require, 'mini.icons')
          if ok then
            local icon = icons.get('filetype', ft)
            if icon and icon ~= '' then
              return icon .. ' ' .. ft
            end
          end
        end
        return ft
      end

      statusline.setup {
        use_icons = vim.g.have_nerd_font,
        content = {
          active = function()
            local mode, mode_hl = statusline.section_mode { trunc_width = 120 }
            local search = statusline.section_searchcount { trunc_width = 75 }
            local repo = section_repo()
            local filename = section_filename_gitroot()
            local modified = section_modified()
            local fileinfo = section_fileinfo()
            local location = '%2l:%-2v'

            return statusline.combine_groups {
              { hl = mode_hl, strings = { mode } },
              { hl = 'MiniStatuslineDevinfo', strings = { repo } },
              '%<',
              { hl = 'MiniStatuslineFilename', strings = { filename, modified } },
              '%=',
              { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
              { hl = mode_hl, strings = { search, location } },
            }
          end,
        },
      }

      require('mini.align').setup {}
      --require('mini.starter').setup {}
      -- ... and there is more!
      --  Check out: https://github.com/echasnovski/mini.nvim
    end,
  },
}
