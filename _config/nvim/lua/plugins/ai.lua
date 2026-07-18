return {
  {
    'nickjvandyke/opencode.nvim',
    version = '*', -- Latest stable release
    dependencies = {
      {
        -- `snacks.nvim` integration is recommended, but optional
        ---@module "snacks" <- Loads `snacks.nvim` types for configuration intellisense
        'folke/snacks.nvim',
        optional = true,
      },
    },
    config = function()
      ---@type opencode.Opts
      vim.g.opencode_opts = {
        -- Your configuration, if any; goto definition on the type or field for details
      }

      vim.o.autoread = true -- Required for `opts.events.reload`

      -- Recommended/example keymaps
      vim.keymap.set({ 'n', 'x' }, '<leader>aoa', function()
        require('opencode').ask('@this: ', { submit = true })
      end, { desc = 'Ask opencode…' })
      vim.keymap.set({ 'n', 'x' }, '<leader>aop', function()
        require('opencode').select()
      end, { desc = 'Execute opencode action…' })
      vim.keymap.set({ 'n', 't' }, '<leader>aoo', function()
        require('opencode').toggle()
      end, { desc = 'Toggle opencode' })

      vim.keymap.set('n', '<S-C-u>', function()
        require('opencode').command 'session.half.page.up'
      end, { desc = 'Scroll opencode up' })
      vim.keymap.set('n', '<S-C-d>', function()
        require('opencode').command 'session.half.page.down'
      end, { desc = 'Scroll opencode down' })
    end,
  },
  -- Claude Code
  {
    'coder/claudecode.nvim',
    dependencies = { 'folke/snacks.nvim' },
    opts = {
      log_level = 'info',
      auto_start = true,
      track_selection = true,
      git_repo_cwd = true,
      terminal_cmd = '~/.local/bin/claude',
      terminal = {
        provider = 'snacks',
        snacks_win_opts = { position = 'float', width = 0.9, height = 0.9, border = 'rounded' },
      },
      diff_opts = {
        keep_terminal_open = true,
      },
    },
    config = true,
    keys = {
      { '<leader>acc', '<cmd>ClaudeCode<cr>', desc = '[a]i [c]laude: Open/Toggle claude [c]ode' },
      { '<C-a>', '<cmd>ClaudeCode<cr>', mode = { 'n', 't' }, desc = '[a]i [c]laude: Open/Toggle claude [c]ode' },
      { '<C-a>', '<cmd>ClaudeCodeSend<cr>', mode = 'v', desc = '[a]i [c]laude: send selection to claude code' },
      { '<leader>acf', '<cmd>ClaudeCodeFocus<cr>', desc = '[a]i [c]laude: [f]ocus' },
      -- Open/toggle in a chosen window style. NOTE: the style is locked when the
      -- Claude session starts; whichever you press first from a closed state wins.
      -- To actually switch styles you must close (ends the session) and reopen.
      {
        '<leader>acF',
        function()
          require('claudecode.terminal').toggle {
            snacks_win_opts = { position = 'float', width = 0.9, height = 0.9, border = 'rounded' },
          }
        end,
        desc = '[a]i [c]laude: toggle [F]loating',
      },
      {
        '<leader>acS',
        function()
          require('claudecode.terminal').toggle {
            snacks_win_opts = { position = 'right', width = 0.35 },
          }
        end,
        desc = '[a]i [c]laude: toggle [S]plit',
      },
      { '<leader>acb', '<cmd>ClaudeCodeAdd %:p<cr>', desc = '[a]i [c]laude: send current [b]uffer' },
      { '<leader>acs', '<cmd>ClaudeCodeSend<cr>', mode = { 'n', 'v' }, desc = '[a]i [c]laude: send selected content' },
      {
        '<leader>acs',
        '<cmd>ClaudeCodeTreeAdd<cr>',
        desc = '[a]i [claude]: add [f]ile',
        ft = { 'NvimTree', 'neo-tree', 'oil', 'minifiles' },
      },
      -- Diff management
      { '<leader>acy', '<cmd>ClaudeCodeDiffAccept<cr>', desc = 'Accept diff' },
      { '<leader>acn', '<cmd>ClaudeCodeDiffDeny<cr>', desc = 'Deny diff' },
    },
  },

  -- codex
  {
    'kkrampis/codex.nvim',
    lazy = true,
    cmd = { 'Codex', 'CodexToggle' }, -- Optional: Load only on command execution
    keys = {
      {
        '<leader>axc', -- Change this to your preferred keybinding
        function()
          require('codex').toggle()
        end,
        desc = 'Toggle Codex popup or side-panel',
        mode = { 'n', 't' },
      },
      {
        '<C-x>', -- Change this to your preferred keybinding
        function()
          require('codex').toggle()
        end,
        desc = 'Toggle Codex popup or side-panel',
        mode = { 'n', 't' },
      },
      {
        '<C-x>',
        function()
          local lines = vim.api.nvim_buf_get_lines(0, vim.fn.line "'<" - 1, vim.fn.line "'>", false)
          require('codex').open()
          -- codex.nvim has no public "send" API; state.job is its internal terminal job handle
          local job = require('codex.state').job
          if job then
            vim.api.nvim_chan_send(job, table.concat(lines, '\n') .. '\n')
          end
        end,
        desc = 'Send selection to Codex',
        mode = 'v',
      },
    },
    opts = {
      keymaps = {
        toggle = nil, -- Keybind to toggle Codex window (Disabled by default, watch out for conflicts)
        quit = '<C-q>', -- Keybind to close the Codex window (default: Ctrl + q)
      }, -- Disable internal default keymap (<leader>cc -> :CodexToggle)
      border = 'rounded', -- Options: 'single', 'double', or 'rounded'
      width = 0.9, -- Width of the floating window (0.0 to 1.0)
      height = 0.9, -- Height of the floating window (0.0 to 1.0)
      model = nil, -- Optional: pass a string to use a specific model (e.g., 'o3-mini')
      autoinstall = true, -- Automatically install the Codex CLI if not found
      panel = false, -- Open Codex in a side-panel (vertical split) instead of floating window
      use_buffer = false, -- Capture Codex stdout into a normal buffer instead of a terminal buffer
    },
  },

  -- GitHub Copilot
  {
    'github/copilot.vim',
    init = function()
      -- Use dynamic node path (works on macOS with Homebrew/NVM and Linux with NVM/apt)
      vim.g.copilot_node_command = vim.fn.exepath 'node'
      --vim.g.copilot_no_tab_map = true
      vim.cmd [[inoremap <silent><script><expr> <C-i> copilot#Accept("\t")]]
    end,
    opt = {},
    enabled = true,
  },

  -- GitHub Copilot Chat
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    dependencies = {
      { 'github/copilot.vim' }, -- or zbirenbaum/copilot.lua
      { 'nvim-lua/plenary.nvim', branch = 'master' }, -- for curl, log and async functions
    },
    build = 'make tiktoken', -- Only on MacOS or Linux
    selection = function(source)
      return select.visual(source) or select.buffer(source)
    end,
    keys = {
      { '<leader>aac', '<cmd>CopilotChatToggle<cr>', desc = 'Copilot Chat Toggle' },
      {
        '<leader>a<space>',
        function()
          local input = vim.fn.input 'Quick Chat: '
          if input ~= '' then
            require('CopilotChat').ask(input, { window = { layout = 'float', relative = 'cursor' } })
          end
        end,
        mode = 'n',
        desc = 'Copilot Chat Quick chat',
      },
      {
        '<leader>a<space>',
        function()
          require('CopilotChat').ask('Explain how it works', {
            window = { layout = 'float', relative = 'cursor' },
          })
        end,
        mode = 'v',
        desc = 'Copilot Chat Explain',
      },
    },
    opts = {
      --model = 'o4-mini',
      mappings = {
        submit_prompt = {
          normal = '<CR>',
          insert = '<C-CR>',
        },
      },
      window = {
        border = 'rounded',
      },
    },
    lazy = false,
    enabled = false,
  },
}
