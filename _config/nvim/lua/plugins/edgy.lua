return {
  {
    'folke/edgy.nvim',
    event = 'VeryLazy',
    init = function()
      vim.opt.laststatus = 3 -- global statusline (recommended by edgy)
      vim.opt.splitkeep = 'screen'
      -- edgy does not play well with cmdheight=0 (set globally in
      -- config/options.lua): opening an edgebar shrinks editor windows
      -- and never restores them. Force a 1-line cmdline.
      vim.opt.cmdheight = 1
    end,
    opts = {
      animate = { enabled = false },
      left = {
        -- File tree: neo-tree (filesystem source)
        {
          title = 'Files',
          ft = 'neo-tree',
          filter = function(buf)
            return vim.b[buf].neo_tree_source == 'filesystem'
          end,
          size = { height = 0.6 },
        },
        -- File tree: nerdtree (alternative to neo-tree)
        {
          title = 'Files',
          ft = 'nerdtree',
          size = { height = 0.6 },
        },
        -- Symbol outline (outline.nvim)
        {
          title = 'Outline',
          ft = 'Outline',
          pinned = true,
          open = 'Outline',
          size = { height = 0.4 },
        },
      },
    },
  },
}
