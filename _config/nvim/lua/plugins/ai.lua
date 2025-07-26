return {
  {
    'github/copilot.vim',
    init = function()
      vim.g.copilot_node_command = '~/.nvm/versions/node/v22.11.0/bin/node'
      --vim.g.copilot_no_tab_map = true
      vim.cmd [[inoremap <silent><script><expr> <C-i> copilot#Accept("\t")]]
    end,
    opt = {},
    enabled = true,
  },

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
      { '<leader>ac', '<cmd>CopilotChatToggle<cr>', desc = 'Copilot Chat Toggle' },
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
      { '<leader>ap', '<cmd>CopilotChatPrompts<cr>', desc = 'Copilot Chat Prompts' },
      { '<leader>af', '<cmd>CopilotChatFix<cr>', desc = 'Copilot Chat Fix' },
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
