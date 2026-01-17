return {
  -- Claude Code
  {
    'coder/claudecode.nvim',
    dependencies = { 'folke/snacks.nvim' },
    opts = {
      log_level = 'info',
      auto_start = true,
      track_selection = true,
      terminal = {
        provider = 'snacks',
      },
      diff_opts = {
        keep_terminal_open = true,
      },
    },
    config = true,
    keys = {
      { '<leader>acc', '<cmd>ClaudeCode<cr>', desc = '[a]i [c]laude: Open/Toggle claude [c]ode' },
      { '<leader>acf', '<cmd>ClaudeCodeFocus<cr>', desc = '[a]i [c]laude: [f]ocus' },
      { '<leader>acb', '<cmd>ClaudeCodeAdd %:p<cr>', desc = '[a]i [c]laude: send current [b]uffer' },
      { '<leader>acs', '<cmd>ClaudeCodeSend<cr>', mode = 'v', desc = '[a]i [c]laude: send selected content' },
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
    enabled = true,
  },
}
